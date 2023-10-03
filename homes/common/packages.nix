{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    rnote
    rofi
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
    vscodium
    tidal-dl
    mumble
  ];
}
