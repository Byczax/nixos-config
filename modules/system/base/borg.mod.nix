{
  config,
  lib,
  ...
}: let
  cfg = config.modules.borg;
in {
  options.modules.borg.enable = lib.mkEnableOption "borg/borgmatic backups (home-manager side reads osConfig)";

  # Requires secrets: no passphrase without the agenix stack, so borg follows
  # the master modules.secrets.enable switch.
  config = lib.mkIf (cfg.enable && config.modules.secrets.enable) {
    # borg backup passphrase. Create/edit with: agenix edit secrets/borg-passphrase.age
    # Rekeyed per host into hosts/${hostName}/secrets by `agenix rekey`.
    age.secrets = lib.genAttrs ["borg-passphrase" "borg-repo"] (name: {
      rekeyFile = ../../../secrets/${name}.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    });
  };
}
