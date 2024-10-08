# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
      #outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  imports = [ ../../modules/home-manager/fish.nix ];

  home.packages = with pkgs; [
    # Shell
    bash
    fish
    grc
    fzf
    lsd
    fd
    # Dev
    unstable.neovim
    direnv
    meld
    gh
    difftastic
    # Kubernetes
    k9s
    kubectl
    # Utility
    bat
    du-dust
    ranger
    htop
    dogdns
  ];

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

  home = {
    username = "arraen";
    homeDirectory = "/home/arraen";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
}
