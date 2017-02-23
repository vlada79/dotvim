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

