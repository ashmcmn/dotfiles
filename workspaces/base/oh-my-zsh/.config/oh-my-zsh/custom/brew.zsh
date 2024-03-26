# Determine machine architecture and set the appropriate Homebrew path
if [[ "$(uname -m)" == "arm64" ]]; then
    # M1 Macs
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$(uname -m)" == "x86_64" ]]; then
    # Intel Macs
    eval "$(/usr/local/bin/brew shellenv)"
fi

brewi() {
    local workspace="$1"
    local item="$2"
    local is_cask=false

    # Check if cask option is provided
    if [[ $item == "-c" ]]; then
        is_cask=true
        item="$3"
    fi

    local brew_command
    local list_command
    local workspace_path="$HOME/dotfiles/workspaces/$workspace"
    local workspace_file

    if $is_cask; then
        brew_command="brew install --cask"
        list_command="brew list --cask"
        workspace_file="$workspace_path/brew-casks"
    else
        brew_command="brew install"
        list_command="brew list"
        workspace_file="$workspace_path/brew-apps"
    fi

    # Check if the item is already installed
    if $list_command | grep -q "^$item$"; then
        echo "$item is already installed."
        return 0
    fi

    # Install the item
    $brew_command $item

    # Add the item to the workspace file
    echo "$item" >> "$workspace_file"
    echo "Added $item to $workspace workspace."
}
