{
  config,
  osConfig,
  lib,
  compositor,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    username = osConfig.meta.mainUser.username;
    homeDirectory = osConfig.meta.mainUser.homeDirectory;
    sessionVariables = {
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = lib.getAttr compositor {
        hyprland = "Hyprland";
        niri = "niri";
      };
      QT_QPA_PLATFORM = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      QT_SCREEN_SCALE_FACTORS = "1;1";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      TENV_AUTO_INSTALL = "true";
    };
  };
}
