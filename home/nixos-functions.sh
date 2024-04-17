nx-update() {
	cd ~/repos/nixos-baremetal/ || exit
	make switch
	cd - || exit
}

nx-update-flakes() {
	cd ~/repos/nixos-baremetal/ || exit
	nix flake update
	cd - || exit
}

nx-update-input() {
	# nix flake lock --update-input nixos-hardware
	nix flake lock --update-input "$1"
}

nx-search() {
	nix search nixpkgs
}
