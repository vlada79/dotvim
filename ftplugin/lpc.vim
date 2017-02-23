" Genesis style LPC
let g:lpc_genesis = 1

" Toggle 'K' help {{{

" Function: IncludeOrInherit(path)
" Description: Attempt to locate path in vim 'path'
"              Useful in include/inherit expressions
function! IncludeOrInherit(path)
    let ret = substitute(a:path, '^/', '', '')
    let fname = fnamemodify(findfile(ret), ':p')
    
    if fname != ''
      return fname
    else
      return ret
    endif
endfunction

" Function: s:previewWindowId()
" Description: Return number of preview window 
"              (specific to current tab)
function! s:previewWindowId()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            return nr
        endif  
    endfor
    return 0
endfun

" Function: s:previewPos()
" Description: Return cursor position in preview window
function! s:previewPos()
    let pwinid = s:previewWindowId()
    if pwinid == 0
        return 0
    endif

    let info = getbufinfo(winbufnr(pwinid))
    return info[0].name . ':' . info[0].lnum
endfun

" Function: ToggleHelp()
" Description: Toggle help in preview window
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
" }}}


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

" Tab behavior {{{

" Function:    LpcTab()
" Description: Smart tab completion
"
"              Context sensitive, uses tab for completion 
"              based on where cursor is
function! LpcTab()
    let l:input = strpart(getline('.'), 0, col('.')-1)
    let l:word = matchstr(l:input, '\<\S*$')

    if strlen(l:word) == 0
        return "\<Tab>"
    endif

    let l:context = synID(line('.'), col('.')-1, 0)

    if l:context != 0
        let l:context = synIDattr(synIDtrans(l:context), 'name')
    endif

    if type(l:context) == type('') && (l:context == 'Comment' || l:context == 'String')
        set complete=k,kspell,s
        return "\<C-N>"
    endif

    return "\<C-X>\<C-O>"
endfunction
" }}}

" Omni completion for LPC {{{
function! LpcFindCompletionStart()
  let l:input = strpart(getline('.'), 0, col('.')-1)

  " Check for include/inherit statemenets 
  let l:regexp =  "^\\s*\\(#\\s*include\\s*[<\"]\\|inherit\\s*\"\\)"
  let l:include_or_inherit = matchstr(l:input, l:regexp) 

  if strlen(l:include_or_inherit) != 0
    return strlen(l:include_or_inherit)
  endif

  let l:word = matchstr(l:input, '\(\<\|(\)\zs[^\s\(]*$')

  if strlen(l:word) == 0
    return -3
  endif

  let l:context = synID(line('.'), col('.')-1, 0)

  if l:context != 0
    let l:context = synIDattr(synIDtrans(l:context), 'name')
  endif

  if type(l:context) == type('') && (l:context == 'Comment' || l:context == 'String')
    return -3
  end

  let l:offset = col('.') - 1 - strlen(l:word)
  let l:has_object = strridx(l:word, "->")

  if l:has_object != -1
    let l:offset += l:has_object
  endif

  return l:offset
endfunction

function! LpcAddDeps(deps, new_deps)
    for l:dep in a:new_deps
        if index(a:deps, l:dep) == -1
            call add(a:deps, l:dep)
        endif
    endfor
endfunction

function! LpcSimulatedEfuns()
  return 'lib/secure/simul_efun.c'
endfunction

function! LpcLocateDeps(filename)
  let l:queue = [ a:filename, LpcSimulatedEfuns() ]
  let l:deps = [ a:filename, LpcSimulatedEfuns() ]
  let l:includes = g:lpc_deps['includes']
  let l:inherits = g:lpc_deps['inherits']

  while len(l:queue) > 0
    let l:current = remove(l:queue, 0)
    let l:inherit = get(l:inherits, l:current)

    if type(l:inherit) == type([]) && len(l:inherit) > 0
      call LpcAddDeps(l:deps, l:inherit)
      call extend(l:queue, l:inherit)
    endif

    let l:include_queue = copy(get(l:includes, l:current))
    if type(l:include_queue) == type([])
      call LpcAddDeps(l:deps, l:include_queue)
      while len(l:include_queue) > 0
        let l:cinclude = remove(l:include_queue, 0)

        let l:included = get(l:includes, l:cinclude)

        if type(l:included) == type([]) && len(l:included) > 0
          call LpcAddDeps(l:deps, l:included)
          call extend(l:include_queue, l:included)
        endif
      endwhile
    endif
  endwhile

  return l:deps
