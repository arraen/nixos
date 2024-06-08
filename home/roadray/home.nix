# Home manager configuration
{ inputs, config, lib, pkgs-stable, pkgs-unstable, ... }:
let
  hm = inputs.home-manager.lib.hm;
  stable-apps = with pkgs-stable; [
    # Stable packages
    neovim
    htop
    spotify
    google-chrome
  ];
  unstable-apps =  with pkgs-unstable; [
    devbox
  ];
in
{
  # Import home-manager modules
  imports = builtins.concatMap import [
    ../modules
  ];

  # User packages
  home.packages = stable-apps ++ unstable-apps;

  # Git
  programs.git = {
    enable = true;
    userName = "Roman Shaposhnikov";
    userEmail = "arraen@arraen.org.ua";
  };

  # VScode configuration
  programs.vscode = {
    enable = true;
  };
  # State version
  home.stateVersion = "24.05";
}
