{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../nix-storage.nix
  ];

  networking.hostName = "sandyman-nixos";
  networking.firewall.interfaces.wlp0s20f3.allowedTCPPorts = [ 4390 ];

  # Keep this at the NixOS version used for the first installation.
  system.stateVersion = "26.05";
}