endfunction

function! LpcSourceObject(filename)
  let l:filename = a:filename

  if type(g:lpc_deps) == type({})
    let l:include_map = g:lpc_deps['reversed_includes']
    while get(l:include_map, l:filename, "not found") != "not found"
      let l:filename = l:include_map[l:filename]
    endwhile
  endif

  let l:fname = fnamemodify(l:filename, ':t')
  let l:object = substitute(l:fname, '\.c$', '', '')
  return l:object
endfunction

function! LpcFormatInfo(tag)
  if a:tag["kind"] == 'f'
    let l:cmd = strpart(a:tag['cmd'], 2, strlen(a:tag['cmd'])-4)

    " Extract function declaration
    let l:cmd = substitute(l:cmd, '^.*\<\([a-zA-Z0-9_]*([^)]*)\).*$', '\1', "")
    "let l:cmd = substitute(l:cmd, '()', '', '')
    let l:cmd = substitute(l:cmd, '^\s\+' , '', '')
    let l:cmd = substitute(l:cmd, '\s\s\+', ' ', 'g') " Whitespace squeeze

    return l:cmd
  elseif a:tag["kind"] == 'v'
    let l:cmd = strpart(a:tag['cmd'], 2, strlen(a:tag['cmd'])-4)
    let l:cmd = substitute(l:cmd, '\s\s\+', ' ', 'g') " Whitespace squeeze
    let l:cmd = substitute(l:cmd, ';s*$', '', '') " Remove everything after ';'
    let l:cmd = substitute(l:cmd, '^\s\+' , '', '')
    let l:cmd = substitute(l:cmd, '\\/' , '/', 'g')
    
    return l:cmd
  endif
endfunction

function! LpcCompleteEfuns(word)
  if type(g:lpc_deps) != type({})
    return
  endif

  let l:efuns = keys(g:lpc_deps['efuns'])

  for efun in l:efuns
    if match(l:efun, '\C^.*' . a:word) != -1
      let l:entry = {}
      let l:entry['word'] = l:efun
      let l:entry['kind'] = '[efun]'
      let l:entry['menu'] = g:lpc_deps['efuns'][l:efun]
      
      call complete_add(l:entry)
    endif
  endfor
endfunction

