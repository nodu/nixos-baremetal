# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home/vpns.nix
    ];

  services.nordvpn.enable = true;
  services.fwupd.enable = true;
  virtualisation.docker.enable = true;

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config.permittedInsecurePackages = [
  ];
  #wayland requirments/stuff
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  security.pam.services.login.fprintAuth = false;
  # https://github.com/NixOS/nixpkgs/issues/171136#issuecomment-1627779037
  # similarly to how other distributions handle the fingerprinting login
  security.pam.services.gdm-fingerprint = lib.mkIf (config.services.fprintd.enable) {
    # lock on suspend not working? no i3 lock mechanism?
    text = ''
      auth       required                    pam_shells.so
      auth       requisite                   pam_nologin.so
      auth       requisite                   pam_faillock.so      preauth
      auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth       optional                    pam_permit.so
      auth       required                    pam_env.so
      auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so

      account    include                     login

      password   required                    pam_deny.so

      session    include                     login
      session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';
  services.upower.criticalPowerAction = "Hibernate";


  environment.pathsToLink = [ "/libexec" "/share/zsh" ];
  environment.localBinInPath = true;
  environment.variables.GTK_THEME = "Adwaita:dark";

  #maybe set this to false after figuring out users.matt.hashedPassword
  users.mutableUsers = true;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "baremetal"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  hardware.keyboard.uhk.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    epiphany # web browser
    gnome-tour
    geary
  ]) ++ (with pkgs.gnome; [
  ]);
  console.useXkbConfig = true;
  services.xserver = {
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "ctrl:nocaps";

    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    windowManager.i3.enable = true;

  };

  # services.displayManager.defaultSession = "sway";
  services.displayManager.defaultSession = "none+i3";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = null;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.clickMethod = "clickfinger";
  services.libinput.touchpad.disableWhileTyping = true;
  services.libinput.mouse.disableWhileTyping = true;

  # Android
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    isNormalUser = true;
    home = "/home/matt";
    description = "Matt N";
    extraGroups = [ "nordvpn" "docker" "networkmanager" "wheel" "adbusers" ];
    openssh.authorizedKeys.keys = [ "ssh blah blah" ];
    shell = pkgs.zsh;

    packages = with pkgs; [

    ];
  };
  programs.zsh.enable = true;

  programs.steam.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.git
    pkgs.gnumake
    pkgs.gh
    pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  fonts = {
    fontDir.enable = true;

    packages = [
      pkgs.fira-code
    ];
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  services.fstrim.enable = true;

  # Open ports in the firewall.
  networking.firewall =
    {
      enable = true;
      allowedTCPPorts = [ 443 1701 9001 ]; #443 nordvpn, 1701/9001 weylus
      allowedUDPPorts = [ 1194 ]; #nordvpn

      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } #kdeconnect
      ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } #kdeconnect
      ];

    };
  networking.firewall.checkReversePath = false; #nordvpn
  networking.enableIPv6 = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Make hosts writable for nordvpn mesh
  environment.etc.hosts.mode = "0644";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
