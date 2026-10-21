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
  inputs,
  ...
}: let
  inherit (lib) mkOption types mkIf mapAttrs filterAttrs attrValues optionals;
  cfg = config.modules.apps;

  # name -> package. Keys are plain identifiers (option paths); pick camelCase
  # where the package name has dots/dashes.
  catalog = {
    # --- base CLI ----------------------------------------------------------
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
      jq
      comma
      xlsclients
      wl-clipboard
      iperf
      font-awesome
      ;
    qtwayland = pkgs.qt5.qtwayland;

    # --- screenshot / annotation ------------------------------------------
    inherit
      (pkgs)
      grim
      slurp
      grimblast
      ;

    # --- development -------------------------------------------------------
    inherit
      (pkgs)
      gcc
      gnumake
      nodejs
      lua
      luarocks
      gopls
      wakatime-cli
      tree-sitter
      hugo
      vscodium
      ;

    # --- kubernetes / infra -----------------------------------------------
    inherit
      (pkgs)
      kubectl
      krew
      tanka
      jsonnet-bundler
      kubeseal
      ansible
      tenv
      opentofu
      ;
    helm = pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    };

    # --- documents / office / notes / PDF ---------------------------------
    inherit
      (pkgs)
      xournalpp
      trilium-desktop
      typst
      pdf2svg
      pdfpc
      logseq
      joplin
      notesnook
      ;
    libreoffice = pkgs.libreoffice-qt;

    # --- creative / graphics / 3D -----------------------------------------
    inherit
      (pkgs)
      blender
      krita
      imagemagick
      prusa-slicer
      gimp
      freecad
      drawio
      ;
    inkscape = pkgs.inkscape-with-extensions;

    # --- media -------------------------------------------------------------
    inherit
      (pkgs)
      qbittorrent
      vlc
      jellyfin-media-player
      memento
      ;

    # --- network diagnostics / VPN ----------------------------------------
    inherit
      (pkgs)
      dig
      whois
      nmap
      dnslookup
      openconnect
      openssl
      ;

    # --- security / yubikey / secrets -------------------------------------
    inherit
      (pkgs)
      yubikey-manager
      yubioath-flutter
      age-plugin-yubikey
      git-agecrypt
      bitwarden-desktop
      keepass
      ;

    # --- desktop / file manager / display ---------------------------------
    inherit
      (pkgs)
      pavucontrol
      adwaita-icon-theme
      bibata-cursors
      nwg-displays
      wdisplays
      lm_sensors
      ddcutil
      xdotool
      libinput
      gcr
      hyprshade
      hyprsunset
      ;
    dolphin = pkgs.kdePackages.dolphin;
    kio-fuse = pkgs.kdePackages.kio-fuse;
    kio-extras = pkgs.kdePackages.kio-extras;
    qtsvg = pkgs.kdePackages.qtsvg;

    # --- hardware / flashing / virtualization / scanner -------------------
    inherit
      (pkgs)
      popsicle
      rpi-imager
      simple-scan
      quickemu
      qemu
      virt-manager
      ;

    # --- browser / messaging / gaming / gis -------------------------------
    inherit
      (pkgs)
      brave
      signal-desktop
      element-desktop
      prismlauncher
      qgis
      ;

    # orden = inputs.orden.packages.${pkgs.system}.orden-unstable;
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
