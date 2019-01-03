self: super: {
  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    taffybar = hsuper.taffybar.overrideDerivation (old: {
      src = super.fetchFromGitHub {
        owner = "taffybar";
        repo = "taffybar";
        rev = "ee2cd6b871ea05bc60a050d5cefc9e307475e794";
        sha256 = "10gfmp7zmihmbipcby1k75bv5mazij3mhnnawq8fpzp65mav5zcv";
      };
    });

    status-notifier-item = hsuper.status-notifier-item.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ./status-notifier-item-0.3.0.0.patch ];
    });
  });
}
