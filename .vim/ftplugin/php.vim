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

  if l:dir =~# 'embark'
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/*.php', '')
    silent! execute 'noautocmd vimgrep ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/app/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/storage/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/config/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/resources/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/routes/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/database/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
    let l:dir = substitute(l:dir, '\Cembark.*$', 'embark/bootstrap/**/*.php', '')
    silent! execute 'noautocmd vimgrepadd ' . '/\C\<' . a:word . '\>/j' . ' ' . l:dir
  endif

  cwindow
endfunction
" }}}

" vim: foldmethod=marker
