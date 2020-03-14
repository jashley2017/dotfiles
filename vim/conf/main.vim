execute pathogen#infect()
set diffopt+=iwhite

set ttyfast
set number 
set tabstop=2 shiftwidth=2 expandtab
set noswapfile
set title
set nowrap 
set guioptions+=b
set backspace=indent,eol,start
set hlsearch

set t_Co=256
set background=dark 
colorscheme gruvbox 
syntax on
set autoindent
filetype plugin indent on 

let g:DirDiffForceLang = ""


" Airline diff
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16_gruvbox_dark_hard'

" Ale Syntax checker
let g:airline#extensions#ale#enabled = 1



if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif
"Important! Syntastic will do nothing if pylint fails for some reason (if you
"do the pylint in a directory with logging.py for instance. It will crash)
" pylint filename blacklist: logging.py, ast.py 
" you can fix this problem by simply opening vim in a different directory. 
let mapleader = " "

au BufRead,BufNewFile *.ini set filetype=tcl
au BufRead,BufNewFile *.rb set filetype=ruby
au BufRead,BufNewFile *.py set filetype=python
au BufRead,BufNewFile *.tcl set filetype=tcl
au BufRead,BufNewFile Make.*.inc set filetype=make

map <F9>  :%s/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{2\}\)/20\3-\1-\2/gc <cr>
autocmd FileType ruby compiler ruby

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"NerdTree
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '^'

au VimEnter * wincmd l

augroup urdf_ft
  au!
  autocmd BufNewFile,BufRead *.urdf set syntax=xml
augroup END

augroup launch_ft
  au!
  autocmd BufNewFile,BufRead *.launch set syntax=xml
augroup END
"Markdown Preview
"Call this on initial install
"call mkdp#util#install()
