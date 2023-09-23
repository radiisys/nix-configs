{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    signal-desktop
    scrcpy
    kitty
    wofi
    tetrio-desktop
    hyprpaper
    networkmanagerapplet
    swaylock
    grim
    slurp
    prismlauncher
    brightnessctl
    jetbrains.pycharm-professional
    hyfetch
    timidity
    wl-clipboard
    wev
    tidal-hifi
    transmission
    spotify
    chromium
    fluffychat
    firefox-devedition
    stellarium
    beeper
    vscodium
    tidal-dl
    zerotierone
  ];
}
