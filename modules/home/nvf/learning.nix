# Learning helpers for the nvf keymap set.
#
# Single source of truth: `keymaps.nix`. From that list this file derives
#   * `markdownTable` — the generated half of `shortcuts.md`
#   * `drillLua`      — a Lua table used by the dashboard "3 keys a day" drill
#
# Nothing here touches Neovim directly; `nvf.mod.nix` consumes the results.
{lib}: let
  keymaps = import ./keymaps.nix;

  # Keys that are already muscle memory (or are the very first thing to learn).
  # They are excluded from the daily drill so it only surfaces the unknown half.
  # Kept in sync with the "Tier 1" section of shortcuts.md.
  tier1 = [
    "<C-s>"
    "<C-d>"
    "<C-u>"
    "<S-h>"
    "<S-l>"
    "<leader>e"
    "<leader>ff"
    "<leader>fg"
    "<leader>fb"
    "<leader>gg"
    "<leader>tt"
    "<leader>ca"
    "<leader>cr"
    "<leader>cf"
    "<leader>qq"
    "<leader>-"
    "<leader>|"
    "j"
    "k"
    "<Down>"
    "<Up>"
  ];

  mdEscape = lib.replaceStrings ["|"] ["\\|"];
  modesOf = km: lib.concatStringsSep ", " (km.mode or ["n"]);

  row = km: "| `${mdEscape km.key}` | ${modesOf km} | ${mdEscape km.desc} |\n";

  # One entry per key: keymaps.nix repeats a key once per mode group, and the
  # drill should not show the same key three times in a row.
  dedupe = list:
    (builtins.foldl' (acc: km:
      if builtins.elem km.key acc.seen
      then acc
      else {
        seen = acc.seen ++ [km.key];
        out = acc.out ++ [km];
      })
    {
      seen = [];
      out = [];
    }
    list)
    .out;

  drillable = dedupe (builtins.filter (km: !(builtins.elem km.key tier1)) keymaps);

  luaEntry = km: "  { key = ${builtins.toJSON km.key}, desc = ${builtins.toJSON km.desc} },\n";
in {
  inherit keymaps tier1 drillable;

  # Generated section of shortcuts.md. Header included so the file can be
  # concatenated straight onto the hand-written part.
  markdownTable =
    ''
      ## All `keymaps.nix` bindings †

      Generated from `modules/home/nvf/keymaps.nix` — do not edit by hand, run
      `nix build .#nvim-shortcuts` instead. Plugin-default keys are documented in
      the hand-written sections above.

      | Key | Mode | Action |
      | --- | --- | --- |
    ''
    + lib.concatMapStrings row keymaps;

  # Lua table literal `{ {key=..., desc=...}, ... }` — embedded in the
  # dashboard footer expression by nvf.mod.nix.
  drillTable = "{\n" + lib.concatMapStrings luaEntry drillable + "}";
}
