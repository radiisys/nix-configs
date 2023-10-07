{
  inputs,
  pkgs,
  home,
  ...
}: {
  imports = [
    inputs.arrpc.homeManagerModules.default
  ];
  
  home.packages = [ pkgs.webcord ];

  # provided by the arrpc-flake home-manager module
  services.arrpc.enable = true;
}
