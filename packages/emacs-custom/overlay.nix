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
    # foundation of package config in emacsd/init.el
    use-package

    ###
    # General editor behaviour
    ###

    # code checking in editor
    flycheck

    # company (code-completion) front end with icons
    company-box

    # fuzzy matching in company code-completion
    company-flx

    # project interaction library for Emacs
    projectile

    # Ivy completion for Emacs commands
    ivy
    ivy-hydra

    # extended search command
    swiper

    # Ivy completion support in projectile
    counsel-projectile

    # Infer indentation offset from file contents
    dtrt-indent

    # draw line at suggested max line width
    fill-column-indicator

    # show relative line numbers
    linum-relative

    # rainbow colouring for brackets
    rainbow-delimiters

    # show completion for multi-step key bindings
    which-key

    # easy entry of many unicode symbols
    xah-math-input


    #####
    # Language support
    #####

    # haskell language support
    company-cabal
    lsp-haskell
    lsp-ui
    yasnippet

    csv-mode

    dockerfile-mode
    docker-compose-mode

    # JavaScript
    tide
    js2-mode

    php-mode

    markdown-mode

    nix-mode
    nix-sandbox

    # git support
    diff-hl
    magit
    gitattributes-mode
    gitconfig-mode
    gitignore-mode

    # ruby language support
    robe

    # HTML mode with support for embedded parts in other languages
    # (for CSS, script tags, and templating engines in PHP, Python, etc)
    web-mode

    yaml-mode
  ]);

  # launcher script for using emacs client
  emacs-edit = super.writeShellScriptBin "ee" ''
    if [[ $IN_NIX_SHELL = "" ]]; then
      socketName="default"
    else
      socketName="nix-shell: $name"
    fi

    ${self.emacs-custom}/bin/emacsclient \
      --socket-name "$socketName" \
      --alternate-editor "" \
      --create-frame \
      --no-wait \
      "$@"
  '';
}
