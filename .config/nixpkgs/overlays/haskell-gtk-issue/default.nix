self: super:
let
  gtk3 = super.gtk3.overrideAttrs (oa: {
    patches = (oa.patches or []) ++ [
      (self.fetchpatch {
        # missing symbols but exported from gir
        url = https://gitlab.gnome.org/GNOME/gtk/commit/95c0f07295fd300ab7f3416a39290ae33585ea6c.patch;
        sha256 = "0z9w7f39xcn1cbcd8jhx731vq64nvi5q6kyc86bq8r00daysjwnl";
      })
    ];
  });
in
{
  haskellPackages = with self.haskell.lib; super.haskellPackages.extend (hself: hsuper: {
    gi-gdk = hsuper.gi-gdk.override { inherit gtk3; };
    taffybar = hsuper.taffybar.overrideAttrs (oa : {
      meta = oa.meta // { broken = false; };
    });
  });
}
