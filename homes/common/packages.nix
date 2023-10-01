{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    rnote
    drawing
    signal-desktop
    scrcpy
    foot
    alacritty
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
    transmission-qt
    spotify
    chromium
    fluffychat
    firefox-devedition
    stellarium
    beeper
    vscodium
    tidal-dl
    mumble
  ];
}
