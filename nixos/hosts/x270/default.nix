{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./desktop.nix
    ./packages.nix
  ];

  networking.hostName = "x270";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  # No public SSH listener; tailscale up is a separate, authenticated step.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  console.keyMap = "jp106";

  users.users.sandyman = {
    isNormalUser = true;
    description = "Sandyman";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "ydotool"
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    # Keep the existing password and ~/.ssh/authorized_keys on an installed X270.
    # A fresh installation needs `passwd sandyman` before leaving the installer.
  };
  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
  ];
  security.sudo.wheelNeedsPassword = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    max-jobs = 1;
    cores = 2;
    min-free = 2 * 1024 * 1024 * 1024;
    max-free = 5 * 1024 * 1024 * 1024;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  services.fstrim.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;
  services.journald.settings.Journal.SystemMaxUse = "256M";
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Initial installation baseline; do not bump this when updating nixpkgs.
  # If the existing X270 installation predates 26.05, retain its original value.
  system.stateVersion = "26.05";
}
