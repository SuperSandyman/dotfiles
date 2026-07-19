{
  description = "Independently updatable language runtimes and compilers";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "sandyman-runtimes";
        pathsToLink = [ "/bin" ];
        paths = with pkgs; [
          beamPackages.elixir
          beamPackages.erlang
          nodejs
          pnpm
          cargo
          gcc
          rustc
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
