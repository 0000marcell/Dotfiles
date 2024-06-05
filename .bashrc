# check battery capacity
# the following start a new process everytime I run a new terminal

#bash git branch
#export PS1="\\w:\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "

export PS1='\[\e]0;\w\a\]\[\033[01;34m\]\W\[\033[00m\]\$ '

#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]:\[\033[01;31m\]\!$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ '


#mmc 
# use single tap to click
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
# natural scrolling
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1

cdd() {
  echo /home/mmc/ghp
  cd /home/mmc/ghp
}

export GPG_TTY=$(tty)

export BROWSER="brave"

# System Maintainence
alias mw="~/.config/mutt/mutt-wizard.sh"
alias muttwizard="~/.config/mutt/mutt-wizard.sh"
alias sdn="sudo shutdown now"
alias psref="gpg-connect-agent RELOADAGENT /bye" # Refresh gpg

# Some aliases
alias p="sudo pacman"
alias SS="sudo systemctl"
alias v="nvim"
alias envim="nvim $c/nvim/init.vim"
alias sv="sudo nvim"
alias r="ranger"
alias sr="sudo ranger"
alias ka="killall"
alias g="git"
alias ref="shortcuts && source ~/.bashrc" # Refresh shortcuts manually and reload bashrc

# Adding color
alias ls='ls -hN --color=auto --group-directories-first'
alias grep="grep --color=auto" 
alias diff="diff --color=auto"
alias ccat="highlight --out-format=ansi" # Color cat - print file with syntax highlighting.

# Internet
alias yt="youtube-dl --add-metadata -ic" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio
alias YT="youtube-viewer"

shdl() { curl -O $(curl -s http://sci-hub.tw/"$@" | grep location.href | grep -o http.*pdf) ;}
vf() { $EDITOR $(fzf) ;}
source /home/mmc/.shortcuts

source /home/mmc/.functions

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias sncli="sncli"
alias sk='setxkbmap'
alias pdf='zathura'
alias copy="xclip -selection clipboard "
alias t="tizonia"
alias eb="nvim ~/.bashrc"
export ghp="~/home/ghp"

export TZ="America/Brasilia"
export p="/home/mmc/ghp"
export pe="/home/mmc/ghp/personal"
export c="/home/mmc/.config"
export s="/home/mmc/scripts"
export d="/home/mmc/Downloads"

# reload bindings
#xbindkeys --poll-rc

# add script folder to path
export PATH="$PATH:$HOME/scripts"

export PYTHONPATH="/usr/bin/python"

# python things
export PATH="$PATH:$HOME/.local/bin"

# add telegram
export PATH="$PATH:$HOME/Telegram"

# add go bin  
export PATH="$PATH:$HOME/go/bin"

# enable user namespace cloning for pageres
sudo sysctl -w kernel.unprivileged_userns_clone=1 > /dev/null

# to solve a simple problem in ruby
#export LANG=en_US.UTF-8
#export LANGUAGE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

#rust things
export PATH="$PATH:$HOME/.cargo/bin"

cd /home/mmc/ghp

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# psql
export PGDATABASE=postgres

# deno
export DENO_INSTALL="/home/mmc/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# decisiv enviroment variables
source ~/Decisiv/.profile

export PATH="$PATH:$HOME/.gem"
export GEM_HOME=$HOME/.gem
export GEM_PATH=$HOME/.gem

# Go path
export PATH=$PATH:/usr/local/go/bin

# execices-cli-program
export PATH="$PATH:$HOME/ghp/mastering-python/cli-exercices-app/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

SYSTEMD_EDITOR="nvim"

# py env
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

_nvmrc_hook() {
  if [[ $PWD == $PREV_PWD ]]; then
    return
  fi
  
  PREV_PWD=$PWD
  [[ -f ".nvmrc" ]] && nvm use
}

if ! [[ "${PROMPT_COMMAND:-}" =~ _nvmrc_hook ]]; then
  PROMPT_COMMAND="_nvmrc_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
