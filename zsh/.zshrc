# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

for config in ~/.zsh/config/*; do
  source $config
done

export PATH=$HOME/bin:/usr/local/bin:$PATH
export VAULT_ADDR=https://vault.int.quantcast.com:8200

autoload -U colors

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

source "$HOME/.sdkman/bin/sdkman-init.sh"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
