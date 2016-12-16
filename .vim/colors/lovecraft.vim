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
let g:colors_name = "lovecraft"

"""" GUI cursor
set guicursor+=n:blinkon10000
set guicursor+=n:blinkoff200
set guicursor+=n:blinkwait5000

"""" GUI 

highlight Cursor        gui=NONE guifg=yellow guibg=darkred
highlight CursorIM      gui=bold guifg=white guibg=PaleTurquoise3
highlight CursorLine    gui=None guibg=#091F22
highlight CursorColumn  gui=None guibg=#091F22
highlight Directory     guifg=LightSeaGreen guibg=bg
highlight DiffAdd       gui=italic guifg=lightgray guibg=#203030
highlight DiffChange    gui=italic guifg=gray guibg=#203030
highlight DiffText      gui=bold guifg=white guibg=#203030
highlight DiffDelete    gui=none guifg=black guibg=#203030
highlight ErrorMsg      guifg=LightYellow guibg=FireBrick
highlight VertSplit     gui=NONE guifg=white guibg=#102020
highlight Folded        gui=bold guibg=#103030 guifg=#b0d0e0
highlight FoldColumn    gui=bold guibg=#103030 guifg=#b0d0e0
highlight IncSearch     gui=reverse guifg=fg guibg=bg
highlight LineNr        gui=bold guibg=#102020 guifg=lightyellow
highlight ModeMsg       gui=bold guibg=black guifg=red
highlight MoreMsg       gui=bold  guifg=SeaGreen4 guibg=bg
highlight NonText       gui=None guibg=bg guifg=lightcyan

highlight Normal        gui=None guibg=#102320 guifg=honeydew2
highlight Question      gui=bold  guifg=SeaGreen2 guibg=bg
highlight Search        gui=NONE guibg=#602020 guifg=NONE
highlight SpecialKey    guibg=bg guifg=#324262
highlight StatusLine    gui=none guibg=black guifg=white
highlight StatusLineNC  gui=none guibg=#101B1B guifg=#707070
highlight Title         gui=none  guifg=MediumOrchid1 guibg=bg
highlight Visual        gui=none guibg=black
"highlight Visual        gui=reverse guibg=WHITE guifg=SeaGreen
highlight VisualNOS     gui=bold,underline guifg=fg guibg=bg
highlight WarningMsg    gui=bold guifg=FireBrick1 guibg=bg
highlight WildMenu      gui=bold guibg=Chartreuse guifg=Black

highlight Comment       gui=italic guifg=#507080
highlight Constant      guifg=cyan3 guibg=bg
highlight String        gui=None guifg=turquoise2 guibg=bg
highlight Number        gui=None guifg=Cyan guibg=bg
highlight Boolean       gui=bold guifg=Cyan guibg=bg
highlight Identifier    guifg=LightSkyBlue3
highlight Function      gui=None guifg=DarkSeaGreen3 guibg=bg

highlight Statement     gui=NONE guifg=LightGreen
highlight Conditional   gui=None guifg=LightGreen guibg=bg
highlight Repeat        gui=None guifg=SeaGreen2 guibg=bg
highlight Operator      gui=None guifg=Chartreuse guibg=bg
highlight Keyword       gui=bold guifg=LightGreen guibg=bg
highlight Exception     gui=bold guifg=LightGreen guibg=bg

highlight PreProc       guifg=SkyBlue1
highlight Include       gui=None guifg=LightSteelBlue3 guibg=bg
highlight Define        gui=None guifg=LightSteelBlue2 guibg=bg
highlight Macro         gui=None guifg=LightSkyBlue3 guibg=bg
highlight PreCondit     gui=None guifg=LightSkyBlue2 guibg=bg

highlight Type          gui=NONE guifg=LightBlue
highlight StorageClass  gui=None guifg=LightBlue guibg=bg
highlight Structure     gui=None guifg=LightBlue guibg=bg
highlight Typedef       gui=None guifg=LightBlue guibg=bg

highlight Special       gui=bold guifg=aquamarine3
highlight Underlined    gui=underline guifg=honeydew4 guibg=bg
highlight Ignore        guifg=#204050
highlight Error         guifg=LightYellow  guibg=FireBrick
highlight Todo          guifg=Cyan guibg=#507080

if v:version >= 700
    highlight PMenu      gui=bold guibg=LightSkyBlue4 guifg=honeydew2
    highlight PMenuSel   gui=bold guibg=DarkGreen guifg=honeydew2
    highlight PMenuSbar  gui=bold guibg=LightSkyBlue4
    highlight PMenuThumb gui=bold guibg=DarkGreen
    highlight SpellBad   gui=undercurl guisp=Red
    highlight SpellRare  gui=undercurl guisp=Orange
    highlight SpellLocal gui=undercurl guisp=Orange
    highlight SpellCap   gui=undercurl guisp=Yellow
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
highlight StatusLine    ctermfg=Blue ctermbg=White
highlight Statement     ctermfg=Yellow cterm=NONE
highlight Type          cterm=NONE
highlight Macro         ctermfg=DarkRed
highlight Identifier    ctermfg=DarkYellow
highlight Structure     ctermfg=DarkGreen
highlight String        ctermfg=DarkCyan

" Status line highlites
highlight User1         gui=none guibg=black guifg=lightyellow
highlight User2         gui=none guibg=black guifg=darkgray
highlight User3         gui=none guibg=black guifg=cyan


" vim: sw=4 ts=4 et
