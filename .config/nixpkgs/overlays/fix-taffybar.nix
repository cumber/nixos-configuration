# https://github.com/NixOS/nixpkgs/issues/63500#issuecomment-674835273
# updated for further developments as of https://github.com/NixOS/nixpkgs/issues/63500#issuecomment-692270010
self: super:
{
  haskellPackages = with self.haskell.lib; super.haskellPackages.extend (hself: hsuper: {
    gi-cairo-render = hself.callHackage "gi-cairo-render" "0.1.0" { inherit (self) cairo; };
    gi-cairo-connector = hself.callHackage "gi-cairo-connector" "0.1.0" {};
    gi-dbusmenu = markUnbroken hself.gi-dbusmenu_0_4_8;
    gi-dbusmenugtk3 = markUnbroken hself.gi-dbusmenugtk3_0_4_9;
    gi-gdk = markUnbroken hself.gi-gdk_3_0_23;
    gi-gdkx11 = markUnbroken (overrideSrc hsuper.gi-gdkx11 {
      src = self.fetchurl {
        url = "https://hackage.haskell.org/package/gi-gdkx11-3.0.10/gi-gdkx11-3.0.10.tar.gz";
        sha256 = "0kfn4l5jqhllz514zw5cxf7181ybb5c11r680nwhr99b97yy0q9f";
      };
      version = "3.0.10";
    });
    gi-gtk-hs = markUnbroken hself.gi-gtk-hs_0_3_9;
    gi-xlib = markUnbroken hself.gi-xlib_2_0_9;
    gtk-sni-tray = markUnbroken (hsuper.gtk-sni-tray);
    gtk-strut = markUnbroken (hsuper.gtk-strut);
    taffybar = markUnbroken (appendPatch hsuper.taffybar (self.fetchpatch {
      url = "https://github.com/taffybar/taffybar/pull/494/commits/a7443324a549617f04d49c6dfeaf53f945dc2b98.patch";
      sha256 = "0prskimfpapgncwc8si51lf0zxkkdghn33y3ysjky9a82dsbhcqi";
    }));
  });
}
