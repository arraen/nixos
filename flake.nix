{
  description = "Roadray config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: 
  let
    system = "x86_64-linux";
    owner = "arraen";
    workLaptop = "roadray";
    winWSL = "winray";
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        overlay-unstable
      ];
    }; 
  in {
    nixosConfigurations = {
      ${workLaptop} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs; 
        };
        modules = [
          ./systems/${workLaptop}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit pkgs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${owner} = import ./home/${workLaptop}/home.nix;
          }
        ];
      };
    };

    homeConfigurations.${owner} = home-manager.lib.homeManagerConfiguration {
      inherit system;
      SpecialArgs = { inherit pkgs; };
      modules = [
        ./home/${winWSL}/home.nix
      ];
    };

    packages.${system}.${owner} = self.homeConfigurations.${owner}.activationPackage;
  };
}

