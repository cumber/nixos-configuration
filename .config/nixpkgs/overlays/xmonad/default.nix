self: super: {
  xmonad-custom = (
    self.haskellPackages.callPackage
      ./haskell-package/xmonad-custom.nix
      {
        powerline = self.powerlineWithGitStatus;
        inherit (self.python27Packages) syncthing-gtk;
      }
  );
}
