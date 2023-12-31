{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

let
   dbus-sway-environment = pkgs.writeTextFile {
      name = "dbus-sway-environment";
      destination = "/bin/dbus-sway-environment";
      executable = true;

      text = ''
         dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
         systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
          systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
   };

   configure-gtk = pkgs.writeTextFile {
     name = "configure-gtk";
     destination = "/bin/configure-gtk";
     executable = true;
     text = let
       schema = pkgs.gsettings-desktop-schemas;
       datadir = "${schema}/share/gsettings-schemas/${schema.name}";
     in ''
       export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
       gnome_schema=org.gnome.desktop.interface
       gsettings set $gnome_schema gtk-theme 'Dracula'
     '';
   };

 in

 {
  imports = [
    ./hardware-configuration.nix
    ./vaapi.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      vulkan-validation-layers
      nvidia-vaapi-driver
      libvdpau-va-gl
      vaapiVdpau
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    layout = "us";
  };
  
  environment.pathsToLink = [ "/libexec" ];

  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    open = false;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    vaapi = {
      enable = true;
      firefox.enable = true;
    };
  };

  hardware.enableAllFirmware = true;

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
    sway = {
      enable = true;
      extraOptions = [
        "--unsupported-gpu"
      ];
      wrapperFeatures.gtk = true;
    };	
    };

  environment.systemPackages = with pkgs; [
    dbus-sway-environment
    swayosd
    pavucontrol
    configure-gtk
    wayland
    xdg-utils
    glib
    dracula-theme
    gnome3.adwaita-icon-theme
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    bemenu
    wdisplays
    cinnamon.nemo
    swaynotificationcenter
    font-awesome
    jetbrains-mono
    libsForQt5.ark
    (pkgs.python3.withPackages(ps: with ps; [ tkinter]))
    polkit_gnome
    pulseaudio
    temurin-bin-18
    temurin-jre-bin-8
    udiskie
    virt-manager
  ];
  
  environment.sessionVariables = {
    #GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    XWAYLAND_NO_GLAMOR = "1";
    XCURSOR_SIZE = "24";
    WLR_RENDERER = "vulkan";
  };

  fonts.packages = with pkgs; [
	font-awesome
	jetbrains-mono
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
  ];
  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" "Source Han Serif" ];
    sansSerif = [ "Noto Sans" "Source Han Sans" ];
  };

  # bluetooth
  hardware.bluetooth.enable = true;

  # services
  services.printing.enable = true;
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.lvm.enable = true;
  services.blueman.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  }; 

  console.useXkbConfig = true;

  networking.hostName = "Whirlpool";

  virtualisation.libvirtd = {
	enable = true;
        extraConfig = ''
          user="alyx"
        '';
	qemu.ovmf.enable = true;
        qemu.package = pkgs.qemu_kvm;
	qemu.runAsRoot = true;
        qemu.swtpm.enable = true;  
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = [ "exfat" "xfs" "ntfs" ];
  boot.kernelParams = [ "intel_iommu=on" "pcie_acs_override=downstream,multifunction" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia.NVreg_TemporaryFilePath=/var/tmp"];
  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel" ];
  boot.extraModprobeConfig = "options vfio-pci ids=1002:67df,1002:aaf0,1b21:2142";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.blacklistedKernelModules = [ "amdgpu" ];
  # enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

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

  security.pam.services.swaylock = {};

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

  users.users.alyx = {
    isNormalUser = true;
    description = "alyx";
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
