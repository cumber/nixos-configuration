self: super: {
  haskellPackages = super.haskellPackages.extend (hpSelf: hpSuper: {
    intero-nix-shim = hpSuper.callPackage ./intero-nix-shim.nix {};
  });
}
