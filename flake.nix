#Order 1
{
  description = "NixOS systems and tools by mattn";
  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    handy = {
      url = "github:cjpais/Handy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    defaults = {
      url = "github:nodu/defaults";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      home-manager = inputs.home-manager.nixosModules;
      unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      # TODO: Remove this override once upstream fixes the hash in their flake.nix
      # Upstream issue: AppImage hash mismatch for v0.7.3
      handy = inputs.handy.packages.${system}.default;
      overlays = [
        #(import ./overlays/sddm.nix)
      ];
    in
    {
      # Overlays is the list of overlays we want to apply from flake inputs.
      nixosConfigurations.baremetal = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit unstable handy; }; # Passes unstable and handy inputs to all modules
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./configuration.nix
          {
            environment.systemPackages = [
            ];
          }
          nixos-hardware.nixosModules.framework-13-7040-amd
          { nixpkgs.overlays = overlays; }
          {
            nixpkgs.config.packageOverrides = pkgs: {
              nordvpn = (pkgs.callPackage
                ./modules/vpn.nix
                { });
            };
          }

          home-manager.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit unstable handy; };
            home-manager.users.matt = import ./home/home-manager.nix
              {
                # inputs = inputs;
                inherit inputs; #Same as inputs = inputs;
              };
          }

        ];
      };
    };
}
