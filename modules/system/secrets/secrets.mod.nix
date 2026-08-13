{
  config,
  lib,
  inputs,
  self,
  ...
}: let
  cfg = config.module.secrets;
in {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  options = {
    module.secrets.enable = lib.mkEnableOption "Enable agenix-managed secrets";

    meta = {
      host.hostPubkey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The SSH host public key used for agenix-rekeying";
      };
      mainUser.username = lib.mkOption {
        type = lib.types.str;
        default = "bq";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Host identity used to decrypt secrets at runtime (matches meta.host.hostPubkey).
    age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    age.rekey = {
      inherit (config.meta.host) hostPubkey;
      storageMode = "local";
      # Master rekeyFiles (encrypted to the yubikeys) live in the repo-root
      # /secrets dir. Rekeyed runtime copies land here, per host. Kept in a
      # separate dir from the masters because `agenix rekey` deletes every stray
      # file in localStorageDir.
      localStorageDir = self + "/hosts/${config.networking.hostName}/secrets";

      masterIdentities = [
        {identity = ./yubikey-22488930.pub;}
        {identity = ./yubikey-23303604.pub;}
      ];
    };
  };
}
