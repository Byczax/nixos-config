{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Neovim with very nice nix way of configuration
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Fork of Firefox that has much cleaner interface
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # watt = {
    #   url = "github:notashelf/watt";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # zedless.url = "github:zedless-editor/zed";
    # impermanence.url = "github:nix-community/impermanence";
    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # Nice clipboard history manager
    # stash = {
    #   url = "github:notashelf/stash";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # Check nix files for the dead code
    # deadnix = {
    #   url = "github:astro/deadnix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # statix = {
    #   url = "github:oppiliappan/statix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };
  };

  outputs = {self, ...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (builtins) map toString;

    systems = ["x86_64-linux"];
    eachSystem = lib.genAttrs systems;
    pkgsFor = inputs.nixpkgs.legacyPackages;

    mkSystem = system: hostname: conf-name: compositor:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs compositor self;};
        modules =
          [
            ./hosts/${conf-name}/configuration.nix
            ./modules/system/secrets/secrets.mod.nix

            inputs.home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              nixpkgs.hostPlatform = system;
            }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs compositor;};

                users.bq.imports =
                  [
                    ./hosts/${conf-name}/home.nix
                    inputs.nvf.homeManagerModules.default
                    inputs.zen-browser.homeModules.twilight
                    inputs.agenix.homeManagerModules.default
                  ]
                  ++ lib.filter (lib.hasSuffix ".mod.nix") (map toString (lib.filesystem.listFilesRecursive ./modules/home));
              };
            }
          ]
          ++ lib.filter (lib.hasSuffix ".mod.nix") (map toString (lib.filesystem.listFilesRecursive ./modules/system));
      };
  in {
    nixosConfigurations = {
      yoga = mkSystem "x86_64-linux" "yoga" "yoga" "hyprland";
      g7 = mkSystem "x86_64-linux" "g7" "g7" "hyprland";
    };
    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };

    # Your development shell handles importing the binary directly
    devShells = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in {
      default = pkgs.mkShellNoCC {
        packages = [
          inputs.agenix-rekey.packages.${system}.default
          pkgs.age-plugin-yubikey
        ];
        shellHook = ''
          export AGENIX_REKEY_PRIMARY_IDENTITY=$(age-plugin-yubikey --identity 2>&1 | awk '/^Recipient:/ {key=$2} END {print key}')
          echo "Agenix environment active. YubiKey Identity loaded."
        '';
      };
    });
  };
}
