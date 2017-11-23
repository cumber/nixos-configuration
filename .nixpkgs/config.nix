{
  packageOverrides = pkgs_: with pkgs_; rec {

    vim-custom = callPackage ./vim {};
    vimPlugins = callPackage ./vim/plugins.nix {} pkgs_.vimPlugins;

    zsh-custom = callPackage ./zsh { vte = gnome3.vte; };

    powerline-gitstatus = (
      pythonPackages.callPackage ./powerline-gitstatus.nix {}
    );
    powerlineWithGitStatus = pythonPackages.powerline.overrideDerivation (
      super: {
        propagatedBuildInputs
          = [ powerline-gitstatus ]
            ++ builtins.filter (dep: dep != bazaar)
                 super.propagatedBuildInputs;
        }
    );

    haskellPackages = pkgs_.haskellPackages.extend (self: super: {
      type-nat-solver = self.callPackage ./type-nat-solver {
        # There's a haskell package called z3 that would automatically be
        # chosen by callPackage; we need the z3 executable
        z3-exe = pkgs_.z3;
      };
    });

    updatedHaskellSrcTools = (
      let hp = haskellPackages.extend (self: super: {
            haskell-src-exts = self.haskell-src-exts_1_19_1;
          });
      in  {
        inherit (hp) hlint;
      }
    );

    xmonad-custom = haskellPackages.callPackage ./xmonad-custom {
      powerline = powerlineWithGitStatus;
      inherit (python27Packages) syncthing-gtk;
    };

    emacs-custom = emacsPackagesNg.emacsWithPackages (epkgs: with epkgs; [
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

    chatty = callPackage ./chatty.nix {};

    mine = with pkgs; buildEnv {
      name = "mine";
      paths = [
        # System
        blueman
        gnome3.adwaita-icon-theme  # fallback icons from numix
        gnome3.gnome-system-monitor
        hicolor_icon_theme
        inconsolata
        lxappearance
        numix-gtk-theme
        numix-icon-theme
        psmisc
        python27Packages.syncthing-gtk
        source-code-pro
        taffybar
        termite
        tree
        xmonad-custom
        xsel
        zsh-custom

        # Devlopment
        cabal-install
        cabal2nix
        colordiff
        emacs-custom
        gitAndTools.gitFull
        haskellPackages.hasktags
        haskellPackages.hdevtools
        updatedHaskellSrcTools.hlint
        nix-repl
        nox
        powerlineWithGitStatus
        powerline-fonts
        vim-custom

        # Office
        chromium
        evince
        gimp
        gnome3.eog
        libreoffice
        rhythmbox
        speedcrunch
        thunderbird
        vlc

        chatty

        # LyX / LaTeX
        lyx
        (texlive.combine {
          inherit (texlive)
            collection-fontsrecommended
            collection-latex
            collection-latexrecommended

            paralist
          ;
        })
      ];
    };
  };
}
