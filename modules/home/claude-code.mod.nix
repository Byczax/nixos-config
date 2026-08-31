{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.claudeCode;
in {
  options.modules.claudeCode = {
    enable = lib.mkEnableOption "declarative Claude Code config";
  };

  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      package = pkgs.claude-code;

      settings = {
        model = "opus";
        theme = "auto";
        effortLevel = "medium";
        includeCoAuthoredBy = false;

        permissions.deny = [
          "Read(~/.ssh/**)"
          "Read(//home/${config.home.username}/.ssh/**)"
          "Bash(cat ~/.ssh/**)"
          "Bash(head ~/.ssh/**)"
          "Bash(tail ~/.ssh/**)"
          "Bash(sed * ~/.ssh/**)"
          "Bash(xxd ~/.ssh/**)"
          "Bash(base64 ~/.ssh/**)"
          "Bash(od ~/.ssh/**)"
          "Bash(strings ~/.ssh/**)"
          "Bash(gpg * ~/.ssh/**)"
        ];

        statusLine = {
          type = "command";
          command = "bash \"${config.home.homeDirectory}/.claude/plugins/cache/caveman/caveman/0d95a81d35a9/src/hooks/caveman-statusline.sh\"";
        };

        enabledPlugins = {
          "caveman@caveman" = true;
          "gopls-lsp@claude-plugins-official" = true;
          "typescript-lsp@claude-plugins-official" = true;
          "pyright-lsp@claude-plugins-official" = true;
        };

        extraKnownMarketplaces = {
          caveman.source = {
            source = "github";
            repo = "JuliusBrussee/caveman";
          };
        };
      };
    };
  };
}
