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
  if [ -z "$1" ]; then
    echo "Command:"
    echo "nix flake lock --update-input nixos-hardware"
  else
    nix flake lock --update-input "$1"
  fi
}

nx-search() {
  nix-search
}
