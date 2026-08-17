{pkgs, ...}: {
  # Weekly garbage collection so the store does not grow unbounded (disk-fill is
  # a common cause of a system that suddenly won't build or boot).
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    download-buffer-size = 524288000;

    # Binary caches: pull prebuilt hyprland / niri / nvf / community packages
    # instead of compiling them locally. Big build-time win.
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "flakes"
      "nix-command"
      "recursive-nix"
      "pipe-operators"
    ];
    trusted-users = ["bq"];
    auto-optimise-store = true;
    warn-dirty = false;
    keep-going = true;
    auto-allocate-uids = true;
    use-cgroups = pkgs.stdenv.isLinux;
    builders-use-substitutes = true;
    accept-flake-config = false;
    max-jobs = "auto";
    cores = 0;
  };
}
