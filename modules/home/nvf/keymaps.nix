[
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
  {
    key = "<C-h>";
    mode = ["n"];
    action = "<C-w>h";
    desc = "Go to Left Window";
    #remap = true;
  }
  {
    key = "<C-j>";
    mode = ["n"];
    action = "<C-w>j";
    desc = "Go to Lower Window";
    #remap = true;
  }
  {
    key = "<C-k>";
    mode = ["n"];
    action = "<C-w>k";
    desc = "Go to Upper Window";
    #remap = true;
  }
  {
    key = "<C-l>";
    mode = ["n"];
    action = "<C-w>l";
    desc = "Go to Right Window";
    #remap = true;
  }
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
    key = "<A-j>";
    mode = ["n"];
    action = "<cmd>execute 'move .+' . v:count1<cr>==";
    desc = "Move Down";
  }
  {
    key = "<A-k>";
    mode = ["n"];
    action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
    desc = "Move Up";
  }
  {
    key = "<A-j>";
    mode = ["i"];
    action = "<esc><cmd>m .+1<cr>==gi";
    desc = "Move Down";
  }
  {
    key = "<A-k>";
    mode = ["i"];
    action = "<esc><cmd>m .-2<cr>==gi";
    desc = "Move Up";
  }
  {
    key = "<A-j>";
    mode = ["v"];
    action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
    desc = "Move Down";
  }
  {
    key = "<A-k>";
    mode = ["v"];
    action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
    desc = "Move Up";
  }
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
    key = "<leader>bD";
    mode = ["n"];
    action = "<cmd>:bd<cr>";
    desc = "Delete Buffer and Window";
  }
  #{
  #  key = "<esc>";
  #  mode = ["i" "n" "s"];
  #  action = ":lua (function() vim.cmd('noh'); return '<esc>' end)()<CR>";
  #  expr = true;
  #  desc = "Escape and Clear hlsearch";
  #}
  {
    key = "<leader>ur";
    mode = ["n"];
    action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
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
    mode = ["x"];
    action = "'Nn'[v:searchforward]";
    expr = true;
    desc = "Next Search Result";
  }
  {
    key = "n";
    mode = ["o"];
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
    mode = ["x"];
    action = "'nN'[v:searchforward]";
    expr = true;
    desc = "Prev Search Result";
  }
  {
    key = "N";
    mode = ["o"];
    action = "'nN'[v:searchforward]";
    expr = true;
    desc = "Prev Search Result";
  }
  {
    key = ",";
    mode = ["i"];
    action = ",<c-g>u";
  }
  {
    key = ".";
    mode = ["i"];
    action = ".<c-g>u";
  }
  {
    key = ";";
    mode = ["i"];
    action = ";<c-g>u";
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
  }
  {
    key = ">";
    mode = ["v"];
    action = ">gv";
  }
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
  {
    key = "<leader>l";
    mode = ["n"];
    action = "<cmd>Lazy<cr>";
    desc = "Lazy";
  }
  {
    key = "<leader>fn";
    mode = ["n"];
    action = "<cmd>enew<cr>";
    desc = "New File";
  }
  # -- Location and Quickfix Lists
  {
    key = "<leader>xl";
    mode = ["n"];
    action = "function() local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen); if not success and err then vim.notify(err, vim.log.levels.ERROR) end end";
    desc = "Location List";
  }
  {
    key = "<leader>xq";
    mode = ["n"];
    action = "function() local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen); if not success and err then vim.notify(err, vim.log.levels.ERROR) end end";
    desc = "Quickfix List";
  }
  {
    key = "[q";
    mode = ["n"];
    action = "vim.cmd.cprev";
    desc = "Previous Quickfix";
  }
  {
    key = "]q";
    mode = ["n"];
    action = "vim.cmd.cnext";
    desc = "Next Quickfix";
  }

  # -- Formatting
  {
    key = "<leader>cf";
    mode = ["n" "v"];
    action = "function() vim.lsp.buf.format({ force = true }) end";
    desc = "Format";
  }

  # -- Diagnostics
  {
    key = "<leader>cd";
    mode = ["n"];
    action = "vim.diagnostic.open_float";
    desc = "Line Diagnostics";
  }
  {
    key = "]d";
    mode = ["n"];
    action = "function() vim.diagnostic.goto_next() end";
    desc = "Next Diagnostic";
  }
  {
    key = "[d";
    mode = ["n"];
    action = "function() vim.diagnostic.goto_prev() end";
    desc = "Prev Diagnostic";
  }
  {
    key = "]e";
    mode = ["n"];
    action = "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end";
    desc = "Next Error";
  }
  {
    key = "[e";
    mode = ["n"];
    action = "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end";
    desc = "Prev Error";
  }
  {
    key = "]w";
    mode = ["n"];
    action = "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end";
    desc = "Next Warning";
  }
  {
    key = "[w";
    mode = ["n"];
    action = "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end";
    desc = "Prev Warning";
  }

  # -- Quit
  {
    key = "<leader>qq";
    mode = ["n"];
    action = "<cmd>qa<cr>";
    desc = "Quit All";
  }

  # -- Inspect
  {
    key = "<leader>ui";
    mode = ["n"];
    action = "vim.show_pos";
    desc = "Inspect Pos";
  }
  {
    key = "<leader>uI";
    mode = ["n"];
    action = "function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end";
    desc = "Inspect Tree";
  }

  # -- Terminal (floating)
  {
    key = "<leader>fT";
    mode = ["n"];
    action = "function() Snacks.terminal() end";
    desc = "Terminal (cwd)";
  }
  {
    key = "<leader>ft";
    mode = ["n"];
    action = "function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end";
    desc = "Terminal (Root Dir)";
  }
  {
    key = "<c-/>"; # Control forward slash
    mode = ["n"];
    action = "function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end";
    desc = "Terminal (Root Dir)";
  }
  {
    key = "<c-_>"; # Control underscore
    mode = ["n"];
    action = "function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end";
    desc = "which_key_ignore";
  }
  {
    key = "<C-/>"; # Terminal mode exit
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

  # -- Windows
  {
    key = "<leader>-";
    mode = ["n"];
    action = "<C-W>s";
    desc = "Split Window Below";
    #remap = true;
  }
  {
    key = "<leader>|";
    mode = ["n"];
    action = "<C-W>v";
    desc = "Split Window Right";
    #remap = true;
  }
  {
    key = "<leader>wd";
    mode = ["n"];
    action = "<C-W>c";
    desc = "Delete Window";
    #remap = true;
  }

  # -- Tabs
  {
    key = "<leader><tab>l";
    mode = ["n"];
    action = "<cmd>tablast<cr>";
    desc = "Last Tab";
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
    key = "<leader><tab><tab>";
    mode = ["n"];
    action = "<cmd>tabnew<cr>";
    desc = "New Tab";
  }
  {
    key = "<leader><tab>]";
    mode = ["n"];
    action = "<cmd>tabnext<cr>";
    desc = "Next Tab";
  }
  {
    key = "<leader><tab>d";
    mode = ["n"];
    action = "<cmd>tabclose<cr>";
    desc = "Close Tab";
  }
  {
    key = "<leader><tab>[";
    mode = ["n"];
    action = "<cmd>tabprevious<cr>";
    desc = "Previous Tab";
  }

  # -- Snippets for nvim < 0.11
  {
    key = "<Tab>";
    mode = ["s"];
    action = "function() return vim.snippet.active({ direction = 1 }) and '<cmd>lua vim.snippet.jump(1)<cr>' or '<Tab>' end";
    expr = true;
    desc = "Jump Next";
  }
  {
    key = "<S-Tab>";
    mode = ["i" "s"];
    action = "function() return vim.snippet.active({ direction = -1 }) and '<cmd>lua vim.snippet.jump(-1)<cr>' or '<S-Tab>' end";
    expr = true;
    desc = "Jump Previous";
  }
  {
    key = "<leader>uf";
    mode = ["n"];
    action = "function() vim.lsp.buf.format.snacks_toggle() end";
    desc = "Toggle Autoformat";
  }
  {
    key = "<leader>uF";
    mode = ["n"];
    action = "function() vim.lsp.buf.format.snacks_toggle(true) end";
    desc = "Force Toggle Autoformat";
  }
  {
    key = "<leader>us";
    mode = ["n"];
    action = ":lua vim.opt.spell = not vim.opt.spell:get()<CR>";
    desc = "Toggle Spelling";
  }
  {
    key = "<leader>uw";
    mode = ["n"];
    action = ":lua vim.opt.wrap = not vim.opt.wrap:get()<CR>";
    desc = "Toggle Wrap";
  }
  {
    key = "<leader>uL";
    mode = ["n"];
    action = ":lua vim.opt.relativenumber = not vim.opt.relativenumber:get()<CR>";
    desc = "Toggle Relative Number";
  }
  {
    key = "<leader>ud";
    mode = ["n"];
    action = "function() Snacks.toggle.diagnostics() end";
    desc = "Toggle Diagnostics";
  }
  {
    key = "<leader>ul";
    mode = ["n"];
    action = "function() Snacks.toggle.line_number() end";
    desc = "Toggle Line Numbers";
  }
  {
    key = "<leader>uc";
    mode = ["n"];
    action = "function() Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' })() end";
    desc = "Toggle Conceal Level";
  }
  {
    key = "<leader>uA";
    mode = ["n"];
    action = "function() Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' })() end";
    desc = "Toggle Tabline";
  }
  {
    key = "<leader>uT";
    mode = ["n"];
    action = "function() Snacks.toggle.treesitter() end";
    desc = "Toggle Treesitter Highlighting";
  }
  {
    key = "<leader>ub";
    mode = ["n"];
    action = "function() Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' })() end";
    desc = "Toggle Background";
  }
  {
    key = "<leader>uD";
    mode = ["n"];
    action = "function() Snacks.toggle.dim() end";
    desc = "Toggle Dim Inactive Windows";
  }
  {
    key = "<leader>ua";
    mode = ["n"];
    action = "function() Snacks.toggle.animate() end";
    desc = "Toggle Animation";
  }
  {
    key = "<leader>ug";
    mode = ["n"];
    action = "function() Snacks.toggle.indent() end";
    desc = "Toggle Indent Guides";
  }
  {
    key = "<leader>uS";
    mode = ["n"];
    action = "function() Snacks.toggle.scroll() end";
    desc = "Toggle Smooth Scroll";
  }
  {
    key = "<leader>dpp";
    mode = ["n"];
    action = "function() Snacks.toggle.profiler() end";
    desc = "Toggle Profiling";
  }
  {
    key = "<leader>dph";
    mode = ["n"];
    action = "function() Snacks.toggle.profiler_highlights() end";
    desc = "Toggle Profiling Highlights";
  }
  {
    key = "<leader>uh";
    mode = ["n"];
    action = "function() Snacks.toggle.inlay_hints() end";
    desc = "Toggle Inlay Hints";
    #condition = "vim.lsp.inlay_hint ~= nil";
  }
  {
    key = "<leader>wm";
    mode = ["n"];
    action = "function() Snacks.toggle.zoom() end";
    desc = "Toggle Window Zoom";
  }
  {
    key = "<leader>uZ";
    mode = ["n"];
    action = "function() Snacks.toggle.zoom() end";
    desc = "Toggle Window Zoom";
  }
  {
    key = "<leader>uz";
    mode = ["n"];
    action = "function() Snacks.toggle.zen() end";
    desc = "Toggle Zen Mode";
  }
  {
    key = "<leader>fe";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ toggle = true, dir = vim.fn.getcwd() })<CR>";
    desc = "Explorer NeoTree (Root Dir)";
  }
  {
    key = "<leader>e";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ toggle = true, dir = vim.fn.getcwd() })<CR>";
    desc = "Explorer NeoTree (Root Dir)";
  }
  {
    key = "<leader>ge";
    mode = ["n"];
    action = "<cmd>lua require('neo-tree.command').execute({ source = 'git_status', toggle = true })<CR>";
    desc = "Git Explorer";
  }
  {
    key = "Y";
    mode = ["v"];
    action = "\"+y";
  }
]
