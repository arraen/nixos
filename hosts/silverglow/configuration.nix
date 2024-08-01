# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ../../modules/nixos/common.nix
  ];
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking.hostName = "silverglow";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  services.flatpak.enable = true;

  users.users.arraen = {
    isNormalUser = true;
    createHome = true;
    home = "/home/arraen";
    shell = pkgs.bash;
    ignoreShellProgramCheck = true;
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "systemd-journal"
      "uucp"
      "video"
      "wheel"
      "dialout"
    ];
  };

  programs.nix-ld = {
    enable = true;
    package = inputs.nix-ld-rs.packages."${pkgs.system}".nix-ld-rs;
  };

  environment.etc = {
    "current-system-packages".text = let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;
  };

  system.stateVersion = "24.05";
}
