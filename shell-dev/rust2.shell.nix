{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  strictDeps = true;

  nativeBuildInputs = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    glib
    gtk3
    gtk4
    webkitgtk_4_1
    libsoup_3
    gobject-introspection
    gsettings-desktop-schemas
  ];

  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
}
