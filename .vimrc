"
" Vundle
"
set rtp+=~/.vim/bundle/vundle

filetype off

call vundle#rc()

Bundle 'marik/vundle'

" Classics
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-commentary'
Bundle 'tsaleh/vim-matchit'
Bundle 'godlygeek/tabular'
Bundle 'majutsushi/tagbar'
Bundle 'duff/vim-bufonly'

" Ruby powertools
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/UltiSnips'

" Puppet
Bundle 'rodjek/vim-puppet'

" Coffee
Bundle 'kchmck/vim-coffee-script'

" JSON
Bundle 'elzr/vim-json'

" Git powertools
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'

" Experimental
Bundle 'mattn/webapi-vim'
Bundle 'Figlet.vim'
Bundle 'vim-scripts/CSApprox'
Bundle 'gerw/vim-HiLinkTrace'
Bundle 'vim-scripts/Better-CSS-Syntax-for-Vim'
Bundle 'ap/vim-css-color'
Bundle 'vim-scripts/AnsiEsc.vim'
Bundle 'ctrlp.vim'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-notes'

" Themes
Bundle 'jellybeans.vim'
Bundle 'Solarized'
Bundle 'railscasts'

"
" Setup
"
set langmenu=none

"  Configure GUI
"set guifont=DejaVu_Sans_Mono:h11:cANSI
set guifont=DejaVu\ Sans\ Mono\ 11
set guioptions=Me
set guitablabel=%t
set guicursor=n:blinkwait5000-blinkon10000-blinkoff200

set t_Co=256

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
set nu magic nowrap nocompatible
set nosmartindent nocindent autoindent

" Status line
set laststatus=2
set statusline=%<%1*%t%*\ %20.30(%{&ff}\ %{&fenc}\ %{&ft}%)\ %2*%10.40(%h%w%m%)%*%=(%3*%c%*,%3*%l%*)%3*%5.5p%*%%\ %*

set directory=/tmp
set backupdir=/tmp
set tags=~/shrm/sherman-scraper/coffeetags,~/shrm/tags

set path=.,~/shrm/**/lib/**

filetype plugin on
filetype indent on
syntax on
colorscheme lovecraft

set nospell spelllang=en_us

" Ruby folding stuff (experimental)
function! RubyMethodFoldText()
    let nl = v:foldend - v:foldstart + 1
    let linetext = substitute(getline(v:foldstart),"def","method:",1)
    let txt = linetext . ' ['. nl . ' LoC] '
    return txt
endfunction
set foldtext=RubyMethodFoldText()

function! RubyMethodFold(line)
  let syms2 = map(synstack(a:line, indent(a:line)+1), 'synIDattr(v:val, "name", 0)')
  return !empty(filter(syms2, 'count(["rubyMethodBlock", "rubyDefine"], v:val)>0'))
endfunction

set foldmethod=expr
set foldexpr=RubyMethodFold(v:lnum)
set foldlevelstart=1

" SHRM CMS project specifics
nnoremap <silent> <F6> :TagbarToggle<CR>
nnoremap <F2> :cprev<CR>
nnoremap <F3> :cnext<CR>
nnoremap <F4> :cw<CR>

command! -nargs=+ CoreGrep grep -R <q-args> ~/shrm/sherman-core/lib/sherman-core/ --include=*.rb
command! -nargs=+ ManageGrep grep -R <q-args> ~/shrm/sherman-manage/lib/sherman-manage/ --include=*.rb --include=*.haml
command! -nargs=+ AgentsGrep grep -R <q-args> ~/shrm/sherman-agents/lib/sherman-agents/ --include=*.rb
command! -nargs=+ MossGrep grep -R <q-args> ~/shrm/sherman-moss/ --include=*.rb
command! -nargs=+ UtilsGrep grep -R <q-args> ~/shrm/sherman-utils/ --include=*.rb

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

nnoremap <Leader>sc :call ShowLog('~/shrm/sherman-core/server.log')<CR>
nnoremap <Leader>sm :call ShowLog('~/shrm/sherman-manage/server.log')<CR>
nnoremap <Leader>sa :call ShowLog('~/shrm/sherman-agents/server.log')<CR>
nnoremap <Leader>sp :call ShowLog('~/shrm/apollo/server.log')<CR>

" BiG key maps
" nnoremap <silent> <Tab> :bn<cr>
" nnoremap <silent> <S-Tab> :bp<cr>
" nnoremap <silent> <Enter> :cn<cr>
" nnoremap <silent> <S-Enter> :cp<cr>
nnoremap <silent> <C-Enter> :e $MYVIMRC<cr>

" Reload .vimrc after each save
augroup VimRc
autocmd!
autocmd BufWritePost .vimrc :so $MYVIMRC
augroup END

if !has('gui_running')
  colorscheme solarized
end
