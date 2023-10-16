{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    wget
    alacritty
    beeper
    brightnessctl
    firefox-devedition
    fluffychat
    hyfetch
    playerctl
    mumble
    networkmanagerapplet
    prismlauncher
    polybar
    ripcord
    rnote
    rofi
    scrcpy
    signal-desktop
    tetrio-desktop
    tidal-hifi
    tidal-dl
    timidity
    transmission-qt
    spotify
    stellarium
    vscodium
  ];
}
