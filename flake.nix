{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs (unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # arrpc
    arrpc = {
	url = "github:notashelf/arrpc-flake";
	inputs.nixpkgs.follows = "nixpkgs";
    };
	
    # nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";    
  };
  

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      #"aarch64-linux"
      #"i686-linux"
      "x86_64-linux"
      #"aarch64-darwin"
      #"x86_64-darwin"
    ];
  in rec {
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );
    nixosModules = import ./modules/shared/nixos;
    homeManagerModules = import ./modules/shared/home-manager;
    nixosConfigurations = import ./hosts {inherit nixpkgs self outputs nixos-hardware;};   
    };
}
