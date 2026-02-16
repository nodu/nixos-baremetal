# Shared SSH configuration
{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "bitbucket.org" = {
        hostname = "bitbucket.org";
        identityFile = "~/.ssh/baremetal";
      };

      "github-personal.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/baremetal";
        extraOptions.IdentitiesOnly = "yes";
      };

      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/mnodu@github";
        extraOptions.IdentitiesOnly = "yes";
      };

      "bau-slate-wifi" = {
        user = "pi";
        hostname = "192.168.8.8";
        identityFile = "~/.ssh/baremetal";
      };

      "bau-slate" = {
        user = "pi";
        hostname = "192.168.8.6";
        identityFile = "~/.ssh/baremetal";
      };

      "bau" = {
        user = "pi";
        hostname = "bau";
        identityFile = "~/.ssh/baremetal";
      };

      "bau-kai" = {
        user = "pi";
        hostname = "192.168.0.6";
        identityFile = "~/.ssh/baremetal";
      };

      "bau-att" = {
        user = "pi";
        hostname = "192.168.1.76";
        identityFile = "~/.ssh/baremetal";
      };

      "bau-mesh-ip" = {
        user = "pi";
        hostname = "100.105.37.182";
        identityFile = "~/.ssh/baremetal";
      };

      "rpi3" = {
        user = "matt";
        hostname = "rpi3";
        identityFile = "~/.ssh/baremetal";
      };

      "moode" = {
        user = "pi";
        hostname = "192.168.0.102";
      };

      "fermentation-station" = {
        user = "pi";
        hostname = "192.168.0.4";
      };

      "*" = {
        extraOptions.IdentitiesOnly = "yes";
      };
    };
  };
}

