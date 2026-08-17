{
  config,
  lib,
  ...
}: let
  cfg = config.modules.borg;
in {
  options.modules.borg.enable = lib.mkEnableOption "borg/borgmatic backups (home-manager side reads osConfig)";

  config = lib.mkIf cfg.enable {
    # borg backup passphrase. Create/edit with: agenix edit secrets/borg-passphrase.age
    # Rekeyed per host into hosts/${hostName}/secrets by `agenix rekey`.
    age.secrets.borg-passphrase = {
      rekeyFile = ../../secrets/borg-passphrase.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    };
  };
}
