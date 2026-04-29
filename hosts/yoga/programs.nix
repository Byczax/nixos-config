{pkgs, ...}: {
  home.packages = with pkgs; [
    fira-code #font for terminal
    prismlauncher # minecraft
    brightnessctl # ability to change screen brightness
    xournalpp # notes app
    signal-desktop
    traceroute
    grim
    grimblast # fast screenshot
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

    # to fulfill lazyvim plugins
    luarocks
    fd
    lua
    fzf

    quickemu # virtual machines

    simple-scan # scanner

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

    bitwarden-desktop

    pavucontrol # add audio control alongside helvum
    adwaita-icon-theme # icons for gnome apps

    blender
    krita
    #vscodium
    #atom
    #wireshark
    # joplin
    vlc
    nodejs
    tree-sitter
    imagemagick # convert images
    ripgrep
    xdotool
    hugo
    # notesnook

    nwg-displays
    lm_sensors
    dysk

    # k9s
    kubectl
    krew
    tanka
    jsonnet-bundler
    gnumake
    kubeseal

    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })

    trilium-desktop
    gimp
    typst
    pdf2svg
    dig
    whois
    nmap
    dnslookup
    pdfpc

    kdePackages.dolphin
    kdePackages.kio-fuse #to mount remote filesystems via FUSE
    kdePackages.kio-extras #extra protocols support (sftp, fish and more)
    kdePackages.qtsvg

    ddcutil
    prusa-slicer
    openssl

    freecad
    brave

    comma
    libinput
    gcr
    # lmms
    # alsa-utils
    # libgig
    rpi-imager
    tenv
    jellyfin-media-player
    memento
    # nicotine-plus
    # vagrant
    rubocop
    ansible

    yubikey-manager
    yubioath-flutter
    # wireshark
    tcpdump
    wakatime-cli

    jsonnet

    # swaybg

    bibata-cursors
    wdisplays

    libsForQt5.qt5.qtwayland
    jq
    #icu
  ];
}
