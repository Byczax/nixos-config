{
  config,
  lib,
  ...
}:
# Builder list is a machines file kept in agenix, so host/IP never reach git or the store.
# Create/edit with: agenix edit secrets/nix-builders.age (one /etc/nix/machines line per builder).
lib.mkIf config.modules.secrets.enable {
  age.secrets.nix-builders.rekeyFile = ../../../secrets/nix-builders.age;
  nix = {
    distributedBuilds = true;
    settings.builders = "@${config.age.secrets.nix-builders.path}";
  };
}
