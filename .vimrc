"General config
set nocompatible
filetype off
syntax on
set relativenumber
set rtp+=~/.vim/bundle/Vundle.vim
set tabstop=2
set shiftwidth=2
set softtabstop=2

call vundle#begin() 

"Default
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'digitaltoad/vim-jade'
Plugin 'flazz/vim-colorschemes'
Plugin 'Lokaltog/powerline',{'rtp': 'powerline/bindings/vim'}
Plugin 'jelera/vim-javascript-syntax'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'

"Testing
Plugin 'jiangmiao/auto-pairs'

call vundle#end()

filetype plugin indent on
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
let g:ctrlp_cache_dir = $HOME . '/ .cache/ctrlp'
if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
