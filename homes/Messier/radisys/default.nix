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
    ../../common/packages.nix
    ../../common/programs.nix
    ../../common/arrpc.nix
    ../../common/udiskie.nix
  ];

  # TODO: Set your username
  home = {
    username = "radisys";
    homeDirectory = "/home/radisys";
    file.".config/hypr/hyprpaper.conf".text = ''
      preload = ~/.config/nixos/wallpapers/wallpaper1.png
      wallpaper = eDP-1,~/.config/nixos/wallpapers/wallpaper1.png
    '';
    file.".config/lockonsleep/config.sh".text = ''
      exec swayidle -w \
        timeout 240 'gtklock -d -b ~/.config/nixos/wallpapers/wallpaper1.png' \
        before-sleep 'gtklock -d -b ~/.config/nixos/wallpapers/wallpaper1.png'
    '';
    file.".config/i3/lock.sh".text = ''
      #!/bin/sh
      set -e
      xset s off dpms 0 10 0
      i3lock --color=4c7899 --ignore-empty-password --show-failed-attempts --nofork
      xset s off -dpms
  };

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 64;
          package =
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
      };
    in
      getFrom
        "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
        "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
        "Fuchsia-Pop";

  wayland.windowManager.hyprland = {
    enable = true;
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
