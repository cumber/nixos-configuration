set whichwrap=b,s,<,>,[,]
set backspace=indent,eol,start
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
map <C-A> :noh<CR>
map <F12> :set number!<CR>
set pastetoggle=<C-S>
set hlsearch
set incsearch
set tags=tags;
set modeline
set numberwidth=6
set number
filetype on
filetype plugin on
syntax enable
set listchars=tab:»\ ,trail:·
set list

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

let g:haddock_browser = "chromium-browser"
