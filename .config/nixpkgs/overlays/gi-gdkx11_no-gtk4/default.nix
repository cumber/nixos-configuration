# Upstream has updated gi-gdkx11 to 4.0.1, which needs gtk4.
# Override version here until either gtk4 is available or upstream
# downgrades.

self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    gi-gdkx11 = super.haskellPackages.callHackage "gi-gdkx11" "3.0.9" { gtk3 = self.gtk3; };

    # taffybar was marked broken upstream, because of the dependency on gi-gdkx11
    taffybar = hsuper.taffybar.overrideAttrs (old: { meta = old.meta // { broken = false; }; });
  });
}
