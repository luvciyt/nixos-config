# modules/system/networking.nix
{ config, lib, ... }:

with lib;

let
  cfg = config.modules.networking;
in
{
  options.modules.networking = {
    enable = mkEnableOption "networking configuration";
    
    hostName = mkOption {
      type = types.str;
      default = "nixos";
      description = "System hostname";
    };
    
    networkmanager = {
      enable = mkEnableOption "NetworkManager";
    };
    
    wireless = {
      enable = mkEnableOption "wireless support via wpa_supplicant";
    };
    
    openssh = {
      enable = mkEnableOption "OpenSSH daemon";
      permitRootLogin = mkOption {
        type = types.bool;
        default = false;
        description = "Allow root login via SSH";
      };
    };
    
    firewall = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable firewall";
      };
      
      allowedTCPPorts = mkOption {
        type = types.listOf types.int;
        default = [];
        description = "Allowed TCP ports";
      };
      
      allowedUDPPorts = mkOption {
        type = types.listOf types.int;
        default = [];
        description = "Allowed UDP ports";
      };
    };
    
    proxy = {
      default = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Default proxy URL";
      };
      
      noProxy = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Comma-separated list of hosts to bypass proxy";
      };
    };
  };
  
  config = mkIf cfg.enable {
    networking.hostName = cfg.hostName;
    
    networking.networkmanager.enable = mkIf cfg.networkmanager.enable true;
    networking.wireless.enable = mkIf cfg.wireless.enable true;

    assertions = [
      {
        assertion = !(cfg.networkmanager.enable && cfg.wireless.enable);
        message = "NetworkManager and wpa_supplicant cannot be enabled simultaneously";
      }
    ];
  
    services.openssh = mkIf cfg.openssh.enable {
      enable = true;
      settings = {
        PermitRootLogin = if cfg.openssh.permitRootLogin then "yes" else "no";
        PasswordAuthentication = true;
      };
    };
    
    networking.firewall = mkIf cfg.firewall.enable {
      enable = true;
      allowedTCPPorts = cfg.firewall.allowedTCPPorts;
      allowedUDPPorts = cfg.firewall.allowedUDPPorts;
    };

    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    networking.proxy = mkIf (cfg.proxy.default != null) {
      default = cfg.proxy.default;
      noProxy = mkIf (cfg.proxy.noProxy != null) cfg.proxy.noProxy;
    };
  };
}