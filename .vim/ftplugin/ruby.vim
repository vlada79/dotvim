" My Ruby goodies

" Ruby folding stuff (experimental)
function! RubyMethodFoldText()
    let nl = v:foldend - v:foldstart + 1
    let linetext = substitute(getline(v:foldstart),"def","method:",1)
    let txt = linetext . ' ['. nl . ' LoC] '
    return txt
endfunction
setlocal foldtext=RubyMethodFoldText()

function! RubyMethodFold(line)
  let syms2 = map(synstack(a:line, indent(a:line)+1), 'synIDattr(v:val, "name", 0)')
  return !empty(filter(syms2, 'count(["rubyMethodBlock", "rubyDefine"], v:val)>0'))
endfunction

setlocal foldmethod=expr
setlocal foldexpr=RubyMethodFold(v:lnum)
setlocal foldlevelstart=1
setlocal nofoldenable

" Ripper ctags/tagbar
if executable('ripper-tags')
  let g:tagbar_type_ruby = {
      \ 'kinds'      : ['m:modules',
                      \ 'c:classes',
                      \ 'C:constants',
                      \ 'F:singleton methods',
                      \ 'f:methods',
                      \ 'a:aliases'],
      \ 'kind2scope' : { 'c' : 'class',
                       \ 'm' : 'class' },
      \ 'scope2kind' : { 'class' : 'c' },
      \ 'ctagsbin'   : 'ripper-tags',
      \ 'ctagsargs'  : ['-f', '-']
      \ }
endif

" Run ruby -c as linter
setlocal makeprg=ruby\ -c
map <buffer> <Leader>l :write <bar> silent make % <bar> cwindow <CR>

" Split-joins
nnoremap <buffer> <Leader>j :SplitjoinJoin<cr>
nnoremap <buffer> <Leader>s :SplitjoinSplit<cr>

"execute "Rvm use 2.5.0@suitetalk"
