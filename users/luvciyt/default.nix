# users/luvciyt/default.nix
{
  pkgs,
  ...
}:

{
  # 用户账户配置
  users.users.luvciyt = {
    isNormalUser = true;
    description = "Luvciyt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "storage"
      "optical"
      "scanner"
      "lp"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
}
