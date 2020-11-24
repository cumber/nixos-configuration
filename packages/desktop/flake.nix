{
  description = "Desktop environment using Xmonad";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = {
      inherit (import nixpkgs { overlays = self.overlays; system = "x86_64-linux"; })
        xmonad-custom
        xmonad-session-init;
    };

    overlays = [
      (import ./overlay.nix)
      (import ./fix-taffybar.nix)
      (import ./dunst.nix)
    ];

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.xmonad-custom;
  };
}
