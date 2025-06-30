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
    echo "nx-update-input nixos-hardware"
    echo ""
  else
    nix flake update "$1"
  fi
}

nx-search() {
  nix-search
}

nx-info-size() {
  if [ -z "$1" ]; then
    echo "Command:"
    echo "nix path-info --recursive --size --closure-size --human-readable nixpkgs#vlc "
  else
    nix path-info --recursive --size --closure-size --human-readable "$1"
  fi
}
