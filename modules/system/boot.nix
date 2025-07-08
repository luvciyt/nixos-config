# modules/system/boot.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.boot;
in
{
  options.modules.boot = {
    enable = mkEnableOption "boot configuration";
    
    useLatestKernel = mkOption {
      type = types.bool;
      default = false;
      description = "Use latest kernel packages";
    };
    
    systemd-boot = {
      enable = mkEnableOption "systemd-boot EFI boot loader";
    };
    
    grub = {
      enable = mkEnableOption "GRUB boot loader";
      device = mkOption {
        type = types.str;
        default = "/dev/nvme1n1";
        description = "GRUB device";
      };
      efiSupport = mkOption {
        type = types.bool;
        default = false;
        description = "Enable EFI support for GRUB";
      };
    };
    
    efi = {
      canTouchEfiVariables = mkOption {
        type = types.bool;
        default = false;
        description = "Allow modifying EFI variables";
      };
    };
    
    kernelParams = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional kernel parameters";
    };
    
    extraModules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional kernel modules to load";
    };
  };
  
  config = mkIf cfg.enable {
    boot.kernelPackages = mkIf cfg.useLatestKernel pkgs.linuxPackages_latest;
    boot.kernelParams = cfg.kernelParams;
    boot.extraModulePackages = cfg.extraModules;

    boot.loader = {
      systemd-boot.enable = mkIf cfg.systemd-boot.enable true;

      grub = mkIf cfg.grub.enable {
        enable = true;
        device = if cfg.grub.efiSupport then "nodev" else cfg.grub.device;
        efiSupport = cfg.grub.efiSupport;
      };
      
      efi.canTouchEfiVariables = mkIf cfg.efi.canTouchEfiVariables true;
    };
    
    assertions = [
      {
        assertion = !(cfg.systemd-boot.enable && cfg.grub.enable);
        message = "systemd-boot and GRUB cannot be enabled simultaneously";
      }
    ];
  };
}