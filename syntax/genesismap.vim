" Vim syntax file
" Language:     genesis map file
" Maintainer:   Vladimir Mihajlovic
" Version Info:
" Last Change:  2017 Feb 21

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Get the CTRL-H syntax to handle backspaced text
runtime! syntax/ctrlh.vim

syn case match

syn region  gmapMainMap             
      \ start=/\%^/ end=/^::NEWMAP::$/me=s-1 
      \ contains=gmapMainMapName,@gmapMapRooms 
      \ transparent fold keepend

syn region  gmapRoomSection         
      \ start=/^::MAPDATA::$/ end=/^::MAPDATA::$/me=s-1
      \ contained contains=@gmapMapRooms transparent
      \ nextgroup=gmapAsciiSection skipwhite skipempty skipnl keepend

syn region  gmapAsciiSection        
      \ start=/^::MAPDATA::$/ end=/^::NEWMAP::$/me=s-1
      \ contained contains=gmapMapData transparent 
      \ nextgroup=gmapNewSubMap skipwhite skipempty skipnl keepend

syn region  gmapNewSubMap           
      \ start=/^::NEWMAP::$/ end=/^::NEWMAP::$/me=s-1
      \ contains=gmapNewMap,gmapSubMapName transparent
      \ nextgroup=gmapNewSubMap skipwhite skipempty skipnl fold keepend

syn match   gmapMapData             "^::MAPDATA::$" contained
syn match   gmapNewMap              "^::NEWMAP::$" contained

syn match   gmapMapRef              "\<\f\+\>\s*$" contained 
syn match   gmapCoord               "\d\+" contained 
syn match   gmapRoomName            "^\f\+\>" contained 

syn cluster gmapMapRooms            contains=gmapMapData,gmapRoomName,gmapCoord,gmapMapRef 

syn match   gmapSubMapName          "^\f\+\>\s*$" contained nextgroup=gmapRoomSection skipwhite skipempty skipnl
syn match   gmapMainMapName         "^\f\+\>\s*$" contained nextgroup=gmapRoomSection skipwhite skipempty skipnl


" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link gmapMainMapName     String
hi def link gmapSubMapName      Constant
hi def link gmapMapData         Keyword
hi def link gmapNewMap          Keyword
hi def link gmapRoomName        Title
hi def link gmapCoord           Number
hi def link gmapMapRef          Type

let b:current_syntax = "genesismap"

" vim:ts=8 sts=2 sw=2:

