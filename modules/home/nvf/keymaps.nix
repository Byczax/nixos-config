# LazyVim-style keymaps, ported to nvf.
#
# Notes on the nvf keymap schema (modules/neovim/init/mappings.nix upstream):
#   * `action` is a *string*. If it contains Lua, you MUST set `lua = true`,
#     otherwise nvf passes it to `vim.keymap.set` as a literal RHS string.
#   * There is no `remap` option — use `noremap = false` instead.
#   * There is no `condition`/`cond` option.
#   * `expr = true` + `lua = false` means the action is a *Vimscript* expression.
#     `expr = true` + `lua = true` means the Lua function's return value is used.
#
# These keymaps are emitted last (after all plugin configs), so they win over
# plugin defaults. Deliberately NOT re-mapped here, because nvf already binds
# them to something better:
#   <C-h/j/k/l>   vim-tmux-navigator pane/window focus
#   <A-h/j/k/l>   mini.move (move line/selection)
#   f F t T ; s S  mini.jump / flash
#   gr gp gy gm gx mini.operators / mini.basics clipboard
#   <leader>f*    telescope                          <leader>l*  LSP
#   <leader>h*    gitsigns hunks                     <leader>b[nps]* bufferline
#   <leader>d*    nvim-dap                           <leader>s*  session manager
#   <leader>c[obt0] git-conflict                     <leader>t[bd] gitsigns toggles
#   [b ]b [q ]q … mini.bracketed (kept anyway below for LazyVim parity)
# See shortcuts.md for the full rendered list.
[
  ###########################################################################
  # Motion
  ###########################################################################
  {
    key = "j";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gj' : 'j'";
    desc = "Down";
    expr = true;
    silent = true;
  }
  {
    key = "<Down>";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gj' : 'j'";
    desc = "Down";
    expr = true;
    silent = true;
  }
  {
    key = "k";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gk' : 'k'";
    desc = "Up";
    expr = true;
    silent = true;
  }
  {
    key = "<Up>";
    mode = ["n" "x"];
    action = "v:count == 0 ? 'gk' : 'k'";
    desc = "Up";
    expr = true;
    silent = true;
  }
  # Keep the cursor centred while half-page scrolling / joining.
  {
    key = "<C-d>";
    mode = ["n"];
    action = "<C-d>zz";
    desc = "Half Page Down (centered)";
  }
  {
    key = "<C-u>";
    mode = ["n"];
    action = "<C-u>zz";
    desc = "Half Page Up (centered)";
  }
  {
    key = "J";
    mode = ["n"];
    action = "mzJ`z";
    desc = "Join Line (keep cursor)";
  }

  ###########################################################################
  # Windows (resize; focus/resize with C-hjkl / A-hjkl comes from smart-splits)
  ###########################################################################
  {
    key = "<C-Up>";
    mode = ["n"];
    action = "<cmd>resize +2<cr>";
    desc = "Increase Window Height";
  }
  {
    key = "<C-Down>";
    mode = ["n"];
    action = "<cmd>resize -2<cr>";
    desc = "Decrease Window Height";
  }
  {
    key = "<C-Left>";
    mode = ["n"];
    action = "<cmd>vertical resize -2<cr>";
    desc = "Decrease Window Width";
  }
  {
    key = "<C-Right>";
    mode = ["n"];
    action = "<cmd>vertical resize +2<cr>";
    desc = "Increase Window Width";
  }
  {
    key = "<leader>-";
    mode = ["n"];
    action = "<C-w>s";
    desc = "Split Window Below";
  }
  {
    key = "<leader>|";
    mode = ["n"];
    action = "<C-w>v";
    desc = "Split Window Right";
  }
  {
    key = "<leader>w-";
    mode = ["n"];
    action = "<C-w>s";
    desc = "Split Window Below";
  }
  {
    key = "<leader>w|";
    mode = ["n"];
    action = "<C-w>v";
    desc = "Split Window Right";
  }
  {
    key = "<leader>wd";
    mode = ["n"];
    action = "<C-w>c";
    desc = "Delete Window";
  }
  {
    key = "<leader>ww";
    mode = ["n"];
    action = "<C-w>p";
    desc = "Other Window";
  }
  {
    key = "<leader>wm";
    mode = ["n"];
    action = "function() Snacks.toggle.zoom():toggle() end";
    lua = true;
    desc = "Toggle Window Zoom";
  }

  ###########################################################################
  # Move lines
  # <A-hjkl> is already mini.move here, so the LazyVim-style explicit
  # move-line maps live on <A-S-jk> to avoid fighting it.
  ###########################################################################
  {
    key = "<A-J>";
    mode = ["n"];
    action = "<cmd>execute 'move .+' . v:count1<cr>==";
    desc = "Move Line Down";
  }
  {
    key = "<A-K>";
    mode = ["n"];
    action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
    desc = "Move Line Up";
  }
  {
    key = "<A-J>";
    mode = ["i"];
    action = "<esc><cmd>m .+1<cr>==gi";
    desc = "Move Line Down";
  }
  {
    key = "<A-K>";
    mode = ["i"];
    action = "<esc><cmd>m .-2<cr>==gi";
    desc = "Move Line Up";
  }
  {
    key = "<A-J>";
    mode = ["v"];
    action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
    desc = "Move Selection Down";
  }
  {
    key = "<A-K>";
    mode = ["v"];
    action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
    desc = "Move Selection Up";
  }

  ###########################################################################
  # Buffers
  ###########################################################################
  {
    key = "<S-h>";
    mode = ["n"];
    action = "<cmd>bprevious<cr>";
    desc = "Prev Buffer";
  }
  {
    key = "<S-l>";
    mode = ["n"];
    action = "<cmd>bnext<cr>";
    desc = "Next Buffer";
  }
  {
    key = "[b";
    mode = ["n"];
    action = "<cmd>bprevious<cr>";
    desc = "Prev Buffer";
  }
  {
    key = "]b";
    mode = ["n"];
    action = "<cmd>bnext<cr>";
    desc = "Next Buffer";
  }
  {
    key = "<leader>bb";
    mode = ["n"];
    action = "<cmd>e #<cr>";
    desc = "Switch to Other Buffer";
  }
  {
    key = "<leader>`";
    mode = ["n"];
    action = "<cmd>e #<cr>";
    desc = "Switch to Other Buffer";
  }
  {
    key = "<leader>bd";
    mode = ["n"];
    action = "function() Snacks.bufdelete() end";
    lua = true;
    desc = "Delete Buffer (keep window)";
  }
  {
    key = "<leader>bD";
    mode = ["n"];
    action = "<cmd>:bd<cr>";
    desc = "Delete Buffer and Window";
  }
  {
    key = "<leader>bo";
    mode = ["n"];
    action = "function() Snacks.bufdelete.other() end";
    lua = true;
    desc = "Delete Other Buffers";
  }

  ###########################################################################
  # Tabs
  ###########################################################################
  {
    key = "<leader><tab><tab>";
    mode = ["n"];
    action = "<cmd>tabnew<cr>";
    desc = "New Tab";
  }
  {
    key = "<leader><tab>d";
    mode = ["n"];
    action = "<cmd>tabclose<cr>";
    desc = "Close Tab";
  }
  {
    key = "<leader><tab>o";
    mode = ["n"];
    action = "<cmd>tabonly<cr>";
    desc = "Close Other Tabs";
  }
  {
    key = "<leader><tab>f";
    mode = ["n"];
    action = "<cmd>tabfirst<cr>";
    desc = "First Tab";
  }
  {
    key = "<leader><tab>l";
    mode = ["n"];
    action = "<cmd>tablast<cr>";
    desc = "Last Tab";
  }
  {
    key = "<leader><tab>]";
    mode = ["n"];
    action = "<cmd>tabnext<cr>";
    desc = "Next Tab";
  }
  {
    key = "<leader><tab>[";
    mode = ["n"];
    action = "<cmd>tabprevious<cr>";
    desc = "Previous Tab";
  }

  ###########################################################################
  # Search / highlight
  ###########################################################################
  {
    key = "<esc>";
    mode = ["i" "n" "s"];
    action = "<cmd>noh<cr><esc>";
    desc = "Escape and Clear hlsearch";
  }
  {
    key = "<leader>ur";
    mode = ["n"];
    action = "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>";
    desc = "Redraw / Clear hlsearch / Diff Update";
  }
  {
    key = "n";
    mode = ["n"];
    action = "'Nn'[v:searchforward].'zv'";
    expr = true;
    desc = "Next Search Result";
  }
  {
    key = "n";
    mode = ["x" "o"];
    action = "'Nn'[v:searchforward]";
    expr = true;
    desc = "Next Search Result";
  }
  {
    key = "N";
    mode = ["n"];
    action = "'nN'[v:searchforward].'zv'";
    expr = true;
    desc = "Prev Search Result";
  }
  {
    key = "N";
    mode = ["x" "o"];
    action = "'nN'[v:searchforward]";
    expr = true;
    desc = "Prev Search Result";
  }

  ###########################################################################
  # Editing
  ###########################################################################
  # Undo break-points in insert mode.
  {
    key = ",";
    mode = ["i"];
    action = ",<c-g>u";
    desc = "Undo Break Point";
  }
  {
    key = ".";
    mode = ["i"];
    action = ".<c-g>u";
    desc = "Undo Break Point";
  }
  {
    key = ";";
    mode = ["i"];
    action = ";<c-g>u";
    desc = "Undo Break Point";
  }
  {
    key = "<C-s>";
    mode = ["i" "x" "n" "s"];
    action = "<cmd>w<cr><esc>";
    desc = "Save File";
  }
  {
    key = "<leader>K";
    mode = ["n"];
    action = "<cmd>norm! K<cr>";
    desc = "Keywordprg";
  }
  {
    key = "<";
    mode = ["v"];
    action = "<gv";
    desc = "Dedent and Reselect";
  }
  {
    key = ">";
    mode = ["v"];
    action = ">gv";
    desc = "Indent and Reselect";
  }
  # Paste over a selection without clobbering the unnamed register.
  {
    key = "p";
    mode = ["x"];
    action = "\"_dP";
    desc = "Paste (keep register)";
  }
  {
    key = "Y";
    mode = ["v"];
    action = "\"+y";
    desc = "Yank to System Clipboard";
  }
  {
    key = "<leader>y";
    mode = ["n" "v"];
    action = "\"+y";
    desc = "Yank to System Clipboard";
  }
  {
    key = "<leader>Y";
    mode = ["n"];
    action = "\"+y$";
    desc = "Yank Rest of Line to Clipboard";
  }
  {
    key = "<leader>P";
    mode = ["n" "v"];
    action = "\"+p";
    desc = "Paste from System Clipboard";
  }
  # Comments (mini.comment provides gcc/gc).
  {
    key = "gco";
    mode = ["n"];
    action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
    desc = "Add Comment Below";
  }
  {
    key = "gcO";
    mode = ["n"];
    action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
    desc = "Add Comment Above";
  }

  ###########################################################################
  # Files
  ###########################################################################
  {
    key = "<leader>fn";
    mode = ["n"];
    action = "<cmd>enew<cr>";
    desc = "New File";
  }
  {
    key = "<leader>e";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ toggle = true, dir = vim.fn.getcwd() })<CR>";
    desc = "Explorer NeoTree (cwd)";
  }
  {
    key = "<leader>fe";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ toggle = true, dir = vim.fn.getcwd() })<CR>";
    desc = "Explorer NeoTree (cwd)";
  }
  {
    key = "<leader>fE";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ toggle = true, reveal = true })<CR>";
    desc = "Explorer NeoTree (reveal current file)";
  }
  {
    key = "<leader>ge";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ source = 'git_status', toggle = true })<CR>";
    desc = "Git Explorer";
  }
  {
    key = "<leader>be";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ source = 'buffers', toggle = true })<CR>";
    desc = "Buffer Explorer";
  }

  ###########################################################################
  # Location list / quickfix
  ###########################################################################
  {
    key = "<leader>xl";
    mode = ["n"];
    action = "function() local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen); if not ok and err then vim.notify(err, vim.log.levels.ERROR) end end";
    lua = true;
    desc = "Location List";
  }
  {
    key = "<leader>xq";
    mode = ["n"];
    action = "function() local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen); if not ok and err then vim.notify(err, vim.log.levels.ERROR) end end";
    lua = true;
    desc = "Quickfix List";
  }
  {
    key = "[q";
    mode = ["n"];
    action = "vim.cmd.cprev";
    lua = true;
    desc = "Previous Quickfix";
  }
  {
    key = "]q";
    mode = ["n"];
    action = "vim.cmd.cnext";
    lua = true;
    desc = "Next Quickfix";
  }

  ###########################################################################
  # Code / LSP (LazyVim-style aliases; nvf also binds these under <leader>l)
  ###########################################################################
  {
    key = "<leader>cf";
    mode = ["n" "v"];
    action = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
    lua = true;
    desc = "Format";
  }
  {
    key = "<leader>ca";
    mode = ["n" "v"];
    action = "vim.lsp.buf.code_action";
    lua = true;
    desc = "Code Action";
  }
  {
    key = "<leader>cr";
    mode = ["n"];
    action = "vim.lsp.buf.rename";
    lua = true;
    desc = "Rename Symbol";
  }
  {
    key = "<leader>cR";
    mode = ["n"];
    action = "function() Snacks.rename.rename_file() end";
    lua = true;
    desc = "Rename File (LSP aware)";
  }
  {
    key = "<leader>cl";
    mode = ["n"];
    action = "<cmd>checkhealth vim.lsp<cr>";
    desc = "LSP Info";
  }
  {
    key = "gd";
    mode = ["n"];
    action = "vim.lsp.buf.definition";
    lua = true;
    desc = "Goto Definition";
  }
  {
    key = "gD";
    mode = ["n"];
    action = "vim.lsp.buf.declaration";
    lua = true;
    desc = "Goto Declaration";
  }
  {
    key = "gI";
    mode = ["n"];
    action = "vim.lsp.buf.implementation";
    lua = true;
    desc = "Goto Implementation";
  }
  {
    # `gy` is taken by mini.basics (copy to system clipboard), so type
    # definitions live on `gY` instead of LazyVim's `gy`.
    key = "gY";
    mode = ["n"];
    action = "vim.lsp.buf.type_definition";
    lua = true;
    desc = "Goto Type Definition";
  }
  {
    key = "gR";
    mode = ["n"];
    action = "vim.lsp.buf.references";
    lua = true;
    desc = "References";
  }
  {
    key = "gK";
    mode = ["n"];
    action = "vim.lsp.buf.signature_help";
    lua = true;
    desc = "Signature Help";
  }

  ###########################################################################
  # Diagnostics
  ###########################################################################
  {
    key = "<leader>cd";
    mode = ["n"];
    action = "vim.diagnostic.open_float";
    lua = true;
    desc = "Line Diagnostics";
  }
  {
    key = "]d";
    mode = ["n"];
    action = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
    lua = true;
    desc = "Next Diagnostic";
  }
  {
    key = "[d";
    mode = ["n"];
    action = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
    lua = true;
    desc = "Prev Diagnostic";
  }
  {
    key = "]e";
    mode = ["n"];
    action = "function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end";
    lua = true;
    desc = "Next Error";
  }
  {
    key = "[e";
    mode = ["n"];
    action = "function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end";
    lua = true;
    desc = "Prev Error";
  }
  {
    key = "]w";
    mode = ["n"];
    action = "function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN }) end";
    lua = true;
    desc = "Next Warning";
  }
  {
    key = "[w";
    mode = ["n"];
    action = "function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN }) end";
    lua = true;
    desc = "Prev Warning";
  }
  # Snacks "words": jump between LSP references of the word under the cursor.
  {
    key = "]]";
    mode = ["n" "t"];
    action = "function() Snacks.words.jump(vim.v.count1) end";
    lua = true;
    desc = "Next Reference";
  }
  {
    key = "[[";
    mode = ["n" "t"];
    action = "function() Snacks.words.jump(-vim.v.count1) end";
    lua = true;
    desc = "Prev Reference";
  }

  ###########################################################################
  # Git (nvf already binds <leader>gg = lazygit, <leader>h* = gitsigns hunks)
  ###########################################################################
  {
    key = "<leader>gb";
    mode = ["n"];
    action = "function() Snacks.git.blame_line() end";
    lua = true;
    desc = "Git Blame Line";
  }
  {
    key = "<leader>gB";
    mode = ["n" "v"];
    action = "function() Snacks.gitbrowse() end";
    lua = true;
    desc = "Git Browse (open in browser)";
  }
  {
    key = "<leader>gf";
    mode = ["n"];
    action = "function() Snacks.lazygit.log_file() end";
    lua = true;
    desc = "Lazygit Current File History";
  }
  {
    key = "<leader>gl";
    mode = ["n"];
    action = "function() Snacks.lazygit.log() end";
    lua = true;
    desc = "Lazygit Log (cwd)";
  }

  ###########################################################################
  # Terminal
  ###########################################################################
  {
    key = "<leader>tt";
    mode = ["n"];
    action = "function() Snacks.terminal() end";
    lua = true;
    desc = "Terminal (cwd)";
  }
  {
    key = "<leader>tT";
    mode = ["n"];
    action = "function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end";
    lua = true;
    desc = "Terminal (Root Dir)";
  }
  {
    key = "<c-/>";
    mode = ["n"];
    action = "function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end";
    lua = true;
    desc = "Terminal (Root Dir)";
  }
  {
    key = "<c-_>";
    mode = ["n"];
    action = "function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end";
    lua = true;
    desc = "which_key_ignore";
  }
  {
    key = "<c-/>";
    mode = ["t"];
    action = "<cmd>close<cr>";
    desc = "Hide Terminal";
  }
  {
    key = "<c-_>";
    mode = ["t"];
    action = "<cmd>close<cr>";
    desc = "which_key_ignore";
  }
  {
    key = "<esc><esc>";
    mode = ["t"];
    action = "<C-\\><C-n>";
    desc = "Enter Normal Mode";
  }

  ###########################################################################
  # Scratch buffers / misc UI
  ###########################################################################
  {
    key = "<leader>.";
    mode = ["n"];
    action = "function() Snacks.scratch() end";
    lua = true;
    desc = "Toggle Scratch Buffer";
  }
  {
    key = "<leader>S";
    mode = ["n"];
    action = "function() Snacks.scratch.select() end";
    lua = true;
    desc = "Select Scratch Buffer";
  }
  {
    key = "<leader>?";
    mode = ["n"];
    action = "<cmd>WhichKey<cr>";
    desc = "Keymaps (which-key)";
  }
  {
    key = "<leader>ui";
    mode = ["n"];
    action = "vim.show_pos";
    lua = true;
    desc = "Inspect Pos";
  }
  {
    key = "<leader>uI";
    mode = ["n"];
    action = "function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end";
    lua = true;
    desc = "Inspect Treesitter Tree";
  }
  {
    key = "<leader>un";
    mode = ["n"];
    action = "function() Snacks.notifier.hide() end";
    lua = true;
    desc = "Dismiss All Notifications";
  }

  ###########################################################################
  # Quit / sessions
  ###########################################################################
  {
    key = "<leader>qq";
    mode = ["n"];
    action = "<cmd>qa<cr>";
    desc = "Quit All";
  }
  {
    key = "<leader>qQ";
    mode = ["n"];
    action = "<cmd>qa!<cr>";
    desc = "Quit All (force)";
  }

  ###########################################################################
  # UI toggles (<leader>u)
  ###########################################################################
  {
    key = "<leader>us";
    mode = ["n"];
    action = "function() Snacks.toggle.option('spell', { name = 'Spelling' }):toggle() end";
    lua = true;
    desc = "Toggle Spelling";
  }
  {
    key = "<leader>uw";
    mode = ["n"];
    action = "function() Snacks.toggle.option('wrap', { name = 'Wrap' }):toggle() end";
    lua = true;
    desc = "Toggle Wrap";
  }
  {
    key = "<leader>uL";
    mode = ["n"];
    action = "function() Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):toggle() end";
    lua = true;
    desc = "Toggle Relative Number";
  }
  {
    key = "<leader>ul";
    mode = ["n"];
    action = "function() Snacks.toggle.line_number():toggle() end";
    lua = true;
    desc = "Toggle Line Numbers";
  }
  {
    key = "<leader>ud";
    mode = ["n"];
    action = "function() Snacks.toggle.diagnostics():toggle() end";
    lua = true;
    desc = "Toggle Diagnostics";
  }
  {
    key = "<leader>uc";
    mode = ["n"];
    action = "function() Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }):toggle() end";
    lua = true;
    desc = "Toggle Conceal Level";
  }
  {
    key = "<leader>uA";
    mode = ["n"];
    action = "function() Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):toggle() end";
    lua = true;
    desc = "Toggle Tabline";
  }
  {
    key = "<leader>uT";
    mode = ["n"];
    action = "function() Snacks.toggle.treesitter():toggle() end";
    lua = true;
    desc = "Toggle Treesitter Highlighting";
  }
  {
    key = "<leader>ub";
    mode = ["n"];
    action = "function() Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):toggle() end";
    lua = true;
    desc = "Toggle Dark Background";
  }
  {
    key = "<leader>uD";
    mode = ["n"];
    action = "function() Snacks.toggle.dim():toggle() end";
    lua = true;
    desc = "Toggle Dim Inactive Windows";
  }
  {
    key = "<leader>ua";
    mode = ["n"];
    action = "function() Snacks.toggle.animate():toggle() end";
    lua = true;
    desc = "Toggle Animation";
  }
  {
    key = "<leader>ug";
    mode = ["n"];
    action = "function() Snacks.toggle.indent():toggle() end";
    lua = true;
    desc = "Toggle Indent Guides";
  }
  {
    key = "<leader>uS";
    mode = ["n"];
    action = "function() Snacks.toggle.scroll():toggle() end";
    lua = true;
    desc = "Toggle Smooth Scroll";
  }
  {
    key = "<leader>uh";
    mode = ["n"];
    action = "function() Snacks.toggle.inlay_hints():toggle() end";
    lua = true;
    desc = "Toggle Inlay Hints";
  }
  {
    key = "<leader>uW";
    mode = ["n"];
    action = "function() Snacks.toggle.words():toggle() end";
    lua = true;
    desc = "Toggle Reference Highlighting";
  }
  {
    key = "<leader>uz";
    mode = ["n"];
    action = "function() Snacks.toggle.zen():toggle() end";
    lua = true;
    desc = "Toggle Zen Mode";
  }
  {
    key = "<leader>uZ";
    mode = ["n"];
    action = "function() Snacks.toggle.zoom():toggle() end";
    lua = true;
    desc = "Toggle Window Zoom";
  }
  # nvf drives format-on-save through vim.g.formatsave / vim.b.disableFormatSave.
  {
    key = "<leader>uf";
    mode = ["n"];
    action = "function() vim.b.disableFormatSave = not vim.b.disableFormatSave; vim.notify((vim.b.disableFormatSave and 'Disabled' or 'Enabled') .. ' format on save (buffer)') end";
    lua = true;
    desc = "Toggle Autoformat (Buffer)";
  }
  {
    key = "<leader>uF";
    mode = ["n"];
    action = "function() vim.g.formatsave = not vim.g.formatsave; vim.notify((vim.g.formatsave and 'Enabled' or 'Disabled') .. ' format on save (global)') end";
    lua = true;
    desc = "Toggle Autoformat (Global)";
  }

  ###########################################################################
  # Profiler
  ###########################################################################
  {
    key = "<leader>upp";
    mode = ["n"];
    action = "function() Snacks.toggle.profiler():toggle() end";
    lua = true;
    desc = "Toggle Profiler";
  }
  {
    key = "<leader>uph";
    mode = ["n"];
    action = "function() Snacks.toggle.profiler_highlights():toggle() end";
    lua = true;
    desc = "Toggle Profiler Highlights";
  }
]
