{ pkgs, lib, ... }:
{
  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3;
  };

  #Packages
  home.packages = with pkgs; [
    pkgs.playerctl
    pkgs.brightnessctl
    pkgs.xscreensaver
    pkgs.xss-lock
    pkgs.maim
    pkgs.xdotool
    pkgs.xclip
    pkgs.networkmanagerapplet
    pkgs.dunst
    pkgs.blueman
    pkgs.xorg.xhost
  ];
  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
      interval = 5;
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "wireless _first_".position = 5;
      "battery all".enable = true;
      "disk /" = {
        position = 1;
        settings = { format = "󰨣 %free (%avail)/ %total"; };
      };
      load = {
        position = 2;
        settings = { format = "󰝲 %1min"; };
      };
      memory = {
        position = 3;
        settings.format = "󰍛 F:%free A:%available (U:%used) / T:%total";
      };
      "ethernet _first_" = {
        enable = false;
        position = 4;
        settings = {
          format_up = "E: %ip"; #
          format_down = "E: down";
        };
      };
      "volume master" = {
        position = 6;
        settings = {
          mixer = "Master";
          format = " %volume";
          format_muted = "♪ muted (%volume)";
          device = "default";
        };
      };
      "tztime local" = {
        position = 7;
        settings = { format = "%Y-%m-%d %H:%M:%S"; };
      };
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#eceff1";
        font = "FiraCode Nerd Font 14";

      };
      urgency_normal = { background = "#37474f"; foreground = "#eceff1"; timeout = 10; };
    };
  };
}
