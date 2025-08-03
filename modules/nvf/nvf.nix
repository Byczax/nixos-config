{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nvf;
in {
  options.nvf.enable = lib.mkEnableOption "Enable custom nvf config";

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      # your settings need to go into the settings attribute set
      # most settings are documented in the appendix
      settings = {
        vim = {
          viAlias = false;
          vimAlias = true;
          keymaps = import ./keymaps.nix;
          options = import ./options.nix; 
          globals = {
            mapleader = " ";
            maplocalleader = "\\";
            autoformat = true;
            snacks_animate = true;
            lazyvim_picker = "auto";
            lazyvim_cmp = "auto";
            #ai_cmp = true;
            trouble_lualine = true;
            markdown_recommended_style = 0;
          };
          telescope.enable = true;
          statusline.lualine.enable = true;
          autocomplete = {
            nvim-cmp.enable = true;
          };
          snippets.luasnip.enable = true;
          spellcheck = {
            enable = true;
          };
          diagnostics = {
            nvim-lint = {
              enable = true;
            };
          };
          autopairs.nvim-autopairs.enable = true;
          formatter.conform-nvim.enable = true;
          #filetree.neo-tree.enable = true;
          filetree.nvimTree.enable = true;
          notify.nvim-notify.enable = true;
          #dashboard.dashboard-nvim.enable = true;
          lazy.enable = true;
          tabline.nvimBufferline.enable = true;
          treesitter.enable = true;
          git.enable = true;
          utility.snacks-nvim.enable = true;
          #config.vim.extraPlugins = {
          #  vimtex.package = pkgs.vimPlugins.vimtex;
          #};
          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = false;
            lspsaga.enable = false;
            trouble.enable = false;
            lspSignature.enable = false;
            lspconfig.enable = true;
            lspkind.enable = true;
            nvim-docs-view.enable = true;
          };
          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };
          theme = {
            enable = true;
            name = "tokyonight";
            style = "moon";
            #transparent = true;
          };
          #languages = {
          #  enableFormat = true;
          #  enableTreesitter = true;
          #  enableExtraDiagnostics = true;
          #  bash.enable = true;
          #  clang.enable = true;
          #  java.enable = true;
          #  lua.enable = true;
          #  markdown.enable = true;
          #  python.enable = true;
          #  yaml.enable = true;
          #};
          comments = {
            comment-nvim.enable = true;
          };
        };
      };
    };
  };
}
