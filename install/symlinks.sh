#!/usr/bin/env bash

# Config file path
config_file="symlink-config"

# Check for --override flag
override_flag=false
if [ "$1" = '--override' ]; then
  override_flag=true
fi

# Read the config file
while IFS=: read -r workspace directory
do
  # Path to the workspace directory
  workspace_dir="${HOME}/dotfiles/workspaces/${workspace}"

  if [ -d "${workspace_dir}/${directory}" ]; then
    # If the directory exists, get all the files in the directory
    files=($(find "${workspace_dir}/${directory}" -type f))
    # Process each file
    for file_path in "${files[@]}"; do
      # Compute relative path
      relative_path="${file_path#${workspace_dir}/${directory}/}"
      symlink_path="${HOME}/${relative_path}"

      # Ensure the target directory exists
      mkdir -p "$(dirname "${symlink_path}")"

      # If the file is not a symlink or the override flag is set, create/update the symlink
      if [ ! -L "${symlink_path}" ] || [ "$override_flag" = "true" ]; then
        echo "Creating symlink: ${symlink_path} -> ${file_path}"
        ln -sf "${file_path}" "${symlink_path}"
      else
        echo "Skipping existing symlink: ${symlink_path}"
      fi
    done
  else
    echo "Skipping \"${directory}\" (not found in \"${workspace}\")"
  fi
done < "${config_file}"

echo "Done!"
