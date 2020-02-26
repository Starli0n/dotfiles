#echo .zshrc

export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="robbyrussell"
ZSH_THEME="starli0n"

plugins=(
  ansible docker docker-compose dircycle git go kubectl pip python virtualenv
)

source $ZSH/oh-my-zsh.sh

bindkey "^[[1~" beginning-of-line   # tmux
bindkey '^[[4~' end-of-line         # tmux

if [ -f ~/.starrc ]; then
    . ~/.starrc
fi

