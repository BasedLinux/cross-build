{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-generators, ... }: 
    let
      systems = ["x86_64-linux" "aarch64-linux" "riscv64-linux"];
      mkMachine = system: nixpkgs.lib.nixosSystem {
        modules = [
          nixos-generators.nixosModules.all-formats
          { nixpkgs.hostPlatform = system; }
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs (map (system: {
        name = "machine-${system}";
        value = mkMachine system;
      }) systems);
    };
}
