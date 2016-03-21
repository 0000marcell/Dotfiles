"General config
colorscheme idle 
set hls
set nocompatible
set shell=/bin/bash
filetype off
syntax on
set relativenumber
set rtp+=~/.vim/bundle/Vundle.vim
set tabstop=2
set clipboard=unnamed
set shiftwidth=2
set softtabstop=2
set wildignore+=*/node_modules/*,*/bower_components/*,*/dist/*,*/tmp/*,*/build/*
"Powerline config
set guifont=Inconsolata\ for\ Powerline:h15
set laststatus=2
set term=xterm-256color
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8
let g:Powerline_symbols = 'fancy'
"CTRLP config
:command RefreshFiles CtrlPClearCache

let g:ctrlp_cache_dir = $HOME . '/ .cache/ctrlp'
let g:ctrlp_working_path_mode = 0
if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" easy align 
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

vmap <Tab> >gv
vmap <S-Tab> <gv
nmap <C-k> :set nohls!<CR>
nmap Q	:wq<CR>
nmap S :q<CR>
nmap P :pu<CR>
nmap - ddP
nmap _ ddo
nmap <c-u> viwU
map <C-n> :NERDTreeToggle<CR>
" Insert Maps
imap <C-l> <esc>
imap <C-f> <esc>A
imap <C-b> (
imap <C-c> {
"General maps
map <C-r> :set relativenumber!<CR>
" Easy motion shortcuts
map <C-o> <Leader><Leader>s
"Show highlighting groups for current word
nmap <C-h> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
call vundle#begin() 
"Default
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'digitaltoad/vim-jade'
Plugin 'flazz/vim-colorschemes'
Plugin 'Lokaltog/powerline',{'rtp': 'powerline/bindings/vim'}
Plugin 'leshill/vim-json'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'tpope/vim-surround'
"Testing
Plugin 'junegunn/vim-easy-align'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

Plugin 'dag/vim-fish'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'jiangmiao/auto-pairs'

call vundle#end()
filetype plugin indent on

