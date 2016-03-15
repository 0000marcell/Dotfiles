" Vim color file - inkpot_modified
" Generated by http://bytefluent.com/vivify 2016-03-10
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "inkpot_modified"

"hi SignColumn -- no settings --
"hi TabLineSel -- no settings --
"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
"hi Ignore -- no settings --
hi Normal ctermfg=179 cterm=NONE
"hi CTagsImport -- no settings --
"hi CTagsGlobalVariable -- no settings --
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
"hi CursorLine -- no settings --
"hi Union -- no settings --
"hi TabLineFill -- no settings --
"hi VisualNOS -- no settings --
"hi CursorColumn -- no settings --
"hi EnumerationName -- no settings --
"hi SpellCap -- no settings --
"hi SpellLocal -- no settings --
"hi DefinedName -- no settings --
"hi LocalVariable -- no settings --
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
"hi TabLine -- no settings --
"hi clear -- no settings --
hi IncSearch guifg=#301730 guibg=#cdc9c7 guisp=#cdc9c7 gui=NONE ctermfg=236 ctermbg=252 cterm=NONE
hi WildMenu guifg=#ee77ee guibg=#1717af guisp=#1717af gui=NONE ctermfg=213 ctermbg=19 cterm=NONE
hi SpecialComment guifg=#ab17d0 guibg=NONE guisp=NONE gui=NONE ctermfg=10 ctermbg=NONE cterm=NONE
hi Typedef guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Title guifg=#afa3a3 guibg=NONE guisp=NONE gui=NONE ctermfg=138 ctermbg=NONE cterm=NONE
hi Folded guifg=#cfcf65 guibg=#79698f guisp=#79698f gui=NONE ctermfg=185 ctermbg=60 cterm=NONE
hi PreCondit guifg=#899090 guibg=NONE guisp=NONE gui=NONE ctermfg=246 ctermbg=NONE cterm=NONE
hi Include guifg=#899090 guibg=NONE guisp=NONE gui=NONE ctermfg=246 ctermbg=NONE cterm=NONE
hi StatusLineNC guifg=#b95bb9 guibg=#0f0f5e guisp=#0f0f5e gui=NONE ctermfg=133 ctermbg=17 cterm=NONE
hi NonText guifg=#2323cd guibg=NONE guisp=NONE gui=NONE ctermfg=20 ctermbg=NONE cterm=NONE
hi DiffText guifg=#ffff4b guibg=#4a074a guisp=#4a074a gui=NONE ctermfg=227 ctermbg=53 cterm=NONE
hi ErrorMsg guifg=#ff7dff guibg=#ceb3b3 guisp=#ceb3b3 gui=NONE ctermfg=213 ctermbg=181 cterm=NONE
hi Debug guifg=#ab17d0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=#ee77ee guibg=#1717af guisp=#1717af gui=NONE ctermfg=213 ctermbg=19 cterm=NONE
hi Identifier guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#ab17d0 guibg=#402140 guisp=#402140 gui=NONE ctermfg=128 ctermbg=238 cterm=NONE
hi Conditional guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi StorageClass guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Todo guifg=#301730 guibg=#d0ccc7 guisp=#d0ccc7 gui=NONE ctermfg=236 ctermbg=252 cterm=NONE
hi Special guifg=#ab17d0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi LineNr guifg=#2323cd guibg=#2e152e guisp=#2e152e gui=NONE ctermfg=20 ctermbg=236 cterm=NONE
hi StatusLine guifg=#b95bb9 guibg=#0f0f5e guisp=#0f0f5e gui=NONE ctermfg=133 ctermbg=17 cterm=NONE
hi Label guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi PMenuSel guifg=#ee77ee guibg=#10103f guisp=#10103f gui=NONE ctermfg=213 ctermbg=17 cterm=NONE
hi Search guifg=#301730 guibg=#cdc9c7 guisp=#cdc9c7 gui=NONE ctermfg=236 ctermbg=252 cterm=NONE
hi Delimiter guifg=#ab17d0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi Statement guifg=#0920ed guibg=NONE guisp=NONE gui=NONE ctermfg=21 ctermbg=NONE cterm=NONE
hi Comment guifg=#cdaa64 guibg=NONE guisp=NONE gui=NONE ctermfg=179 ctermbg=NONE cterm=NONE
hi Character guifg=#ff950a guibg=NONE guisp=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi Float guifg=#f0eae5 guibg=NONE guisp=NONE gui=NONE ctermfg=255 ctermbg=NONE cterm=NONE
hi Number guifg=#f0eae5 guibg=NONE guisp=NONE gui=NONE ctermfg=255 ctermbg=NONE cterm=NONE
hi Boolean guifg=#0920ed guibg=NONE guisp=NONE gui=NONE ctermfg=21 ctermbg=NONE cterm=NONE
hi Operator guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Question guifg=#ffe57d guibg=NONE guisp=NONE gui=NONE ctermfg=222 ctermbg=NONE cterm=NONE
hi WarningMsg guifg=#ff7dff guibg=#cec1b3 guisp=#cec1b3 gui=NONE ctermfg=213 ctermbg=187 cterm=NONE
hi DiffDelete guifg=#ffff4b guibg=#6d6666 guisp=#6d6666 gui=NONE ctermfg=227 ctermbg=242 cterm=NONE
hi ModeMsg guifg=#2828ae guibg=NONE guisp=NONE gui=NONE ctermfg=19 ctermbg=NONE cterm=NONE
hi Define guifg=#899090 guibg=NONE guisp=NONE gui=NONE ctermfg=246 ctermbg=NONE cterm=NONE
hi Function guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi FoldColumn guifg=#2323cd guibg=#2e152e guisp=#2e152e gui=NONE ctermfg=20 ctermbg=236 cterm=NONE
hi PreProc guifg=#899090 guibg=NONE guisp=NONE gui=NONE ctermfg=246 ctermbg=NONE cterm=NONE
hi Visual guifg=#ee77ee guibg=#08088f guisp=#08088f gui=NONE ctermfg=213 ctermbg=18 cterm=NONE
hi MoreMsg guifg=#2828ae guibg=NONE guisp=NONE gui=NONE ctermfg=19 ctermbg=NONE cterm=NONE
hi VertSplit guifg=#b95bb9 guibg=#0f0f5e guisp=#0f0f5e gui=NONE ctermfg=133 ctermbg=17 cterm=NONE
hi Exception guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Keyword guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Type guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi DiffChange guifg=#ffff4b guibg=#79868f guisp=#79868f gui=NONE ctermfg=227 ctermbg=66 cterm=NONE
hi Cursor guifg=#402140 guibg=#0a0aff guisp=#0a0aff gui=NONE ctermfg=238 ctermbg=21 cterm=NONE
hi Error guifg=#ff7dff guibg=#6e6565 guisp=#6e6565 gui=NONE ctermfg=213 ctermbg=242 cterm=NONE
hi PMenu guifg=#ee77ee guibg=#08088f guisp=#08088f gui=NONE ctermfg=213 ctermbg=18 cterm=NONE
hi SpecialKey guifg=#e2d5ed guibg=NONE guisp=NONE gui=NONE ctermfg=255 ctermbg=NONE cterm=NONE
hi Constant guifg=#ff950a guibg=NONE guisp=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi Tag guifg=#ab17d0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi String guifg=#ff950a guibg=#402140 guisp=#402140 gui=NONE ctermfg=208 ctermbg=238 cterm=NONE
hi PMenuThumb guifg=#ee77ee guibg=#1717af guisp=#1717af gui=NONE ctermfg=213 ctermbg=19 cterm=NONE
hi MatchParen guifg=#402140 guibg=#12ff0a guisp=#12ff0a gui=NONE ctermfg=238 ctermbg=10 cterm=NONE
hi Repeat guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Directory guifg=#7dffc2 guibg=NONE guisp=NONE gui=NONE ctermfg=122 ctermbg=NONE cterm=NONE
hi Structure guifg=#ff0aff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE
hi Macro guifg=#899090 guibg=NONE guisp=NONE gui=NONE ctermfg=246 ctermbg=NONE cterm=NONE
hi Underlined guifg=#dfc69d guibg=NONE guisp=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
hi DiffAdd guifg=#ffff4b guibg=#666d66 guisp=#666d66 gui=NONE ctermfg=227 ctermbg=242 cterm=NONE
hi cursorim guifg=#402140 guibg=#0a0aff guisp=#0a0aff gui=NONE ctermfg=238 ctermbg=21 cterm=NONE
hi mbenormal guifg=#cf8f45 guibg=#10103f guisp=#10103f gui=NONE ctermfg=179 ctermbg=17 cterm=NONE
hi perlspecialstring guifg=#ab17d0 guibg=#402140 guisp=#402140 gui=NONE ctermfg=128 ctermbg=238 cterm=NONE
hi doxygenspecial guifg=#fd9b11 guibg=NONE guisp=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi mbechanged guifg=#ee77ee guibg=#10103f guisp=#10103f gui=NONE ctermfg=213 ctermbg=17 cterm=NONE
hi mbevisiblechanged guifg=#ee77ee guibg=#08088f guisp=#08088f gui=NONE ctermfg=213 ctermbg=18 cterm=NONE
hi doxygenparam guifg=#fd9b11 guibg=NONE guisp=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi doxygensmallspecial guifg=#fd9b11 guibg=NONE guisp=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi doxygenprev guifg=#fd9b11 guibg=NONE guisp=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi perlspecialmatch guifg=#ab17d0 guibg=#402140 guisp=#402140 gui=NONE ctermfg=128 ctermbg=238 cterm=NONE
hi cformat guifg=#ab17d0 guibg=#402140 guisp=#402140 gui=NONE ctermfg=128 ctermbg=238 cterm=NONE
hi lcursor guifg=#402140 guibg=#12ff0a guisp=#12ff0a gui=NONE ctermfg=238 ctermbg=10 cterm=NONE
hi doxygenspecialmultilinedesc guifg=#ad8662 guibg=NONE guisp=NONE gui=NONE ctermfg=137 ctermbg=NONE cterm=NONE
hi taglisttagname guifg=#0920ed guibg=NONE guisp=NONE gui=NONE ctermfg=21 ctermbg=NONE cterm=NONE
hi doxygenbrief guifg=#fdebde guibg=NONE guisp=NONE gui=NONE ctermfg=224 ctermbg=NONE cterm=NONE
hi mbevisiblenormal guifg=#cfcf65 guibg=#08088f guisp=#08088f gui=NONE ctermfg=185 ctermbg=18 cterm=NONE
hi user2 guifg=#2020a0 guibg=#0f0f5e guisp=#0f0f5e gui=NONE ctermfg=19 ctermbg=17 cterm=NONE
hi user1 guifg=#7dffc2 guibg=#0f0f5e guisp=#0f0f5e gui=NONE ctermfg=122 ctermbg=17 cterm=NONE
hi doxygenspecialonelinedesc guifg=#ad8662 guibg=NONE guisp=NONE gui=NONE ctermfg=137 ctermbg=NONE cterm=NONE
hi doxygencomment guifg=#ad9477 guibg=NONE guisp=NONE gui=NONE ctermfg=144 ctermbg=NONE cterm=NONE
hi cspecialcharacter guifg=#ab17d0 guibg=#402140 guisp=#402140 gui=NONE ctermfg=128 ctermbg=238 cterm=NONE

" Custom
hi rubyComment ctermbg=42 ctermfg=0

