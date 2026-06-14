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
    age.rekey = {
      inherit (config.meta.host) hostPubkey;
      storageMode = "local";
      localStorageDir = self + "/hosts/${config.networking.hostName}/secrets";

      masterIdentities = [
        {identity = ./yubikey-22488930.pub;}
      ];
    };
  };
}
