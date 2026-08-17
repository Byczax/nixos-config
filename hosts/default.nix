inputs: let
  inherit (inputs) self nixpkgs;
  inherit (nixpkgs) lib;
  inherit (lib.filesystem) listFilesRecursive;

  systemModules =
    lib.filter (lib.hasSuffix ".mod.nix")
    (map toString (listFilesRecursive ../modules/system));

  mkSystem = system: hostname:
    lib.nixosSystem {
      specialArgs = {inherit inputs self;};
      modules =
        [
          {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;
          }
          ./${hostname}/default.nix
        ]
        ++ systemModules;
    };
in {
  yoga = mkSystem "x86_64-linux" "yoga";
  g7 = mkSystem "x86_64-linux" "g7";
}
