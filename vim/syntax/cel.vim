" Vim syntax file
" Language: Celestia Star Catalogs
" Maintainer: Kevin Lauder
" Latest Revision: 26 April 2008

if exists("b:current_syntax")
   finish
endif

syn match celNumber '\d\+'
syn keyword celBlockCmd RA Dec Mass Distance AbsMag nextgroup=celNumber skipwhite

" Integer with - + or nothing in front
syn match celNumber '\d\+'
syn match celNumber '[-+]\d\+'

" Floating point number with decimal no E or e 
syn match celNumber '[-+]\d\+\.\d*'

" Floating point like number with E and no decimal point (+,-)
syn match celNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match celNumber '\d[[:digit:]]*[eE][\-+]\=\d\+'

" Floating point like number with E and decimal point (+,-)
syn match celNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
syn match celNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

syn region celDescBlock start="{" end="}" fold transparent contains=celNumber,celBlockCmd

syn keyword celTodo contained TODO FIXME XXX NOTE
syn match celComment "#.*$" contains=celTodo

let b:current_syntax = "cell"

hi def link celTodo        Todo
hi def link celComment     Comment
hi def link celBlockCmd    Statement
hi def link celHip         Type
hi def link celString      Constant
hi def link celDesc        PreProc
hi def link celNumber      Constant
