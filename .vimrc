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
let mercury_highlight_full_comment = 1
set listchars=tab:»\ ,trail:·
set list

au BufNewFile,BufRead *.mako set ft=mako
