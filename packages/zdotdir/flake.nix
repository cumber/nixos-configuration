{
  description = "Cumber's zsh configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = {
      inherit (import nixpkgs { overlays = self.overlays; system = "x86_64-linux"; })
        zdotdir;
    };

    overlays = [
      (import ./overlay.nix)
    ];

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.zdotdir;
  };
}
