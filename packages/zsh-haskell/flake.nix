{
  description = "ZSH shell plugin for Haskell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = {
      inherit (import nixpkgs { overlays = self.overlays; system = "x86_64-linux"; })
        zsh-haskell;
    };

    overlays = [
      (import ./overlay.nix)
    ];

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.zsh-haskell;
  };
}
