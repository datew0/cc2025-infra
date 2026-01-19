{
    description = "Cloud Computing 2025";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        home-manager.url = "github:nix-community/home-manager/release-25.05";
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
        snowfall-lib = {
            url = "github:snowfallorg/lib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs:
        let
            lib = inputs.snowfall-lib.mkLib {
                inherit inputs;
                src = ./.;
            };
        in
            lib.mkFlake { 
                channels-config = {
                    allowUnfree = true;
                };
            };
}