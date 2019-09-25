self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    dbus = super.haskell.lib.appendPatch hsuper.dbus ./dbus.patch;
  });
}
