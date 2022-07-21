" Vimrc and gVimrc file
set nocompatible                    " be iMproved!
set nobackup                        " no annoying file.txt~ files

set ttimeoutlen=1               " Exit insert mode quickly
set timeoutlen=100              " But still give me time to enter leader commands

" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'vim-airline/vim-airline'
Plug 'tmux-plugins/vim-tmux'
call plug#end()

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

"==== Indentation and word wrapping ===="
set shiftwidth=4 tabstop=4
set expandtab
set smarttab
set formatoptions=1
set lbr
set scrolloff=4                  " keep at least 4 lines above/below
set sidescrolloff=4              " keep at least 4 lines left/right

" Fix smartindent stupidities
set autoindent                      " Retain indentation on next line
set smartindent                     " Turn on autoindenting of blocks

set t_Co=256
set t_u7=

"==== Syntax highlighting and coloring ===="
syntax on
set background=dark
set termguicolors
colorscheme quantum

"==== Searching ===="
set hlsearch    " highlights search results
set incsearch   " highlights as you type
set ignorecase  " ignore case
set smartcase   " case insensitive for all lowercase searches
nohl
" <Ctrl-l> redraws the screen and removes any search highlighting
nnoremap <silent> <C-l> :nohl<CR>

"==== Line numbers ===="
set number

"==== Enable backspace ===="
set backspace=indent,eol,start

"" Instantly Better Vim additions ""

"====[ Make the 81st column stand out ]====================

    " OR ELSE just the 81st column of wide lines...
    highlight ColorColumn ctermbg=magenta
    call matchadd('ColorColumn', '\%81v', 100)


"======Taken from online======"

""==== Make tabs, trailing whitespace, and non-breaking spaces visible ===="
    exec "set listchars=tab:\uB6~,nbsp:~,trail:\uB7"
    set list

" Load vimrc at startup
augroup ConfigReload
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Mouse scrolling
set mouse=a
set ttymouse=xterm
