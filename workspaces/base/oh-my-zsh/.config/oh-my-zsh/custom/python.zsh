# pyenv
export PYENV_ROOT=$HOME/.pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# poetry
fpath+=~/.zfunc
autoload -Uz compinit && compinit
