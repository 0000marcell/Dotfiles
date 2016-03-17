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
