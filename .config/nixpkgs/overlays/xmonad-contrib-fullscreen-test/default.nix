self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    xmonad-contrib = hsuper.xmonad-contrib.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ./xmonad-contrib-0.14.patch ];
    });
  });
}
