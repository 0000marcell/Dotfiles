#!/bin/bash

# Reports skills that exist in ~/.claude/skills as real directories instead of
# symlinks into this repo. Those would never be committed or pushed by ~/ud.
#
# Usage: ./check_skills.sh [--fix]

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$DOTFILES_DIR/skills"
SKILLS_DIR="$HOME/.claude/skills"
FIX=0
DRIFTED=0

if [ "$1" = "--fix" ]; then
    FIX=1
fi

if [ ! -d "$SKILLS_DIR" ]; then
    echo "No skills directory at $SKILLS_DIR"
    exit 0
fi

for skill in "$SKILLS_DIR"/*/; do
    [ -e "$skill" ] || continue

    name="$(basename "$skill")"
    target="$SKILLS_DIR/$name"

    if [ -L "$target" ]; then
        continue
    fi

    DRIFTED=1

    if [ "$FIX" = "1" ]; then
        mv "$target" "$SKILLS_SRC/$name"
        ln -s "$SKILLS_SRC/$name" "$target"
        echo "Moved $name into the repo and relinked it"
    else
        echo "Not tracked: $name (real folder, not a symlink into $SKILLS_SRC)"
    fi
done

if [ "$DRIFTED" = "0" ]; then
    echo "All skills are symlinked into the repo."
elif [ "$FIX" = "0" ]; then
    echo
    echo "Run ./check_skills.sh --fix to move them into the repo, then ~/ud to push."
    exit 1
fi
