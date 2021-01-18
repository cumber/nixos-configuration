# https://github.com/NixOS/nixpkgs/issues/63500#issuecomment-674835273
# updated for further developments as of https://github.com/NixOS/nixpkgs/issues/63500#issuecomment-692270010
# Deleted most of this; upstream seems to have incorporated the patches and switched to the working
# versions by detault, the only remaining issue is that taffybar is still marked as broken!
self: super:
{
  haskellPackages = with self.haskell.lib; super.haskellPackages.extend (hself: hsuper: {
    taffybar = markUnbroken hsuper.taffybar;
  });
}
