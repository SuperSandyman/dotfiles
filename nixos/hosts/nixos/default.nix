{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../nix-storage.nix
  ];

  networking.hostName = "nixos";

  # Keep this at the NixOS version used for the first installation.
  system.stateVersion = "26.05";
}
