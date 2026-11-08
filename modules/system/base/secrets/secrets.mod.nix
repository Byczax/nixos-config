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

  options.modules.secrets.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.meta.host.hostPubkey != "";
    description = "agenix secrets; off until the host has a hostPubkey, so fresh installs never block on decryption";
  };

  config = {
    # Host identity used to decrypt secrets at runtime (matches meta.host.hostPubkey).
    age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    age.rekey = {
      hostPubkey = lib.mkIf cfg.enable config.meta.host.hostPubkey;
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
