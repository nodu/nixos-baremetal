#Order 1
{
  description = "NixOS systems and tools by mattn";
  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other packages
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      home-manager = inputs.home-manager.nixosModules;
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable { inherit system; };


      overlays = [
        inputs.neovim-nightly-overlay.overlay
        #(import ./overlays/sddm.nix)
      ];
    in
    {

      # Overlays is the list of overlays we want to apply from flake inputs.
      nixosConfigurations.baremetal = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          { nixpkgs.overlays = overlays; }

          home-manager.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit unstable; };
            home-manager.users.matt = import ./home/home-manager.nix
              {
                inputs = inputs;
              };
          }


        ];
      };
    };
}


#mkSystem = import ./lib/mksystem.nix {
#inherit nixpkgs nixpkgs-unstable overlays inputs;
#};
#in
#{
## x86_64-linux
#nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
#system = "aarch64-linux";
#user = "matt";
#};

#nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
#system = "x86_64-linux";
#user = "matt";
#};
#  };
#}
