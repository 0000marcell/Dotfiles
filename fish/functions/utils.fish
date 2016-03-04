function save-dotfiles
	cp -R ~/.config/fish/ ~/documents/github/dotfiles/fish/
	rm ~/documents/github/dotfiles/fish/config.fish
	cp ~/.vimrc ~/documents/github/dotfiles/vim/	
	cp ~/.tmux.conf ~/documents/github/dotfiles/tmux/
	cp ~/.tmuxinator ~/documents/github/dotfiles/tmux/
	cp -R ~/.vim ~/documents/github/dotfiles/vim/ 
	cd ~/documents/github/dotfiles
end


function make-exec
	chmod +x $argv[1]
end
