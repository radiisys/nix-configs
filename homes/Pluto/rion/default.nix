{
  pkgs,
  outputs,
  lib,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../../common/packages.nix # home.packages and similar stuff
    ../../common/programs.nix # programs.<programName>.enable
    ../../common/arrpc.nix
    ../../common/udiskie.nix
  ];

  home = {
    username = "rion";
    homeDirectory = "/home/rion";
    file.".config/hypr/hyprpaper.conf".text = ''
      preload = ~/.config/nixos/wallpapers/wallpaper1.jpg
      wallpaper = eDP-1,~/.config/nixos/wallpapers/wallpaper1.jpg
      wallpaper = HDMI-A-1,~/.config/nixos/wallpapers/wallpaper1.jpg
    '';
    file.".config/lockonsleep/config.sh".text = ''
      exec swayidle -w \
        timeout 240 'gtklock -d -b ~/.config/nixos/wallpapers/wallpaper1.jpg' \
        before-sleep 'gtklock -d -b ~/.config/nixos/wallpapers/wallpaper1.jpg'
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemdIntegration = true;
    settings = import ./hyprland.nix;
  };
  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
