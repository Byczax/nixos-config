{
  osConfig,
  config,
  lib,
  ...
}:
lib.mkIf (osConfig.modules.nextcloud.enable && osConfig.modules.secrets.enable) {
  programs.rclone = {
    enable = true;
    remotes.nextcloud = {
      config = {
        type = "webdav";
        vendor = "nextcloud";
      };
      secrets = lib.genAttrs ["url" "user" "pass"] (k: osConfig.age.secrets."nextcloud-${k}".path);
      mounts."" = {
        enable = true;
        mountPoint = "${config.home.homeDirectory}/Cloud";
      };
    };
  };
}
