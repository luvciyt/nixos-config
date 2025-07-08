# modules/system/default.nix
{ ... }:

{
  imports = [
    ./fonts.nix
    ./networking.nix
    ./desktop.nix
    ./boot.nix
    ./development.nix
    ./locale.nix
  ];
}