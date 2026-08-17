# Central application catalog.
#
# Every entry below becomes an individual toggle `modules.apps.<name>` (default
# true). A host installs an app unless it sets `modules.apps.<name> = false;`.
# LaTeX is a single bundle behind `modules.apps.latex`.
#
# Workflow: to add an app, add it to `catalog`, then per host enable/disable it.
# If an app should be on yoga but not g7: leave default (on) and set it false in
# hosts/g7/home.nix (and vice versa).
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mapAttrs filterAttrs attrValues optionals;
  cfg = config.modules.apps;

  # name -> package. Keys are plain identifiers (option paths); pick camelCase
  # where the package name has dots/dashes.
  catalog = with pkgs; {
    # --- base CLI ----------------------------------------------------------
    fira-code = fira-code;
    brightnessctl = brightnessctl;
    traceroute = traceroute;
    unzip = unzip;
    gdu = gdu;
    dysk = dysk;
    btop = btop;
    libqalculate = libqalculate;
    libnotify = libnotify;
    fd = fd;
    ripgrep = ripgrep;
    jq = jq;
    comma = comma;
    xlsclients = xlsclients;
    wl-clipboard = wl-clipboard;
    qtwayland = qt5.qtwayland;
    iperf = iperf;
    font-awesome = font-awesome;

    # --- screenshot / annotation ------------------------------------------
    grim = grim;
    slurp = slurp;
    grimblast = grimblast;

    # --- development -------------------------------------------------------
    gcc = gcc;
    gnumake = gnumake;
    nodejs = nodejs;
    lua = lua;
    luarocks = luarocks;
    gopls = gopls;
    wakatime-cli = wakatime-cli;
    claude-code = claude-code;
    tree-sitter = tree-sitter;
    hugo = hugo;
    vscodium = vscodium;

    # --- kubernetes / infra -----------------------------------------------
    kubectl = kubectl;
    krew = krew;
    tanka = tanka;
    jsonnet-bundler = jsonnet-bundler;
    kubeseal = kubeseal;
    ansible = ansible;
    tenv = tenv;
    opentofu = opentofu;
    helm = wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    };

    # --- documents / office / notes / PDF ---------------------------------
    xournalpp = xournalpp;
    libreoffice = libreoffice-qt6-fresh;
    trilium-desktop = trilium-desktop;
    typst = typst;
    pdf2svg = pdf2svg;
    pdfpc = pdfpc;
    logseq = logseq;
    joplin = joplin;
    notesnook = notesnook;

    # --- creative / graphics / 3D -----------------------------------------
    inkscape = inkscape-with-extensions;
    blender = blender;
    krita = krita;
    imagemagick = imagemagick;
    prusa-slicer = prusa-slicer;
    gimp = gimp;
    freecad = freecad;

    # --- media -------------------------------------------------------------
    qbittorrent = qbittorrent;
    vlc = vlc;
    jellyfin-media-player = jellyfin-media-player;
    memento = memento;

    # --- network diagnostics / VPN ----------------------------------------
    dig = dig;
    whois = whois;
    nmap = nmap;
    dnslookup = dnslookup;
    openconnect = openconnect;
    openssl = openssl;

    # --- security / yubikey / secrets -------------------------------------
    yubikey-manager = yubikey-manager;
    yubioath-flutter = yubioath-flutter;
    age-plugin-yubikey = age-plugin-yubikey;
    git-agecrypt = git-agecrypt;
    bitwarden-desktop = bitwarden-desktop;

    # --- desktop / file manager / display ---------------------------------
    pavucontrol = pavucontrol;
    adwaita-icon-theme = adwaita-icon-theme;
    bibata-cursors = bibata-cursors;
    nwg-displays = nwg-displays;
    wdisplays = wdisplays;
    lm_sensors = lm_sensors;
    ddcutil = ddcutil;
    dolphin = kdePackages.dolphin;
    kio-fuse = kdePackages.kio-fuse;
    kio-extras = kdePackages.kio-extras;
    qtsvg = kdePackages.qtsvg;
    xdotool = xdotool;
    libinput = libinput;
    gcr = gcr;
    hyprshade = hyprshade;
    hyprsunset = hyprsunset;

    # --- hardware / flashing / virtualization / scanner -------------------
    popsicle = popsicle;
    rpi-imager = rpi-imager;
    simple-scan = simple-scan;
    quickemu = quickemu;
    qemu = qemu;
    virt-manager = virt-manager;

    # --- browser / messaging / gaming / gis -------------------------------
    brave = brave;
    signal-desktop = signal-desktop;
    element-desktop = element-desktop;
    prismlauncher = prismlauncher;
    qgis = qgis;
  };

  # LaTeX bundle. Toggle with modules.apps.latex; the package selection is
  # per-host via modules.apps.latexPackages so each host keeps exactly its set.
  latexBundle = pkgs.texliveSmall.withPackages cfg.latexPackages;
in {
  options.modules.apps =
    {
      # Master switch: off = this module installs nothing.
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install the application catalog";
      };
      latex = mkOption {
        type = types.bool;
        default = true;
        description = "Install the LaTeX (texlive) bundle";
      };
      # Function `ps: [ ... ]` selecting texlive packages. Default = yoga's set;
      # a host can override with its own list.
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
    }
    // mapAttrs (name: _:
      mkOption {
        type = types.bool;
        default = true;
        description = "Install ${name}";
      })
    catalog;

  config = mkIf cfg.enable {
    home.packages =
      attrValues (filterAttrs (name: _: cfg.${name}) catalog)
      ++ optionals cfg.latex [latexBundle];
  };
}
