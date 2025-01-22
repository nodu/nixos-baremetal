nx-metadata() {
  cd ~/repos/nixos-baremetal/ || exit
  nix flake metadata
  cd - || exit
}

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
    echo "nix flake update nixos-hardware"
  else
    nix flake update "$1"
  fi
}

nx-search() {
  nix-search
}
