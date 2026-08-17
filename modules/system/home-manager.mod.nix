{
  config,
  inputs,
  lib,
  ...
}: let
  user = config.meta.mainUser.username;
  homeModules =
    lib.filter (lib.hasSuffix ".mod.nix")
    (map toString (lib.filesystem.listFilesRecursive ../home));
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      compositor = config.meta.compositor;
    };
    users.${user}.imports =
      [
        inputs.nvf.homeManagerModules.default
        inputs.zen-browser.homeModules.twilight
        inputs.agenix.homeManagerModules.default
      ]
      ++ homeModules;
  };
}
