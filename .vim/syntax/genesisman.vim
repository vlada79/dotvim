" Vim syntax file
" Language:	gman page
" Maintainer:	SungHyun Nam <goweol@gmail.com>
" Previous Maintainer:	Gautam H. Mudunuri <gmudunur@informatica.com>
" Version Info:
" Last Change:	2015 Nov 24

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Get the CTRL-H syntax to handle backspaced text
runtime! syntax/ctrlh.vim

syn case match
syn match  gmanTitle	      "^\f\+([0-9]\+[a-z]\=).*"
syn match  gmanSectionHeading  "^\s*[A-Z][A-Z1-9 -]*[A-Z1-9]$"
syn match  gmanOptionDesc      "^\s*[+-][a-z0-9]\S*"
syn match  gmanLongOptionDesc  "^\s*--[a-z0-9-]\S*"
syn match  gmanLine            "^\s*[=-]\+\s*$"
syn match  gmanFunction        "\<[a-zA-Z_][a-zA-Z1-9_]*\ze("
syn match  gmanIncludedFile    "<\f\+>"
syn match  gmanBracketedText   "<[a-z A-Z]\+>"
syn match  gmanDirective       "#[a-zA-Z1-9_]*\>"

" integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	gmanNumbers	display transparent "\<\d\|\.\d" contains=gmanNumber,gmanFloat,gmanOctalError,gmanOctal
syn match	gmanNumbersCom	display contained transparent "\<\d\|\.\d" contains=gmanNumber,gmanFloat,gmanOctal
syn match	gmanNumber	display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
syn match	gmanNumber	display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
syn match	gmanOctal	display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=gmanOctalZero
syn match	gmanOctalZero	display contained "\<0"
syn match	gmanFloat	display contained "\d\+f"
syn match	gmanFloat	display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
syn match	gmanFloat	display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match	gmanFloat	display contained "\d\+e[-+]\=\d\+[fl]\=\>"
syn match	gmanOctalError	display contained "0\o*[89]\d*"
syn case match

" A comment can contain gmanString, gmanCharacter and gmanNumber.
syn match	gmanCommentTitle	contained "Function\s*:"
syn match	gmanCommentTitle	contained "Function name\s*:"
syn match	gmanCommentTitle	contained "Arguments\s*:"
syn match	gmanCommentTitle	contained "Notice\s*:"
syn match	gmanCommentTitle	contained "Returns\s*:"
syn match	gmanCommentTitle	contained "Description\s*:"
syn cluster	gmanCommentGroup	contains=gmanCommentTitle

syntax match	gmanCommentSkip	contained "^\s*\*\($\|\s\+\)"
syntax region gmanCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=gmanSpecial,gmanCommentSkip
syntax region gmanComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=gmanSpecial
syntax region  gmanCommentL	start="//" skip="\\$" end="$" keepend contains=@Spell,@gmanCommentGroup,gmanComment2String,gmanCharacter,gmanNumbersCom,gmanSpaceError
syntax region gmanComment	matchgroup=gmanCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@Spell,@gmanCommentGroup,gmanCommentStartError,gmanCommentString,gmanCharacter,gmanNumbersCom,gmanSpaceError

" keep a // comment separately, it terminates a preproc. conditional
syntax match	gmanCommentError	display "\*/"
syntax match	gmanCommentStartError display "/\*"me=e-1 contained

syn match	gmanSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match	gmanFormat	display "%\(\d\+\)\=[-+ |=#@:.]*\(\d\+\)\=\('\I\+'\|'\I*\\'\I*'\)\=[OsdicoxXf]" contained
syn match	gmanFormat	display "%%" contained
syn region	gmanString	start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=gmanSpecial,gmanFormat

" syn match  gmanHistory		"^[a-z].*last change.*$"

if getline(1) =~ '^[a-zA-Z_]\+([23])'
  syntax include @cCode <sfile>:p:h/c.vim
  syn match gmanCFuncDefinition  display "\<\h\w*\>\s*("me=e-1 contained
  syn region gmanSynopsis start="^SYNOPSIS"hs=s+8 end="^\u\+\s*$"me=e-12 keepend contains=gmanSectionHeading,@cCode,gmanCFuncDefinition
endif


" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link gmanTitle           Title
hi def link gmanSectionHeading  Statement
hi def link gmanOptionDesc      Constant
hi def link gmanLine            PreProc
hi def link gmanLongOptionDesc  Constant
hi def link gmanReference       PreProc
hi def link gmanSubHeading      Function
hi def link gmanCFuncDefinition Function
hi def link gmanNumber		Number
hi def link gmanComment		Comment
hi def link gmanCommentL	Comment
hi def link gmanCommentStart	Comment
hi def link gmanString		String
hi def link gmanFunction        Function
hi def link gmanIncludedFile    String
hi def link gmanBracketedText   String
hi def link gmanDirective       PreProc

let b:current_syntax = "genesisman"

" vim:ts=8 sts=2 sw=2:
