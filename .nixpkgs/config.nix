{
  packageOverrides = pkgs_: with pkgs_; {
    vim-custom = callPackage ./vim {};

    mine = with pkgs; buildEnv {
      name = "mine";
      paths = [
        # System
        arc-gtk-theme
        compton
        gnome3.gnome-system-monitor
        gnome3.nautilus
        gtk-engine-murrine
        inconsolata
        libnotify
        networkmanagerapplet
        notify-osd
        numix-icon-theme
        synapse
        taffybar
        tree
        xfce.terminal
        blueman

        # Devlopment
        cabal-install
        cabal2nix
        colordiff
        ctags
        # ctagsWrapped.ctagsWrapped
        # haskellPackages.hothasktags
        gitAndTools.gitFull
        haskellPackages.hdevtools
        haskellPackages.hlint
        nix-repl
        python
        vim-custom.vim

        # Office
        chromium
        evince
        gimp
        libreoffice
        lyx
        speedcrunch
        texLiveFull
        thunderbird
      ];
    };
  };
}
