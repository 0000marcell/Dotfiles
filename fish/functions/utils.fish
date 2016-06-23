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

function repo-size-total
	du -sh $argv[1]
end

function repo-size
	for file in *
		du -sh $file
	end
end

function read 
	open http://learnvimscriptthehardway.stevelosh.com/
	lrn
	cd Programming/vim/
end

function colors
	open https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
end

function lrn
	open https://www.railstutorial.org/book/user_microposts
end

function fish_color
	set -l textcol  white
	set -l bgcol    blue
	set -l arrowcol green
	set_color $textcol -b $bgcol
	echo -n " "(basename $PWD)" "
	set_color $arrowcol -b normal
	echo -n "⮀ "
end
