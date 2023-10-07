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
    displayManager = {
      sddm.enable = true;
      #setupCommands = "xrandr --output DP-4 --mode 1280x1024 --output HDMI-0 --mode 1920x1080 --right-of DP-4";
    }; 
    desktopManager = {
      xterm.enable = false;
    };
    layout = "us";
    xkbVariant = "colemak";  
    videoDrivers = lib.mkForce [ "nvidia" ];
    config = ''
      Section "Device"
          Identifier  "Intel Graphics"
          Driver      "intel"
          Option      "TearFree"       "true"
          Option      "SwapbuffersWait" "true"
          BusID       "PCI:0:2:0"
      EndSection
      Section "Device"
          Identifier  "nvidia"
          Driver      "nvidia"
          BusID       "PCI:1:0:0"
          Option      "AllowEmptyInitialConfiguration"
          Option      "TearFree"       "true"
      EndSection
    '';
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
         modesetting.enable = lib.mkForce false;
         powerManagement.enable = lib.mkForce false;
         powerManagement.finegrained = lib.mkForce false;
         prime.offload.enable = lib.mkForce false;
         prime.offload.enableOffloadCmd = lib.mkForce false;
         prime.sync.enable = lib.mkForce true;
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
    hyprland = {
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };
    steam.enable = true;
    nm-applet.enable = true;
    adb.enable = true;
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    libva
    libsForQt5.qt5ct
    onboard
    gtklock
    swayidle
    picom
    logitech-udev-rules
    pulseaudio
    xss-lock
    nitrogen
    virt-manager
    solaar
    maim
    xclip
    xdotool
    (pkgs.python3.withPackages(ps: with ps; [ tkinter ]))
    python311Packages.dbus-python
    temurin-jre-bin-8
    temurin-bin-18
    font-awesome
    blueman
    bluez
    bluez-alsa
    dunst
    polkit_gnome
    jetbrains-mono
    udiskie
    cinnamon.nemo
    libsForQt5.ark
    lshw
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

  # TODO: Set your hostname
  networking.hostName = "Messier";

  virtualisation.libvirtd.enable = true;

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = [ "exfat" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "nvidia" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

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
