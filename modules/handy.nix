{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, buildFHSEnv
, webkitgtk_4_1
, gtk3
, cairo
, gdk-pixbuf
, glib
, dbus
, openssl
, librsvg
, libsoup_3
, alsa-lib
, libpulseaudio
, vulkan-loader
, mesa
, libappindicator-gtk3
}:

let
  pname = "handy";
  version = "0.6.11";

  handyBase = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/cjpais/Handy/releases/download/v${version}/Handy_${version}_amd64.deb";
      hash = "sha256-N2FZ1CgfZ57ACOuMDqbMZQHuQwe+l2DSbLMCjjfJFq8=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = [
      webkitgtk_4_1
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl
      librsvg
      libsoup_3
      alsa-lib
      libpulseaudio
      vulkan-loader
      mesa
      libappindicator-gtk3
    ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --extract $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/* $out/
      runHook postInstall
    '';
  };

  handyFHS = buildFHSEnv {
    name = "handy";
    runScript = "handy";

    targetPkgs = pkgs: [
      handyBase
      pkgs.webkitgtk_4_1
      pkgs.gtk3
      pkgs.cairo
      pkgs.gdk-pixbuf
      pkgs.glib
      pkgs.dbus
      pkgs.openssl
      pkgs.librsvg
      pkgs.libsoup_3
      pkgs.alsa-lib
      pkgs.libpulseaudio
      pkgs.pulseaudio
      pkgs.vulkan-loader
      pkgs.mesa
      pkgs.libappindicator-gtk3
    ];
  };

in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    ln -s ${handyFHS}/bin/handy $out/bin/
    ln -s ${handyBase}/share/* $out/share/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Privacy-focused offline speech-to-text desktop application";
    homepage = "https://github.com/cjpais/Handy";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
