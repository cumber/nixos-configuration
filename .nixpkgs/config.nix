{
  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
      name = "mine";
      paths = [
        chromium
        ghc
        gitAndTools.gitFull
        gnome3.gnome-system-monitor
        vim-cumber
        xfce.terminal

        compton
        networkmanagerapplet
        synapse
        pkgs.taffybar
      ];
    };

    vim-cumber = vim_configurable.customize {
      name = "vim";

      vimrcConfig.customRC = ''
        set colorcolumn=80
      '';

      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        { name = "youcompleteme"; }
      ];
    };
  };
}
