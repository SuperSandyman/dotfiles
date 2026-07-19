{ pkgs }:

{
  hunkdiff = pkgs.callPackage ./hunkdiff.nix { };
  portless = pkgs.callPackage ./portless.nix { };
}
