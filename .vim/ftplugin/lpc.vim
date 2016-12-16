setlocal sw=4 tw=78 omnifunc=syntaxcomplete#Complete

" LPC style
let g:lpc_genesis = 1

function! IncludeOrInherit(path)
    let ret = substitute(a:path, '^/', '', '')
    let fname = fnamemodify(findfile(ret), ':p')
    
    if fname != ''
      return fname
    else
      return ret
    endif

endfunction

function! s:previewWindowId()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            return nr
        endif  
    endfor
    return 0
endfun

function! s:previewPos()
    let pwinid = s:previewWindowId()
    if pwinid == 0
        return 0
    endif

    let info = getbufinfo(winbufnr(pwinid))
    return info[0].name . ':' . info[0].lnum
endfun

if !exists("*ToggleHelp")
  function! ToggleHelp()
    let cword = expand('<cword>')
    let cword = substitute(cword, '\.$', '', '')
    let file = findfile(cword)
    let pid = s:previewWindowId()

    if file != ''
      execute 'pclose'
      execute 'pedit +set\ ft=man ' . file 
    else
      try
        execute 'pclose'
        execute 'psearch /^\C' . cword . '('
      catch
        try
          execute 'pclose'
          if match(cword, '^\C[A-Z_]\+$') != -1
            execute 'psearch /\C^\s*#\s*define\s*' . cword 
          endif
        catch
          execute 'pclose'
        endtry
      endtry
    endif

    if pid != 0 
      " If preview window is showing current buffer - close it
      let currBuf = bufnr('%') == winbufnr(pid) && pid != win_getid()

      if currBuf
          execute 'pclose'
      endif
    endif
  endfunction
endif

function! ShowMethod()
  execute 'ijump /^\C' . expand('<cword>') . '('
endfunction

setlocal includeexpr=IncludeOrInherit(v:fname)
setlocal include=^\\s*\\(#\\s*include\\\\|inherit\\)

setlocal suffixesadd+=.c

set complete=.,d,i,t

setlocal tags=~/genesis/mud/tags

set path=.,~/genesis/mud/lib,~/genesis/mud/lib/sys
set path+=~/genesis/mud/lib/doc/man/**

" Remap man page help
nnoremap <silent> K :call ToggleHelp()<CR>
nnoremap <silent> <C-K> :silent! :call ShowMethod()<CR>

setlocal previewheight=25

" Tagbar config
let g:tagbar_type_lpc = {
            \ 'ctagstype' : 'c',
            \ 'kinds'     : [
            \ 'd:defines:0',
            \ 'v:variables:0',
            \ 'f:functions:0',
            \ ]
            \ }

