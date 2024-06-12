# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    patchelf
    unzip
    vim
    wget
    zsh
    nix-ld
    nix-index
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Install neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    uiua386
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];

  # Use Flatpak, just in case
  services.flatpak.enable = true;

  programs.steam.enable = true;

  # Define arraen user.
  users.users.arraen = {
    isNormalUser = true;
    description = "arraen";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" "systemd-journal" "docker" ];
    createHome = true;
  };
  
  # Enable the PCSC service for yubikey authentication
  services.pcscd.enable = true;

  # Nix configuration
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org/"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "arraen"
      ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;

  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.hostName = "roadray";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us,ua,se";
    xkb.variant = "";
  };

  # LD Service
  programs.nix-ld.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;


  ## Audio config
  # Enable sound with pipewire.
  hardware.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;
    extraConfig = "
      load-module module-switch-on-connect
    ";
  };
  # Enable realtime kit, needed for pulseaudio
  security.rtkit.enable = true;
  # Enable pipewire service
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "24.05";

}
