#!/bin/bash

which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

install_items() {
  file=$1
  install_cmd=$2

  if [ -f "$file" ]; then
    items=$(<"$file")
    for item in ${items[@]}; do
      $install_cmd $item
    done
  fi
}

if [[ $1 == "-c" ]]; then
  /opt/homebrew/bin/brew tap homebrew/cask-fonts
  install_cmd="/opt/homebrew/bin/brew install --cask"

  # loop through each workspace
  for workspace in ~/dotfiles/workspaces/*; do
    if [ -d "$workspace" ]; then
      install_items "$workspace/brew-casks" "$install_cmd"
    fi
  done
else
  install_cmd="/opt/homebrew/bin/brew install"

  # loop through each workspace
  for workspace in ~/dotfiles/workspaces/*; do
    if [ -d "$workspace" ]; then
      install_items "$workspace/brew-apps" "$install_cmd"
    fi
  done
fi