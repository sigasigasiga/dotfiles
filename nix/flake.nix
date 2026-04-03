{
  description = "My System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    # Replace 'my-hostname' with your actual hostname
    nixosConfigurations.siga-zenbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      modules = [
        ./configuration.nix
      ];
    };
  };
}
