" ignore case when searching
set ignorecase

" fold options
set foldmethod=indent
set foldlevel=1
set foldlevelstart=99
set nowrap
let mapleader = " "

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

" Find where it's used in the project
noremap <leader>w :! rg -l 

" Debugger remaps
nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint

set shell=/usr/bin/bash
set hlsearch
set colorcolumn=81
inoremap <C-l> <esc>
noremap <C-n> :NERDTreeToggle<CR>
noremap <C-o> <Leader><Leader>s
noremap <C-e> :lopen<CR>
noremap <C-p> :GFiles ./<CR>
noremap <C-u> :noh<CR>
noremap <C-o> :b#<CR>
noremap <leader>h :History<CR>
let g:user_emmet_leader_key='<C-Y>'
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Shortcutting split navigation, saving a keypress:
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" Go to code definition
nmap <silent> gd <Plug>(coc-definition)
" ruby completion 
let g:coc_global_extensions = ['coc-solargraph']

" Markdownpreview
nmap <C-s> <Plug>MarkdownPreview

" Specify a directory for plugins
" " - For Neovim: ~/.local/share/nvim/plugged
" " - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Debugger Pluggins
Plug 'kevinoid/vim-jsonc'
Plug '/tpope/vim-rails'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Code Analisys
Plug 'dense-analysis/ale', { 'on': 'ALEToggle' }
" Svelte syntax
Plug 'leafoftree/vim-svelte-plugin'
" vim mustache handlebars syntax
Plug 'mustache/vim-mustache-handlebars'
" vim typescript syntax
Plug 'leafgarland/typescript-vim'
" tsx syntax
Plug 'peitalin/vim-jsx-typescript'
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
" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" zomm in and out of window
Plug 'markstory/vim-zoomwin'

" Initialize plugin system
call plug#end()
