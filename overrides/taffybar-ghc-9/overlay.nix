# Pull taffybar from master to fix compatibility with ghc 9+.
# Can remove overlay once a hackage release includes this.
# See https://github.com/taffybar/taffybar/issues/542

final: prev:
let taffybar-src = final.fetchFromGitHub {
      owner = "taffybar";
      repo = "taffybar";
      rev = "945a08452660de603193da8d297d559fdca497d1";
      hash = "sha256-3H8sRK7qszYpVnX9o1UMCDUGTGtS+KLhyZ+Pu0h8EbY=";
    };
in
{
  haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
    taffybar = hfinal.callCabal2nix "taffybar" taffybar-src { inherit (final) gtk3; };
  });
}
