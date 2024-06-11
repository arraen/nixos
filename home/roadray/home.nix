# Home manager configuration
{ inputs, config, lib, pkgs, ... }:
let
  hm = inputs.home-manager.lib.hm;
in
{
  # Import home-manager modules
  imports = builtins.concatMap import [
    ../modules
  ];

  # User packages
  home.packages = with pkgs; [
    # Dev
    unstable.devbox
    unstable.neovim
    meld
    # Utility
    ranger
    htop
    # Music
    spotify
    # Internet tools
    discord
    google-chrome
    slack
    telegram-desktop
    # Note and task tools
    unstable.obsidian
    # Games
    steam
  ];

  # Git
  programs.git = {
    enable = true;
    userName = "Roman Shaposhnikov";
    userEmail = "arraen@arraen.org.ua";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
    extraConfig = {
      push = { autoSetupRemote = true; };
    };
  };

  # VScode configuration
  programs.vscode = {
    enable = true;
  };

  # State version
  home.stateVersion = "24.05";
}
