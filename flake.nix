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

    systems = ["x86_64-linux"];
    eachSystem = lib.genAttrs systems;
    pkgsFor = inputs.nixpkgs.legacyPackages;
  in {
    nixosConfigurations = import ./hosts inputs;

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };

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
