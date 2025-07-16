{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixvim = {
    #  url = "github:nix-community/nixvim/nixos-25.05";
    #  # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    aw-watcher-window-hyprland = {
      url = "github:bobvanderlinden/aw-watcher-window-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          ./modules/steam.nix

	        # make home-manager as a module of nixos so that home-manager configuration
          # will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.bq.imports = [
              ./home.nix
            ];
          }
        ];

      };
      
    };
}
