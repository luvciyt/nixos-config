# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/system

    ../../users/luvciyt
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  modules.desktop = {
    enable = true;
    gnome.enable = true;
  };

  modules.development = {
    enable = true;
    enableFirefox = false;
    enableNeoVim = true;
    enableVscode = true;
    enableGit = true;
    languages = {
      nix = true;
      python = true;
      rust = true;
      nodejs = true;
    };
    extraPackages = [
      pkgs.cmake
    ];
  };

  modules.networking = {
    enable = true;
    hostName = "nixos";
    networkmanager.enable = true;
    openssh = {
      enable = true;
      permitRootLogin = false;
    };
  };

  modules.fonts = {
    enable = true;
    enablePingFang = true;
    enableDefaultFonts = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old";
  };

  nix.settings.min-free = 1073741824;
  
  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
