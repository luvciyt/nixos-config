# modules/system/fonts.nix
{ config, lib, pkgs, self, ... }:

with lib;

let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = mkEnableOption "custom fonts configuration";
    
    enablePingFang = mkEnableOption "PingFang fonts";
    
    enableDefaultFonts = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable default font packages";
    };
    
    additionalFonts = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional font packages to install";
    };
  };
  
  config = mkIf cfg.enable {
    # 启用字体配置
    fonts = {
      fontconfig.enable = true;
      packages = with pkgs; [
        # 默认字体
        (mkIf cfg.enableDefaultFonts noto-fonts)
        (mkIf cfg.enableDefaultFonts noto-fonts-cjk-sans)
        (mkIf cfg.enableDefaultFonts noto-fonts-emoji)
        (mkIf cfg.enableDefaultFonts source-code-pro)
        
        # PingFang 字体
        (mkIf cfg.enablePingFang self.packages.${pkgs.system}.pingfang-fonts)
      ] ++ cfg.additionalFonts;
      
      # 字体配置优化
      fontconfig.defaultFonts = mkIf cfg.enablePingFang {
        serif = [ "PingFang SC" "Noto Serif CJK SC" ];
        sansSerif = [ "PingFang SC" "Noto Sans CJK SC" ];
        monospace = [ "Source Code Pro" "Noto Sans Mono CJK SC" ];
      };
    };
  };
}