# Shared neovim configuration: neovim nightly + LSPs + linters/formatters
{ inputs, ... }:
{ config, lib, pkgs, unstable, ... }:

{
  programs.neovim = {
    # https://github.com/nix-community/neovim-nightly-overlay/issues/525
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = [
    ];

    extraConfig = ''
      source ~/.config/nvim/bootstrap.init.lua
    '';

    extraPackages = [
    ];
  };

  home.packages = [
    # neovim
    pkgs.tree-sitter

    # Minimal LSPs for Nix/shell config editing (shared across all hosts)
    pkgs.nil
    pkgs.nodePackages.bash-language-server
    pkgs.shellcheck
    pkgs.nixpkgs-fmt
    pkgs.shfmt
  ];
}
