" Vim syntax file
" Language: HandleBars
" Maintainer: Marcell Monteiro Cruz <https://github.com/0000marcell>
" Latest Revision: 26 January 2016
" Version: 0.0.1

if exists("b:current_syntax")
	finish
endif

set isk+=-

" Number 

" Integer with - + or nothing in front
syn match hbsNumber '\d\+'
syn match hbsNumber '[-+]\d\+'

" Floating point number with decimal no E or e
syn match hbsNumber '[-+]\d\+\.\d*'

syn match hbsNumber '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match hbsNumber '\d[[:digit:]]*[eE][\-+]\=\d\+'

" Floating point like number with E and decimal point (+,-)
syn match hbsNumber '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
syn match hbsNumber '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

"syn match hbsComment "#.*$" 

let b:current_syntax = "hbs"

" Region

syn region hbsString   start="'" end="'"
syn region hbsString   start="\"" end="\""

" Match 

syn match hbsSymbols "[<>]"
syn match hbsSymbols "[/]"
syn match hbsSymbols "[{}]"

" Keywords 
syn keyword hbsTag	li h3 h1 offset href img section div class svg width xml x y height style xml inkscape id pagecolor bordercolor
