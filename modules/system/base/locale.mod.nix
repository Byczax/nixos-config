{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Zurich";
  console.keyMap = lib.mkDefault "pl";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "pl_PL.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };
}
