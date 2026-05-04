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
        update = "nh os switch $HOME/nixos-config -H ${cfg.host} --ask --diff always";
        update_boot = "nh os boot $HOME/nixos-config -H ${cfg.host} --ask --diff always";
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
        export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.local/bin:$PATH"
        export KUBECONFIG=$HOME/.kube/config
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        ZSH_DISABLE_COMPFIX="true"

        translate() {
          if [ "$#" -ne 3 ]; then
              echo "Usage: translate <text> <source_lang> <target_lang>"
              return 1
          fi

          local TEXT="$1"
          local SOURCE_LANG="$2"
          local TARGET_LANG="$3"
          local API_URL="http://localhost:1188/translate"
          local ACCESS_TOKEN="your_access_token"  # Replace with your actual token

          # Make API request and store response
          RESPONSE=$(curl -s -X POST "$API_URL" \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer $ACCESS_TOKEN" \
              -d "{
                  \"text\": \"$TEXT\",
                  \"source_lang\": \"$SOURCE_LANG\",
                  \"target_lang\": \"$TARGET_LANG\"
              }")

          # Extract values using jq
          CODE=$(echo "$RESPONSE" | jq -r '.code')
          MAIN=$(echo "$RESPONSE" | jq -r '.data')

          if [ "$CODE" -eq 200 ]; then
              echo "$MAIN"

              # Safely print alternatives only if they exist
              echo "$RESPONSE" | jq -r '.alternatives[]?' 2>/dev/null
          else
              echo "Error: Failed to translate"
          fi
        }
      '';
    };
  };
}
