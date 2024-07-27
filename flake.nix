{
  description = "Roadray config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plasma
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, plasma-manager, ... }: 
  let
    system = "x86_64-linux";
    username = "arraen";
    ownLaptop = "roadray";
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
      ${ownLaptop} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs; 
        };
        modules = [
          ./systems/${ownLaptop}/configuration.nix
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = { inherit pkgs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/${username}/home.nix;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
          }
        ];
      };
    };

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit system;
      SpecialArgs = { inherit pkgs; };
      modules = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
        ./home/${username}/home.nix
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };

    packages.${system}.${username} = self.homeConfigurations.${username}.activationPackage;
  };
}

