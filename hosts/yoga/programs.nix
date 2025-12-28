{pkgs, ...}: {
  home.packages = with pkgs; [
    fira-code #font for terminal
    prismlauncher # minecraft
    vim # as a backup
    brightnessctl # ability to change screen brightness
    font-awesome # fancy icons
    xournalpp # notes app
    signal-desktop
    git
    traceroute
    #(flameshot.override {enableWlrSupport = true;}) # slow screenshot with drawings
    grimblast # fast screenshot
    xorg.xlsclients # check if app is running under X11
    inkscape-with-extensions
    btop
    libreoffice-qt6-fresh
    wl-clipboard #clipboard
    helvum # audio configuration
    qbittorrent
    unzip
    gdu # disk analyzer, better than ncdu
    logseq
    hyprshade
    #lm_sensors #maybe I don't need it
    libqalculate #calculator
    popsicle # os burner
    opentofu

    direnv #why I have that?
    libnotify # what is this for?
    gcc # C++ let's go

    # to fulfill lazyvim plugins
    luarocks
    lazygit
    fd
    lua
    fzf

    #zathura #pdf viewer
    quickemu # virtual machines
    qemu
    virt-manager

    simple-scan # scanner

    (pkgs.texlive.combine {
      inherit
        (pkgs.texlive)
        scheme-basic # base minimal setup
        latex # core LaTeX support
        geometry # example extra packages
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
        ;
    })

    hyprsunset # need to install manually

    iperf
    bitwarden-desktop

    pavucontrol # add audio control alongside helvum
    adwaita-icon-theme # icons for gnome apps

    feh
    tmux
    blender
    krita
    #vscodium
    #atom
    #freecad
    #wireshark
    joplin
    vlc
    nodejs
    tree-sitter
    imagemagick # convert images
    ripgrep
    xdotool
    hugo
    go
    notesnook

    nwg-displays
    lm_sensors
    adwaita-icon-theme
    dysk

    k9s
    kubectl
    krew
    tanka
    jsonnet-bundler
    gnumake
    kubeseal

    vesktop

    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })

    trilium-desktop
    element-desktop
    vscodium
    gimp
    typst
    pdf2svg
    #python3
    dig
    whois
    nmap
    dnslookup
    fastfetch
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
    lmms
    alsa-utils
    libgig
    rpi-imager
    anki
  ];
}
