{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    playerctl
    ripcord
    wl-clipboard
    grim
    slurp
    rnote
    rofi
    wofi
    polybar
    drawing
    signal-desktop
    scrcpy
    alacritty
    tetrio-desktop
    hyprpaper
    networkmanagerapplet
    prismlauncher
    brightnessctl
    hyfetch
    timidity
    tidal-hifi
    transmission-qt
    spotify
    fluffychat
    firefox-devedition
    stellarium
    beeper
    (writeShellApplication {
       name = "vscodium";
       text = "${pkgs.vscodium}/bin/codium --use-gl=desktop";
    })
    (makeDesktopItem {
       name = "vscodium";
       exec = "vscodium";
       desktopName = "VSCodium";
    })
    tidal-dl
    mumble
  ];
}
