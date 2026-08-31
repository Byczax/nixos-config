# Neovim shortcuts

Reference for the nvf-based Neovim in this config
(`modules/home/nvf/`). Leader is `<Space>`, local leader is `\`.

Two sources of keymaps:

* **`keymaps.nix`** — the LazyVim-style set maintained here. These are emitted
  *after* every plugin config, so they win any conflict.
* **plugin defaults** — telescope, gitsigns, mini.*, nvim-dap, bufferline,
  toggleterm, flash, vim-tmux-navigator, etc., configured in `nvf.mod.nix`.

Press `<Space>` and wait — which-key (helix preset) shows what is available.
`<Space>?` opens the full which-key list.

---

## Cheatsheet — most used

| Key | Action |
| --- | --- |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffers |
| `<Space>e` | File explorer (neo-tree) |
| `<Space>gg` | Lazygit |
| `<Space>tt` | Floating terminal |
| `<C-s>` | Save file |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-h/j/k/l>` | Move between windows (and tmux panes) |
| `<Space>ca` | Code action |
| `<Space>cr` | Rename symbol |
| `<Space>cf` | Format |
| `<Space>qq` | Quit all |

---

## Motion and scrolling

| Key | Mode | Action |
| --- | --- | --- |
| `j` / `k`, `<Down>` / `<Up>` | n, x | Down / up, respecting wrapped lines (`gj`/`gk`) |
| `<C-d>` / `<C-u>` | n | Half page down / up, cursor re-centred |
| `J` | n | Join lines, keeping the cursor in place |
| `f` / `F` / `t` / `T` / `;` | n, v, o | mini.jump — jump to character, `;` repeats |
| `s` / `S` | n, v, o | Flash / Flash Treesitter jump |
| `<CR>` | n, v, o | mini.jump2d — 2D jump anywhere on screen |
| `%`, `[%`, `]%` | n | matchit — jump to matching construct |
| `n` / `N` | n, x, o | Next / previous search result, always in the same direction, folds opened |

## Windows

| Key | Action |
| --- | --- |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Focus window left/down/up/right (tmux aware) |
| `<C-\>` | Focus previously used window/pane |
| `<Space><Space>h/j/k/l` | Swap buffer with the neighbouring window |
| `<C-Up>` / `<C-Down>` | Increase / decrease window height |
| `<C-Left>` / `<C-Right>` | Decrease / increase window width |
| `<Space>-` or `<Space>w-` | Split window below |
| `<Space>\|` or `<Space>w\|` | Split window right |
| `<Space>wd` | Close window |
| `<Space>ww` | Go to previous window |
| `<Space>wm` / `<Space>uZ` | Toggle window zoom |

## Buffers

