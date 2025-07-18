{
  description = "Nixos config flake";

  inputs = {
    # use stable version of nixos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix";
    # use home-manager, it's cool
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Activitywatch for hyprland
    aw-watcher-window-hyprland = {
      url = "github:bobvanderlinden/aw-watcher-window-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    catppuccin,
    home-manager,
    ...
  }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix # systemwide configuration
        ./modules/steam.nix # steam config, avaliable only systemwide

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.bq.imports = [
            ./home.nix # home manager config file
            catppuccin.homeModules.catppuccin
          ] ++ import ./modules/all-home-modules.nix; # modules for home manager
        }
      ];
    };
  };
}
