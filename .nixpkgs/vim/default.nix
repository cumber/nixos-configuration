{ vim_configurable, vimPlugins, vimUtils, fetchgit }: rec {

  rainbow-parentheses-improved = vimUtils.buildVimPluginFrom2Nix {
    name = "rainbow-parentheses-improved-2015-12-02";
    src = fetchgit {
      url = "git://github.com/luochen1990/rainbow";
      rev = "18b7bc1b721f32fcabe740e098d693eace6ad655";
      sha256 = "0wyhifdpdzbgppsq1gyh41nf2dgwcvmh29qc69r0akphpqhhk3m4";
    };
    dependencies = [];
  };

  knownPlugins = vimPlugins // { inherit rainbow-parentheses-improved; };

  vim = vim_configurable.customize {
    name = "vim";

    vimrcConfig.customRC = ''
      " Pretty stuff
      set guifont=Inconsolata\ 15
      if has('gui_running')
        set guioptions-=T
        colorscheme google
      else
        set t_Co=256
        colorscheme darkbone
      endif

      " Rainbow parentheses does nothing if this variable isn't set, so had
      " to delay that plugin from loading
      let g:rainbow_conf = {
      \ 'separately': {
      \   'haskell': {
      \     'parentheses': [
      \       'start=/(/ end=/)/',
      \       'start=/\[/ end=/\]/',
      \       'start=/{-\@!/ end=/-\@<!}/',
      \     ]
      \   }
      \ }
      \}
      let g:rainbow_active = 1
      call vam#Scripts([], {'tag_regex': 'delay'})

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
      set colorcolumn=81
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

    vimrcConfig.vam.knownPlugins = knownPlugins;
    vimrcConfig.vam.pluginDictionaries = [
      { name = "youcompleteme"; }
      { name = "syntastic"; }
      { name = "tagbar"; }
      { name = "vim-hdevtools"; ft_regex = "^haskell$"; }
      { name = "vim-colorschemes"; }
      { name = "CSApprox"; }
      { name = "rainbow-parentheses-improved"; tag = "delayed"; }
      { name = "hasksyn"; }
    ];
  };
}
