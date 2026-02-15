# Shared SSH configuration
{ config, lib, pkgs, ... }:

{
  home.file.".ssh/config".text = builtins.readFile ../ssh-config;
}
