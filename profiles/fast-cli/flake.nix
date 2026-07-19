{
  description = "Fast-moving AI and service CLIs";

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
        name = "sandyman-fast-cli";
        pathsToLink = [ "/bin" ];
        paths = with pkgs; [
          # Agent and npm-style CLIs.
          ni
          llmAgents.codex
          llmAgents.copilot-cli
          llmAgents.opencode
          llmAgents.pi
          herdr.packages.${system}.default
          localPackages.hunkdiff
          localPackages.portless
          gh
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
