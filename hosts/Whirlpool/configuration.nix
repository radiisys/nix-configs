{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager.lightdm.enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    layout = "us";
    xkbVariant = "colemak";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };
  
  environment.pathsToLink = [ "/libexec" ];

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  programs = {
    steam.enable = true;
    nm-applet.enable = true;
    adb.enable = true;
    dconf.enable = true;
    };

  environment.systemPackages = with pkgs; [
    autorandr
    cinnamon.nemo
    dunst
    font-awesome
    jetbrains-mono
    libsForQt5.ark
    libsForQt5.qt5ct
    libva
    logitech-udev-rules
    lshw
    maim
    nitrogen
    picom
    (pkgs.discord-canary.override {
      withVencord = true;
    })
    (pkgs.python3.withPackages(ps: with ps; [ tkinter]))
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
  
  fonts.packages = with pkgs; [
	font-awesome
	jetbrains-mono
  ];

  # services
  services.printing.enable = true;
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.lvm.enable = true;
  services.zerotierone.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };
  services.udev.extraRules = import ./60-openrgb.rules    

  console.useXkbConfig = true;

  networking.hostName = "Whirlpool";

  virtualisation.libvirtd = {
	enable = true;
        extraConfig = ''
          user="radisys"
        '';
	qemu.ovmf.enable = true;
        qemu.package = pkgs.qemu_kvm;
	qemu.runAsRoot = true;  
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = [ "exfat" "xfs" "ntfs" ];
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio_virqfd" "vfio_iommu_type1" "vfio" ];
  boot.extraModprobeConfig = "options vfio-pci ids=8086:1912";
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.blacklistedKernelModules = [ "i915" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # enable networking
  networking.networkmanager.enable = true;

  # Set a time zone
  time.timeZone = "Europe/London";

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

  users.users.radisys = {
    isNormalUser = true;
    description = "radisys";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd"];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };
  
services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "22.11";
}
