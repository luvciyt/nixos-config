# packages/default.nix
{ pkgs }:

{
  pingfang-fonts = pkgs.callPackage ./pingfang-fonts.nix { };
}