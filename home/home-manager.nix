# Order 5
{ inputs, ... }:
{ config, lib, pkgs, unstable, handy, ... }:
# https://mipmip.github.io/home-manager-option-search

let
  inherit (pkgs)
    fetchFromGitHub
    ;

  # Note: Nix Search for package, click on platform to find binary build status
  # Get specific versions of packages here:
  #   https://lazamar.co.uk/nix-versions/
  #   ex) https://lazamar.co.uk/nix-versions/?channel=nixos-23.11&package=authy
  # To get the sha256 hash:
  #   nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/e49c28b3baa3a93bdadb8966dd128f9985ea0a09.tar.gz
  #   or use an empty sha256 = ""; string, it'll show the hash; prefetch is safer

  oldauthy = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/eb090f7b923b1226e8beb954ce7c8da99030f4a8.tar.gz";
      sha256 = "15iglsr7h3s435a04313xddah8vds815i9lajcc923s4yl54aj4j";
    })
    {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  # { inherit config; };
  # oldPkgs = import
  #   (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/e49c28b3baa3a93bdadb8966dd128f9985ea0a09.tar.gz";
  #     sha256 = "14xrf5kny4k32fns9q9vfixpb8mxfdv2fi4i9kiwaq1yzcj1bnx2";
  #   })
  #   { system = builtins.trace "aarch64-linux" "aarch64-linux"; };
  # TODO: - where is system arch config var?
  # { system = builtins.trace config._module.args config._module.args; };
  # { inherit config; };

  freerdpLauncherGPC =
    pkgs.writeShellApplication
      {
        name = "freerdp3-launcher-GPC.sh";
        runtimeInputs = [ pkgs.zenity pkgs.freerdp3 ];
        text = ''
          pw=$(gpg --decrypt "$HOME"/repos/nixos-baremetal/gpc-rdp-secret.gpg)
          # pw=$(zenity --entry --title="Domain Password" --text="Enter your _password:" --hide-text)
          xfreerdp /v:192.168.0.3 +clipboard /dynamic-resolution /sound:sys:alsa /u:GPC /d: /p:"$pw"
        '';
      };
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
    # freerdp3GPClauncher Add the shell application here if wanted in path
    # oldPkgs.chromium #example how to import specific versions

    # GUI Apps
    oldauthy.authy
    pkgs.google-chrome
    pkgs.firefox
    unstable.ladybird
    pkgs.obs-studio
    pkgs.vlc
    pkgs.jellyfin-media-player
    # pkgs.kodi
    pkgs.spotify
    pkgs.discord
    pkgs.anki-bin
    #pkgs.baobab
    pkgs.zoom-us
    # unstable.vscode
    pkgs.scrcpy
    pkgs.uhk-agent
    pkgs.prusa-slicer
    pkgs.bitwarden-desktop
    unstable.godot
    pkgs.freerdp3
    pkgs.remmina
    pkgs.kdePackages.okular # PDF
    pkgs.blender
    unstable.rpi-imager
    pkgs.arandr
    handy

    pkgs.zenity

    # Sound
    pkgs.helvum
    pkgs.qpwgraph
    pkgs.pwvucontrol
    pkgs.coppwr
    pkgs.audacity

    # Utilities
    pkgs.nix-search-cli
    pkgs.libsForQt5.kdeconnect-kde
    pkgs.neofetch
    pkgs.rclone
    pkgs.fd
    pkgs.bat
    pkgs.gum
    pkgs.glow
    pkgs.fzf
    pkgs.gotop
    pkgs.btop
    pkgs.jq
    pkgs.jqp #jq playground tui
    pkgs.ripgrep
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.gcc
    pkgs.normcap
    pkgs.xdotool
    pkgs.entr
    pkgs.ffmpeg
    pkgs.killall
    pkgs.lshw
    pkgs.yt-dlp
    pkgs.tealdeer
    # Check Bios version:
    # sudo dmidecode | grep -A3 'Vendor:\|Product:' && sudo lshw -C cpu | grep -A3 'product:\|vendor:'
    pkgs.dmidecode
    pkgs.openpomodoro-cli
    pkgs.file
    pkgs.dig

    # GPU
    pkgs.gamemode
    pkgs.amdgpu_top
    pkgs.lact
    pkgs.corectrl

    # Gnome
    pkgs.gnome-tweaks
    pkgs.atomix
    pkgs.gnome-sudoku
    pkgs.iagno
    pkgs.gnomeExtensions.power-profile-switcher
    pkgs.gnomeExtensions.grand-theft-focus
    pkgs.gnomeExtensions.gnordvpn-local
    pkgs.gnomeExtensions.nordvpn-quick-toggle
    pkgs.dconf-editor

    # Network
    pkgs.inetutils
    pkgs.wget
    pkgs.speedtest-cli
    pkgs.httpstat
    pkgs.sshfs
    pkgs.nmap
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

    unstable.claude-code
    unstable.opencode

    pkgs.go
    pkgs.python3
    pkgs.nodejs_22
    pkgs.nodePackages.ts-node
    pkgs.yarn
    pkgs.cargo

    # neovim
    pkgs.tree-sitter
    # nvim LSPs
    ## Mason cannot setup because NixOS cannot run binarys
    pkgs.nil
    pkgs.marksman

    pkgs.lua-language-server
    pkgs.vtsls
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.nodePackages.typescript-language-server
    pkgs.pyright
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.vscode-json-languageserver
    pkgs.nodePackages.dockerfile-language-server-nodejs
    pkgs.tailwindcss-language-server
    pkgs.shellcheck
    # TODO: Update to stable
    # pkgs.ruff-lsp
    unstable.ruff
    # TODO: not quite working:
    pkgs.docker-compose-language-service

    # nvim Linters
    pkgs.stylua
    pkgs.nixpkgs-fmt
    pkgs.markdownlint-cli2
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
  home.sessionPath = [
    "$HOME/.npm/global/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];

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
    "rofi/rofi-theme-deathemonic.rasi".text = builtins.readFile ./rofi/rofi-theme-deathemonic.rasi;
    "rofi/catppuccin-mocha.rasi".text = builtins.readFile ./rofi/catppuccin-mocha.rasi;
    "rofi/power-profiles.rasi".text = builtins.readFile ./rofi/power-profiles.rasi;
    "rofi/arc-dark-colors.rasi".text = builtins.readFile ./rofi/arc-dark-colors.rasi;

    # After defaults repo is pushed; change the rev to commit hash; make sha254 empty string
    # Then nx-update; Then update sha256 from the failed build
    "defaults".source = fetchFromGitHub {
      owner = "nodu";
      repo = "defaults";
      rev = "347ce09708ef36134b6075f7a1550d1b81aa04e0";
      sha256 = "oN6I3tZQ3cRGr62tl/GUkswbWgawmfgpyt/drMe3paw=";
    };
  };

  xdg.desktopEntries =
    {
      btop = {
        type = "Application";
        name = "Activity Monitor (btop)";
        exec = "btop";
        terminal = true;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
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
      sunsama = {
        type = "Application";
        name = "Sunsama";
        exec = "/home/matt/AppImages/sunsama-3.0.7-build-250130sppknclbo-x86_64.AppImage";
        categories = [ "Application" ];
      };
      zwift = {
        type = "Application";
        name = "Zwift";
        exec = "/home/matt/.local/bin/zwift";
        categories = [ "Application" "Game" ];
      };
      freeRDPGPC = {
        type = "Application";
        name = "RDP GPC";
        icon = "🖥️";
        terminal = false;
        exec = lib.getExe freerdpLauncherGPC;
        categories = [ "Application" ];
      };
      handy = {
        type = "Application";
        name = "Handy";
        comment = "Offline speech-to-text";
        exec = "handy";
        terminal = false;
        categories = [ "Application" "Utility" "Audio" ];
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
    pinentry.package = pkgs.pinentry-gtk2;
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
      modi = "combi,emoji,filebrowser,calc,run,window"; #calc,run,filebrowser,
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
      display-filebrowser = "📁";
      display-combi = "🔎";
      display-emoji = "😀";
      display-calc = "🧮";
      display-drun = "   Apps ";
      display-run = "🚀";
      display-window = "🪟";
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
    enableZshIntegration = true;

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
    autosuggestion.enable = true;
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

    initContent = ''
      source $HOME/.config/nixos-functions.sh
      source $HOME/.config/apps.sh
      source $HOME/.config/aliases
      source $HOME/.config/defaults/basic.sh
      source $HOME/.config/defaults/network.sh
      source $HOME/.config/defaults/git.sh
      source $HOME/.config/m-os.sh
      source $HOME/.config/shellConfig
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
            email = "matt@work.com";
            name = "Matt Nodurfth";
          };
        };
        condition = "gitdir:~/repos/work/";
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

    package = unstable.alacritty;

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
        window.dynamic_title = true;
        window.decorations = "Full";
        scrolling.history = 100000;
        #padding.y = 27;

        keyboard.bindings = [
          # { key = "K"; mods = "Alt"; chars = "ClearHistory"; } #remap
          { key = "Key0"; mods = "Alt"; action = "ResetFontSize"; }
          { key = "Equals"; mods = "Alt"; action = "IncreaseFontSize"; }
          { key = "Plus"; mods = "Alt"; action = "IncreaseFontSize"; }
          { key = "NumpadAdd"; mods = "Alt"; action = "IncreaseFontSize"; }
          { key = "Minus"; mods = "Alt"; action = "DecreaseFontSize"; }
          { key = "NumpadSubtract"; mods = "Alt"; action = "DecreaseFontSize"; }
          { key = "F"; mods = "Shift|Alt"; action = "SearchBackward"; }
          { key = "V"; mods = "Alt"; action = "ToggleViMode"; }
          { key = "N"; mods = "Shift|Control"; action = "CreateNewWindow"; }
        ];

        colors = with config.colorScheme.palette; {
          draw_bold_text_with_bright_colors = true;
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
    # https://github.com/nix-community/neovim-nightly-overlay/issues/525
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}
