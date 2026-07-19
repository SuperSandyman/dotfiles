{
  description = "SuperSandyman's NixOS and Home Manager configuration";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      localPackages = import ./profiles/fast-cli/packages { inherit pkgs; };
      updateAll = pkgs.writeShellApplication {
        name = "dotfiles-update-all";
        runtimeInputs = [
          pkgs.git
          pkgs.nix
        ];
        text = ''
          repository="$(git rev-parse --show-toplevel)"
          cd "$repository"

          nix flake update
          nix flake update --flake "$repository/profiles/fast-cli"
          nix flake update --flake "$repository/profiles/dev-tools"
          nix flake update --flake "$repository/profiles/runtimes"

          nix profile upgrade fast-cli dev-tools runtimes

          echo "Updated all four flake.lock files and the three user profiles."
          echo "Review the changes, then rebuild NixOS to apply system and Home Manager updates."
        '';
      };
    in
    {
      nixosModules.nix-storage = import ./nixos/nix-storage.nix;

      packages.${system} = localPackages // {
        home-manager = home-manager.packages.${system}.home-manager;
        update-all = updateAll;
      };

      apps.${system}.update-all = {
        type = "app";
        program = "${updateAll}/bin/dotfiles-update-all";
        meta.description = "Update every dotfiles lock file and user package profile";
      };

      homeConfigurations.sandyman = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit localPackages;
        };
        modules = [ ./home.nix ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/hosts/nixos
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "nix-backup";
              extraSpecialArgs = {
                inherit localPackages;
              };
              users.sandyman = import ./home.nix;
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
