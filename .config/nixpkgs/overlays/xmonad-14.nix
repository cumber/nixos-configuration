self: super: {
  haskellPackages = super.haskellPackages.extend (hpSelf: hpSuper: {
    xmonad = hpSelf.callCabal2nix "xmonad" (super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad";
      rev = "v0.14";
      sha256 = "1pwf90hypg8v2dli6qzdcbi4xywvl6wpavkrkbjy3acmm0h4qd1b";
    }) {};

    xmonad-contrib = hpSelf.callCabal2nix "xmonad-contrib" (super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad-contrib";
      rev = "v0.14";
      sha256 = "0y7nwl3i5df1p6i76r9yyhpnbnz9847pbnf8jj000g274ysdmkgr";
    }) {};
  });
}
