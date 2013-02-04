" Vim color file
" Maintainer: Vlada
" Last Change:
"
" 2011-08-27 change by Vlada
"  - thematic adjustments
"
" 2007-10-16 change by Alexei Alexandrov
" - highlight CursorColumn
"
" 2007-08-20 change by Diederick Niehorster
" - highlight CursorLine
"
" 2007-02-05
" - included changes from Keffin Barnaby
"   (vim>=7.0 PMenu and Spellchecking)
"
" 2006-09-06
" - changed String to DarkCyan, Macro to DarkRed
"
" 2006-09-05
" - more console-colors
" - added console-colors, clean-up
"
" Version: 1.2.5
" URL: http://vim.sourceforge.net/script.php?script_id=368

""" Init
set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "lovecraft2"

"""" GUI cursor
set guicursor+=n:blinkon10000
set guicursor+=n:blinkoff200
set guicursor+=n:blinkwait5000

"""" GUI 

highlight Cursor        gui=NONE guifg=#FFFF00 ctermfg=11 guibg=#B80000 ctermbg=124
highlight CursorIM      gui=bold guifg=#FFFFFF ctermfg=15 guibg=#69DCDC ctermbg=80
highlight CursorLine    gui=None guibg=#091F22 ctermbg=234
highlight CursorColumn  gui=None guibg=#091F22 ctermbg=234
highlight Directory     guifg=#022BAA ctermfg=19 guibg=bg
highlight DiffAdd       gui=italic guifg=#3D3D3D ctermfg=237 guibg=#203030 ctermbg=235
highlight DiffChange    gui=italic guifg=#EBEBEB ctermfg=7 guibg=#203030 ctermbg=235
highlight DiffText      gui=bold guifg=#FFFFFF ctermfg=15 guibg=#203030 ctermbg=235
highlight DiffDelete    gui=none guifg=#000000 ctermfg=0 guibg=#203030 ctermbg=235
highlight ErrorMsg      guifg=#FFFF0E ctermfg=11 guibg=#2B2222 ctermbg=235
highlight VertSplit     gui=NONE guifg=#FFFFFF ctermfg=15 guibg=#102020 ctermbg=234
highlight Folded        gui=bold guibg=#103030 ctermbg=235 guifg=#b0d0e0 ctermfg=152
highlight FoldColumn    gui=bold guibg=#103030 ctermbg=235 guifg=#b0d0e0 ctermfg=152
highlight IncSearch     gui=reverse guifg=fg guibg=bg
highlight LineNr        gui=bold guibg=#102020 ctermbg=234 guifg=#FFFF0E ctermfg=11
highlight ModeMsg       gui=bold guibg=#000000 ctermbg=0 guifg=#FF0000 ctermfg=9
highlight MoreMsg       gui=bold  guifg=#E2B875 ctermfg=180 guibg=bg
highlight NonText       gui=None guibg=bg guifg=#0EFFFF ctermfg=14

highlight Normal        gui=None guibg=#102320 ctermbg=234 guifg=#0EEE0E ctermfg=10
highlight Question      gui=bold  guifg=#E4EE49 ctermfg=191 guibg=bg
highlight Search        gui=NONE guibg=#602020 ctermbg=52 guifg=NONE
highlight SpecialKey    guibg=bg guifg=#324262 ctermfg=238
highlight StatusLine    gui=none guibg=#000000 ctermbg=0 guifg=#FFFFFF ctermfg=15
highlight StatusLineNC  gui=none guibg=#101B1B ctermbg=234 guifg=#707070 ctermfg=242
highlight Title         gui=none  guifg=#0E66FF ctermfg=27 guibg=bg
highlight Visual        gui=none guibg=#000000 ctermbg=0
"highlight Visual        gui=reverse guibg=#FFFFFF ctermbg=15 guifg=#E2B875 ctermfg=180
highlight VisualNOS     gui=bold,underline guifg=fg guibg=bg
highlight WarningMsg    gui=bold guifg=#FF0303 ctermfg=9 guibg=bg
highlight WildMenu      gui=bold guibg=#F7FF00 ctermbg=11 guifg=#000000 ctermfg=0

highlight Comment       gui=italic guifg=#507080 ctermfg=60
highlight Constant      guifg=#00DCDC ctermfg=44 guibg=bg
highlight String        gui=None guifg=#005EEE ctermfg=27 guibg=bg
highlight Number        gui=None guifg=#00FFFF ctermfg=14 guibg=bg
highlight Boolean       gui=bold guifg=#00FFFF ctermfg=14 guibg=bg
highlight Identifier    guifg=#D86BDC ctermfg=170
highlight Function      gui=None guifg=#B9DCB9 ctermfg=151 guibg=bg

highlight Statement     gui=NONE guifg=#09EE09 ctermfg=10
highlight Conditional   gui=None guifg=#09EE09 ctermfg=10 guibg=bg
highlight Repeat        gui=None guifg=#E4EE49 ctermfg=191 guibg=bg
highlight Operator      gui=None guifg=#F7FF00 ctermfg=11 guibg=bg
highlight Keyword       gui=bold guifg=#09EE09 ctermfg=10 guibg=bg
highlight Exception     gui=bold guifg=#09EE09 ctermfg=10 guibg=bg

highlight PreProc       guifg=#78ECFF ctermfg=123
highlight Include       gui=None guifg=#2A5BDC ctermfg=26 guibg=bg
highlight Define        gui=None guifg=#CB2DEE ctermfg=165 guibg=bg
highlight Macro         gui=None guifg=#D86BDC ctermfg=170 guibg=bg
highlight PreCondit     gui=None guifg=#4A3DEE ctermfg=12 guibg=bg

highlight Type          gui=NONE guifg=#DA8D6E ctermfg=173
highlight StorageClass  gui=None guifg=#DA8D6E ctermfg=173 guibg=bg
highlight Structure     gui=None guifg=#DA8D6E ctermfg=173 guibg=bg
highlight Typedef       gui=None guifg=#DA8D6E ctermfg=173 guibg=bg

highlight Special       gui=bold guifg=#66DCAA ctermfg=79
highlight Underlined    gui=underline guifg=#38B838 ctermfg=71 guibg=bg
highlight Ignore        guifg=#204050 ctermfg=237
highlight Error         guifg=#FFFF0E ctermfg=11  guibg=#2B2222 ctermbg=235
highlight Todo          guifg=#00FFFF ctermfg=14 guibg=#507080 ctermbg=60
if v:version >= 700
    highlight PMenu      gui=bold guibg=#06B7B8 ctermbg=37 guifg=#0EEE0E ctermfg=10
    highlight PMenuSel   gui=bold guibg=#004600 ctermbg=22 guifg=#0EEE0E ctermfg=10
    highlight PMenuSbar  gui=bold guibg=#06B7B8 ctermbg=37
    highlight PMenuThumb gui=bold guibg=#004600 ctermbg=22
    highlight SpellBad   gui=undercurl guisp=#FF0000
    highlight SpellRare  gui=undercurl guisp=#FF5A00
    highlight SpellLocal gui=undercurl guisp=#FF5A00
    highlight SpellCap   gui=undercurl guisp=#FFFF00
endif



""" Console
if v:version >= 700
    highlight PMenu      cterm=bold ctermbg=DarkGreen ctermfg=Gray
    highlight PMenuSel   cterm=bold ctermbg=Yellow ctermfg=Gray
    highlight PMenuSbar  cterm=bold ctermbg=DarkGreen
    highlight PMenuThumb cterm=bold ctermbg=Yellow
    highlight SpellBad   ctermbg=Red
    highlight SpellRare  ctermbg=Red
    highlight SpellLocal ctermbg=Red
    highlight SpellCap   ctermbg=Yellow
endif

highlight Normal        ctermfg=Gray ctermbg=None
highlight Search        ctermfg=Black ctermbg=Red cterm=NONE
highlight Visual        cterm=reverse
highlight Cursor        ctermfg=Black ctermbg=Green cterm=bold
highlight Special       ctermfg=Brown
highlight Comment       ctermfg=DarkGray
highlight Statement     ctermfg=Yellow cterm=NONE
highlight Type          cterm=NONE
highlight Macro         ctermfg=DarkRed
highlight Identifier    ctermfg=DarkYellow
highlight Structure     ctermfg=DarkGreen
highlight String        ctermfg=DarkCyan

" Status line highlites
highlight User1         gui=none guibg=#000000 ctermbg=0 guifg=#FFFF0E ctermfg=11
highlight User2         gui=none guibg=#000000 ctermbg=0 guifg=#9A9A9A ctermfg=247
highlight User3         gui=none guibg=#000000 ctermbg=0 guifg=#00FFFF ctermfg=14

" vim: sw=4 ts=4 et
