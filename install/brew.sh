#!/bin/bash

which -s brew
if [[ $? != 0 ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    reload
else
    brew update
fi

install_items() {
    file=$1
    install_cmd=$2
    list_cmd=$3
    installed_items=$($list_cmd)

    if [ -f "$file" ]; then
        items_to_install=$(<"$file")

        # Find items not already installed
        items_to_install=($(comm -13 <(echo "$installed_items" | sort) <(echo "$items_to_install" | sort)))

        for item in "${items_to_install[@]}"; do
            $install_cmd $item
        done
    fi
}

if [[ $1 == "-c" ]]; then
    brew tap homebrew/cask-fonts
    install_cmd="brew install --cask"
    list_cmd="brew list --cask"

    # loop through each workspace
    for workspace in ~/dotfiles/workspaces/*; do
        if [ -d "$workspace" ]; then
            install_items "$workspace/brew-casks" "$install_cmd" "$list_cmd"
        fi
    done
else
    install_cmd="brew install"
    list_cmd="brew list"

    # loop through each workspace
    for workspace in ~/dotfiles/workspaces/*; do
        if [ -d "$workspace" ]; then
            install_items "$workspace/brew-apps" "$install_cmd" "$list_cmd"
        fi
    done
fi

