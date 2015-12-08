{
  packageOverrides = pkgs_: with pkgs_; {
    vim-custom = callPackage ./vim {};

    mine = with pkgs; buildEnv {
      name = "mine";
      paths = [
        cabal-install
        cabal2nix
        chromium
        ctags
        # ctagsWrapped.ctagsWrapped
        gitAndTools.gitFull
        blueman
        gnome3.gnome-system-monitor
        haskellPackages.hdevtools
        haskellPackages.hlint
        haskellPackages.hoogle
        # haskellPackages.hothasktags
        nix-repl
        python
        vim-custom.vim
        xfce.terminal

        compton
        networkmanagerapplet
        synapse
        pkgs.taffybar
      ];
    };
  };
}
