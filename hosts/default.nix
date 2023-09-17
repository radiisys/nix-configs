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
  homeNebula = ../homes/Nebula;
  homePluto = ../homes/Pluto;
  homeDysnomia = ../homes/Dysnomia;
  homeCygnus = ../homes/Cygnus;
  homeEdible = ../homes/Edible;

in {
  Dysnomia = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Dysnomia/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeDysnomia
    ];
  };

  Nebula = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Nebula/configuration.nix

      # use the nixos-module for home-manager
      home-manager
      homeNebula
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

  Cygnus = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Cygnus/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homeCygnus
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

  Pluto = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      nixos-hardware.nixosModules.microsoft-surface-common
      ./Pluto/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homePluto
    ];
  };
}
