{
  description = "Stable development CLIs, language servers, and formatters";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "sandyman-dev-tools";
        pathsToLink = [ "/bin" ];
        paths = with pkgs; [
          bash-language-server
          elixir-ls
          lua-language-server
          nil
          nixfmt
          prettier
          rust-analyzer
          stylua
          typescript-language-server
          vscode-langservers-extracted
          yaml-language-server
          fd
          gnumake
          ripgrep
          tree-sitter
          wl-clipboard
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
