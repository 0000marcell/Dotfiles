function save-dotfiles
	cp -R ~/.config/fish/ ~/documents/github/dotfiles/fish/
	cp ~/.vimrc ~/documents/github/dotfiles/vim/	
	cp ~/.tmux.conf ~/documents/github/dotfiles/tmux/
	cp ~/.tmuxinator ~/documents/github/dotfiles/tmux/
	cp -R ~/.vim ~/documents/github/dotfiles/vim/ 
end
