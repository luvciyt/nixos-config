{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
       system = "x86_64-linux";
       pkgs = import nixpkgs {
       inherit system;
       config.allowUnfree = true;
    };
    in
    {
      packages.${system} = import ./packages { inherit pkgs; };

      nixosModules = {
        fonts = import ./modules/system/fonts.nix;

        default = import ./modules/system/default.nix;
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs self; };

        modules = [
          ./hosts/default/configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = { inherit inputs self; };

            home-manager.users.luvciyt = import ./users/luvciyt/home.nix;
          }
        ];
      };
    };
}