
" Project specific config
if expand('%:p') =~? '/suitescripts/'
  " SuiteScripts / NetSuite backend dev
  setlocal sts=4 sw=4 ts=4 et
  retab
  setlocal ff=unix
  "Rvm use 2.5.0@suitetalk
elseif expand('%p') =~? '/sca/'
  " SuiteCommerce Advanced
  setlocal sts=4 sw=4 ts=4 et
  retab
elseif expand('%p') =~? '/dapper/'
  " Dapper IDP
  setlocal sts=2 sw=2 ts=8 et
endif

" ========================
" === JS configuration ===
" ========================

" {{{
" Configure vim-mocha
map <buffer> <Leader>tf :call RunCurrentSpecFile()<CR>
map <buffer> <Leader>ts :call RunNearestSpec()<CR>
let g:mocha_js_command = '!npx mocha --recursive --no-colors {spec}'

" Configure vim for tern
let g:tern_map_keys = 1
"let g:tern_show_argument_hints = 'on_hold'
let g:tern_show_signature_in_pum = 1
let g:tern_request_timeout = 5

" Beautify js (used to make minified files readable)
nnoremap <buffer> <Leader>j :%!js-beautify<CR>
" }}}

" ==============
" === Dapper ===
" ==============

command! -buffer -nargs=+ DapperGrep :vimgrep <q-args> ~/shrm/dapper/app/**/*.js ~/shrm/dapper/*.js


" ============================
" === SuiteScripts goodies ===
" ============================

" Linter
nnoremap <buffer> <Leader>l :silent JSHint <bar> cwindow<CR>

" Collect stack traces produced by NetSuite
setlocal errorformat+=%m(%f:%l)
let g:netsuite_exception_path = "/tmp/netsuite-error.txt"
nnoremap <Leader>n :execute 'cfile ' . g:netsuite_exception_path<CR>

" Xdotool automation
" {{{

" Automate test running in google-chrome (execute runTest() js func)
nnoremap <Plug>XdotoolSelectTarget :call XdotoolSelectTarget()<CR>
nnoremap <Plug>XdotoolRunTest :call XdotoolRunTest()<CR>

nmap <buffer> <Leader>xs <Plug>XdotoolSelectTarget
nmap <buffer> <Leader>xr <Plug>XdotoolRunTest

function! XdotoolRunTest()
  if !executable('xdotool')
    echoerr 'xdotool not found in path'
    return
  endif

  if !exists("g:xdotool_window_target")
    echom "Select target window first"
    return
  endif

  let current_window  = systemlist('xdotool getactivewindow')[0]
  let activate_remote = 
                \ 'windowactivate --sync ' . g:xdotool_window_target . ' '
  let send_keys = 'key --clearmodifiers alt+d ' . 
                \ 'j a v a s c r i p t colon r u n T e s t ' . 
                \ 'parenleft parenright Return'
  let activate_current = 'windowactivate --sync ' . l:current_window . ' '

  call system('xdotool ' . l:activate_remote)
  " Workaround for xdotool layout issue
  call system("xdotool key F20\n xdotool " . l:send_keys)
  call system('xdotool ' . l:activate_current)
endfunction

function! XdotoolSelectTarget()
  if !executable('xdotool')
    echoerr 'xdotool not found in path'
    return
  endif

  let g:xdotool_window_target = systemlist('xdotool selectwindow')[0]
  echom 'Selected window: ' . g:xdotool_window_target
endfunction

" }}}

" Nessie configuration
" {{{
let b:nessie_linter = 'JSHint'
" }}}

" Find references (via vimgrep)
" {{{

" Grep through project source tree
nnoremap <buffer> <Leader>f :call NormalFindReferences()<CR>
vnoremap <buffer> <Leader>f :call VisualFindReferences()<CR>

function! VisualFindReferences()
  let start_pos = getpos("'<")
  let end_pos = getpos("'>")

  " Check if selection is within the same line
  " or if selection is too short (need more than 4 characters)
  if start_pos[1] != end_pos[1] || end_pos[2] - start_pos[2] < 4 
    return
  endif

  let l:word = getline('.')[l:start_pos[2]-1:l:end_pos[2]-1]
  call FindReferencesInProject(l:word)
endfunction

function! NormalFindReferences()
  let word = expand('<cword>')
  call FindReferencesInProject(l:word)
endfunction

function! FindReferencesInProject(word)
  let l:dir = expand('%:p:h')

  if l:dir =~# 'SuiteScripts'
    let l:dir = substitute(l:dir, '\CSuiteScripts.*$', 'SuiteScripts/**/*.js', '')
    execute 'noautocmd vimgrep  ' . '/\C' . a:word . '/j' . ' ' . l:dir
  endif

  if l:dir =~# 'dapper'
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/*.js', '')
    silent! execute 'noautocmd vimgrep ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/app/**/*.js', '')
    silent! execute 'noautocmd vimgrep ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/config/**/*.js', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/env/**/*.json', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/views/**/*.js', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/etc/**/*.js', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/public/**/*.js', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/tasks/**/*.js', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cdapper.*$', 'dapper/test/**/*.js', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
  endif

  cwindow
endfunction
" }}}

" ===================
" === SCA goodies ===
" ===================

" {{{
" Trigger function
map <F4> :call SCAFindReference()<CR>

map <Leader>to :call SCAFindReference()<CR>

" TODO: Refactor this
" TODO: Support templates
" TODO: template syntax hilite / handlebar syntax
function! SCAFindReference()
  " Place current position into jump list
  normal! m`
  let l:startingpos = winsaveview()
  
  " Find function start
  call search('[A-Za-z1-9_.]*')
  normal! b

  if s:runTernDef() 
    return
  endif

  let l:word = expand('<cfile>')
  let l:module = s:findSCAModule(l:word)

  if strlen(l:module) == 0
    " echom "Restore position"
    call winrestview(l:startingpos)
    
    " Attempt tag resolution
    silent! execute "normal! \<C-]>"
  endif
endfunction

" Function:     s:runTernDef
" Description:  RunTernDef command
" Returns:      boolean based on whether lookup was succesful
function! s:runTernDef()
  let l:current_pos = getcurpos()
  silent! execute 'TernDef'
  let l:new_pos = getcurpos()

  return l:new_pos != l:current_pos
endfunction

" Function:     s:findSCAModule()
" Description:  Examine requirejs module definitions at start of file
" Returns:      boolean, whether module was found or not
function! s:findSCAModule(name)
  let l:dotted = substitute(a:name, "\\C[a-zA-Z]\\zs\\ze[A-Z]", "\\\\.\\\\?", 'g')
  let l:module = matchstr(l:dotted, "[a-zA-Z1-9._\\?]*")
  call cursor(1, 1)

  while l:module !=# ''
    " Handle underscore library


    if l:module ==# '_'

      let l:module = 'underscore'
    endif

    " Handle SC golbal namespace in search expr
    let l:search_expr = "[\"']\\s*\\(SC\\.\\)\\?" . l:module . "\\s*[\"']"

    " echom "search expression: " . l:search_expr
    if search(l:search_expr, '', 100) != 0 
      if s:runTernDef()
        break
      else
        call cursor(1, 1)
      endif
    else
      " Remove last .Name from module and retry search
      let l:module = substitute(l:module, '\(^[^.]*$\)\|\(\.[^.]*$\)', '', '')
    endif
  endwhile

  return l:module
endfunction
" }}}

" vim: foldmethod=marker
