self: super: {
  emacsPackagesNg = super.emacsPackagesNg.overrideScope' (_epSelf: epSuper: {
    nix-sandbox = epSuper.nix-sandbox.overrideAttrs (_oldAttrs: {
      src = super.fetchFromGitHub {
        owner = "benley";
        repo = "nix-emacs";
        rev = "c98d119ec31994a9303abe0f35e465b86f39650f";
        sha256 = "0ick49lrf906wfjvnasrrpbshnbgkxykbwm3n7ayk8172bgpdnha";
      };
    });
  });

  emacs-custom = self.emacsPackagesNg.emacsWithPackages (epkgs: with epkgs; [
    use-package

    flycheck

    company-cabal
    lsp-haskell
    lsp-ui
    yasnippet

    csv-mode

    dockerfile-mode
    docker-compose-mode

    php-mode

    markdown-mode

    nix-mode
    nix-sandbox

    diff-hl
    magit
    gitattributes-mode
    gitconfig-mode
    gitignore-mode

    robe

    web-mode

    yaml-mode

    company-flx
    counsel-projectile
    dtrt-indent
    fill-column-indicator
    ivy
    ivy-hydra
    linum-relative
    projectile
    rainbow-delimiters
    rainbow-identifiers
    swiper
    which-key
    xah-math-input
  ]);

  # launcher script for using emacs client
  emacs-edit = super.writeShellScriptBin "ee" ''
    ${self.emacs-custom}/bin/emacsclient \
      --alternate-editor "" \
      --create-frame \
      --no-wait \
      "$@"
  '';
}
