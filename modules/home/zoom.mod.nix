{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.module.zoom;
in {
  options.module.zoom.enable = lib.mkEnableOption "Enable custom Zoom config";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.zoom-us];

    # Only stable preference toggles. Zoom persists its own runtime state
    # (session tokens, device id, window positions) elsewhere at runtime.
    home.file.".config/zoomus.conf".text = ''
      [General]
      GeoLocale=system
      SensitiveInfoMaskOn=true
      autoScale=true
      captureHDCamera=true
      enableMiniWindow=true
      forceEnableTrayIcon=true
      newMeetingWithVideo=true
      showSystemTitlebar=false
      speaker_volume=255
      system.audio.type=default
      timeFormat12HoursEnable=true
      useSystemTheme=false
      xwayland=false
    '';
  };
}
