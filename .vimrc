"General config
set hls
set nocompatible
set shell=/bin/bash
filetype off
syntax on
set relativenumber
set rtp+=~/.vim/bundle/Vundle.vim
set tabstop=2
set shiftwidth=2
set softtabstop=2
set wildignore+=*/node_modules/*,*/bower_components/*,*/dist/*,*/tmp/*,*/build/*
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

"Testing
Plugin 'easymotion/vim-easymotion'
Plugin 'alvan/vim-closetag'
Plugin 'dag/vim-fish'
Plugin 'mustache/vim-mustache-handlebars'
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
vmap <Tab> >gv
vmap <S-Tab> <gv
nmap <C-k> :set nohls<CR>
map <C-u> <Plug>(easymotion-prefix)

"Show highlighting groups for current word

nmap <C-h> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

colorscheme lemon
let g:mustache_abbreviations = 1

let g:closetag_filenames = "*.html, *.hbs, *.xhtml, *.phtml"
