self: super: {
  haskellPackages = super.haskellPackages.override {
    overrides = hself: hsuper: rec {
      gtk2hs-buildtools = super.haskell.lib.overrideCabal hsuper.gtk2hs-buildtools (_: {
        patches = [
          ./gtk2hs-buildtools-ghc-8.6.patch
        ];
      });
      buildHaskellPackages = hsuper.buildHaskellPackages // { inherit gtk2hs-buildtools; };
    };
  };
}
