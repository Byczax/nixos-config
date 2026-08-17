{pkgs, ...}: {
  nix.settings = {
    download-buffer-size = 524288000;
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
