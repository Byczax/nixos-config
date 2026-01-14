{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    aw-watcher-hyprland = {
      url = "github:bobvanderlinden/aw-watcher-window-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # watt = {
    #   url = "github:notashelf/watt";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # agenix-rekey = {
    #   url = "github:oddlama/agenix-rekey";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # zedless.url = "github:zedless-editor/zed";
    # impermanence.url = "github:nix-community/impermanence";
    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (builtins) map toString;

    mkSystem = system: hostname: conf-name:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = system;

        modules =
          [
            ./hosts/${conf-name}/configuration.nix

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit inputs;};

              home-manager.users.bq.imports =
                [
                  ./hosts/${conf-name}/home.nix
                  inputs.nvf.homeManagerModules.default
                  inputs.zen-browser.homeModules.twilight
                ]
                ++ lib.filter (lib.hasSuffix ".mod.nix") (map toString (lib.filesystem.listFilesRecursive ./modules/home));
            }
          ]
          ++ lib.filter (lib.hasSuffix ".mod.nix") (map toString (lib.filesystem.listFilesRecursive ./modules/system));
      };
  in {
    nixosConfigurations = {
      yoga = mkSystem "x86_64-linux" "yoga" "yoga";
      g7 = mkSystem "x86_64-linux" "g7" "g7";
    };
  };
}
