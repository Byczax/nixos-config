# Niri home config — deployed only when this host's meta.compositor is "niri".
# Mirrors the hyprland home stack (bar, lock, idle, wallpaper, clipboard) so
# switching compositors is a one-line change with feature parity.
#
# The shared home services (waybar, hyprlock, hypridle, hyprpolkitagent, mako,
# kanshi, wlsunset) are compositor-agnostic and stay enabled across both; they
# bind to graphical-session.target so they start under niri too.
{
  pkgs,
  lib,
  compositor,
  ...
}:
lib.mkIf (compositor == "niri") {
  xdg.configFile."niri/config.kdl".source = ./niri/niri-config.kdl;

  # Tools the niri config's spawn-at-startup / binds reference and that hyprland
  # otherwise pulls in itself.
  home.packages = with pkgs; [
    swaybg # wallpaper
    xwayland-satellite # XWayland apps under niri
    cliphist # clipboard history (Super+V)
  ];
}
