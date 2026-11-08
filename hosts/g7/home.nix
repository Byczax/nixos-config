{
  config,
  pkgs,
  ...
}: {
  modules.apps = {
    bundles = ["cli" "dev" "infra" "office" "creative" "media" "network" "security" "desktop" "hardware" "comms" "games"];
    latex = true;
    latexPackages = ps:
      with ps; [
        scheme-basic
        latex
        geometry
        xcolor
        amsmath
        fontspec
        hyperref
        moderncv
        polski
        latexmk
        enumitem
        pgf
        titlesec
      ];
  };

  home.packages = with pkgs; [
    iperf
    font-awesome
    tree-sitter
    hugo
    vscodium
    opentofu
    logseq
    notesnook
    bitwarden-desktop
    xdotool
    libinput
    gcr_4
    hyprshade
    hyprsunset
    qemu
    virt-manager
    element-desktop
  ];

  home.stateVersion = "25.05";
  home.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  # Make sure if you enable it, to configure the fans
  # dell-bios-fan-control.enable = true;

  # make sure that user have polish layout
  home.keyboard = {
    layout = "pl";
  };

  services.swayidle.enable = true;

  #services.hyprsunset = {
  #  enable = true;
  #  transitions = {
  #    sunrise = {
  #      calendar = "*-*-* 06:00:00";
  #      requests = [
  #        ["temperature" "6500"]
  #        ["gamma 100"]
  #      ];
  #    };
  #    sunset = {
  #      calendar = "*-*-* 19:00:00";
  #      requests = [
  #        ["temperature" "2500"]
  #      ];
  #    };
  #  };
  #};
  #services.hyprpaper.enable = true;
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    #profiles.default = {
    #    bookmarks = [];
    #    settings = {};
    #  };
  };

  services.syncthing = {
    enable = true;
  };

  # other games that are not on steam
  programs.lutris = {
    enable = true;
    winePackages = [
      pkgs.wineWow64Packages.full
    ];
  };

  # mail client
  programs.thunderbird = {
    enable = true;
    profiles = {};
  };

  # do I need it?
  fonts.fontconfig.enable = true;

  modules.desktop.enable = true;
  modules.cli.enable = true;
  #nvim.enable = true;
  modules.helix.enable = true;

  modules.nvf.enable = true;

  modules.waybar.enable = true;

  modules.zsh = {
    enable = true;
  };

  modules.activitywatch.enable = true;

  #catppuccin.enable = true;
}
