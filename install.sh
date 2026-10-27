#!/bin/bash

# Symlinks the app configs stored in this repo into ~/.config.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# List of apps to link
APPS=("alacritty" "btop" "clipse" "crush" "fastfetch" "fontconfig" "ghostty" "hypr" "i3" "i3blocks" "nvim" "shell" "walker")

mkdir -p "$CONFIG_DIR"

for app in "${APPS[@]}"; do
    if [ ! -d "$DOTFILES_DIR/$app" ]; then
        echo "$app not in repo, skipping."
        continue
    fi

    target="$CONFIG_DIR/$app"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        mv "$target" "$target.backup"
        echo "Backed up $app to $app.backup"
    fi

    ln -s "$DOTFILES_DIR/$app" "$target"
    echo "Created symlink $app"
done
