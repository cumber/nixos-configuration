{
  #haskellPackageOverrides = self: super: {
  #  lushtags = self.callPackage (import ./lushtags) {};
  #};

  packageOverrides = pkgs_: with pkgs_; rec {

    vim-custom = callPackage ./vim {};

    haskellEnvWithHoogle = import ./haskellEnvWithHoogle.nix;

    nda = callPackage ./nda {};

    zsh-custom = callPackage ./zsh { vte = gnome3.vte; };

    vimPlugins = callPackage ./vim/plugins.nix {} pkgs_.vimPlugins;

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

    boo = callPackage ./boo {
      inherit (gnome2) gtksourceview;
      mono = mono46;
    };

    banshee = pkgs_.banshee.override {
      inherit boo;
    };

    xmonad-custom = haskellPackages.callPackage ./xmonad-custom {
      powerline = powerlineWithGitStatus;
      inherit (python27Packages) syncthing-gtk;
      inherit (gnome3) gnome_keyring;
    };

    mine = with pkgs; buildEnv {
      name = "mine";
      paths = [
        # System
        arc-theme
        blueman
        compton
        gnome3.adwaita-icon-theme  # fallback icons from numix
        gnome3.gcr  # needed for gnome-keyring-daemon
        gnome3.gnome-system-monitor
        gnome3.gnome_keyring
        gnome3.nautilus
        gtk-engine-murrine
        inconsolata
        libnotify
        lxappearance
        networkmanagerapplet
        notify-osd
        numix-icon-theme
        python27Packages.syncthing-gtk
        synapse
        taffybar
        termite
        tree
        udiskie
        xmonad-custom
        xsel
        zsh-custom

        # Devlopment
        cabal-install
        cabal2nix
        colordiff
        ctags
        gitAndTools.gitFull
        # hasktags needs a version bump on directory dependency
        # has been made upstream, needs to make it into hackage and then nixpkgs
        #haskellPackages.hasktags
        haskellPackages.hdevtools
        updatedHaskellSrcTools.hlint
        nda
        nix-repl
        powerlineWithGitStatus
        powerline-fonts
        vim-custom

        # Office
        banshee
        chromium
        evince
        gimp
        libreoffice
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
