{
  inputs,
  pkgs,
  home,
  ...
}: {
  imports = [
    inputs.arrpc.homeManagerModules.default
  ];
  
  home.packages = [
    (pkgs.writeShellApplication {
      name = "webcord";
      text = "${pkgs.webcord-vencord}/bin/webcord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {
       name = "webcord";
       exec = "webcord";
       desktopName = "Webcord";
    })
  ];

  # provided by the arrpc-flake home-manager module
  services.arrpc.enable = true;
}
