{
  config,
  lib,
  localPackages,
  pkgs,
  ...
}:

{
  imports = [ ./plasma.nix ];

  home.username = "sandyman";
  home.homeDirectory = "/home/sandyman";
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Editors, CLI tools, and runtimes live in the development Nix profile.
    ghostty
    inconsolata
    nerd-fonts.hack
    noto-fonts-cjk-sans
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.lmstudio/bin"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons -la --group-directories-first";
      la = "eza --icons -a --group-directories-first";
      grep = "rg";
      cat = "bat --paging=never";
      vi = "nvim";
      vim = "nvim";
    };
    initExtra = ''
      if command -v herdr >/dev/null 2>&1; then
        source <(herdr completion bash)
      fi
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons -la --group-directories-first";
      la = "eza --icons -a --group-directories-first";
      grep = "rg";
      cat = "bat --paging=never";
      vi = "nvim";
      vim = "nvim";
    };
    initContent = lib.mkOrder 1200 ''
      if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
        source "$HOME/google-cloud-sdk/path.zsh.inc"
      fi
      if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
        source "$HOME/google-cloud-sdk/completion.zsh.inc"
      fi
      if command -v herdr >/dev/null 2>&1; then
        source <(herdr completion zsh)
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./private_dot_config/starship.toml);
  };

  programs.bat.enable = true;
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  xdg.configFile = {
    "nvim/init.lua".source = ./private_dot_config/nvim/init.lua;
    "nvim/README.md".source = ./private_dot_config/nvim/README.md;
    "nvim/after".source = ./private_dot_config/nvim/after;
    "nvim/lua".source = ./private_dot_config/nvim/lua;
    "ghostty/config".source = ./private_dot_config/ghostty/config;
    "ghostty/empty_config.ghostty".source = ./private_dot_config/ghostty/empty_config.ghostty;
    "eza/theme.yml".source = ./private_dot_config/eza/theme.yml;
  };

  # Only custom skills are managed. Codex auth, history, sessions, caches,
  # bundled skills, plugin state, and the mutable config.toml remain untouched.
  home.file = {
    ".gitconfig".text = lib.generators.toGitINI {
      user = {
        name = "SuperSandyman";
        email = "66544945+SuperSandyman@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
    ".codex/skills/empirical-prompt-tuning".source = ./dot_codex/skills/empirical-prompt-tuning;
    ".codex/skills/opensrc".source = ./dot_codex/skills/opensrc;
    ".codex/skills/planning".source = ./dot_codex/skills/planning;
    ".codex/skills/review".source = ./dot_codex/skills/review;
    ".codex/skills/worktree".source = ./dot_codex/skills/worktree;
    ".codex/skills/hunk-review/SKILL.md".source =
      "${localPackages.hunkdiff}/share/hunkdiff/skills/hunk-review/SKILL.md";
  };

  # The tracked Codex config is a bootstrap template. Codex Desktop mutates
  # config.toml, so an existing installation must never be replaced by a
  # read-only Home Manager symlink.
  home.activation.bootstrapCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "$HOME/.codex/config.toml" ]]; then
      run mkdir -p "$HOME/.codex"
      run install -m 0600 \
        ${./dot_codex/private_config.toml} \
        "$HOME/.codex/config.toml"
    fi
  '';

  # lazy.nvim updates this file as plugins change, so it must remain writable.
  home.activation.bootstrapNeovimLock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "$HOME/.config/nvim/lazy-lock.json" ]]; then
      run install -m 0644 \
        ${./private_dot_config/nvim/lazy-lock.json} \
        "$HOME/.config/nvim/lazy-lock.json"
    fi
  '';
}
