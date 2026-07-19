{ ... }:

{
  # Deduplicate identical files as paths are added to the store.
  nix.settings.auto-optimise-store = true;

  # Build outputs remain reproducible from the flake locks, so retaining every
  # derivation is less useful than keeping disk use bounded.
  nix.settings.keep-derivations = false;
  nix.settings.keep-outputs = false;

  # Ask the daemon to reclaim space during builds if free space becomes low.
  nix.settings.min-free = 5 * 1024 * 1024 * 1024;
  nix.settings.max-free = 15 * 1024 * 1024 * 1024;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Old bootable generations also retain complete system closures.
  boot.loader.systemd-boot.configurationLimit = 10;
}
