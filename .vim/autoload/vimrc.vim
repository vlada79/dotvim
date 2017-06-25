" Log management (should be obsolete with new async methods in vim8.0)
function! vimrc#ShowLog(file)
  botright vnew
  silent execute "%r! tail -100 " . shellescape(expand(a:file))
  setlocal readonly
  setlocal nomodifiable
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nobuflisted
  wincmd p
endfunction

" Function:    VimwikiLinkHandler
" Description: handle vfile:// url - open file or dir locally in vim
" Argument:    string link - url to resolve
" Returns:     0/1 - whether the link has been handled by function
function! VimwikiLinkHandler(link)
  let link = a:link
  if link =~# '^vfile:'
    let link = expand(link[6:])
  else
    return 0
  endif

  if !isdirectory(link) && !filereadable(link)
    echomsg 'Vimwiki Error: Unable to resolve link!'
    return 0
  endif

  if isdirectory(link)
    execute 'NERDTree ' . fnameescape(link)
  else
    execute 'edit ' . fnameescape(link)
  endif
  return 1
endfunction



