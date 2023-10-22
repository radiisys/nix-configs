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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
    layout = "us";
    xkbVariant = "colemak";  
    videoDrivers = [ "nvidia" ];
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock-pixeled
        i3blocks
      ];
    };
  };

  environment.pathsToLink = [ "/libexec" ];

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  specialisation = {
    clamshell.configuration = {
       system.nixos.tags = [ "clamshell" ];
       boot.kernelParams = [ "module_blacklist=i915" ];
       services.logind = {
         lidSwitch = "ignore";
       };
       hardware.nvidia = {
         powermanagement.enable = lib.mkForce false;
         powerManagement.finegrained = lib.mkForce false;
       };
       hardware.nvidia.prime = {
         offload = {
           enable = lib.mkForce false;
           enableOffloadCmd = lib.mkForce false;
         };
       };
    };
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
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

  # the configuration (pain)
  programs = {
    adb.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    autorandr
    blueman
    bluez
    bluez-alsa
    cinnamon.nemo
    dunst
    font-awesome
    jetbrains-mono
    libsForQt5.ark
    libsForQt5.qt5ct
    libva
    logitech-udev-rules
    maim
    nitrogen
    nvidia-vaapi-driver
    onboard    
    picom
    (pkgs.python3.withPackages(ps: with ps; [ tkinter ]))
    polkit_gnome
    pulseaudio
    solaar
    temurin-bin-18
    temurin-jre-bin-8
    udiskie
    virt-manager
    xclip
    xdotool
    xss-lock
  ];

  environment.variables = {
    XCURSOR_SIZE = "24";
  };

  fonts.packages = with pkgs; [
	font-awesome
	jetbrains-mono
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.fwupd.enable = true;

  console.useXkbConfig = true;

  # TODO: Set your hostname
  networking.hostName = "Hyperion";

  virtualisation.spiceUSBRedirection.enable = true; 

  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      user="radisys"
    '';
    qemu.ovmf.enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = true;
  };
 

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-dcc16400-847d-4ce5-9c0a-e34e4ee98cee".device = "/dev/disk/by-uuid/dcc16400-847d-4ce5-9c0a-e34e4ee98cee";
  boot.supportedFilesystems = [ "exfat" "ntfs" "xfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio_virqfd" "vfio_iommu_type1" "vfio" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia_drm.modeset=1" ];

  # enable networking
  networking.networkmanager.enable = true;

  services.dbus.enable = true;

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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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

  security.polkit.enable = true;

 systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
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

  users.extraGroups.vboxusers.members = [ "radisys" ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh.settings = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "yes";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
