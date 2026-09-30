{ pkgs }:

let
  nodejs = pkgs.nodejs_26;
in
{
  codex = pkgs.callPackage ./codex.nix { };
  hunkdiff = pkgs.callPackage ./hunkdiff.nix { };
  portless = pkgs.callPackage ./portless.nix { inherit nodejs; };
}
