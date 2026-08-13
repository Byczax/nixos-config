{pkgs, ...}: {
  home.packages = with pkgs; [
    fira-code #font for terminal
    prismlauncher # minecraft
    brightnessctl # ability to change screen brightness
    xournalpp # notes app
    signal-desktop
    traceroute
    grim
    satty
    grimblast # fast screenshot
    slurp
    xlsclients # check if app is running under X11
    inkscape-with-extensions
    btop
    libreoffice-qt6-fresh
    wl-clipboard #clipboard
    #helvum # audio configuration
    qbittorrent
    unzip
    gdu # disk analyzer, better than ncdu
    # logseq
    #hyprshade
    #lm_sensors #maybe I don't need it
    libqalculate #calculator
    popsicle # os burner
    #opentofu

    libnotify # what is this for?
    gcc # C++ let's go
    gopls
    # to fulfill lazyvim plugins
    # ---
    luarocks
    fd
    lua
    fzf
    # ---

    quickemu # virtual machines

    simple-scan # scanner

    # texliveFull # Latex

    # (pkgs.texlive.combine {
    #   inherit
    #     (pkgs.texlive)
    #     scheme-basic # base minimal setup
    #     latex # core LaTeX support
    #     geometry # example extra packages
    #     xcolor
    #     amsmath
    #     fontspec
    #     hyperref
    #     moderncv
    #     polski
    #     latexmk
    #     enumitem
    #     pgf
    #     titlesec
    # koma-script
    # scrhack
    # mathtools
    # newpx
    # float
    # booktabs
    # siunitx
    # pgfplots
    # xkeyval
    # xstring
    # fontaxes
    # #binhex
    # floatbytocbasic
    # csquotes
    # wrapfig
    # subfig
    # #nicefrac
    # pdfpages
    # cleveref
    # listings
    # kastrup
    # xfrac
    # caption
    # pdflscape
    # units
    # lscapeenhanced
    # newtx
    #     ;
    # })

    (pkgs.texliveSmall.withPackages (ps:
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
    # bitwarden-desktop

    pavucontrol # add audio control alongside helvum
    adwaita-icon-theme # icons for gnome apps

    blender # 3d object creation
    krita # drawing tool
    #vscodium
    #atom
    #wireshark
    # joplin
    vlc # video player
    nodejs # node stuff
    # tree-sitter
    imagemagick # convert images
    ripgrep
    # xdotool
    # hugo
    # notesnook

    nwg-displays # graphical display manager, simple
    lm_sensors # Read values from all sensors
    dysk # check how full are partitions

    # k9s
    kubectl # kubernetes
    krew
    tanka # grafana tanka
    jsonnet-bundler # together with jsonnet and grafana tanka
    gnumake #
    kubeseal # sealed secrets

    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })

    trilium-desktop # notes app
    # gimp
    typst # new generation typing
    pdf2svg # converter
    dig # check DNS record
    whois # check who owns domain
    nmap # check network
    dnslookup # check domain
    pdfpc # display pdf as slides

    kdePackages.dolphin
    kdePackages.kio-fuse #to mount remote filesystems via FUSE
    kdePackages.kio-extras #extra protocols support (sftp, fish and more)
    kdePackages.qtsvg

    ddcutil # control other screen brightness and other parameters
    prusa-slicer # 3d printing software
    openssl #

    # freecad # CAD
    brave # chromium browser for testing

    comma # use comma before for command that is not installed
    # libinput
    # gcr
    # lmms
    # alsa-utils
    # libgig
    rpi-imager # raspberry pi image flasher
    tenv # terraform/open tofu, version manager
    jellyfin-media-player # connect jellyfin with any other player
    memento # mpv fork that allows to translate subs
    # nicotine-plus
    # vagrant
    # rubocop
    ansible # scripts

    yubikey-manager
    yubioath-flutter
    # wireshark
    # tcpdump
    wakatime-cli

    # jsonnet

    # swaybg

    bibata-cursors # change default cursor for something different
    wdisplays # better looking display manager

    qt5.qtwayland
    jq # query tool
    #icu
    # brlaser
    # brgenml1lpr
    # brgenml1cupswrapper

    openconnect # VPN stuff

    # aseprite
    # typescript

    age-plugin-yubikey # combine nixos age with yubikey
    git-agecrypt # encrypt stuff that goes onto github repository

    claude-code
    qgis
  ];
}
