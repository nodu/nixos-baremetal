# RPi3 home-manager configuration - headless server
# Imports shared modules for shell, git, neovim, CLI tools, and GPG
# No GUI packages, no desktop entries, no theming

{ inputs, ... }:
{ config, lib, pkgs, unstable, ... }:

{
  imports = [
    inputs.defaults.homeManagerModules.default
    (import ./shared/neovim.nix { inherit inputs; })
    ./shared/shell.nix
    ./shared/git.nix
    ./shared/cli.nix
    ./shared/gpg.nix
    ./shared/ssh.nix
    ./shared/tmux.nix
  ];

  home.stateVersion = "25.11";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.defaults = {
    enable = true;
  };

  # GPG agent uses pinentry-curses (default from shared/gpg.nix)
  # No override needed for headless

  home.packages = [
    # Add rpi3-specific packages here

    # Gaggimate
    pkgs.esptool
  ];
}
