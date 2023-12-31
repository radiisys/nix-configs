{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    pamixer
    wob
    vlc
    wget
    dnsmasq
    nbd
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
    waybar
    ripcord
    rnote
    wofi
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
