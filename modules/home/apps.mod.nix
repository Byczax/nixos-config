# Opt-in application bundles. A host installs a bundle by listing it in
# `modules.apps.bundles`; one-off packages go straight into the host's `home.packages`.
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf attrValues attrNames concatMap elem optionals;
  cfg = config.modules.apps;

  bundles = {
    cli = {
      inherit
        (pkgs)
        fira-code
        brightnessctl
        traceroute
        unzip
        gdu
        dysk
        btop
        libqalculate
        libnotify
        fd
        ripgrep
        comma
        xlsclients
        wl-clipboard
        ;
    };

    dev = {
      inherit
        (pkgs)
        gcc
        gnumake
        nodejs
        lua
        luarocks
        ;
    };

    infra = {
      inherit
        (pkgs)
        kubectl
        krew
        tanka
        jsonnet-bundler
        kubeseal
        ;
      helm = pkgs.wrapHelm pkgs.kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
      };
    };

    office = {
      inherit
        (pkgs)
        xournalpp
        trilium-desktop
        joplin-desktop
        typst
        pdf2svg
        pdfpc
        ;
      libreoffice = pkgs.libreoffice-qt;
    };

    creative = {
      inherit
        (pkgs)
        blender
        krita
        imagemagick
        prusa-slicer
        gimp
        freecad
        openscad
        drawio
        ;
      inkscape = pkgs.inkscape-with-extensions;
    };

    media = {
      inherit
        (pkgs)
        qbittorrent
        vlc
        ;
    };

    network = {
      inherit
        (pkgs)
        dig
        whois
        nmap
        dnslookup
        openssl
        ;
    };

    security = {
      inherit
        (pkgs)
        age-plugin-yubikey
        git-agecrypt
        keepass
        ;
    };

    desktop = {
      inherit
        (pkgs)
        grimblast
        pavucontrol
        adwaita-icon-theme
        nwg-displays
        lm_sensors
        ddcutil
        ;
      dolphin = pkgs.kdePackages.dolphin;
      kio-fuse = pkgs.kdePackages.kio-fuse;
      kio-extras = pkgs.kdePackages.kio-extras;
      qtsvg = pkgs.kdePackages.qtsvg;
    };

    hardware = {
      inherit
        (pkgs)
        popsicle
        simple-scan
        quickemu
        ;
    };

    comms = {
      inherit
        (pkgs)
        # ungoogled-chromium
        signal-desktop
        zoom-us
        ;
    };

    games = {
      inherit (pkgs) prismlauncher;
    };
  };

  latexBundle = pkgs.texliveSmall.withPackages cfg.latexPackages;
in {
  options.modules.apps = {
    bundles = mkOption {
      type = types.listOf (types.enum (attrNames bundles));
      default = [];
      description = "Application bundles to install";
    };
    latex = mkOption {
      type = types.bool;
      default = false;
      description = "Install the LaTeX (texlive) bundle";
    };
    latexPackages = mkOption {
      type = types.anything;
      default = ps:
        with ps; [
          scheme-basic
          latex
          latexmk
          koma-script
          babel
          babel-english
          amsmath
          amscls
          amsfonts
          mathtools
          siunitx
          units
          newpx
          fontaxes
          microtype
          tools
          float
          booktabs
          wrapfig
          subfig
          enumitem
          xcolor
          pdfpages
          csquotes
          natbib
          pgf
          pgfplots
          msc
          bytefield
          forest
          environ
          minted
          fvextra
          xstring
          upquote
          lineno
          framed
          fancyvrb
          hyperref
          cleveref
        ];
      description = "texlive package selection function";
    };
  };

  config = {
    home.packages =
      concatMap (b: attrValues bundles.${b}) cfg.bundles
      ++ optionals cfg.latex [latexBundle];

    home.file.".config/zoomus.conf" = mkIf (elem "comms" cfg.bundles) {
      text = ''
        [General]
        GeoLocale=system
        SensitiveInfoMaskOn=true
        autoScale=true
        captureHDCamera=true
        enableMiniWindow=true
        forceEnableTrayIcon=true
        newMeetingWithVideo=true
        showSystemTitlebar=false
        speaker_volume=255
        system.audio.type=default
        timeFormat12HoursEnable=true
        useSystemTheme=false
        xwayland=false
      '';
    };
  };
}
