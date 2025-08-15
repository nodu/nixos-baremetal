#Order 1
{
  description = "NixOS systems and tools by mattn";
  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      home-manager = inputs.home-manager.nixosModules;
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };

      overlays = [
        #(import ./overlays/sddm.nix)
      ];
    in
    {
      # Overlays is the list of overlays we want to apply from flake inputs.
      nixosConfigurations.baremetal = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit unstable; }; # Passes unstable input to all modules
        modules = [
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
            home-manager.extraSpecialArgs = { inherit unstable; };
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
