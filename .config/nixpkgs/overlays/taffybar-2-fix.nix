self: super: {
  haskellPackages = super.haskellPackages.extend (hpSelf: hpSuper: {
    status-notifier-item = hpSelf.callCabal2nix "status-notifier-item" (super.fetchFromGitHub {
      owner = "IvanMalison";
      repo = "status-notifier-item";
      rev = "bb7ed5c07418484bda3a9c1cbc513830a83fd158";
      sha256 = "1a5z6xfz9cfjswgvxdr24wcxqbg4g0rivqds38zx3mzg520zmwws";
    }) {};

    xmonad-contrib = hpSelf.callCabal2nix "xmonad-contrib" (super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad-contrib";
      rev = "13e37b964e82f2fcd790530edcdeb8f7cb801121";
      sha256 = "1dbb711m3z7i05klyzgx77z039hsg8pckfb3ar17ffc2yzc2mnad";
    }) {};
  });
}
