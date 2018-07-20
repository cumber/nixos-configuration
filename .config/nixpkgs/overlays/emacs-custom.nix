self: super: {
  emacsPackagesNg = super.emacsPackagesNg.overrideScope (epSuper: _epSelf: {
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

    company-cabal
    dante

    csv-mode

    tern
    company-tern
    indium

    php-mode

    markdown-mode

    nix-mode
    nix-sandbox

    diff-hl
    magit
    gitattributes-mode
    gitconfig-mode
    gitignore-mode

    web-mode

    yaml-mode

    company-flx
    counsel-projectile
    fill-column-indicator
    ivy
    ivy-hydra
    linum-relative
    projectile
    rainbow-delimiters
    rainbow-identifiers
    swiper
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
