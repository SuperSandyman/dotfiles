{
  description = "SuperSandyman's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-x270.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager-x270 = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-x270";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-x270,
      home-manager,
      home-manager-x270,
      plasma-manager,
      qylock,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      localPackages = import ./profiles/development/packages { inherit pkgs; };
      updateAll = pkgs.writeShellApplication {
        name = "dotfiles-update-all";
        runtimeInputs = [
          pkgs.git
          pkgs.nix
        ];
        text = ''
          repository="$(git rev-parse --show-toplevel)"
          cd "$repository"

          nix --accept-flake-config flake update
          nix --accept-flake-config flake update --flake "$repository/profiles/development"

          nix --accept-flake-config profile upgrade development

          echo "Updated the system and development flake.lock files."
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
        meta.description = "Update the system and development environments";
      };

      homeConfigurations."sandyman@t14g6" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          plasma-manager.homeModules.plasma-manager
          ./home/t14g6.nix
        ];
      };

      nixosConfigurations.t14g6 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/hosts/t14g6
          home-manager.nixosModules.home-manager
          qylock.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "nix-backup";
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              users.sandyman = import ./home/t14g6.nix;
            };
          }
        ];
      };

      # Compatibility aliases for existing commands.
      homeConfigurations.sandyman = self.homeConfigurations."sandyman@t14g6";
      nixosConfigurations.nixos = self.nixosConfigurations.t14g6;
      nixosConfigurations.t14 = self.nixosConfigurations.t14g6;

      nixosConfigurations.x270 = nixpkgs-x270.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/hosts/x270
          home-manager-x270.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "nix-backup";
              users.sandyman = import ./home/x270.nix;
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
