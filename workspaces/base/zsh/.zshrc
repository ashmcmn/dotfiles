export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"
fpath=($ZSH_CUSTOM/completions $fpath)
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

export TERM=alacritty
export EDITOR=nvim

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(aliases aws docker encode64 fzf git golang jsontools poetry tmux)

autoload -Uz compinit
compinit
eval "$(op completion zsh)"; compdef _op op # onepassword completion
eval "$(jira --completion-script-zsh)" # go-jira completion

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
