self: super: {
  haskellPackages = super.haskellPackages.extend (hpSelf: hpSuper: {
    xmonad-contrib = hpSelf.callCabal2nix "xmonad-contrib" (super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad-contrib";
      rev = "13e37b964e82f2fcd790530edcdeb8f7cb801121";
      sha256 = "1dbb711m3z7i05klyzgx77z039hsg8pckfb3ar17ffc2yzc2mnad";
    }) {};
  });
}
