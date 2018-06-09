" Vim dev map (F11: save, source and go to alternate file)
noremap <buffer> <F11> :w <bar> so % <bar> buffer # <CR>

" Vint as vim linter
setlocal makeprg=~/.local/bin/vint
map <buffer> <Leader>l :write <bar> silent make % <bar> cwindow <CR>

