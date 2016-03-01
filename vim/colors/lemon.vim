set background=light
highlight clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "Lemon"

highlight Normal ctermfg=155 ctermbg=NONE 
highlight LineNr ctermfg=darkgreen
highlight Visual ctermbg=blue

" Syntax JavaScript 
highlight javaScriptString ctermfg=22 cterm=underline
highlight javaScriptParens ctermfg=82
highlight javaScriptBraces ctermfg=82
highlight javaScriptIdentifier ctermfg=46
highlight javaScriptEndColons ctermfg=82 ctermbg=22
highlight javaScriptConditional ctermfg=42
highlight javaScriptLabel cterm=italic ctermfg=green
highlight javaScriptReserved ctermfg=84
highlight javaScriptGlobalObjects ctermfg=10
highlight javaScriptNumber ctermbg=darkgreen ctermfg=black
highlight javaScriptOpSymbols ctermfg=64
highlight javaScriptBoolean ctermbg=73 ctermfg=16

" Syntax Ruby
highlight rubyString ctermfg=22 cterm=underline
highlight rubyInstanceVariable ctermfg=42
highlight rubyComment ctermbg=42 ctermfg=0
highlight rubyDefine ctermfg=46
highlight rubySymbol ctermfg=77
highlight rubyInterpolationDelimiter ctermfg=0 ctermbg=82
highlight rubyBoolean ctermfg=46
highlight rubyInclude ctermfg=112
highlight rubyPseudoVariable ctermfg=148 





" Syntax HandleBars 

highlight hbsNumber ctermfg=22 
highlight hbsTag ctermfg=46 
highlight hbsString ctermbg=70
highlight hbsSymbols ctermbg=23
