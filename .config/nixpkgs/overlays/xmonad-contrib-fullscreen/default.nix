self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    xmonad-contrib = hsuper.xmonad-contrib.overrideAttrs (old: {
      src = super.fetchFromGitHub {
        owner = "xmonad";
        repo = "xmonad-contrib";
        rev = "8ec1efd472392b31df216fd6c908d63f942c3a2b";
        sha256 = "0bm50cmgv6jjvg7ldrzdc3rkcsyghrnw3f5chba2c3fkdcdk86ln";
      };
    });
  });
}
