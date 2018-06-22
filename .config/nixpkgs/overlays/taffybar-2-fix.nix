self: super: {
  haskellPackages = super.haskellPackages.extend (hpSelf: hpSuper:
    {
    taffybar = hpSuper.taffybar.overrideDerivation (drv: {
      name = "taffybar-2.1.2";
      version = "2.1.2";
      src = super.fetchFromGitHub {
        owner = "taffybar";
        repo = "taffybar";
        rev = "v2.1.2";
        sha256 = "0snjwx75qf9ccf4j99cdsh0njh4pzl8s4lmarrfs6l0mirgh4grw";
      };
    });

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

    "gi-dbusmenugtk3" = hpSelf.callPackage
    ({ mkDerivation, base, bytestring, Cabal, containers, gi-atk
     , gi-dbusmenu, gi-gdk, gi-gdkpixbuf, gi-glib, gi-gobject, gi-gtk
     , haskell-gi, haskell-gi-base, haskell-gi-overloading
     , libdbusmenu-gtk3, text, transformers, system-gtk3
     }:
     mkDerivation {
       pname = "gi-dbusmenugtk3";
       version = "0.4.1";
       sha256 = "0gl37jsska2qsakzbmvwvb33lskdrbxpk1hmw907y187d0hq7pry";
       setupHaskellDepends = [ base Cabal haskell-gi ];
       libraryHaskellDepends = [
         base bytestring containers gi-atk gi-dbusmenu gi-gdk gi-gdkpixbuf
         gi-glib gi-gobject gi-gtk haskell-gi haskell-gi-base
         haskell-gi-overloading text transformers
       ];
       libraryPkgconfigDepends = [ libdbusmenu-gtk3 system-gtk3.dev];
       doHaddock = false;
       homepage = "https://github.com/haskell-gi/haskell-gi";
       description = "DbusmenuGtk bindings";
       license = self.stdenv.lib.licenses.lgpl21;
       hydraPlatforms = self.stdenv.lib.platforms.none;
     }) {inherit (self) libdbusmenu-gtk3; system-gtk3 = self.gtk3;};
    }
  );
}
