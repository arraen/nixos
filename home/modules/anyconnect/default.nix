with import <nixpkgs> {}; let
  version = "5.1.3.62";
in
  mkShell {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      # found by
      # $ LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$PWD ldd zoom | grep 'not found'
      atk
      cairo
      gtk3
      gdk-pixbuf
      glib
      pango
      stdenv.cc.cc
      xorg.libX11
    ];
    NIX_LD = builtins.readFile "${stdenv.cc}/nix-support/dynamic-linker";
    shellHook = ''
      if [ ! -d /opt/cisco/secureclient ]; then
        echo "Need to install Anyconnect manually"
      fi
      export LD_LIBRARY_PATH=/opt/cisco/secureclient/lib
      echo '$ /opt/cisco/secureclient/bin/vpnui'
      /opt/cisco/secureclient/bin/vpnui
    '';
  }
