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


" Rename identifier in file
" {{{
nnoremap <Leader>r :call <SID>RenameIdentifierInFile()<CR>

" Function:    s:RenameIdentifierInFile
" Description: Substitute word under cursor with another in whole file
function! s:RenameIdentifierInFile()
  let name = expand('<cword>')
  let newName = input('Rename ' . l:name . ' to: ')

  if l:newName == ""
    return
  endif

  execute '%substitute/\C\<' . l:name . '\>/' . l:newName . '/g'
endfunction
" }}}

" Nessie helpers (generic)
" {{{
nnoremap <silent> <Leader>u :call <SID>AsyncNetsuiteUpload()<CR>
command! NetsuiteUpload :call <SID>AsyncNetsuiteUpload()

" Function:    s:AsyncNetsuiteUpload
" Description: Upload file to netsuite
function! s:AsyncNetsuiteUpload()
  write
  if exists("b:nessie_linter")
    execute b:nessie_linter

    if len(getqflist()) > 0
      cwindow
      return
    endif
  endif

  let nessie_cmd = 'nessie upload %:p --client'
  let post_cmd = "echom\\ \'Script\\ upload\\ complete.\'"
  "let post_cmd = fnameescape(l:post_cmd)
  execute 'AsyncRun -post=' . l:post_cmd . ' ' . l:nessie_cmd
endfunction
" }}}

" vim: foldmethod=marker