function! LpcCompleteIncludeInherit(word)
  let l:input = strpart(getline('.'), 0, col('.')-1) . a:word

  let l:regexp =  "^\\s*\\(#\\s*include\\s*\\([<\"]\\)\\|inherit\\s*\\(\"\\)\\)\\(\\f*\\)$"
  let l:matched = matchlist(l:input, l:regexp)

  if len(l:matched) == 0
    return 0
  endif

  let l:include = match(l:matched[1], "include") != -1
  let l:lib_match = l:matched[2] == "<"
  let l:incomplete_file = l:matched[4]
  let l:absolute_path = l:incomplete_file[0] == "/"
  let l:buffer_path = expand('%:p:h')
  let l:root = g:lpc_home . 'lib'

  if l:absolute_path
    let l:wildcard = g:lpc_home . 'lib/' . l:incomplete_file . '*'
    let l:relative = g:lpc_home . 'lib/'
    let l:root = l:root . '/'
  elseif l:lib_match
    let l:wildcard = g:lpc_home . 'lib/sys/' . l:incomplete_file . '*'
    let l:relative = g:lpc_home . 'lib/sys/'
  else
    let l:wildcard = l:buffer_path . '/' . l:incomplete_file . '*'
    let l:relative = l:buffer_path . '/'
  endif
  
  let l:dirs = glob(l:wildcard . '/', v:true, v:true)

  for l:dir in l:dirs
    let l:full_path = strpart(l:dir, strlen(l:root), strlen(l:dir) - strlen(l:root))
    let l:path = strpart(l:dir, strlen(l:relative), strlen(l:dir) - strlen(l:relative))
    let l:dirname = split(l:dir, '/')[-1]

    let l:entry = {}
    let l:entry['word'] = l:path
    let l:entry['abbr'] = l:dirname
    let l:entry['kind'] = '[dir]'
    let l:entry['menu'] = l:full_path
    
    call complete_add(l:entry)
  endfor

  if l:include
    let l:wildcard .= '.h'
  else
    let l:wildcard .= '.c'
  end

  let l:files = glob(l:wildcard, v:true, v:true)

  for l:file in l:files
    let l:full_path = strpart(l:file, strlen(l:root), strlen(l:file) - strlen(l:root))
    let l:path = strpart(l:file, strlen(l:relative), strlen(l:file) - strlen(l:relative))
    let l:filename = split(l:file, '/')[-1]

    if l:include
      if l:lib_match
        let l:path = l:path . ">"
      else
        let l:path = l:path . '"'
      endif
    else
      let l:path = substitute(l:path, '\.c$', '', '') . '";'
    endif
    
    let l:entry = {}
    let l:entry['word'] = l:path
    let l:entry['abbr'] = l:filename
    let l:entry['kind'] = '[file]'
    let l:entry['menu'] = l:full_path
    
    call complete_add(l:entry)
  endfor

  return 1
endfunction

function! s:lpcResponseSortFunc(a, b)
  return a:a['priority'] - a:b['priority']
endfunction

function! LpcComplete(word)
  let l:response = []
  let l:all_caps = match(a:word, '\C^[A-Z][A-Z1-9_]\+$') != -1
  let l:buffer_name = fnamemodify(expand('%'), ':p:s?^' . g:lpc_home . '??')
  let l:deps = LpcLocateDeps(l:buffer_name)
  let l:object_complete = stridx(a:word, '->') == 0

  if LpcCompleteIncludeInherit(a:word)
    return 1 " file completion only
  endif

  if l:object_complete
    let l:word = strpart(a:word, 2, strlen(a:word)-2)
  else
    let l:word = a:word
    call LpcCompleteEfuns(l:word)
  endif

  let l:tags = taglist('^.*' . l:word)

  for l:tag in l:tags
    if l:all_caps && l:tag['kind'] == 'd'
      " Complete defines
      let l:tag_file = fnamemodify(l:tag['filename'], ':p:s?^' . g:lpc_home . '??')
      let l:index = index(l:deps, l:tag_file)
      let l:priority = l:index

      let l:wdist = stridx(l:tag['name'], l:word)
      if l:wdist != 0
        let l:priority += 250 + l:wdist
      endif

      let l:entry = {}
      let l:entry['word'] = l:tag['name']
      let l:entry['kind'] = '<' . fnamemodify(l:tag_file, ':t') . '>'
      let l:entry['priority'] = l:priority
      let l:response = add(l:response, l:entry)
    elseif !l:all_caps && l:tag['kind'] != 'd'
      " Complete functions
      let l:tag_file = fnamemodify(l:tag['filename'], ':p:s?^' . g:lpc_home . '??')
      let l:source_file = LpcSourceObject(l:tag_file)
      let l:completion = l:tag['name']

      if l:object_complete
        if l:tag['kind'] == 'f'
          let l:priority = 999
          let l:completion = '->' . l:completion
          let l:source_file = '[' . l:source_file . ']'
          let l:index = 1
        else
          let l:index = -1
        end
      else
        let l:index = index(l:deps, l:tag_file)
        let l:priority = l:index

        if l:tag['kind'] == 'v'
          let l:priority += 500
          let l:source_file = '{' . l:source_file . '}'
        elseif l:tag['kind'] == 'f'
          let l:source_file = '[' . l:source_file . ']'
        endif

        let l:wdist = stridx(l:tag['name'], l:word)
        if l:wdist != 0
          let l:priority += 250 + l:wdist
        endif
      endif

      if l:index != -1
        let l:entry = {}
        let l:entry['word'] = l:completion
        let l:entry['abbr'] = l:tag['name']
        let l:entry['kind'] = l:source_file
        let l:entry['priority'] = l:priority

        let l:entry['menu'] = LpcFormatInfo(l:tag)
        let l:response = add(l:response, l:entry)
      endif
    endif
  endfor

  let l:response = sort(l:response, 's:lpcResponseSortFunc')

  return l:response
