{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.jellyfin;
in {
  options.modules.jellyfin.enable = lib.mkEnableOption "Jellyfin media server";

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true; # 8096/8920 TCP, 1900/7359 UDP
      forceEncodingConfig = true;
      hardwareAcceleration = {
        enable = true;
        type = "qsv";
        device = "/dev/dri/renderD128";
      };
      transcoding = {
        enableSubtitleExtraction = false;
        enableHardwareEncoding = true;
        enableIntelLowPowerEncoding = true;
        enableToneMapping = true;
        throttleTranscoding = true;
        hardwareDecodingCodecs = {
          h264 = true;
          hevc = true;
          hevc10bit = true;
          vp9 = true;
          av1 = true;
        };
      };
    };
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };
    users.users.jellyfin.extraGroups = ["render" "video"];
  };
}
