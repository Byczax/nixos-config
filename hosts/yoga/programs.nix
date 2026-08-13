{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.module.apps;
  # Toggle a group with `module.apps.<group>.enable = false;` (defaults on).
  grp = desc: lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install ${desc} packages";
  };
in {
  options.module.apps = {
    screenshot.enable = grp "screenshot / annotation";
    dev.enable = grp "development tooling";
    kubernetes.enable = grp "Kubernetes / infra";
    latex.enable = grp "LaTeX";
    documents.enable = grp "office / notes / PDF";
    creative.enable = grp "graphics / 3D / drawing";
    media.enable = grp "media players / torrents";
    network.enable = grp "network diagnostics / VPN";
    security.enable = grp "Yubikey / secrets";
    desktop.enable = grp "desktop / file manager / display";
    hardware.enable = grp "flashing / scanner / virtualization";
    browser.enable = grp "browsers";
    messaging.enable = grp "messaging";
    gaming.enable = grp "gaming";
    gis.enable = grp "GIS";
  };

  config.home.packages = with pkgs;
    # --- Base CLI (always installed) ---------------------------------------
    [
      fira-code # font for terminal
      brightnessctl # change screen brightness
      traceroute
      unzip
      gdu # disk analyzer, better than ncdu
      dysk # check how full partitions are
      btop # system monitor
      libqalculate # calculator
      libnotify # notifications (notify-send)
      fd
      fzf
      ripgrep
      jq # query tool
      comma # run a command that isn't installed
      xlsclients # check if app runs under X11
      wl-clipboard # clipboard
      qt5.qtwayland
      #icu
    ]
    # --- Screenshot / annotation -------------------------------------------
    ++ lib.optionals cfg.screenshot.enable [
      grim
      slurp
      satty
      grimblast # fast screenshot
    ]
    # --- Development --------------------------------------------------------
    ++ lib.optionals cfg.dev.enable [
      gcc # C++ let's go
      gopls
      nodejs # node stuff
      gnumake
      # lazyvim plugin deps
      luarocks
      lua
      wakatime-cli
      claude-code
      # tree-sitter
      # typescript
      # hugo
      # rubocop
      # vscodium
      # atom
    ]
    # --- Kubernetes / infra -------------------------------------------------
    ++ lib.optionals cfg.kubernetes.enable [
      kubectl # kubernetes
      krew
      tanka # grafana tanka
      jsonnet-bundler # together with jsonnet and grafana tanka
      kubeseal # sealed secrets
      ansible # scripts
      tenv # terraform / opentofu version manager
      (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
      })
      # k9s
      # jsonnet
      # opentofu
    ]
    # --- LaTeX --------------------------------------------------------------
    ++ lib.optionals cfg.latex.enable [
      # texliveFull # full distribution
      (texliveSmall.withPackages (ps:
        with ps; [
          # Base setup, Document Class & Build Tools
          scheme-basic
          latex
          latexmk
          koma-script # Provides scrbook and scrhack

          # Languages & Localization
          babel
          babel-english # Provides 'american' / 'english' language specs

          # Mathematics & Units
          amsmath
          amscls # Provides amsthm
          amsfonts
          mathtools
          siunitx
          units # Provides nicefrac

          # Fonts & Typography
          newpx
          fontaxes
          microtype
          # Layout, Tables & Styling
          tools # Provides array.sty
          float
          booktabs
          wrapfig
          subfig
          enumitem
          xcolor
          pdfpages
          csquotes
          natbib
          # Diagrams & Graphics
          pgf # Provides TikZ and positioning
          pgfplots
          msc
          bytefield
          forest
          environ # Dependency required by forest

          # Code Highlighting (minted dependencies)
          minted
          fvextra
          xstring
          upquote
          lineno
          framed
          fancyvrb
          # Cross-referencing & Links
          hyperref
          cleveref
        ]))
    ]
    # --- Documents / office / notes / PDF ----------------------------------
    ++ lib.optionals cfg.documents.enable [
      xournalpp # notes app
      libreoffice-qt6-fresh
      trilium-desktop # notes app
      typst # new generation typing
      pdf2svg # converter
      pdfpc # display pdf as slides
      # logseq
      # joplin
      # notesnook
    ]
    # --- Creative / graphics / 3D ------------------------------------------
    ++ lib.optionals cfg.creative.enable [
      inkscape-with-extensions
      blender # 3d object creation
      krita # drawing tool
      imagemagick # convert images
      prusa-slicer # 3d printing software
      # gimp
      # freecad # CAD
      # aseprite
      # lmms
      # libgig
    ]
    # --- Media --------------------------------------------------------------
    ++ lib.optionals cfg.media.enable [
      qbittorrent
      vlc # video player
      jellyfin-media-player # connect jellyfin with any other player
      memento # mpv fork that allows to translate subs
      # nicotine-plus
    ]
    # --- Network diagnostics / VPN -----------------------------------------
    ++ lib.optionals cfg.network.enable [
      dig # check DNS record
      whois # check who owns domain
      nmap # check network
      dnslookup # check domain
      openconnect # VPN stuff
      openssl
      # wireshark
      # tcpdump
    ]
    # --- Security / Yubikey / secrets --------------------------------------
    ++ lib.optionals cfg.security.enable [
      yubikey-manager
      yubioath-flutter
      age-plugin-yubikey # combine nixos age with yubikey
      git-agecrypt # encrypt stuff that goes onto github repository
    ]
    # --- Desktop / file manager / display ----------------------------------
    ++ lib.optionals cfg.desktop.enable [
      pavucontrol # audio control alongside helvum
      adwaita-icon-theme # icons for gnome apps
      bibata-cursors # nicer default cursor
      nwg-displays # graphical display manager, simple
      wdisplays # better looking display manager
      lm_sensors # read values from all sensors
      ddcutil # control external screen brightness and other parameters
      kdePackages.dolphin
      kdePackages.kio-fuse # mount remote filesystems via FUSE
      kdePackages.kio-extras # extra protocols (sftp, fish and more)
      kdePackages.qtsvg
      # helvum # audio configuration
      # swaybg
      # xdotool
      # libinput
      # gcr
      # alsa-utils
    ]
    # --- Hardware / flashing / virtualization / scanner --------------------
    ++ lib.optionals cfg.hardware.enable [
      popsicle # os burner
      rpi-imager # raspberry pi image flasher
      simple-scan # scanner
      quickemu # virtual machines
      # vagrant
      # brlaser
      # brgenml1lpr
      # brgenml1cupswrapper
    ]
    # --- Browser ------------------------------------------------------------
    ++ lib.optionals cfg.browser.enable [
      brave # chromium browser for testing
    ]
    # --- Messaging ----------------------------------------------------------
    ++ lib.optionals cfg.messaging.enable [
      signal-desktop
    ]
    # --- Gaming -------------------------------------------------------------
    ++ lib.optionals cfg.gaming.enable [
      prismlauncher # minecraft
    ]
    # --- GIS ----------------------------------------------------------------
    ++ lib.optionals cfg.gis.enable [
      qgis
    ];
}
