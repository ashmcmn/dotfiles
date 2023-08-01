# Editors
export EDITOR='nvim'
export PAGER='less -R'
export VISUAL='nvim'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Paths
## Ensure path arrays do not contain duplicates (except manpath, which needs gnuman placed at the start)
typeset -gU cdpath fpath mailpath path

path=(
  $HOME/bin
  $HOME/.bin 
  /usr/local/{bin,sbin}
  $path
)

# History
export HISTSIZE=500
