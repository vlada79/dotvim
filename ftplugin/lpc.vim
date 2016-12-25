" Genesis style LPC
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
      execute 'pedit +set\ ft=genesisman ' . file 
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

" Function: s:showMethod()
"
" Jump to first method defined in list of
" included files (included + inherited)
if !exists("*s:showMethod")
  function! s:showMethod()
    execute 'ijump /^\C' . expand('<cword>') . '('
  endfunction
endif
" Follow both #include and inherit statements
setlocal includeexpr=IncludeOrInherit(v:fname)
setlocal include=^\\s*\\(#\\s*include\\\\|inherit\\)

setlocal suffixesadd+=.c

set complete=.,d,i,t

setlocal tags=~/genesis/mud/tags

set path=.,~/genesis/mud/lib,~/genesis/mud/lib/sys
set path+=~/genesis/mud/lib/doc/man/**

" Remap man page help
nnoremap <silent> K :call ToggleHelp()<CR>
"nnoremap <silent> <C-K> :silent! :call <SID>showMethod()<CR>
nnoremap <C-K> :call <SID>showMethod()<CR>

setlocal previewheight=25

" Tagbar config
let g:tagbar_type_lpc = {
  \ 'ctagstype' : 'c',
  \ 'kinds'     : [
  \   'd:defines:0',
  \   'v:variables:0',
  \   'f:functions:0',
  \ ]
  \ }

" Smart tab completion
"
" Context sensitive, uses tab for completion 
" based on where cursor is
function! CleverTab()
    messages clear

    let l:input = strpart(getline('.'), 0, col('.')-1)
    let l:word = matchstr(l:input, '\<\S*$')

    if strlen(l:word) == 0
        return "\<Tab>"
    endif

    let l:context = synID(line('.'), col('.')-1, 0)

    if l:context != 0
        let l:context = synIDattr((synIDtrans(l:context)), 'name')
    endif

    echom 'Context: ' . l:context
    if l:context != 0 && (l:context == 'Comment' || l:context == 'String')
        echom 'Seems like comment or string'
        set complete=k,kspell,s
    else
        let l:has_object = strridx(l:word, "->")

        echom 'Not comment or string'
        if l:has_object != -1
            "let l:word = strpart(l:word, l:has_object+2)
            set complete=t
        else
            set complete=i,d,.,k~/.vim/words/lpc.txt
        endif
    endif

    "set complete?
    "return "\<C-o>:messages\<CR>"
    return "\<C-N>"
endfunction

"imap <Tab> <C-R>=CleverTab()<CR>
setlocal omnifunc=syntaxcomplete#Complete
setlocal completeopt=menuone,noinsert

" Indenting config
setlocal tw=75
setlocal sw=4 ts=4
setlocal noautoindent nosmartindent cindent
setlocal cinoptions=t0,p0

" Grep through different files
command! -buffer -nargs=+ Man vimgrep /<args>/j ~/genesis/mud/lib/doc/man/**/* | cw
command! -buffer -nargs=+ -complete=tag Sman vimgrep /<args>/j ~/genesis/mud/lib/doc/sman/**/* | cw
command! -buffer -nargs=+ -complete=tag Mudlib vimgrep /<args>/j ~/genesis/mud/lib/**/* | cw
command! -buffer -nargs=+ -complete=tag Code vimgrep /<args>/j ~/genesis/mud/lib/w/zilmop/**/* | cw
command! -buffer -nargs=+ -complete=tag Fn ilist /^\S*<args>\S*(/

if has('nvim')
  "tnoremap <C-w>h <C-\><C-n><C-w>h
  "tnoremap <C-w>j <C-\><C-n><C-w>j
  "tnoremap <C-w>k <C-\><C-n><C-w>k
  "tnoremap <C-w>l <C-\><C-n><C-w>l

  command! -buffer Genesis :split enew | terminal ~/genesis/mud/connect.sh
endif

" TODO: 
"
" - CleverTab conflicts with UltiSnips
"   - omnifunc for LPC (nicer complete menu, better overal integration)
"     * extract include/inherit data in ruby and save relationships to JSON
"     * json_decode()
" - Snippets
" - Build script (LPC)

" indent sane options: -bad -bap -sc -bl -bli0 -cli0 -cbi4 -ss -di4 -i4 -hnl -nbbo -npcs -cs -lpc*
