# Order 5
{ inputs, ... }:
{ config, lib, pkgs, unstable, ... }:
# https://mipmip.github.io/home-manager-option-search

let
  inherit (pkgs)
    fetchFromGitHub
    ;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  # MN - not needed, but keeping in case of future breakage
  manpager = (pkgs.writeShellScriptBin "manpager" ''
    col -bx < "$1" | bat --language man -p
  '');

  # Note: Nix Search for package, click on platform to find binary build status
  # Get specific versions of packages here:
  # https://lazamar.co.uk/nix-versions/
  # To get the sha256 hash:
  # nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/e49c28b3baa3a93bdadb8966dd128f9985ea0a09.tar.gz
  # or use an empty sha256 = ""; string, it'll show the hash; prefetch is safer

  # oldPkgs = import
  #   (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/e49c28b3baa3a93bdadb8966dd128f9985ea0a09.tar.gz";
  #     sha256 = "14xrf5kny4k32fns9q9vfixpb8mxfdv2fi4i9kiwaq1yzcj1bnx2";
  #   })
  #   { system = builtins.trace "aarch64-linux" "aarch64-linux"; };
  # TODO - where is system arch config var?
  # { system = builtins.trace config._module.args config._module.args; };
  # { inherit config; };

in
{
  imports = [
    ./sway/sway.nix
    ./i3/i3.nix
    # ./hyprland/hyprland.nix
  ];

  #cat "$1" | col -bx | bat --language man --style plain
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  #home.stateVersion = "18.09";
  home.stateVersion = "23.05";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = [
    #   #GUI Apps
    pkgs.authy
    pkgs.google-chrome
    #   oldPkgs.chromium
    pkgs.obsidian
    ##   pkgs.baobab
    #   pkgs.xfce.thunar
    pkgs.vlc
    pkgs.jellyfin-media-player
    pkgs.spotify
    pkgs.discord
    #   pkgs.rclone
    #   pkgs.rclone-browser
    pkgs.libsForQt5.kdeconnect-kde

    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "RobotoMono" ]; })
    pkgs.fd
    pkgs.bat
    pkgs.fzf
    pkgs.gotop
    pkgs.jq
    #    pkgs.jqp
    pkgs.ripgrep
    #    pkgs.tree
    #    pkgs.watch
    #    pkgs.zathura
    pkgs.zip
    pkgs.unzip
    pkgs.gcc
    pkgs.normcap

    #    pkgs.buildkit
    #    pkgs.neofetch
    pkgs.alacritty-theme

    # Gnome
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.atomix
    pkgs.gnome.gnome-sudoku
    pkgs.gnome.iagno
    pkgs.gnomeExtensions.power-profile-switcher
    pkgs.gnomeExtensions.grand-theft-focus
    pkgs.gnomeExtensions.gnordvpn-local
    pkgs.gnome.dconf-editor

    pkgs.lshw
    # network
    pkgs.inetutils
    pkgs.wget
    pkgs.speedtest-cli
    pkgs.httpstat
    #    pkgs.nmap
    #    pkgs.tshark
    pkgs.sshfs

    pkgs.ffmpeg
    pkgs.obs-studio

    #    pkgs.gum
    pkgs.yt-dlp
    #    pkgs.ytfzf
    pkgs.tealdeer
    #
    # pkgs.go

    #    #pkgs.postgresql_11

    #    #pkgs.redshift
    #    #pkgs.kubectl
    #    #pkgs.krew
    #    #pkgs.terraform
    #    #pkgs.vault
    #    #pkgs.awscli2
    #    #pkgs.azure-cli
    #    #(pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
    #    #pkgs.krew

    #    ##try out
    #    #pkgs.ChatGPT.nvim
    #    pkgs.shell_gpt

    # pkgs.beekeeper-studio

    # nvim LSPs
    pkgs.lua-language-server
    pkgs.nil
    pkgs.marksman
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.pyright
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.vscode-json-languageserver
    pkgs.nodePackages.dockerfile-language-server-nodejs
    pkgs.tailwindcss-language-server
    pkgs.ruff-lsp
    # pkgs.gopls

    # nvim Linters
    pkgs.stylua
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.markdownlint-cli
    pkgs.nodePackages.prettier

    # TODO not quite working:
    pkgs.docker-compose-language-service
  ];

  fonts.fontconfig.enable = true;
  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };
  #MANPAGER = "${manpager}/bin/manpager";

  #home.file.".inputrc".source = ./inputrc;

  # https://github.com/netbrain/zwift
  # docker run -v zwift-$USER:/data --name zwift-copy-op busybox true
  # docker cp .zwift-credentials zwift-copy-op:/data
  # docker rm zwift-copy-op
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.file = {
    "zwift.sh" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/netbrain/zwift/master/zwift.sh";
        hash = "sha256-joipzHtLvy+l4H+NOLTSpVf8bzVGUF4JVDcyfQIt5II=";
      };
      target = ".local/bin/zwift";
      executable = true;
    };
  };

  xdg.configFile = {
    "aliases".text = builtins.readFile ./aliases;
    "m-os.sh".text = builtins.readFile ./m-os.sh;
    "shellConfig".text = builtins.readFile ./shellConfig;
    "fzf-m-os-preview-function.sh".source = config.lib.file.mkOutOfStoreSymlink ./fzf-m-os-preview-function.sh;
    "rofi/rofi-theme-deathemonic.rasi".text = builtins.readFile ./rofi-theme-deathemonic.rasi;

    # After defaults repo is pushed; change the rev to commit hash; make sha254 empty string
    # Then nx-update; Then update sha256 from the failed build
    "defaults".source = fetchFromGitHub {
      owner = "nodu";
      repo = "defaults";
      rev = "6481752";
      sha256 = "ho+/UrZROa+mm17FbJv3SjP3lYKPjI7yprFetYnAZz0=";
    };
  };

  xdg.desktopEntries =
    {
      gotop = {
        type = "Application";
        name = "Activity Monitor (goTop)";
        exec = "gotop";
        terminal = true;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
      normcap = {
        type = "Application";
        name = "normcap - OCR screenshot";
        exec = "normcap";
        categories = [ "Application" ];
      };
      settings = {
        type = "Application";
        name = "Settings";
        exec = "env XDG_CURRENT_DESKTOP=Gnome gnome-control-center";
        categories = [ "Application" "Settings" ];
      };
      zwift = {
        type = "Application";
        name = "Zwift";
        exec = "/home/matt/.local/bin/zwift";
        categories = [ "Application" "Game" ];
      };
    };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
    pinentryFlavor = "gtk2";
  };
  # Setup i3 exclusively in HM; remove from configiguration.nix
  # https://github.com/srid/nix-config/blob/705a70c094da53aa50cf560179b973529617eb31/nix/home/i3.nix
  programs.rofi = {
    enable = true;
    #package = unstable.rofi-wayland;
    # theme = "slate";
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];

    extraConfig = {
      modes = "combi";
      modi = "calc,run,filebrowser,emoji";
      combi-modes = "window,drun";
      show-icons = true;
      sort = true;
      matching = "fuzzy";
      dpi = 220;
      font = "FiraCode Nerd Font 10";
      terminal = "alacritty";
      sorting-method = "fzf";
      kb-mode-next = "Control+n";
      kb-mode-previous = "Control+p";
      kb-element-prev = "";
      kb-element-next = "";
      kb-row-up = "ISO_Left_Tab";
      kb-row-down = "Tab";
      combi-hide-mode-prefix = true;
      display-combi = "";
      display-calc = " ";
      display-drun = "";
      display-window = "";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      click-to-exit = true;
    };
    "theme" = "./rofi-theme-deathemonic.rasi";
  };

  programs.bash = {
    enable = true;
    shellOptions = [ ];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };

  programs.direnv = {
    enable = true;

    config = {
      whitelist = {
        prefix = [
        ];

        exact = [
          "~/repos/job-scraper/"
          "~/repos/www/"
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    #completionInit

    shellAliases = {
      vv = "nvim .";
      znix = "nix-shell --run zsh";

      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";
      nx-update = "cd ~/repos/nixos-baremetal/ && make switch; cd -";
      nx-update-flake = "cd ~/repos/nixos-baremetal/ && nix flake update; cd -";
      nx-search = "nix search nixpkgs";
    };

    history = {
      size = 1000000;
      save = 1000000;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "fzf" "kubectl" "kube-ps1" ];
      theme = "robbyrussell";
    };

    initExtraBeforeCompInit = ''
    '';

    initExtraFirst = ''
    '';

    initExtra = ''
      source $HOME/.config/aliases
      source $HOME/.config/m-os.sh
      source $HOME/.config/defaults/basic.sh
      source $HOME/.config/shellConfig
      eval "$(direnv hook zsh)"
    '';
  };

  programs.git = {
    enable = true;
    userName = "Matt Nodurfth";
    userEmail = "mnodurft@gmail.com";
    signing = {
      key = "";
      signByDefault = false;
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "nodu";
      push.default = "tracking";
      init.defaultBranch = "main";
      url = {
        "git@bitbucket.com:" = {
          insteadOf = "https://bitbucket.com/";
        };
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";

      font = {
        size = 12.0;
        #use_thin_strokes = true;

        normal.family = "FiraCode Nerd Font";
        bold.family = "FiraCode Nerd Font";
        italic.family = "FiraCode Nerd Font";
      };

      cursor.style = "Block";
      dynamic_title = true;
      decorations = "transparent";
      #padding.y = 27;

      key_bindings = [
        { key = "K"; mods = "Alt"; chars = "ClearHistory"; } #remap
        # { key = "V"; mods = "Alt"; action = "Paste"; } #no more command for  copy paste
        # { key = "C"; mods = "Alt"; action = "Copy"; } #cmd is system wide ctrl shift c/v
        { key = "Key0"; mods = "Alt"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Alt"; action = "IncreaseFontSize"; }
        { key = "Plus"; mods = "Alt"; action = "IncreaseFontSize"; }
        { key = "NumpadAdd"; mods = "Alt"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Alt"; action = "DecreaseFontSize"; }
        { key = "NumpadSubtract"; mods = "Alt"; action = "DecreaseFontSize"; }
        { key = "F"; mods = "Alt"; action = "SearchBackward"; }
        { key = "I"; mods = "Alt"; action = "ToggleViMode"; }
        { key = "N"; mods = "Shift|Control"; action = "CreateNewWindow"; }
      ];

      # Colors (Solarized Dark)
      # https://github.com/alacritty/alacritty-theme/tree/master/themes
      colors = {
        # Default colors
        primary = {
          # Dark
          #background= "#011318"; # black
          background = "0x002b36"; #original
          foreground = "0x839496";

          # Light
          #background= "0xfdf6e3";
          #foreground= "0x586e75";
        };
        # Cursor colors
        cursor = {
          text = "#002b36"; # base3
          cursor = "#839496"; # base0
        };
        # Normal colors
        normal = {
          black = "#073642"; # base02
          red = "#dc322f"; # red
          green = "#859900"; # green
          yellow = "#b58900"; # yellow
          blue = "#268bd2"; # blue
          magenta = "#d33682"; # magenta
          cyan = "#2aa198"; # cyan
          white = "#eee8d5"; # base2
        };
        # Bright colors
        bright = {
          black = "#002b36"; # base03
          red = "#cb4b16"; # orange
          green = "#586e75"; # base01
          yellow = "#657b83"; # base00
          blue = "#839496"; # base0
          magenta = "#6c71c4"; # violet
          cyan = "#93a1a1"; # base1
          white = "#fdf6e3"; # base3
        };
      };
    };
  };

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

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;

    plugins = [
    ];

    extraConfig = ''
      source ~/.config/nvim/bootstrap.init.lua
    '';
  };

  #xresources.extraConfig = builtins.readFile ./Xresources;

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };
}
