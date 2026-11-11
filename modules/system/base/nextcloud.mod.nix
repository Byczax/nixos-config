{
  config,
  lib,
  ...
}: {
  options.modules.nextcloud.enable = lib.mkEnableOption "rclone mount of the nextcloud instance (home-manager side reads osConfig)";

  # Endpoint, user and app password stay in agenix so nothing lands in the store.
  # Create/edit with: agenix edit secrets/nextcloud-{url,user,pass}.age
  config = lib.mkIf (config.modules.nextcloud.enable && config.modules.secrets.enable) {
    age.secrets = lib.genAttrs ["nextcloud-url" "nextcloud-user" "nextcloud-pass"] (name: {
      rekeyFile = ../../../secrets/${name}.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    });
  };
}
