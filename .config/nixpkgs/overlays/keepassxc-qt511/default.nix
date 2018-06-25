self: super: {
  keepassxc = super.keepassxc.overrideDerivation (drv: {
    patches = drv.patches ++ [ ./keepassxc-qt511.patch ];
  });
}
