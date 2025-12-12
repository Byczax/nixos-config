{
  config,
  lib,
  ...
}: let
  cfg = config.module.firefox;
in {
  options.module.firefox.enable = lib.mkEnableOption "Enable custom firefox browser config";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      languagePacks = ["en-US" "pl" "de" "ja" "ru"];
      policies = {
        #BlockAboutConfig = true;
        DefaultDownloadDirectory = "\${home}/Downloads";
        #ExtensionSettings = {
        #  "uBlock0@raymondhill.net" = {
        #    default_area = "menupanel";
        #    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        #    installation_mode = "force_installed";
        #    private_browsing = true;
        #  };
        #};
      };
      #profiles.default = {
      #    bookmarks = [];
      #    settings = {};
      #  };
    };
  };
}
