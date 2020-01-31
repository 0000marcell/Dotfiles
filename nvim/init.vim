
" map leader key
" let mapleader = "-" 

" local leader key
" let maplocalleader = "\\"

" nerdtree
let NERDTreeShowHidden=1



" in next parenthesis
:onoremap np :<c-u>normal! f(vi(<cr>

" in next parenthesis
:onoremap pp :<c-u>normal! F(vi(<cr>


" toggle hlsearch
:noremap <leader>h :set hlsearch!<cr>

" abbreviation  
:iabbrev @@ 0000marcell@gmail.com

" go to the end of the line
:nnoremap L $

" go to the beggining of the line
:nnoremap H 0

" wrap with single quotes
:nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel 

" wrap with double quotes
:nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel

" delete line
:nnoremap <leader>d dd

" edit .vimrc
:noremap <leader>ev :vsplit $MYVIMRC<cr>

" reload vimrc
:nnoremap <leader>sv :source $MYVIMRC<cr>

" fold block
:nnoremap <leader>f zfa}

" DELETE fold
:noremap <leader>d zd

" uppercase
inoremap <leader>u <esc>viwU
nnoremap <leader>u viwU

" lowercase
inoremap <leader>l <esc>viwu
nnoremap <leader>l viwu

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

Plug 'w0rp/ale'
Plug 'mustache/vim-mustache-handlebars'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'posva/vim-vue'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Raimondi/delimitMate'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'mattn/emmet-vim'

" Initialize plugin system
call plug#end()
