{
  #haskellPackageOverrides = self: super: {
  #  lushtags = self.callPackage (import ./lushtags) {};
  #};

  packageOverrides = pkgs_: with pkgs_; rec {

    vimPlugins = callPackage ./vim/plugins.nix {} pkgs_.vimPlugins;
    vim-custom = callPackage ./vim {};

    haskellEnvWithHoogle = import ./haskellEnvWithHoogle.nix;

    nda = callPackage ./nda {};

    zsh-custom = callPackage ./zsh { vte = gnome3.vte-select-text; };

    powerline-gitstatus = callPackage ./powerline-gitstatus.nix {};
    powerlineWithGitStatus = pythonPackages.powerline.overrideDerivation (
      super: {
        propagatedNativeBuildInputs
          = [ powerline-gitstatus ] ++ super.propagatedNativeBuildInputs;
        }
    );

    mine = with pkgs; buildEnv {
      name = "mine";
      paths = [
        # System
        arc-gtk-theme
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
        synapse
        taffybar
        termite
        tree
        xsel
        zsh-custom

        # Devlopment
        cabal-install
        cabal2nix
        colordiff
        ctags
        # ctagsWrapped.ctagsWrapped
        # haskellPackages.hothasktags
        gitAndTools.gitFull
        haskellPackages.hasktags
        haskellPackages.hdevtools
        haskellPackages.hlint
        nda
        nix-repl
        powerlineWithGitStatus
        powerline-fonts
        vim-custom

        # Office
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
