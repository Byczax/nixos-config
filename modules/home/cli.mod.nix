{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.cli.enable = lib.mkEnableOption "Shared terminal tooling";

  config = lib.mkIf config.modules.cli.enable {
    programs = {
      git.enable = true;
      lazygit = {
        enable = true;
        enableZshIntegration = true;
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
      };
      tmux = {
        enable = true;
        clock24 = true;
        historyLimit = 10000;
        mouse = true;
        newSession = true;
        sensibleOnTop = true;
        baseIndex = 1;
        shell = "${pkgs.zsh}/bin/zsh";
        tmuxp.enable = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          tokyo-night-tmux
          yank
        ];
      };
      go.enable = true;
      feh.enable = true;
      fastfetch.enable = true;
      vesktop.enable = true;
      k9s.enable = true;
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "${config.home.homeDirectory}/nixos-config";
      };
    };
  };
}
