"
" Vim-plug
"
call plug#begin('~/.config/nvim/plugged')

" Let Vundle manage itself
Plug 'VundleVim/Vundle.vim'

" Classics
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
"Plugin 'tsaleh/vim-matchit'
Plug 'duff/vim-bufonly'

" Ruby powertools
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'
Plug 'noprompt/vim-yardoc'

" Python
Plug 'klen/python-mode'
Plug 'glench/vim-jinja2-syntax'

" Coffee
Plug 'kchmck/vim-coffee-script'

" JSON
Plug 'elzr/vim-json'

" HTML/CSS
"Plugin 'mattn/emmet-vim' " Yet to test it out
Plug 'vim-scripts/Better-CSS-Syntax-for-Vim'
Plug 'ap/vim-css-color'

" Git powertools
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'

" Experimental
Plug 'mattn/webapi-vim'
Plug 'L9'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

" Colorscheme tools
Plug 'xterm-color-table.vim'
Plug 'vim-scripts/CSApprox'
Plug 'gerw/vim-HiLinkTrace'

" Themes
Plug 'jellybeans.vim'
Plug 'Solarized'
Plug 'railscasts'

" Coding eyecandy
Plug 'nathanaelkane/vim-indent-guides'

" Thesaurus plugin (:Thesaurus, <Leader>cs)
Plug 'Ron89/thesaurus_query.vim'

" Productivity tools
Plug 'ctrlp.vim'
Plug 'The-NERD-tree'
"Plug 'Shougo/neocomplete.vim'
"Plug 'Shougo/neoinclude.vim'
Plug 'SirVer/ultisnips'

" Golden ratio resizing (should fork and fix this)
"Plugin 'roman/golden-ratio'

" Ascii Art
Plug 'DrawIt'
Plug 'fadein/Figlet.vim'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/AnsiEsc.vim'

" Code navigation through tags/cscope
Plug 'hari-rangarajan/CCTree'
Plug 'majutsushi/tagbar'

call plug#end()

"
" Setup
"
set nocompatible
set langmenu=none

"  Configure GUI
"set guifont=DejaVu_Sans_Mono:h11:cANSI
set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Terminus:h10
set guioptions=Me
set guitablabel=%t
set guicursor=n:blinkwait5000-blinkon10000-blinkoff200

set ignorecase smartcase

set hidden
set nobackup
set noswapfile

set encoding=utf-8
set lcs=tab:»\ ,eol:¶,trail:·,precedes:…,extends:…
set fcs=vert:│,fold:-
set backspace=indent,eol,start

set sts=2 sw=2 ts=8 et
set incsearch hlsearch
set nu magic nowrap 
set nosmartindent nocindent autoindent

" Status line
set laststatus=2

" Status line for Lovecraft scheme 
" (relies on User1, User2 and User3 highlight groups)
set statusline=%<%1*%t%*\ %20.30(%{&ff}\ %{&fenc}\ %{&ft}%)\ %2*%10.40(%h%w%m%)%*%=(%3*%c%*,%3*%l%*)%3*%5.5p%*%%\ %*

" Colorless statusline
"set statusline=%<%t\ %20.30(%{&ff}\ %{&fenc}\ %{&ft}%)\ %10.40(%h%w%m%)%=(%c,%l)%5.5p%%\ 

set directory=/tmp
set backupdir=/tmp
set tags=~/rezon/hermes/tags

filetype plugin on
filetype indent on


" cscope setup
if has("cscope")
  set cscopetag
  set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
  set cscoperelative
  set cscopeverbose
  set cscopetagorder=0
  set cscopepathcomp=1

  nmap <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <Leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <Leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <Leader>fa :cs find a <C-R>=expand("<cword>")<CR><CR>
endif

set mouse=a
set dictionary=/usr/share/dict/words
set thesaurus=~/.vim/thesaurus/mthesaur.txt

syntax on
colorscheme lovecraft

set nospell spelllang=en_us


nnoremap <silent> <Leader><Tab> :TagbarToggle<CR>
nnoremap <silent> <F12> :NERDTreeToggle<CR>
nnoremap <F2> :cprev<CR>
nnoremap <F3> :cnext<CR>
nnoremap <F4> :cw<CR>

" BiG key maps
" nnoremap <silent> <Tab> :bn<cr>
" nnoremap <silent> <S-Tab> :bp<cr>
" nnoremap <silent> <Enter> :cn<cr>
" nnoremap <silent> <S-Enter> :cp<cr>
nnoremap <silent> <C-Enter> :e $MYVIMRC<cr>

" Set passive FTP mode
"Plugin 'Decho' " Debug netrw output for FTP edit
let g:netrw_ftp_cmd="ftp -z nossl -p"
let g:netrw_use_errorwindow=0
let g:netrw_silent=1

if !has('gui_running')
  if $TERM == 'xterm-256color'
    set termguicolors
  else
    let g:solarized_termcolors=256
    set t_Co=256
  endif

  set background=dark
  colorscheme lovecraft
end

" CtrlP configuration
let g:ctrlp_cmd = 'CtrlPMRUFiles'

" Tagbar (:TagbarToggle)
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_zoomwidth = 0
let g:tagbar_autoshowtag = 1

" Goldenratio setup (:GoldenRatioToggle and :GoldenRatioResize)
"let g:golden_ratio_exclude_nonmodifiable = 1
"let g:golden_ration_autocommand = 0 " Does not work well atm

" Indent guides (activate with <leader>ig)
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" UltiSnips config
let g:UltiSnipsSnippetsDir =  "~/.vim/ultisnips"
let g:UltiSnipsSnippetDirectories = [ "ultisnips" ]
let g:UltiSnipsExpandTrigger =       "<tab>"
let g:UltiSnipsListSnippets =        "<c-tab>"
let g:UltiSnipsJumpForwardTrigger =  "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


" Log management
function! ShowLog(file)
  botright vnew
  silent execute "%r! tail -100 " . shellescape(expand(a:file))
  setlocal readonly
  setlocal nomodifiable
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nobuflisted
  wincmd p
endfunction

" Reload .vimrc after each save
augroup VimRc
autocmd!
autocmd BufWritePost init.vim :so $MYVIMRC
augroup END

