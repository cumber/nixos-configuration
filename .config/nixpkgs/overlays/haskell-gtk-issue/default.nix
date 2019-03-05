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
      src = self.fetchFromGitHub {
        owner = "taffybar";
        repo = "taffybar";
        rev = "8e7beca213b48eab26227a8bf2e8d01c624118a0";
        sha256 = "1wvpxwzr4fmvd2hlqdyr5hwc6h87mxvvh675lghan70saq640x7p";
      };
    });
  });
}
