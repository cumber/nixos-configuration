{ vim_configurable, vimPlugins }: rec {

  vim = vim_configurable.customize {
    name = "vim";

    vimrcConfig.vam.knownPlugins = vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
      { name = "youcompleteme"; }
      { name = "syntastic"; }
      { name = "tagbar"; }
      { name = "vim-hdevtools"; ft_regex = "^haskell$"; }
      { name = "vim-colorschemes"; }
      { name = "CSApprox"; }
      { name = "rainbow-parentheses-improved"; tag = "delayed"; }
      { name = "easytags"; }
      { name = "hasksyn"; }
      { name = "sleuth"; }
      { name = "fugitive"; }
      { name = "gitgutter"; }
      { name = "airline"; }
    ];

    vimrcConfig.customRC = builtins.readFile ./vimrc;
  };
}
