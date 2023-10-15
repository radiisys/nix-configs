{
  nixpkgs,
  self,
  outputs,
  nixos-hardware,
  ...
}: let
  inputs = self.inputs;

  home-manager = inputs.home-manager.nixosModules.home-manager;
  homeMessier = ../homes/Messier;
  homeWhirlpool = ../homes/Whirlpool;
  homeGanymede = ../homes/Ganymede;
  homeEdible = ../homes/Edible;

in {
  Ganymede = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Ganymede/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeGanymede
    ];
  };

  Whirlpool = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Whirlpool/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeWhirlpool
    ];
  };

  Messier = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Messier/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeMessier
    ];
  };

  Edible = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      nixos-hardware.nixosModules.microsoft-surface-common
      ./Edible/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeEdible
    ];
  };
}
