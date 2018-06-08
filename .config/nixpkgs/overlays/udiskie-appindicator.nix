self: super: {
  udiskie = super.python3Packages.callPackage ./udiskie.nix.package {};
}
