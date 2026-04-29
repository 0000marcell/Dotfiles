#!/bin/bash

# Define the config directory
CONFIG_DIR="$HOME/.config"

# List of apps to backup
APPS=("alacritty" "btop" "cripse" "fastfetch" "fontconfig" "ghostty" "hypr" "i3" "i3blocks" "nvim" "shell" "walker")

# Loop through apps and rename
for app in "${APPS[@]}"; do
    if [ -d "$CONFIG_DIR/$app" ]; then
        mv "$CONFIG_DIR/$app" "$CONFIG_DIR/$app.backup"
        echo "Backed up $app"
        ln -s "/home/mmc/Dotfiles/$app" "$CONFIG_DIR/$app"
        echo "Created symlink $app"
    else
        echo "$app not found, skipping."
    fi
done

