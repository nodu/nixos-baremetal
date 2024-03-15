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

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;


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
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "RobotoMono" ]; })
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
    #pkgs.baobab

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
    pkgs.helvum
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
    # pkgs.gopls

    # nvim Linters
    pkgs.stylua
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.markdownlint-cli
    pkgs.nodePackages.prettier
    pkgs.shfmt

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
    "apps.sh".text = builtins.readFile ./apps.sh;
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
      modi = "emoji,run,filebrowser"; #calc,run,filebrowser,
      combi-modes = "window,drun";
      show-icons = true;
      sort = true;
      matching = "fuzzy";
      dpi = 220;
      font = "FiraCode Nerd Font 10";
      terminal = "alacritty";
      sorting-method = "fzf";
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
      nx-update = "cd ~/repos/nixos-baremetal/ && make switch; cd -";
      nx-update-flake = "cd ~/repos/nixos-baremetal/ && nix flake update; cd -";
      nx-update-input = "nix flake lock --update-input"; # nix flake lock --update-input nixos-hardware
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
      source $HOME/.config/apps.sh
      source $HOME/.config/aliases
      source $HOME/.config/defaults/basic.sh
      source $HOME/.config/m-os.sh
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

    settings =
      {
        env.TERM = "xterm-256color";
        env.WINIT_X11_SCALE_FACTOR = "1"; #https://major.io/p/disable-hidpi-alacritty/ #i3 font size fix
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
        history = 100000;
        #padding.y = 27;

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
          bright = {
            black = "0x${base00}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            white = "0x${base06}";
            yellow = "0x${base09}";
          };
          cursor = {
            cursor = "0x${base06}";
            text = "0x${base06}";
          };
          normal = {
            black = "0x${base00}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            white = "0x${base06}";
            yellow = "0x${base0A}";
          };
          primary = {
            background = "0x${base00}";
            foreground = "0x${base06}";
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
