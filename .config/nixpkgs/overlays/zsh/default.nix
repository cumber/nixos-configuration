self: super: {
  zsh-custom = self.callPackage ./zsh-custom.nix { vte = self.gnome3.vte; };
}
