{
  osConfig,
  lib,
  ...
}: let
  # Driven by the NixOS-side toggle (modules/system/borg.mod.nix), so enabling borg
  # on a host also provisions the passphrase secret.
  # Also gate on the master secrets switch: when secrets are unavailable the
  # passphrase and private.nix are missing, so borg must stay off. Because `base`
  # below is only forced inside `lib.mkIf enabled`, a disabled host never imports
  # the (possibly still-encrypted) secrets/private.nix — eval stays clean.
  enabled = osConfig.modules.borg.enable && osConfig.modules.secrets.enable;
  base = (import ../../secrets/private.nix).borgRepoBase;
  # System-based repo path: each host backs up to its own subdir, never overwriting.
  repo = "${base}/${osConfig.networking.hostName}";
in
  lib.mkIf enabled {
    programs.borgmatic = {
      enable = true;
      backups.synology = {
        consistency.checks = [
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
        location = {
          repositories = [repo];
          extraConfig = {
            remote_path = "/usr/local/bin/borg";
            # Passphrase read from decrypted agenix secret at runtime.
            encryption_passcommand = "cat ${osConfig.age.secrets.borg-passphrase.path}";
          };
          patterns = [
            "R /home/${osConfig.meta.mainUser.username}"
            "- /home/${osConfig.meta.mainUser.username}/.cache"
            "- /home/${osConfig.meta.mainUser.username}/.config"
            "- /home/${osConfig.meta.mainUser.username}/.local"
            "- /home/${osConfig.meta.mainUser.username}/Media"
            "- /home/${osConfig.meta.mainUser.username}/.java"
          ];
        };
        retention = {
          keepDaily = 7; # last week
          keepWeekly = 4; # last month
          keepMonthly = 12; # last year
          keepYearly = 3; # long-term
        };
      };
    };

    services.borgmatic = {
      enable = true;
      frequency = "daily";
    };
  }
