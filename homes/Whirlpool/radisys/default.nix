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
    username = "radisys";
    homeDirectory = "/home/radisys";
    file.".config/i3/config".source = ./config;
    file.".config/i3status/config".source = ./common/i3status.conf;
    file.".config/polybar/config.ini".source = ./config.ini;
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 24;
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


  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
