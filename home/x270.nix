{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/develop/dotfiles";
in
{
  imports = [ ./x270/agent.nix ];

  home.username = "sandyman";
  home.homeDirectory = "/home/sandyman";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "chromium";
  };
  home.packages = with pkgs; [
    (microsoft-edge.override {
      commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --force-renderer-accessibility";
    })
    mousepad
    libnotify
    seahorse
    at-spi2-core
  ];
  home.activation.workspace = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/Workspace" "$HOME/develop" "$HOME/Downloads" "$HOME/.local/state/agent-artifacts"
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -la";
      vi = "nvim";
      nixos-switch = "sudo nixos-rebuild switch --flake path:${dotfiles}#x270";
      dev-update = "nix flake update --flake ${dotfiles}/profiles/development && nix profile upgrade development";
    };
  };
  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../private_dot_config/starship.toml);
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "SuperSandyman";
      user.email = "66544945+SuperSandyman@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.ff = "only";
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.tmux.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main.font = "Hack Nerd Font:size=10";
      scrollback.lines = 5000;
    };
  };
  programs.fuzzel.enable = true;
  services.mako.enable = true;
  services.polkit-gnome.enable = true;
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--force-renderer-accessibility"
    ];
  };
  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
        "inode/directory" = [ "thunar.desktop" ];
      };
    };
    configFile."uwsm/env".text = ''
      export XCURSOR_SIZE=24
      export QT_IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
      export GTK_A11Y=always
      export ACCESSIBILITY_ENABLED=1
      export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1
      export YDOTOOL_SOCKET=/run/ydotoold/socket
      export COMPUTER_USE_LINUX_BIN=${pkgs.computer-use-linux}/bin/computer-use-linux
      export COMPUTER_USE_LINUX_SKIP_DOWNLOAD=1
      export COMPUTER_USE_LINUX_INDICATOR=0
    '';
  };
  dconf.settings."org/gnome/desktop/interface" = {
    toolkit-accessibility = true;
    color-scheme = "default";
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd.enable = false; # UWSM owns the graphical-session targets/environment.
    extraConfig = builtins.readFile ./x270/hyprland.lua;
  };
}