| Key | Action |
| --- | --- |
| `<S-h>` / `[b` | Previous buffer |
| `<S-l>` / `]b` | Next buffer |
| `[B` / `]B` | First / last buffer |
| `<Space>bb` / `` <Space>` `` | Switch to the alternate buffer |
| `<Space>bd` | Delete buffer, keep the window layout |
| `<Space>bD` | Delete buffer *and* window |
| `<Space>bo` | Delete all other buffers |
| `<Space>be` | Buffer explorer (neo-tree) |
| `<Space>bn` / `<Space>bp` | Cycle bufferline next / previous |
| `<Space>bc` | Pick a buffer from the bufferline |
| `<Space>bmn` / `<Space>bmp` | Move the buffer in the bufferline |
| `<Space>bse` / `<Space>bsd` / `<Space>bsi` | Sort bufferline by extension / directory / id |

## Tabs

| Key | Action |
| --- | --- |
| `<Space><Tab><Tab>` | New tab |
| `<Space><Tab>d` | Close tab |
| `<Space><Tab>o` | Close other tabs |
| `<Space><Tab>f` / `<Space><Tab>l` | First / last tab |
| `<Space><Tab>[` / `<Space><Tab>]` | Previous / next tab |

## Files and explorer

| Key | Action |
| --- | --- |
| `<Space>e` / `<Space>fe` | Toggle neo-tree at the cwd |
| `<Space>fE` | Toggle neo-tree revealing the current file |
| `<Space>ge` | neo-tree git status view |
| `<Space>be` | neo-tree buffer list view |
| `<Space>fn` | New file |
| `<Space>cR` | Rename current file (updates LSP references) |
| `<C-s>` | Save (works in normal, insert, visual, select) |

## Find (telescope)

| Key | Action |
| --- | --- |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffers |
| `<Space>fh` | Help tags |
| `<Space>ft` | Telescope picker list |
| `<Space>fr` | Resume last picker |
| `<Space>fs` | Treesitter symbols |
| `<Space>fp` | Projects |
| `<Space>fld` | Diagnostics |
| `<Space>flr` / `<Space>fli` | LSP references / implementations |
| `<Space>flD` / `<Space>flt` | LSP definitions / type definitions |
| `<Space>flsb` / `<Space>flsw` | LSP document / workspace symbols |
| `<Space>fvf` | Git files |
| `<Space>fvs` / `<Space>fvx` | Git status / stash |
| `<Space>fvb` | Git branches |
| `<Space>fvcw` / `<Space>fvcb` | Git commits (repo / current buffer) |

## Search and highlight

| Key | Action |
| --- | --- |
| `<Esc>` | Leave insert/select mode *and* clear search highlight |
| `<Space>ur` | Redraw, clear hlsearch, refresh diff |
| `g/` (visual) | Search inside the visual selection |
| `<C-s>` (cmdline) | Toggle flash search |

## Editing

| Key | Mode | Action |
| --- | --- | --- |
| `,` `.` `;` | i | Insert an undo break point (so `u` undoes in sane chunks) |
| `<` / `>` | v | Dedent / indent and keep the selection |
| `p` | x | Paste over selection without clobbering the unnamed register |
| `Y` / `<Space>y` | v / n, v | Yank to the system clipboard |
| `<Space>Y` | n | Yank to end of line into the system clipboard |
| `<Space>P` | n, v | Paste from the system clipboard |
| `gy` / `gp` | n, x | mini.basics copy to / paste from the system clipboard |
| `<A-S-j>` / `<A-S-k>` | n, i, v | Move the line / selection down / up |
| `<A-h/j/k/l>` | n, v | mini.move — move line / selection in any direction |
| `go` / `gO` | n | Put an empty line below / above |
| `<Space>K` | n | Run `keywordprg` on the word under the cursor |

### mini.operators, align, surround

| Key | Action |
| --- | --- |
| `gr` | Replace the text object with the register contents |
| `gm` / `gmm` | Multiply (duplicate) a text object / line |
| `gx` | Exchange two text objects |
| `g=` / `g==` | Evaluate a text object / line as code |
| `gs` (visual) | Sort the selection |
| `gS` | Split / join arguments |
| `ga` / `gA` | Align / align with preview |
| `gz` + motion | nvim-surround: add surround (`gzz` line, `gZ` current, `gZZ` current line) |
| `gzd` / `gzr` | nvim-surround: delete / change surround |
| `<C-g>z` (insert) | nvim-surround: insert surround |
| `gc` / `gcc` | Comment a text object / line |
| `gco` / `gcO` | Add a comment line below / above and enter insert mode |

### Text objects (mini.ai)

`i` / `a` plus a target, extended with `n` (next) and `l` (last):
`ain`, `aln`, `iin`, `iil`, … `ii` / `ai` also select the current indent scope.

## Code and LSP

The `<Space>c*` maps below are the LazyVim-style entry points. nvf also
installs a buffer-local `<Space>l*` group when an LSP attaches.

| Key | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gY` | Go to type definition (`gy` is taken by mini.basics clipboard) |
| `gR` | List references (`gr` is mini.operators "replace", so the Neovim `grn`/`gra`/`gri` defaults are shadowed here) |
| `gK` | Signature help |
| `<Space>ca` | Code action (normal and visual) |
| `<Space>cr` | Rename symbol |
| `<Space>cR` | Rename file, LSP aware |
| `<Space>cf` | Format buffer or selection (conform, LSP fallback) |
| `<Space>cd` | Show diagnostics for the current line |
| `<Space>cl` | `:checkhealth vim.lsp` |
| `<C-w>d` | Show diagnostics under the cursor in a float |

