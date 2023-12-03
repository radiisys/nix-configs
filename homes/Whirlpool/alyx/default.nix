{
  pkgs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ../../common/arrpc.nix
    ../../common/packages.nix # home.packages and similar stuff
    ../../common/programs.nix # programs.<programName>.enable
    ../../common/udiskie.nix
  ];

  home = {
    username = "alyx";
    homeDirectory = "/home/alyx";
    file.".config/sway/config".source = ./config;
    file.".config/waybar/config".source = ./waybar;
    file."/etc/modprobe.d/nvidia.conf".text = ''
      options nvidia-drm modeset=1
    '';
  };

  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
