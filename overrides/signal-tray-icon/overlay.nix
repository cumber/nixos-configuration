self: super: {
  signal-desktop = super.signal-desktop.overrideAttrs (old: {
    runtimeDependencies = old.runtimeDependencies ++ [ self.libappindicator-gtk3 ];
  });
}
