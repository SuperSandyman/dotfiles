{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  users.users.sandyman = {
    isNormalUser = true;
    description = "Sandyman";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs = {
    git.enable = true;
    neovim.enable = true;
    zsh.enable = true;
  };

  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = with pkgs; [
    curl
    dmidecode
    efibootmgr
    fastfetch
    git
    openssh
    pciutils
    rsync
    smartmontools
    unzip
    usbutils
    wget
    which
    zip
  ];

  services.tailscale.enable = true;
}
