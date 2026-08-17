{
  config,
  lib,
  inputs,
  self,
  ...
}: let
  cfg = config.modules.secrets;
in {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  options.modules.secrets.enable = lib.mkEnableOption "Enable agenix-managed secrets";

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
