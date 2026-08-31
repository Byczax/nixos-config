# Packages vendored into this flake, exposed through `overlays.default`.
#
# deepseek-harness: DeepSeek Harness (`dsh`). Not in nixpkgs yet — package.nix
# is the expression from the open init PR (NixOS/nixpkgs#552467), copied
# verbatim so it can be dropped wholesale once the PR lands in unstable.
final: _prev: {
  deepseek-harness = (final.callPackage ./deepseek-harness/package.nix {}).overrideAttrs (old: {
    # The lockfile has ~1200 entries and pnpm aborts the entire fetch when one
    # request exceeds its 60 s default — a losing bet on a slow link. This is
    # the only difference from the upstream expression, and it does not touch
    # the fixed-output hash: that pins the fetched content, not how it was
    # fetched.
    pnpmDeps = old.pnpmDeps.override {
      prePnpmInstall = ''
        pnpm config set fetch-timeout 900000
        pnpm config set fetch-retries 10
        pnpm config set fetch-retry-maxtimeout 300000
        pnpm config set network-concurrency 8
      '';
    };
  });
}
