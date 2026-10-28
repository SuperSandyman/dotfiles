{ pkgs }:

let
  nodejs = pkgs.nodejs_26;
in
{
  hunkdiff = pkgs.callPackage ./hunkdiff.nix { };
  portless = pkgs.callPackage ./portless.nix { inherit nodejs; };
}
