inputs: let
  inherit (inputs) self nixpkgs;
  inherit (nixpkgs) lib;
  inherit (lib.filesystem) listFilesRecursive;

  roleModules = role:
    lib.filter (lib.hasSuffix ".mod.nix")
    (map toString (listFilesRecursive ../modules/system/${role}));

  mkSystem = system: hostname: roles:
    lib.nixosSystem {
      specialArgs = {inherit inputs self;};
      modules =
        [
          {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;
            nixpkgs.overlays = [self.overlays.default];
          }
          ./${hostname}/default.nix
        ]
        ++ lib.concatMap roleModules (["base"] ++ roles);
    };
in {
  yoga = mkSystem "x86_64-linux" "yoga" ["desktop"];
  g7 = mkSystem "x86_64-linux" "g7" ["desktop"];
}
