self: super: {
  vimPlugins = self.callPackage ./plugins.nix {} super.vimPlugins;
  vim-custom = self.callPackage ./vim-custom.nix {};
}
