self: super: {
  haskellPackages = super.haskellPackages.extend (hpkgsSelf: hpkgsSuper: {
    type-nat-solver = hpkgsSelf.callPackage ./type-nat-solver.nix {
      # There's a haskell package called z3 that would automatically be
      # chosen by callPackage; we need the z3 executable
      z3-exe = self.z3;
    };
  });
}
