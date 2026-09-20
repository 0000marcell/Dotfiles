#!/bin/bash

# Installs the Crush/Claude skills stored in this repo by symlinking
# each skill folder into ~/.claude/skills.
#
# Usage: clone this repo, then run ./install_skills.sh from anywhere.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$DOTFILES_DIR/skills"
SKILLS_DIR="$HOME/.claude/skills"

if [ ! -d "$SKILLS_SRC" ]; then
    echo "No skills folder found at $SKILLS_SRC"
    exit 1
fi

mkdir -p "$SKILLS_DIR"

for skill in "$SKILLS_SRC"/*/; do
    name="$(basename "$skill")"
    target="$SKILLS_DIR/$name"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "$target.backup"
        echo "Backed up existing $name to $name.backup"
    fi

    ln -s "$SKILLS_SRC/$name" "$target"
    echo "Installed skill: $name"
done

echo
echo "Done. Restart Crush (or start a new session) to load the skills."
