# modules/system/development.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.development;
in
{
  options.modules.development = {
    enable = mkEnableOption "development environment";
    
    enableFirefox = mkEnableOption "Firefox browser";
    
    enableGit = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Git version control";
    };
    
    enableVim = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Vim editor";
    };

    enableNeoVim = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NeoVim editor";
    };
    
    enableVscode = mkEnableOption "Visual Studio Code";
    
    languages = {
      nix = mkEnableOption "Nix development tools";
      python = mkEnableOption "Python development tools";
      nodejs = mkEnableOption "Node.js development tools";
      rust = mkEnableOption "Rust development tools";
    };
    
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional development packages";
    };
  };
  
  config = mkIf cfg.enable {
    programs.firefox.enable = mkIf cfg.enableFirefox true;

    environment.systemPackages = with pkgs; [
      (mkIf cfg.enableGit git)
      
      (mkIf cfg.enableVim vim)
      (mkIf cfg.enableNeoVim neovim)
      (mkIf cfg.enableVscode vscode)

      wget
      curl
      tree
      htop

      (mkIf cfg.languages.nix nixfmt-classic)
      (mkIf cfg.languages.nix nil)

      (mkIf cfg.languages.python python3)
      (mkIf cfg.languages.python python3Packages.pip)

      (mkIf cfg.languages.nodejs nodejs)
      (mkIf cfg.languages.nodejs nodePackages.npm)
      
      (mkIf cfg.languages.rust rustup)
    ] ++ cfg.extraPackages;
    
    programs.git = mkIf cfg.enableGit {
      enable = true;
    };
    
    environment.variables = {
      EDITOR =
        if cfg.enableNeoVim then "nvim"
        else if cfg.enableVim then "vim"
        else null; 
    };
  };
}