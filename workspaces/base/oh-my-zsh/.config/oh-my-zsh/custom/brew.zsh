function brewi() {
  workspace=$1
  shift
  if [[ $1 == "-c" ]]; then
    shift
    brew install --cask "$@"
    if ! grep -Fxq "$@" ~/dotfiles/workspaces/$workspace/brew-casks
    then
      echo "$@" >> ~/dotfiles/workspaces/$workspace/brew-casks
    fi
  else
    brew install "$@"
    if ! grep -Fxq "$@" ~/dotfiles/workspaces/$workspace/brew-apps
    then
      echo "$@" >> ~/dotfiles/workspaces/$workspace/brew-apps
    fi
  fi
}
