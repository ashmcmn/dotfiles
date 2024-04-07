#!/bin/bash

# Function to print usage information
print_help() {
    echo "Usage: $(basename "$0") [-h] [-c] [workspace_directory]"
    echo "Install Homebrew packages or casks based on workspaces."
    echo "  -h, --help       display this help and exit"
    echo "  -c, --cask       install casks instead of packages"
    echo "  workspace_directory    specify a workspace directory to install from"
    echo
    echo "This script ensures Homebrew is installed and up to date."
}

# Function to check if Homebrew is installed and install it if not
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ "$(uname -m)" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ "$(uname -m)" == "x86_64" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "Homebrew is already installed."
    fi
}

# Function to update Homebrew
update_homebrew() {
    echo "Updating Homebrew..."
    brew update
}

# Function to install items
install_items() {
    local file=$1
    local install_cmd=$2
    local list_cmd=$3
    local installed_items=$($list_cmd)

    if [ -f "$file" ]; then
        local items_to_install
        items_to_install=$(<"$file")

        # Find items not already installed
        local items_to_install_filtered
        items_to_install_filtered=($(comm -13 <(echo "$installed_items" | sort) <(echo "$items_to_install" | sort)))

        for item in "${items_to_install_filtered[@]}"; do
            $install_cmd $item
        done
    fi
}

# Ensure Homebrew is installed and up to date
install_homebrew
update_homebrew

# Set default install command for apps
install_cmd="brew install"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -c|--cask)
            # Install casks
            brew tap homebrew/cask-fonts
            install_cmd="brew install --cask"
            list_cmd="brew list --cask"
            ;;
        *)
            if [[ -d $1 ]]; then
                # Install from specified workspace directory
                workspace=$1
                if [[ $install_cmd == "brew install --cask" ]]; then
                    install_items "$workspace/brew-casks" "$install_cmd" "$list_cmd"
                else
                    install_items "$workspace/brew-apps" "$install_cmd" "brew list"
                fi
                exit 0
            else
                echo "Error: Unknown option or workspace directory '$1'"
                print_help
                exit 1
            fi
            ;;
    esac
    shift
done

# Default behavior: install apps/casks from all workspaces
if [[ $install_cmd == "brew install --cask" ]]; then
    for workspace in ~/dotfiles/workspaces/*; do
        if [ -d "$workspace" ]; then
            install_items "$workspace/brew-casks" "$install_cmd" "$list_cmd"
        fi
    done
else
    for workspace in ~/dotfiles/workspaces/*; do
        if [ -d "$workspace" ]; then
            install_items "$workspace/brew-apps" "$install_cmd" "brew list"
        fi
    done
fi
