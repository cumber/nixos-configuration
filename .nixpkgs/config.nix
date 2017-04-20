{
  packageOverrides = pkgs_: with pkgs_; rec {

    vim-custom = callPackage ./vim {};
    vimPlugins = callPackage ./vim/plugins.nix {} pkgs_.vimPlugins;

    haskellEnvWithHoogle = import ./haskellEnvWithHoogle.nix;

    nda = callPackage ./nda {};

    zsh-custom = callPackage ./zsh { vte = gnome3.vte; };

    pythonPackages = pkgs_.pythonPackages.override {
      overrides = self: super: {
        pygit2 = super.pygit2.override rec {
          name = "pygit2-0.25.0";

          src = fetchurl {
            url = "mirror://pypi/p/pygit2/${name}.tar.gz";
            sha256 = "0wf5rp0fvrw7j3j18dvwjq6xqlbm611wd55aphrfpps0v1gxh3ny";
          };
        };
      };
    };

    powerline-gitstatus = (
      callPackage
        ./powerline-gitstatus.nix
        { inherit (pythonPackages) buildPythonPackage; }
    );
    powerlineWithGitStatus = pythonPackages.powerline.overrideDerivation (
      super: {
        propagatedNativeBuildInputs
          = [ powerline-gitstatus ] ++ super.propagatedNativeBuildInputs;
        }
    );

    haskellPackages = pkgs_.haskellPackages.override {
      overrides = self: super: {
        type-nat-solver = self.callPackage ./type-nat-solver {
          # There's a haskell package called z3 that would automatically be
          # chosen by callPackage; we need the z3 executable
          z3-exe = pkgs_.z3;
        };
      };
    };

    updatedHaskellSrcTools = (
      let hp = haskellPackages.override {
            overrides = self: super: {
              haskell-src-exts = self.haskell-src-exts_1_19_1;
            };
          };
      in  {
        inherit (hp) hlint;
      }
    );

    xmonad-custom = haskellPackages.callPackage ./xmonad-custom {
      powerline = powerlineWithGitStatus;
      inherit (python27Packages) syncthing-gtk;
    };

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
        ctags
        gitAndTools.gitFull
        haskellPackages.hasktags
        haskellPackages.hdevtools
        updatedHaskellSrcTools.hlint
        nda
        nix-repl
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
