{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.modules.nvf.enable {
    programs.nvf.settings.vim = {
      filetype.extension.mdx = lib.mkForce "mdx";
      treesitter.filetypeMappings.markdown = ["mdx"];
      languages.markdown.extensions.render-markdown-nvim.setupOpts.file_types = ["markdown" "mdx"];
      formatter.conform-nvim.setupOpts.formatters_by_ft.mdx = ["prettier"];
      lsp.servers.mdx-analyzer = {
        enable = true;
        cmd = [(lib.getExe pkgs.mdx-language-server) "--stdio"];
        filetypes = ["mdx"];
        root_markers = [".git" "package.json"];
        init_options.typescript = {
          enabled = true;
          tsdk = "${pkgs.typescript_5}/lib/node_modules/typescript/lib";
        };
      };
    };
  };
}
