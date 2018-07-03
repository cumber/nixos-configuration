self: super: {
  haskellPackages = super.haskellPackages.extend (hpSelf: hpSuper: {
    status-notifier-item = hpSelf.callCabal2nix "status-notifier-item" (super.fetchFromGitHub {
      owner = "IvanMalison";
      repo = "status-notifier-item";
      rev = "e2cfd82133d02f0df959f1bb0316b9e58ec453d6";
      sha256 = "0v37pfnn7m02jbfc68qa7snncilfad8iyvqcjq85q148qrl53zxm";
    }) {};

    xmonad-contrib = hpSelf.callCabal2nix "xmonad-contrib" (super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad-contrib";
      rev = "13e37b964e82f2fcd790530edcdeb8f7cb801121";
      sha256 = "1dbb711m3z7i05klyzgx77z039hsg8pckfb3ar17ffc2yzc2mnad";
    }) {};
  });
}