endfunction

function! LpcOmniComplete(findstart, base)
  if a:findstart
    return LpcFindCompletionStart()
  else
    return LpcComplete(a:base)
  endif
endfunction

function! LpcLoadDependencies() abort
  if !exists("g:lpc_deps") 
    let l:data = readfile(g:lpc_home . "dependencies.json")
    let l:data = l:data[0]
    let g:lpc_deps = json_decode(l:data)
  endif
endfunction
" }}}

" Load dependencies file
" (needed for completition)
let g:lpc_home = '/home/vlada/genesis/mud/'
call LpcLoadDependencies() 

" Autocomplete
setlocal omnifunc=LpcOmniComplete
setlocal completeopt=menuone,noinsert

" Indenting config
setlocal tw=75
setlocal sw=4 ts=4 sts=4
setlocal noautoindent nosmartindent cindent
setlocal cinoptions=t0,p0

" Grep through different files
command! -buffer -nargs=+ Man vimgrep /<args>/j ~/genesis/mud/lib/doc/man/**/* | cw
command! -buffer -nargs=+ -complete=tag Sman vimgrep /<args>/j ~/genesis/mud/lib/doc/sman/**/* | cw
command! -buffer -nargs=+ -complete=tag Mudlib vimgrep /<args>/j ~/genesis/mud/lib/**/* | cw
command! -buffer -nargs=+ -complete=tag Code vimgrep /<args>/j ~/genesis/mud/lib/w/zilmop/**/* | cw
command! -buffer -nargs=+ -complete=tag Fn ilist /^\S*<args>\S*(/

function! LpcBufferSave(timerid)
  silent! Neomake!
endfunction

augroup Lpc
  autocmd! * <buffer>
  autocmd BufWrite <buffer> call timer_start(250, 'LpcBufferSave')
augroup END

" Make setup (syntax errors)
set makeef=~/genesis/mud/last_error.txt
set makeprg=~/genesis/mud/last_error.rb
set errorformat=%f\ line\ %l:%m

if has('nvim')
  "tnoremap <C-w>h <C-\><C-n><C-w>h
  "tnoremap <C-w>j <C-\><C-n><C-w>j
  "tnoremap <C-w>k <C-\><C-n><C-w>k
  "tnoremap <C-w>l <C-\><C-n><C-w>l

  command! -buffer Genesis :vsplit enew | terminal ~/genesis/mud/connect.sh
endif

" TODO: 
"
" + CleverTab conflicts with UltiSnips
"   - omnifunc for LPC (nicer complete menu, better overal integration)
"     * extract include/inherit data in ruby and save relationships to JSON
"     * json_decode()
"     - perhaps add async completition list population
"
" + Snippets
"   - snippet completition is distinct from tab completion (which is better)
"
" + Build script (LPC)
"   - interobject build dependencies
"   - clone, destruct, delay commands
"   - watch directory
"   - watch objects
"
" + UltiSnips for all objects
"   - somewhat covered (needs more testing)

" indent sane options: -bad -bap -sc -bl -bli0 -cli0 -cbi4 -ss -di4 -i4 -hnl -nbbo -npcs -cs -lpc*

" vim: foldmethod=marker
