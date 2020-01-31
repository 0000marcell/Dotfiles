" uppercase mapping
imap <c-u> <esc>viwU
nmap <c-u> viwU

" Copy paste
vnoremap <C-c> "+y
map <C-v> "+p

" Reload
map <C-r> :so %<CR>

" Compile
map <C-b> :!node %<CR>

set shell=/usr/bin/bash
set hlsearch
set colorcolumn=81
imap <C-l> <esc>
map <C-n> :NERDTreeToggle<CR>
map <C-o> <Leader><Leader>s
map <C-e> :lopen<CR>
map <C-p> :Files ./<CR>
" map <C-t> :Files ./tests<CR>
map <C-H> :set nohlsearch<CR>
map <C-h> :History<CR>
map <C-i> :s/ /./g<CR>
let g:user_emmet_leader_key='<C-Y>'
vmap <Tab> >gv
vmap <S-Tab> <gv
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

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