nvf's buffer-local LSP group (available when a server is attached):

| Key | Action |
| --- | --- |
| `<Space>lgd` / `<Space>lgD` | Definition / declaration |
| `<Space>lgt` / `<Space>lgi` / `<Space>lgr` | Type / implementations / references |
| `<Space>lgn` / `<Space>lgp` | Next / previous diagnostic |
| `<Space>lh` / `<Space>ls` | Hover / signature help |
| `<Space>ln` / `<Space>la` / `<Space>lf` | Rename / code action / format |
| `<Space>le` | Open the diagnostic float |
| `<Space>lH` / `<Space>lS` | Document highlight / document symbols |
| `<Space>lwa` / `<Space>lwr` / `<Space>lwl` / `<Space>lws` | Workspace folder add / remove / list, workspace symbols |
| `<Space>ltf` | Toggle format on save for this buffer |
| `<Space>lvt` / `<Space>lvu` | Toggle / update the docs-view panel |

### Completion (blink.cmp)

| Key | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Select next / previous item, or jump through snippet placeholders |
| `<C-Space>` | Show the completion menu |
| `<C-e>` | Hide the menu |
| `<C-f>` / `<C-d>` | Scroll the documentation window |
| `<C-j>` (insert) | Expand snippet |

## Diagnostics, quickfix, references

| Key | Action |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous **error** |
| `]w` / `[w` | Next / previous **warning** |
| `]D` / `[D` | Last / first diagnostic (mini.bracketed) |
| `]]` / `[[` | Next / previous reference of the word under the cursor (Snacks words) |
| `<Space>xq` | Toggle the quickfix list |
| `<Space>xl` | Toggle the location list |
| `]q` / `[q` | Next / previous quickfix entry |
| `]Q` / `[Q` | Last / first quickfix entry |

## Git

| Key | Action |
| --- | --- |
| `<Space>gg` | Lazygit (toggleterm) |
| `<Space>gl` | Lazygit log for the repo |
| `<Space>gf` | Lazygit log for the current file |
| `<Space>gb` | Blame the current line |
| `<Space>gB` | Open the current line/selection on the git forge in a browser |
| `<Space>ge` | neo-tree git status |
| `<Space>hs` / `<Space>hr` | Stage / reset hunk (also works on a visual range) |
| `<Space>hu` | Undo stage hunk |
| `<Space>hS` / `<Space>hR` | Stage / reset the whole buffer |
| `<Space>hP` | Preview hunk |
| `<Space>hb` | Blame line (gitsigns) |
| `<Space>hd` / `<Space>hD` | Diff this file / the project |
| `<Space>tb` / `<Space>td` | Toggle inline blame / deleted lines |
| `]h` / `[h`, `]H` / `[H` | Next / previous hunk, last / first hunk |
| `gh` / `gH` | Apply / reset hunks over a text object |
| `<Space>co` / `<Space>ct` / `<Space>cb` / `<Space>c0` | Merge conflict: choose ours / theirs / both / none |
| `]x` / `[x` | Next / previous conflict |

## Terminal

| Key | Action |
| --- | --- |
| `<Space>tt` | Floating terminal (cwd) |
| `<Space>tT` / `<C-/>` | Floating terminal (root dir) |
| `<C-t>` | Toggle the toggleterm terminal |
| `<C-/>` (terminal mode) | Hide the terminal |
| `<Esc><Esc>` (terminal mode) | Leave terminal mode into normal mode |

## Debugging (nvim-dap)

