let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.pandas
        python-pkgs.requests
        python-pkgs.faker
        python-pkgs.beautifulsoup4
        python-pkgs.flask
        python-pkgs.pyyaml
        python-pkgs.matplotlib
        python-pkgs.discordpy
        python-pkgs.matrix-nio
        python-pkgs.graphviz
        python-pkgs.pyserial
      ]))
    ];
    shell = pkgs.zsh;
    shellHook = ''
      exec zsh
    '';
  }
