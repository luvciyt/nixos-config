# modules/system/desktop.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = mkEnableOption "desktop environment";
    
    gnome = {
      enable = mkEnableOption "GNOME desktop environment";
    };
    
    kde = {
      enable = mkEnableOption "KDE desktop environment";
    };

    enableWayland = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Wayland display server.";
    };
    
    enableSound = mkOption {
      type = types.bool;
      default = true;
      description = "Enable sound support";
    };
    
    enablePrinting = mkOption {
      type = types.bool;
      default = true;
      description = "Enable CUPS printing";
    };
  };
  
  config = mkIf cfg.enable {
    # services.xserver.enable = true;
    
    # GNOME
    services.displayManager.gdm.enable = mkIf cfg.gnome.enable true; 
    services.desktopManager.gnome.enable = mkIf cfg.gnome.enable true; 
    
    # KDE
    services.xserver.displayManager.sddm.enable = mkIf cfg.kde.enable true;
    services.xserver.desktopManager.plasma5.enable = mkIf cfg.kde.enable true;
    
    # sound
    services.pipewire = mkIf cfg.enableSound {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
    
    services.printing.enable = mkIf cfg.enablePrinting true;
    
    services.libinput.enable = true;
    
    environment.systemPackages = with pkgs; [
      nautilus
      gnome-terminal
    ];

    environment.gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
      gnome-music
      gnome-calendar
      gnome-clocks
      gnome-calculator
      gnome-text-editor
      gnome-maps
      gnome-weather
      gnome-contacts
      gnome-music

      cheese
      
      epiphany
      geary
      totem 
      
      yelp
      simple-scan
    ];
  };
}