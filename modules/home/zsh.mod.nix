{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.module.zsh;
in {
  options.module.zsh.enable = lib.mkEnableOption "Enable custom zsh config";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        update = "nh os switch $HOME/nixos-config -H yoga --ask";
        test_vm = "sudo nixos-rebuild build-vm --flake $HOME/nixos-config/#default";
        calc = "qalc";
        bat_protect_on = "sudo echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
        bat_protect_off = "sudo echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      };
      history.size = 100000;
      history.ignorePatterns = ["rm *" "pkill *" "cp *" "la*" ".." "l*" "la*" "./rsync_local.sh" "update" "git *" "nvim *"];
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "robbyrussell";
      };
      initContent = ''
        bindkey "^R" history-incremental-search-backward;
        export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        export KUBECONFIG=$HOME/.kube/vis-config
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
    };
  };
}
