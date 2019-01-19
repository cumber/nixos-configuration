self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    taffybar = hself.callCabal2nix "taffybar" (super.fetchFromGitHub {
      owner = "taffybar";
      repo = "taffybar";
      rev = "e382599358bb06383ba4b08d469fc093c11f5915";
      sha256 = "0qncwpfz0v2b6nbdf7qgzl93kb30yxznkfk49awrz8ms3pq6vq6g";
      }) { inherit (self) gtk3; };
  });
}
