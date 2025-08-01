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
    # i3.enable = true;
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

  virtualisation.docker.enable = true;

  nix.settings.min-free = 1073741824;

  networking.nameservers = [
    "8.8.8.8"
    "8.8.4.4"
    "1.1.1.1"
    "1.0.0.1"
    "202.114.0.131"
    "202.114.0.242"
  ];

  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    openssl
    pkg-config
  ];

  environment.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    OPENSSL_DIR = "${pkgs.openssl.out}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  };
}