| Key | Action |
| --- | --- |
| `<Space>dc` | Continue |
| `<Space>db` | Toggle breakpoint |
| `<Space>dgj` / `<Space>dgi` / `<Space>dgo` | Step over / into / out |
| `<Space>dgk` | Step back |
| `<Space>dgc` | Run to cursor |
| `<Space>dvo` / `<Space>dvi` | Move up / down the stack trace |
| `<Space>dh` | Hover the value under the cursor |
| `<Space>dr` | Toggle the REPL |
| `<Space>dR` / `<Space>dq` / `<Space>d.` | Restart / terminate / re-run last session |
| `<Space>du` | Toggle the DAP UI |

## Sessions and projects

| Key | Action |
| --- | --- |
| `<Space>sl` | Load a session |
| `<Space>slt` | Load the last session |
| `<Space>sc` | Save the current session |
| `<Space>sd` | Delete a session |
| `<Space>fp` | Switch project (project.nvim + telescope) |

## UI toggles — `<Space>u`

| Key | Toggles |
| --- | --- |
| `<Space>us` | Spelling |
| `<Space>uw` | Line wrap |
| `<Space>ul` | Line numbers |
| `<Space>uL` | Relative line numbers |
| `<Space>ud` | Diagnostics |
| `<Space>uc` | Conceal level |
| `<Space>uA` | Tabline |
| `<Space>uT` | Treesitter highlighting |
| `<Space>ub` | Dark / light background |
| `<Space>uD` | Dim inactive windows |
| `<Space>ua` | Animations |
| `<Space>ug` | Indent guides |
| `<Space>uS` | Smooth scrolling |
| `<Space>uh` | LSP inlay hints |
| `<Space>uW` | Reference highlighting (Snacks words) |
| `<Space>uz` | Zen mode |
| `<Space>uZ` / `<Space>wm` | Window zoom |
| `<Space>uf` | Format on save, this buffer |
| `<Space>uF` | Format on save, globally |
| `<Space>un` | Dismiss all notifications |
| `<Space>ui` / `<Space>uI` | Inspect highlight groups / treesitter tree |
| `<Space>upp` / `<Space>uph` | Profiler / profiler highlights |

mini.basics also provides `\`-prefixed option toggles: `\n` number,
`\r` relativenumber, `\w` wrap, `\s` spell, `\c` cursorline,
`\C` cursorcolumn, `\d` diagnostics, `\b` background.

## Misc

| Key | Action |
| --- | --- |
| `<Space>.` | Toggle a scratch buffer |
| `<Space>S` | Pick a scratch buffer |
| `<Space>?` | Show the which-key keymap list |
| `<Space>qq` / `<Space>qQ` | Quit all / quit all without saving |

## Bracket motions (mini.bracketed)

`[`/`]` plus a lowercase letter moves backward/forward, the uppercase letter
jumps to the first/last item:

`b` buffer · `c` comment · `d` diagnostic · `f` file in the directory ·
`h` git hunk · `i` indent · `j` jump list · `l` location list ·
`o` oldfile · `q` quickfix · `t` treesitter node · `u` undo state ·
`w` window · `x` merge conflict · `y` yank history

---

## Why some LazyVim maps differ here

LazyVim owns its whole config; here the LazyVim set is layered on top of nvf's
plugin defaults, so a few keys had to move:

| LazyVim | Here | Reason |
| --- | --- | --- |
| `<A-j>` / `<A-k>` move line | `<A-S-j>` / `<A-S-k>` | `<A-h/j/k/l>` is mini.move |
| `<C-h/j/k/l>` window focus | unchanged, from vim-tmux-navigator | also switches tmux panes |
| `gy` goto type definition | `gY` | `gy` is mini.basics "copy to clipboard" |
| `gr` references | `gR` | `gr` is mini.operators "replace" |
| `<Space>ft` / `<Space>fT` terminal | `<Space>tt` / `<Space>tT` | `<Space>f*` is the telescope group |
| `<Space>l` lazy.nvim UI | dropped | plugins are managed by Nix, not lazy.nvim |
| `<Space>dpp` / `<Space>dph` profiler | `<Space>upp` / `<Space>uph` | `<Space>d*` is the debugger group |
| `<Space>bd` bufremove | same key, Snacks.bufdelete | `<Space>bD` still deletes buffer + window |
