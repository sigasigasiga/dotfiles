{
  description = "My System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
