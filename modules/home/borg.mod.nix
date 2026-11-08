{
  osConfig,
  lib,
  ...
}: let
  # Driven by the NixOS-side toggle (modules/system/base/borg.mod.nix), so enabling borg
  # on a host also provisions the passphrase secret.
  enabled = osConfig.modules.borg.enable && osConfig.modules.secrets.enable;
  # BORG_REPO_BASE comes from the borg-repo secret at runtime, so eval never needs decrypted files.
  repo = "\${BORG_REPO_BASE}/${osConfig.networking.hostName}";
in
  lib.mkIf enabled {
    programs.borgmatic = {
      enable = true;
      backups.synology = {
        settings = {
          keep_daily = 7; # last week
          keep_weekly = 4; # last month
          keep_monthly = 12; # last year
          keep_yearly = 3; # long-term

          patterns = [
            "R /home/${osConfig.meta.mainUser.username}"
            "- /home/${osConfig.meta.mainUser.username}/.cache"
            "- /home/${osConfig.meta.mainUser.username}/.config"
            "- /home/${osConfig.meta.mainUser.username}/.local"
            "- /home/${osConfig.meta.mainUser.username}/Media"
            "- /home/${osConfig.meta.mainUser.username}/.java"
            "- sh:/home/${osConfig.meta.mainUser.username}/**/docker-data"
          ];

          repositories = [
            {
              path = repo;
              label = "synology";
              encryption = "repokey-blake2";
            }
          ];

          remote_path = "/usr/local/bin/borg";
          # Passphrase read from decrypted agenix secret at runtime.
          encryption_passcommand = "cat ${osConfig.age.secrets.borg-passphrase.path}";

          checks = [
            {
              name = "repository";
              frequency = "2 weeks";
            }
            {
              name = "archives";
              frequency = "4 weeks";
            }
            {
              name = "data";
              frequency = "6 weeks";
            }
            {
              name = "extract";
              frequency = "6 weeks";
            }
          ];
        };
      };
    };

    services.borgmatic = {
      enable = true;
      frequency = "daily";
    };
    systemd.user.services.borgmatic = {
      Unit.ConditionACPower = lib.mkForce "";
      Service.EnvironmentFile = osConfig.age.secrets.borg-repo.path;
    };
  }
