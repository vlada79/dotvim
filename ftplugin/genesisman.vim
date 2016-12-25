" Vim syntax file
" Language:	Genesis man pages

" Tagbar config (Show man ToC in Tagbar)
" Somewhat hackish, but still neat to have in editor
let g:tagbar_type_genesisman = {
            \ 'ctagstype' : 'genesisman',
            \ 'ctagsbin' : 'cat',
            \ 'ctagsargs' : '~/genesis/mud/tags.man',
            \ 'kinds'     : [
            \   'd:definitions:1',
            \   'e:efuns:1',
            \   'f:formulas:1',
            \   'g:general:1',
            \   'i:intermud:1',
            \   'l:lfun:1',
            \   'o:objects:1',
            \   'p:properties:1',
            \   's:simulated efuns:1',
            \   'u:soul:1',
            \   't:tutorial:1',
            \ ],
            \ }

setlocal tags=~/genesis/mud/tags.man

