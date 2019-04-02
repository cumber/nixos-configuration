self: super: {
  syncthing-gtk = super.syncthing-gtk.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ self.gobject-introspection ];
  });
}
