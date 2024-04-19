# Order 5
{ inputs, ... }:
{ config, lib, pkgs, unstable, ... }:
# https://mipmip.github.io/home-manager-option-search

let
  inherit (pkgs)
    fetchFromGitHub
    ;

  # Note: Nix Search for package, click on platform to find binary build status
  # Get specific versions of packages here:
  #   https://lazamar.co.uk/nix-versions/
  # To get the sha256 hash:
  #   nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/e49c28b3baa3a93bdadb8966dd128f9985ea0a09.tar.gz
  #   or use an empty sha256 = ""; string, it'll show the hash; prefetch is safer

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
    inputs.nix-colors.homeManagerModules.default
    ./sway/sway.nix
    ./i3/i3.nix
    # ./hyprland/hyprland.nix
  ];

  # https://tinted-theming.github.io/base16-gallery
  # colorScheme = inputs.nix-colors.colorSchemes.onedark;
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;


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
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    # oldPkgs.chromium #example how to import specific versions

    # GUI Apps
    pkgs.authy
    pkgs.google-chrome
    pkgs.obs-studio
    pkgs.obsidian
    pkgs.vlc
    pkgs.jellyfin-media-player
    pkgs.kodi
    pkgs.spotify
    pkgs.discord
    pkgs.anki-bin
    pkgs.helvum
    #pkgs.baobab
    pkgs.zoom-us
    pkgs.slack
    unstable.vscode

    # Utilities
    pkgs.libsForQt5.kdeconnect-kde
    pkgs.neofetch
    pkgs.rclone
    pkgs.fd
    pkgs.bat
    pkgs.gum
    pkgs.glow
    pkgs.fzf
    pkgs.gotop
    pkgs.jq
    pkgs.jqp #jq playground tui
    pkgs.ripgrep
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.gcc
    pkgs.normcap
    pkgs.xdotool
    pkgs.pulseaudio
    pkgs.entr
    pkgs.ffmpeg
    pkgs.killall
    pkgs.lshw
    pkgs.yt-dlp
    pkgs.gamemode
    pkgs.tealdeer

    # Gnome
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.atomix
    pkgs.gnome.gnome-sudoku
    pkgs.gnome.iagno
    pkgs.gnomeExtensions.power-profile-switcher
    pkgs.gnomeExtensions.grand-theft-focus
    pkgs.gnomeExtensions.gnordvpn-local
    pkgs.gnome.dconf-editor
    pkgs.gnomeExtensions.gamemode-indicator-in-system-settings

    # Network
    pkgs.inetutils
    pkgs.wget
    pkgs.speedtest-cli
    pkgs.httpstat
    pkgs.sshfs
    #pkgs.nmap
    #pkgs.tshark

    # pkgs.postgresql_11
    # pkgs.kubectl
    # pkgs.krew
    # pkgs.terraform
    # pkgs.vault
    # pkgs.awscli2
    # pkgs.azure-cli
    # (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
    # pkgs.krew
    # pkgs.beekeeper-studio

    pkgs.go
    pkgs.gopls
    pkgs.python3
    pkgs.nodejs_20
    pkgs.nodePackages.ts-node
    pkgs.yarn

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
    pkgs.shellcheck
    # TODO not quite working:
    pkgs.docker-compose-language-service

    # nvim Linters
    pkgs.stylua
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.markdownlint-cli
    pkgs.nodePackages.prettier
    pkgs.shfmt
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
    MANROFFOPT = "-c";
  };

  #home.file.".inputrc".source = ./inputrc;

  # https://github.com/netbrain/zwift
  # docker run -v zwift-$USER:/data --name zwift-copy-op busybox true
  # docker cp .zwift-credentials zwift-copy-op:/data
  # docker rm zwift-copy-op
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/go/bin" ];
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
    "nixos-functions.sh".text = builtins.readFile ./nixos-functions.sh;
    "apps.sh".text = builtins.readFile ./apps.sh;
    "aliases".text = builtins.readFile ./aliases;
    "m-os.sh".text = builtins.readFile ./m-os.sh;
    "shellConfig".text = builtins.readFile ./shellConfig;
    "fzf-m-os-preview-function.sh".source = config.lib.file.mkOutOfStoreSymlink ./fzf-m-os-preview-function.sh;
    "rofi/rofi-theme-deathemonic.rasi".text = builtins.readFile ./rofi-theme-deathemonic.rasi;
    "rofi/catppuccin-mocha.rasi".text = builtins.readFile ./catppuccin-mocha.rasi;

    # After defaults repo is pushed; change the rev to commit hash; make sha254 empty string
    # Then nx-update; Then update sha256 from the failed build
    "defaults".source = fetchFromGitHub {
      owner = "nodu";
      repo = "defaults";
      rev = "710dfec";
      sha256 = "Q+zUzeS2Imu0+bcrHtk1AT4em91pZFYTxpWuzj/9niY=";
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

  programs.gpg = {
    enable = true;
    settings = {
      no-symkey-cache = false; # Allow caching of Symmetric Passphrases
    };
  };

  services.gpg-agent = {
    enable = true;
    # cache the keys forever so we don't get asked for a password until reboot
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
      modi = "emoji,calc,run,window"; #calc,run,filebrowser,
      combi-modes = "window,drun";
      show-icons = true;
      sort = true;
      matching = "fuzzy";
      dpi = 220;
      font = "Hack Nerd Font Mono 10";
      terminal = "alacritty";
      sorting-method = "fzf";
      combi-hide-mode-prefix = true;
      drun-display-format = "{icon} {name}";
      disable-history = true;
      click-to-exit = true;
      icon-theme = "Oranchelo";
      hide-scrollbar = true;
      sidebar-mode = true;
      display-combi = "";
      display-calc = "";
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      kb-mode-next = "Tab";
      kb-mode-previous = "ISO_Left_Tab"; #Shift+Tab
      kb-element-prev = "";
      kb-element-next = "";
      kb-select-1 = "Alt+1";
      kb-select-2 = "Alt+2";
      kb-select-3 = "Alt+3";
      kb-select-4 = "Alt+4";
      kb-select-5 = "Alt+5";
      kb-select-6 = "Alt+6";
      kb-select-7 = "Alt+7";
      kb-select-8 = "Alt+8";
      kb-select-9 = "Alt+9";
      kb-select-10 = "Alt+0";
      kb-custom-1 = "";
      kb-custom-2 = "";
      kb-custom-3 = "";
      kb-custom-4 = "";
      kb-custom-5 = "";
      kb-custom-6 = "";
      kb-custom-7 = "";
      kb-custom-8 = "";
      kb-custom-9 = "";
      kb-custom-10 = "";
    };
    # "theme" = "./rofi-theme-deathemonic.rasi";
    "theme" = "./catppuccin-mocha.rasi";
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

    shellAliases = { };

    history = {
      size = 1000000;
      save = 1000000;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "fzf" "kubectl" "kube-ps1" "web-search" ];
      theme = "robbyrussell";
    };

    initExtraBeforeCompInit = ''
    '';

    initExtraFirst = ''
    '';

    initExtra = ''
      source $HOME/.config/nixos-functions.sh
      source $HOME/.config/apps.sh
      source $HOME/.config/aliases
      source $HOME/.config/defaults/basic.sh
      source $HOME/.config/m-os.sh
      source $HOME/.config/shellConfig
      eval "$(direnv hook zsh)"
    '';
  };

  programs.git = {
    # located here: ~/.config/git/config
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
    includes = [
      {
        contents = {
          user = {
            email = "matt@mirwork.ai";
            name = "Matt Nodurfth";
          };
        };
        condition = "gitdir:~/repos/mirwork/";
      }
    ];
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

    settings =
      {
        env.TERM = "xterm-256color";
        env.WINIT_X11_SCALE_FACTOR = "1"; #https://major.io/p/disable-hidpi-alacritty/ #i3 font size fix
        font = {
          size = 12.0;
          normal = {
            family = "Hack Nerd Font Mono";
            style = "Regular";
          };

          bold = {
            family = "Hack Nerd Font Mono";
            style = "Bold";
          };

          italic = {
            family = "Hack Nerd Font Mono";
            style = "Italic";
          };

          bold_italic = {
            family = "Hack Nerd Font Mono";
            style = "Bold Italic";
          };

          # echo -e 'Normal, \x1b[1mbold\x1b[22m, \x1b[3mitalic\x1b[23m, \x1b[1;3mbold italic\x1b[22;23m'
          # fc-list
          # https://www.nerdfonts.com/cheat-sheet
          # don't really love the darkgrey backgroun in term and vim... onedark.
          # ➜  ~ fc-list | grep NerdFont |grep Hack
        };

        cursor.style = "Block";
        dynamic_title = true;
        decorations = "transparent";
        history = 100000;
        #padding.y = 27;

        draw_bold_text_with_bright_colors = true;

        key_bindings = [
          # { key = "K"; mods = "Alt"; chars = "ClearHistory"; } #remap
          { key = "Key0"; mods = "Alt"; action = "ResetFontSize"; }
          { key = "Equals"; mods = "Alt"; action = "IncreaseFontSize"; }
          { key = "Plus"; mods = "Alt"; action = "IncreaseFontSize"; }
          { key = "NumpadAdd"; mods = "Alt"; action = "IncreaseFontSize"; }
          { key = "Minus"; mods = "Alt"; action = "DecreaseFontSize"; }
          { key = "NumpadSubtract"; mods = "Alt"; action = "DecreaseFontSize"; }
          { key = "F"; mods = "Alt"; action = "SearchBackward"; }
          { key = "V"; mods = "Alt"; action = "ToggleViMode"; }
          { key = "N"; mods = "Shift|Control"; action = "CreateNewWindow"; }
        ];
        colors = with config.colorScheme.palette; {
          cursor = {
            cursor = "0x${base06}";
            text = "0x${base00}";
          };
          vi_mode_cursor = {
            cursor = "0x${base07}";
            text = "0x${base00}";
          };
          hints = {
            start = {
              foreground = "0x${base00}";
              background = "0x${base0A}";
            };
            end = {
              foreground = "0x${base00}";
              # background = "0x${A6ADC8}";
            };
          };
          selection = {
            text = "0x${base00}";
            background = "0x${base06}";
          };
          search.matches = {
            foreground = "0x${base00}";
            # background = "0x${A6ADC8}";
          };
          footer_bar = {
            foreground = "0x${base00}";
            # background = "0x${A6ADC8}";
          };

          search.focused_match = {
            foreground = "0x${base00}";
            background = "0x${base0B}";
          };
          primary = {
            background = "0x${base00}";
            foreground = "0x${base05}";
            dim_foreground = "0x${base05}";
            bright_foreground = "0x${base05}";
          };
          indexed_colors = [
            {
              index = 16;
              color = "0x${base09}";
            }
            {
              index = 17;
              color = "0x${base06}";
            }
          ];
          # https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/mocha.lua
          # https://github.com/catppuccin/alacritty/blob/main/catppuccin-mocha.toml
          # https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/catppuccin-mocha.yaml
          # https://github.com/tinted-theming/base16-schemes/blob/main/catppuccin-mocha.yaml
          # normal ={
          # black = "0x${base03}";
          # white = "0x${BAC2DE}";
          # magenta = "0x${F5C2E7}";
          # };
          #
          # bright = {
          # black = "0x${base04}";
          # white = "0x${A6ADC8}";
          # yellow = "0x${base0A}";
          # magenta = "0x${F5C2E7}";
          # };
          normal = {
            black = "0x${base03}";
            white = "0x${base06}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            yellow = "0x${base0A}";
          };

          bright = {
            black = "0x${base00}";
            white = "0x${base06}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            yellow = "0x${base09}";
          };

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

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };
}
