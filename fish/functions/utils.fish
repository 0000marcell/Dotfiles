function save-dotfiles
	rsync -av --progress ~/.config/fish/ ~/documents/github/dotfiles/fish/ --exclude .git
	rm ~/documents/github/dotfiles/fish/config.fish
	rsync -av --progress ~/.vimrc ~/documents/github/dotfiles/vim/ --exclude .git 
	rsync -av --progress ~/.tmux.conf ~/documents/github/dotfiles/tmux/ --exclude .git 
	rsync -av --progress ~/.tmuxinator/ ~/documents/github/dotfiles/tmux/ --exclude .git
	rsync -av --progress ~/.vim/ ~/documents/github/dotfiles/vim/ --exclude .git
	cd ~/documents/github/dotfiles
end


function make-exec
	chmod +x $argv[1]
end

function cp-sync
	rsync -av --progress $argv[1] $argv[2] --exclude $argv[3] 
end

function repo-size
	du -sh $argv[1]
end
