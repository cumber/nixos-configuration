{vim_configurable, vimPlugins, vimUtils, fetchgit }: rec {

  rainbow = vimUtils.buildVimPluginFrom2Nix {
    name = "rainbow_parentheses-2015-12-02";
    src = fetchgit {
      url = "git://github.com/luochen1990/rainbow";
      rev = "18b7bc1b721f32fcabe740e098d693eace6ad655";
      sha256 = "47975a426d06f41811882691d8a51f32bc72f590477ed52b298660486b2488e3";
    };
    dependencies = [];
  };

  vim = vim_configurable.customize {
    name = "vim";

    vimrcConfig.customRC = ''
      " Pretty stuff
      set guifont=Deja\ Vu\ Sans\ Mono\ 14
      if has('gui_running')
        set guioptions-=T
        colorscheme google
      else
        set t_Co=256
        colorscheme darkbone
      endif

      " Make it easy to move over lines
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

    vimrcConfig.vam.knownPlugins = vimPlugins // {
      inherit rainbow;
    };
    vimrcConfig.vam.pluginDictionaries = [
      { name = "youcompleteme"; }
      { name = "syntastic"; }
      { name = "tagbar"; }
      { name = "vim-hdevtools"; ft_regex = "^haskell$"; }
      { name = "vim-colorschemes"; }
      { name = "CSApprox"; }
    ];
  };
}
