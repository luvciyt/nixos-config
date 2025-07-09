# modules/system/desktop.nix
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "desktop environment";

    gnome = {
      enable = mkEnableOption "GNOME desktop environment";
    };

    kde = {
      enable = mkEnableOption "KDE desktop environment";
    };

    i3 = {
      enable = mkEnableOption "i3 window manager";
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
    assertions = [
      {
        assertion = !(cfg.gnome.enable && cfg.kde.enable);
        message = "You cannot enable both GNOME and KDE at the same time in this module.";
      }
    ];

    services.xserver.enable = true;
    services.libinput.enable = true;

    # Display managers
    services.xserver.displayManager.gdm = mkIf cfg.gnome.enable {
      enable = true;
      wayland = cfg.enableWayland;
    };
    
    services.xserver.displayManager.sddm.enable = mkIf cfg.kde.enable true;
    
    services.xserver.displayManager.lightdm.enable = mkIf (
      cfg.i3.enable && !cfg.gnome.enable && !cfg.kde.enable
    ) true;

    # Desktop environments and window managers
    services.xserver.desktopManager.gnome.enable = mkIf cfg.gnome.enable true;
    services.xserver.desktopManager.plasma5.enable = mkIf cfg.kde.enable true;
    services.xserver.windowManager.i3.enable = mkIf cfg.i3.enable true;

    # Sound support
    services.pipewire = mkIf cfg.enableSound {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    # Printing support
    services.printing.enable = mkIf cfg.enablePrinting true;

    # GNOME packages
    environment.systemPackages =
      with pkgs;
      lib.optionals cfg.gnome.enable [
        nautilus
        gnome-terminal
      ] ++ lib.optionals cfg.i3.enable [
        # i3 常用工具
        i3status
        i3lock
        dmenu
        rofi
        alacritty
      ];

    # Remove unwanted GNOME packages
    environment.gnome.excludePackages = lib.optionals cfg.gnome.enable (
      with pkgs;
      [
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
        cheese
        epiphany
        geary
        totem
        yelp
        simple-scan
      ]
    );
  };
}