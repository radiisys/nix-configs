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
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # pain from here on out
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    steam.enable = true;
    nm-applet.enable = true;
    adb.enable = true;
    dconf.enable = true;
    };

  environment.systemPackages = with pkgs; [
    virt-manager
    solaar
    logitech-udev-rules
    swayidle
    gtklock
    (pkgs.python3.withPackages(ps: with ps; [ tkinter]))
    temurin-jre-bin-8
    temurin-bin-18
    libinput
    font-awesome
    swaynotificationcenter
    polkit_gnome
    jetbrains-mono
    libsForQt5.qt5ct
    xdg-desktop-portal-hyprland
    adwaita-qt
    adwaita-qt6
    cinnamon.nemo
    udiskie
  ];
  
  xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";
  
  fonts.packages = with pkgs; [
	font-awesome
	jetbrains-mono
  ];

  # TODO: Set your hostname
  networking.hostName = "Nebula";

  virtualisation.libvirtd = {
	enable = true;
	qemu.ovmf = true;
	qemu.RunAsRoot = true;
  };

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = [ "exfat" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" "kvm-amd" "b43" "wl" "vfio-pci" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.extraModprobeConfig = "options kvm_intel kvm_amd nested=1";
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  # enable networking
  networking.networkmanager.enable = true;
  networking.enableB43Firmware = true;

  # Set a time zone, idiot
  time.timeZone = "Europe/London";

  # Fun internationalisation stuffs (AAAAAAAA)
  i18n.defaultLocale = "it_IT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable X11 Windowing system
  services.xserver.enable = true;
  # Enable display Manager
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  # configure keymap (x11)
  services.xserver = {
    layout = "gb";
    xkbVariant = "colemak";
  };

  # udisks
  services.udisks2.enable = true;
  # Would you like to be able to fucking print?
  services.printing.enable = true;

  # Sound (kill me now)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };

  security.polkit.enable = true;

 systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "hyprland-session.target" ];
    wants = [ "hyprland-session.target" ];
    after = [ "hyprland-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};

  services.lvm.enable = true;

  # define user acc
  users.users.radisys = {
    isNormalUser = true;
    description = "radisys";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd"];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
