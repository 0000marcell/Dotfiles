set shell=/usr/local/bin/fish
set hlsearch
imap <C-l> <esc>
map <C-n> :NERDTreeToggle<CR>
map <C-o> <Leader><Leader>s
map <C-e> :lopen<CR>
map <C-p> :Files ./app<CR>
map <C-t> :Files ./tests<CR>
map <C-h> :History<CR>
vmap <Tab> >gv
vmap <S-Tab> <gv
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Specify a directory for plugins
" " - For Neovim: ~/.local/share/nvim/plugged
" " - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Raimondi/delimitMate'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Initialize plugin system
call plug#end()
