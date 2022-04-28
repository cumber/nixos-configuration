final: prev:
let gtk-strut-src = final.fetchFromGitHub {
      owner = "taffybar";
      repo = "gtk-strut";
      rev = "b8a8c30190a108e2cc977ef424af3a3c00fe973f";
      hash = "sha256-zVkad4/KWVdROaOsT8VvgXHihWEJxKqWLtAjuvIILJw=";
    };
in
{
  haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
    gtk-strut = hfinal.callCabal2nix "gtk-strut" gtk-strut-src {};
  });
}
