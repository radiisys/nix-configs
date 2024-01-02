{
  nixpkgs,
  self,
  outputs,
  nixos-hardware,
  ...
}: let
  inputs = self.inputs;

  home-manager = inputs.home-manager.nixosModules.home-manager;
  homeHyperion = ../homes/Hyperion;
  homeMillwright = ../homes/Millwright;

in {
  Millwright = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Whirlpool/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeMillwright
    ];
  };

  Hyperion = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Hyperion/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeHyperion
    ];
  };
}
