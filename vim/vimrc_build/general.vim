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

