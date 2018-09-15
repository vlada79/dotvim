"
" Vundle
"
set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim

filetype off

call vundle#begin()

" Let Vundle manage itself
Plugin 'VundleVim/Vundle.vim'

" Classics
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-obsession' 

" Autoformat
Plugin 'Chiel92/vim-autoformat'

" Diffs
Plugin 'chrisbra/vim-diff-enhanced'

" CSV support
Plugin 'chrisbra/csv.vim'

"Plugin 'duff/vim-bufonly'
Plugin 'neomake/neomake'

" Undo visualisation
Plugin 'sjl/gundo.vim'

" Ruby powertools
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rvm'
Plugin 'noprompt/vim-yardoc'
Plugin 'AndrewRadev/splitjoin.vim' " gJ / gS

" Python
Plugin 'klen/python-mode'
Plugin 'glench/vim-jinja2-syntax'

" Javascript
" (check config in ~/.vim/ftplugin/javascript.vim)
Plugin 'vim-node'
Plugin 'sidorares/node-vim-debugger'
Plugin 'ternjs/tern_for_vim'
Plugin 'jshint.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'geekjuice/vim-mocha'

" Log file syntax
Plugin 'dzeban/vim-log-syntax'

" JSON
Plugin 'tpope/vim-jdaddy' " JSON pretty print and JSON text objects
Plugin 'elzr/vim-json'

" HTML/CSS
Plugin 'mattn/emmet-vim' " Yet to test it out
Plugin 'vim-scripts/Better-CSS-Syntax-for-Vim'
Plugin 'ap/vim-css-color'

" Handlebars/mustache templates
Plugin 'vlada79/vim-mustache-handlebars'

" Git powertools
Plugin 'tpope/vim-fugitive' " Git helper
Plugin 'tpope/vim-rhubarb' " Github helpers
Plugin 'tpope/vim-git' " :DiffGitCached

" Colorscheme tools
Plugin 'xterm-color-table.vim'
Plugin 'vim-scripts/CSApprox'
Plugin 'gerw/vim-HiLinkTrace'
Plugin 'chrisbra/Colorizer' " Show color codes & colornames

" Themes
Plugin 'jellybeans.vim'
Plugin 'Solarized'
Plugin 'railscasts'

" Coding eyecandy
Plugin 'nathanaelkane/vim-indent-guides'

" Thesaurus plugin (:Thesaurus, <Leader>cs)
Plugin 'Ron89/thesaurus_query.vim'

" Productivity tools
Plugin 'ctrlp.vim'
Plugin 'The-NERD-tree'
Plugin 'SirVer/ultisnips'
Plugin 'skywind3000/asyncrun.vim'

" Org tools
Plugin 'vimwiki'
Plugin 'blindFS/vim-taskwarrior'
"Plugin 'tbabej/taskwiki'

" Ascii Art
Plugin 'DrawIt'
Plugin 'fadein/Figlet.vim'
Plugin 'godlygeek/tabular'
Plugin 'vim-scripts/AnsiEsc.vim'

" Code navigation through tags/cscope
Plugin 'hari-rangarajan/CCTree'
Plugin 'majutsushi/tagbar'
Plugin 'tomtom/quickfixsigns_vim'

call vundle#end()

" Enable matchit for ruby do ... end
runtime macros/matchit.vim

filetype plugin on
filetype indent on

"
" Setup
"
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

set concealcursor=c

" Status line
set laststatus=2

" Status line for Lovecraft scheme 
" (relies on User1, User2, User3 and User 4 highlight groups)
set statusline=%<%1*%t%*\ %20.50(%{&ff}\ %{&fenc}\ %{&ft}\ %4*%{fugitive#head()}%*%)%2*%10.40(%h%w%m%)%*%=(%3*%c%*,%3*%l%*)%3*%5.5p%*%%\ %*

" Colorless statusline
"set statusline=%<%t\ %20.30(%{&ff}\ %{&fenc}\ %{&ft}%)\ %10.40(%h%w%m%)%=(%c,%l)%5.5p%%\ 

set directory=/tmp
set backupdir=/tmp
set tags=./tags;$HOME

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

set undofile
set undodir=~/.vim/undodir

syntax on
colorscheme lovecraft

set nospell spelllang=en_us

nnoremap <silent> <F2>    :cprev<CR>
nnoremap <silent> <F3>    :cnext<CR>
nnoremap <silent> <F4>    :cw<CR>
nnoremap <silent> <F5>    :silent! make! <bar> redraw!<CR>

" BiG key maps
let mapleader=" "
nnoremap <silent> <C-Enter> :e $MYVIMRC<cr>
nnoremap <silent> <Leader>vim :e $MYVIMRC<cr>

" Remap up/down keys when popup menu appears
inoremap <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
inoremap <expr><C-u> pumvisible() ? "\<PageUp>"   : "\<C-u>"
inoremap <expr><C-j> pumvisible() ? "\<Down>"     : "\<C-j>"
inoremap <expr><C-k> pumvisible() ? "\<Up>"       : "\<C-k>"

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

" NERDTree configuration
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1

" NERDTree toggle
nnoremap <silent> <F12> :NERDTreeToggle<CR>
nnoremap <silent><expr> <Leader><Tab> exists('t:NERDTreeBufName') ? (expand('%') != t:NERDTreeBufName ? ":NERDTreeFind<CR>" : ":NERDTreeClose<CR>" ) : ":NERDTreeFind<CR>"

" CtrlP configuration
let g:ctrlp_cmd = 'CtrlPMRUFiles'

" Tagbar (:TagbarToggle)
let g:tagbar_autoclose   = 1
let g:tagbar_autofocus   = 1
let g:tagbar_zoomwidth   = 0
let g:tagbar_autoshowtag = 1

" Tagbar toggle
nnoremap <silent> <Leader><CR>  :TagbarToggle<CR>

" Goldenratio setup (:GoldenRatioToggle and :GoldenRatioResize)
"let g:golden_ratio_exclude_nonmodifiable = 1
"let g:golden_ration_autocommand = 0 " Does not work well atm

" Vimwiki config
let g:vimwiki_listsyms = ' .oOX'
let g:vimwiki_hl_headers = 1
let s:default_wiki = {}
let s:default_wiki.path = '~/.notes/'
let g:vimwiki_list = [s:default_wiki]

" Indent guides (activate with <leader>ig)
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Autocompletion
inoremap <expr><C-Space> '<C-x><C-o>'

" UltiSnips config
let g:UltiSnipsSnippetsDir         = "~/.vim/ultisnips"
let g:UltiSnipsSnippetDirectories  = [ "ultisnips" ]
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsListSnippets        = "<c-tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Gundo setup
let g:gundo_prefer_python3 = 1
nnoremap <Leader>` :GundoToggle<CR>

" Quickfixsign config
set signcolumn=auto
let g:quickfixsigns_classes = [ 'qfl' ]
let g:quickfixsigns_use_dummy = 0
"sign define QFS_QFL icon= text=☢✗ texthl=Cursor
sign define QFS_QFL icon= text=⚡ texthl=Cursor
nnoremap <Backspace> :QuickfixsignsToggle<CR>

" Load vimrc functions
runtime autoload/vimrc.vim

" Reload .vimrc after each save
augroup VimRc
autocmd!
autocmd BufWritePost .vimrc :so $MYVIMRC
augroup END

