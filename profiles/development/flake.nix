{
  description = "Editors, runtimes, language servers, and fast-moving CLI tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr/v0.7.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      llm-agents,
      herdr,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      llmAgents = llm-agents.packages.${system};
      localPackages = import ./packages { inherit pkgs; };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "sandyman-development";
        pathsToLink = [
          "/bin"
          "/share/applications"
          "/share/icons"
          "/share/mime"
          "/share/pixmaps"
        ];
        paths = with pkgs; [
          # Editors.
          neovim
          vscode

          # Language runtimes and compilers.
          beamPackages.elixir
          beamPackages.erlang
          nodejs
          pnpm
          cargo
          gcc
          rustc

          # Language servers and formatters.
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

          # Development utilities.
          fd
          gnumake
          ripgrep
          tree-sitter
          wl-clipboard
          ni
          gh

          # Fast-moving agent and service CLIs.
          llmAgents.codex
          llmAgents.copilot-cli
          llmAgents.opencode
          llmAgents.pi
          herdr.packages.${system}.default
          localPackages.hunkdiff
          localPackages.portless
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
