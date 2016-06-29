" Vimrc and gVimrc file
"==== Vundle ====
set nocompatible                    " be iMproved!
set nobackup                        " no annoying file.txt~ files

set ttimeoutlen=200             " Exit insert mode quickly
set timeoutlen=1000             " But still give me time to enter leader commands

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" All of your Plugins must be added before the following line
call vundle#end()            " required
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

inoremap # X<C-H>#|                 " And no magic outdent for comments
nnoremap <silent> >> :call ShiftLine()<CR>| " And no shift magic on comments
function! ShiftLine()
    set nosmartindent
    normal! >>
    set smartindent
endfunction

set t_Co=256
set t_ut=

"==== Syntax highlighting and coloring ===="
syntax on
set background=dark
hi Normal    guifg=white guibg=black ctermfg=white
hi Search    guifg=black guibg=cyan  ctermfg=black ctermbg=cyan
hi VertSplit guifg=darkgrey guibg=NONE ctermfg=darkgrey ctermbg=NONE cterm=bold gui=bold

"==== Searching ===="
set hlsearch                        " highlights search results
set incsearch                       " highlights as you type
set ignorecase
set smartcase                       " case insens for all-lower searches
nohl

"==== System Information ===="
if has("win32") || has("win16")
    let os = "windows"
elseif has("unix")
    let os = substitute(system('uname'), "\n", "", "")
else
    let os = "undefined"
endif

if has("gui_running")
    let guiMode = "gui"
else
    let guiMode = "terminal"
endif

if os == "windows"
    set dir=%TMP%
    set clipboard=unnamed
endif

"==== Line numbers ===="
set number

"==== Enable backspace ===="
set bs=2

"==== Key remaps ===="

" from Instantly Better Vim
" Swap : and ;
nnoremap  ;  :

" <Ctrl-l> redraws the screen and removes any search highlighting.
"nnoremap <silent> <C-l> :nohl<CR><C-l> " in case I actually need to redraw
nnoremap <silent> <C-l> :nohl<CR>

" pasted text has same indent
nnoremap p ]p

"" Instantly Better Vim additions ""

"====[ Make the 81st column stand out ]====================

    " OR ELSE just the 81st column of wide lines...
    highlight ColorColumn ctermbg=magenta
    call matchadd('ColorColumn', '\%81v', 100)

"=====[ Highlight matches when jumping to next ]=============

    " This rewires n and N to do the highlighing...
    " nnoremap <silent> n   n:call HLNext(0.4)<cr>
    " nnoremap <silent> N   N:call HLNext(0.4)<cr>

    " EITHER blink the line containing the match...
"    function! HLNext (blinktime)
"        set invcursorline
"        redraw
"        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"        set invcursorline
"        redraw
"    endfunction

    " OR ELSE ring the match in red...
"    function! HLNext (blinktime)
"        highlight RedOnRed ctermfg=red ctermbg=red
"        let [bufnum, lnum, col, off] = getpos('.')
"        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
"        echo matchlen
"        let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
"                \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
"                \ . '\|'
"                \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
"                \ . '\|'
"                \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
"        let ring = matchadd('RedOnRed', ring_pat, 101)
"        redraw
"        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"        call matchdelete(ring)
"        redraw
"    endfunction

    " OR ELSE briefly hide everything except the match...
"    function! HLNext (blinktime)
"        highlight BlackOnBlack ctermfg=black ctermbg=black
"        highlight BlackOnBlack guifg=black guibg=black
"        let [bufnum, lnum, col, off] = getpos('.')
"        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
"        let hide_pat = '\%<'.lnum.'l.'
"                \ . '\|'
"                \ . '\%'.lnum.'l\%<'.col.'v.'
"                \ . '\|'
"                \ . '\%'.lnum.'l\%>'.(col+matchlen-1).'v.'
"                \ . '\|'
"                \ . '\%>'.lnum.'l.'
"        let ring = matchadd('BlackOnBlack', hide_pat, 101)
"        redraw
"        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"        call matchdelete(ring)
"        redraw
"    endfunction

    " OR ELSE just highlight the match in red...
    highlight WhiteOnRed ctermfg=white ctermbg=red
    highlight WhiteOnRed guifg=white guibg=red
    function! HLNext (blinktime)
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let target_pat = '\c\%#'.@/
        let ring = matchadd('WhiteOnRed', target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction


""====[ Open any file with a pre-existing swapfile in readonly mode "]=========
"
"    augroup NoSimultaneousEdits
"        autocmd!
"        autocmd SwapExists * let v:swapchoice = 'o'
"        autocmd SwapExists * echomsg ErrorMsg
"        autocmd SwapExists * echo 'Duplicate edit session (readonly)'
"        autocmd SwapExists * echohl None
"        autocmd SwapExists * sleep 2
"    augroup END


"====[ Mappings to activate spell-checking alternatives ]================

"    nmap  ;s     :set invspell spelllang=en<CR>
"    nmap  ;ss    :set    spell spelllang=en-basic<CR>

    " To create the en-basic (or any other new) spelling list:
    "
    "     :mkspell  ~/.vim/spell/en-basic  basic_english_words.txt
    "
    " See :help mkspell


"======Taken from online======"

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END

let g:clipbrdDefaultReg = '+'

""==== Make tabs, trailing whitespace, and non-breaking spaces visible ===="

    exec "set listchars=tab:\uB6~,nbsp:~,trail:\uB7"
    set list
"==== Make visual blocks a little prettier and more useful ===="
vnoremap <silent>  I  I<C-R>=TemporaryColumnMarkerOn()<CR>
vnoremap <silent>  A  A<C-R>=TemporaryColumnMarkerOn()<CR>

function! TemporaryColumnMarkerOn ()
    set cursorcolumn
    inoremap <silent>  <ESC>  <ESC>:call TemporaryColumnMarkerOff()<CR>
    return ""
endfunction

function! TemporaryColumnMarkerOff ()
    set nocursorcolumn
    iunmap <ESC>
endfunction

" Load vimrc at startup

augroup ConfigReload
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" User hjkl!!!!
nnoremap <silent> <LEFT>  :echo 'Press h'<CR>
nnoremap <silent> <DOWN>  :echo 'Press j'<CR>
nnoremap <silent> <UP>    :echo 'Press k'<CR>
nnoremap <silent> <RIGHT> :echo 'Press l'<CR>

inoremap <silent> <LEFT>  <C-O>:echo 'Press h'<CR>
inoremap <silent> <DOWN>  <C-O>:echo 'Press j'<CR>
inoremap <silent> <UP>    <C-O>:echo 'Press k'<CR>
inoremap <silent> <RIGHT> <C-O>:echo 'Press l'<CR>

" Mouse scrolling
set mouse=a
set ttymouse=xterm
