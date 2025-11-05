{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aw-watcher-hyprland = {
      url = "github:bobvanderlinden/aw-watcher-window-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }@inputs: 
  let 
    inherit (nixpkgs) lib;
    inherit (builtins) filter map toString;
  in
  {
    nixosConfigurations.yoga = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hosts/yoga/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };

          home-manager.users.bq.imports = [
            ./hosts/yoga/home.nix
            inputs.nvf.homeManagerModules.default
          ] ++ lib.filter (lib.hasSuffix ".mod.nix") (map toString (lib.filesystem.listFilesRecursive ./modules));

          #++ import ./modules/all-home-modules.nix; # modules for home manager
        }
      ];
    };
    nixosConfigurations.g7 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hosts/g7/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.bq.imports = [
            ./hosts/g7/home.nix
            inputs.nvf.homeManagerModules.default 
          ] ++ lib.filter (lib.hasSuffix ".mod.nix") (map toString (lib.filesystem.listFilesRecursive ./modules));
          #++ import ./modules/all-home-modules.nix; # modules for home manager
        }
      ];
    };
  };
}
