" fold options
set foldmethod=indent
set foldlevel=1
set foldlevelstart=99

" nerdtree
let NERDTreeShowHidden=1

" go to the end of the line
:nnoremap L $

" go to the beggining of the line
:nnoremap H 0

" Copy paste
vnoremap <C-c> "+y
noremap <C-v> "+p

" Reload
noremap <C-r> :so %<CR>

" Compile
noremap <C-b> :!node %<CR>

set shell=/usr/bin/bash
set hlsearch
set colorcolumn=81
inoremap <C-l> <esc>
noremap <C-n> :NERDTreeToggle<CR>
noremap <C-o> <Leader><Leader>s
noremap <C-e> :lopen<CR>
noremap <C-p> :Files ./<CR>
" noremap <C-t> :Files ./tests<CR>
noremap <C-H> :set nohlsearch<CR>
noremap <C-h> :History<CR>
noremap <C-i> :s/ /./g<CR>
let g:user_emmet_leader_key='<C-Y>'
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Shortcutting split navigation, saving a keypress:
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Specify a directory for plugins
" " - For Neovim: ~/.local/share/nvim/plugged
" " - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Code Analisys
Plug 'w0rp/ale'
" Svelte syntax
Plug 'leafoftree/vim-svelte-plugin'
" vim mustache handlebars syntax
Plug 'mustache/vim-mustache-handlebars'
" vim typescript syntax
Plug 'leafgarland/typescript-vim'
" Comment lines of code
Plug 'tpope/vim-commentary'
" File Treeview
Plug 'scrooloose/nerdtree'
" Vim surround
Plug 'tpope/vim-surround'
" Vue syntax
Plug 'posva/vim-vue'
" React syntax
Plug 'maxmellon/vim-jsx-pretty'
" Jump to specific letters
Plug 'easymotion/vim-easymotion'
" Fuzzy searching with CTRL+P
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Closes parentheses quotes etc...
Plug 'Raimondi/delimitMate'
" Create snippets
Plug 'garbas/vim-snipmate'
" Emmet plugin for html completion
Plug 'mattn/emmet-vim'
" Requirement for other plugins
Plug 'tomtom/tlib_vim'
" File identifier 
Plug 'MarcWeber/vim-addon-mw-utils'

" Initialize plugin system
call plug#end()
