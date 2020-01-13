# Upstream has updated gi-gdkx11 to 4.0.1, which needs gtk4.
# Override version here until either gtk4 is available or upstream
# downgrades.

self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    gi-gdkx11 = super.haskellPackages.callHackage "gi-gdkx11" "3.0.9" { gtk3 = self.gtk3; };
  });
}
