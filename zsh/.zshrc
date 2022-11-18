# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

for config in ~/.zsh/config/*; do
  source $config
done

export PATH=$HOME/bin:/usr/local/bin:$PATH

export GOENV_ROOT=$HOME/.goenv
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

export PATH="/Users/ashley.mcmanamon/.local/bin:$PATH"

export VAULT_ADDR=https://vault.int.quantcast.com:8200

fpath+=.zsh/zfunc
autoload -Uz compinit && compinit
autoload -U colors

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

source "$HOME/.sdkman/bin/sdkman-init.sh"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

