{
  config,
  pkgs,
  ...
}: let
  user = config.meta.mainUser.username;
in {
  users = {
    users.${user} = {
      isNormalUser = true;
      description = user;
      initialPassword = "changeme";
      extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
      shell = pkgs.zsh;
    };
    defaultUserShell = pkgs.zsh;
  };

  environment = {
    systemPackages = with pkgs; [
      bash
      coreutils
      vim
    ];
    shells = with pkgs; [zsh];
  };

  programs.zsh.enable = true;
}
