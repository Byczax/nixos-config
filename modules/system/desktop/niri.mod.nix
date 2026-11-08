{
  config,
  pkgs,
  lib,
  ...
}: let
  # Enabled whenever this host's compositor is niri. Still overridable per host
  # (e.g. to install niri without booting it), but the default follows the single
  # meta.compositor switch so flipping that is all it takes.
  enableNiri = config.modules.niri.enable;
in {
  options.modules.niri.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.meta.compositor == "niri";
    description = "Enable Niri and related packages/services.";
  };

  config = lib.mkIf enableNiri {
    programs.niri.enable = true;

    # XWayland support for niri (Xwayland-satellite) + wallpaper tool used by the
    # niri config's spawn-at-startup. Hyprland brings its own equivalents.
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      swaybg
    ];
  };
}
