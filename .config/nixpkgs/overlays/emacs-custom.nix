self: super: {
  emacs-custom = self.emacsPackagesNg.emacsWithPackages (epkgs: with epkgs; [
    haskell-mode
    #structured-haskell-mode
    #ghc-mod
    company-cabal
    #company-ghc
    flycheck-haskell
    flycheck-hdevtools

    nix-mode
    nix-sandbox

    magit
    gitattributes-mode
    gitconfig-mode
    gitignore-mode

    company-flx
    fill-column-indicator
    ivy
    linum-relative
    rainbow-delimiters
    swiper
  ]);
}
