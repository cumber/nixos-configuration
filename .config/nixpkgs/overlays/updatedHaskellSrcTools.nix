self: super: {
  updatedHaskellSrcTools = (
    let hpkgs = self.haskellPackages.extend (hpkgsSelf: hpkgsSuper: {
          haskell-src-exts = hpkgsSelf.haskell-src-exts_1_19_1;
        });
     in { inherit (hpkgs) hlint; }
  );
}
