{
  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
      name = "mine";
      paths = [
        cabal-install
        cabal2nix
        chromium
        ctags
        # ctagsWrapped.ctagsWrapped
        ghc
        gitAndTools.gitFull
        blueman
        gnome3.gnome-system-monitor
        haskellPackages.hdevtools
        haskellPackages.hlint
        haskellPackages.hoogle
        # haskellPackages.hothasktags
        nix-repl
        python
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
        set guifont=Deja\ Vu\ Sans\ Mono\ 14

        " make it easy to move over lines
        set whichwrap=b,s,<,>,[,]
        set backspace=indent,eol,start

        " Tab behaviour
        set autoindent
        set tabstop=4
        set shiftwidth=4
        set expandtab

        " Visible tabs and trailing whitespace
        set listchars=tab:»\ ,trail:·
        set list

        " Highlight searches, and clear highlight
        set hlsearch
        set incsearch
        map <Leader>/ :nohlsearch<CR>

        " Show line numbers
        map <Leader>0 :set number!<CR>
        set colorcolumn=80
        set numberwidth=6
        set number

        set pastetoggle=<F11>

        let g:haddock_browser = "chromium-browser"

        " syntastic
        map <silent> <Leader>e :Errors<CR>
        map <Leader>s :SyntasticToggleMode<CR>

        " tagbar
        map <Leader>= :TagbarToggle<CR>
        let g:tagbar_autofocus = 1

        " Get type or info of thing under cursor
        au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
        au FileType haskell nnoremap <buffer> <F2> :HdevtoolsClear<CR>
        au FileType haskell nnoremap <buffer> <F3> :HdevtoolsInfo<CR>
      '';

      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        { name = "youcompleteme"; }
        { name = "syntastic"; }
        { name = "tagbar"; }
        { name = "vim-hdevtools"; ft_regex = "^haskell$"; }
      ];
    };
  };
}
