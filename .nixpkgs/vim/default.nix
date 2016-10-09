{ neovim, vimPlugins }:

  neovim.override {
    vimAlias = true;

    configure = {
      vam.knownPlugins = vimPlugins;
      vam.pluginDictionaries = [
        { name = "youcompleteme"; }
        { name = "syntastic"; }
        { name = "tagbar"; }
        { name = "vim-hdevtools"; ft_regex = "^haskell$"; }
        { name = "vim-colorschemes"; }
        { name = "CSApprox"; }
        { name = "rainbow-parentheses-improved"; tag = "delayed"; }
        { name = "easytags"; }
        { name = "vim2hs"; }
        { name = "vim-addon-nix"; }
        { name = "sleuth"; }
        { name = "fugitive"; }
        { name = "gitgutter"; }
        { name = "airline"; }
      ];

      customRC = builtins.readFile ./vimrc;
    };
  }
