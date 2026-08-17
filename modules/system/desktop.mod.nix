{
  config,
  pkgs,
  lib,
  ...
}: let
  user = config.meta.mainUser.username;
  compositor = config.meta.compositor;
  isHyprland = compositor == "hyprland";
  isNiri = compositor == "niri";
  # greetd launches whichever compositor meta.compositor selects.
  sessionCmd =
    if isHyprland
    then "systemd-cat -t Hyprland start-hyprland"
    else "systemd-cat -t niri niri --session";
in {
  # login manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${sessionCmd}'";
      inherit user;
    };
  };

  xdg.portal = {
    enable = true;
    # gtk portal is shared; the screencast/screenshot backend follows the
    # compositor (hyprland's own portal, or gnome's for niri).
    extraPortals = with pkgs;
      [xdg-desktop-portal-gtk]
      ++ lib.optional isHyprland xdg-desktop-portal-hyprland
      ++ lib.optional isNiri xdg-desktop-portal-gnome;
    config.common =
      if isHyprland
      then {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
        "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
      }
      else {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      };
  };

  programs = {
    # niri itself is enabled in modules/system/niri.mod.nix (also keyed on
    # meta.compositor); here we only gate the hyprland program.
    hyprland.enable = isHyprland;
    coolercontrol.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };
}
