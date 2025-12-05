{
  config,
  lib,
  ...
}: let
  cfg = config.module.zen;
in {
  options.module.zen.enable = lib.mkEnableOption "Enable custom Zen browser config";

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        # Feature Disabling
        DisableBuiltinPDFViewer = false;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = false;
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = false;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;

        # Access Restrictions
        BlockAboutConfig = false;
        BlockAboutProfiles = false;
        BlockAboutSupport = false;

        # UI and Behavior
        #DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        HardwareAcceleration = true;
        OfferToSaveLogins = false;

        # Enable search suggestions
        SearchSuggestEnabled = true;

        DnsOverHTTPS = "Enabled";

        ExtensionSettings = let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in {
          # Block all extensions by default.
          "*".installation_mode = "blocked";

          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
            installation_mode = "force_installed";
            updates_disabled = true;
          };

          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = moz "bitwarden-password-manager";
            installation_mode = "force_installed";
            updates_disabled = true;
          };

          #"{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          #  install_url = moz "noscript";
          #  installation_mode = "force_installed";
          #  updates_disabled = true;
          #};
          "@testpilot-containers" = {
            install_url = moz "multi-account-containers";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
          "firefox-translations-addon@mozilla.org" = {
            install_url = moz "firefox-translations";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
        };
        SearchEngines = {
          Remove = [
            "Amazon.com"
            "Bing"
            "DuckDuckGo"
            "Google"
            "LibRedirect"
            "Twitter"
            "Wikipedia"
            "eBay"
            "Ecosia"
            "Wikipedia (en)"
          ];
          Default = "Qwant";
        };
      };
    };
  };
}
