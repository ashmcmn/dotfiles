# Determine machine architecture and set the appropriate Homebrew path
if [[ "$(uname -m)" == "arm64" ]]; then
    # M1 Macs
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel Macs
    eval "$(/usr/local/bin/brew shellenv)"
fi

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
