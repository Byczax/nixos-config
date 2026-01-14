{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.module.zsh;
in {
  options.module.zsh = {
    enable = lib.mkEnableOption "Enable custom zsh config";
    host = lib.mkOption {
      type = lib.types.str;
      description = "Host name for nh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        update = "nh os switch $HOME/nixos-config -H ${cfg.host} --ask";
        test_vm = "sudo nixos-rebuild build-vm --flake $HOME/nixos-config#${cfg.host}";
        calc = "qalc";
        bat_protect_on = "sudo echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
        bat_protect_off = "sudo echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      };
      history = {
        extended = true;
        size = 100000;
        append = true;
        share = true;
        #ignoreDups = true;
        #ignorePatterns = ["rm *" "pkill *" "cp *" "la*" ".." "l*" "la*" "./rsync_local.sh" "update" "git *" "nvim *"];
      };
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
