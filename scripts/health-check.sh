#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Dotfiles Health Check"
echo "========================"

# Check Stow conflicts
echo "→ Checking for Stow conflicts..."
find ~ -maxdepth 3 -name "*.stow-*" 2>/dev/null | while read -r conflict; do
    echo "  ⚠️  Conflict: $conflict"
done

# Verify symlinks
echo "→ Verifying symlinks..."
for dir in */; do
    [[ "$dir" == ".git/" || "$dir" == "scripts/" ]] && continue
    target="$HOME/.config/${dir%/}"
    if [[ -L "$target" ]]; then
        if [[ ! -e "$target" ]]; then
            echo "  ❌ Broken: $target"
        else
            echo "  ✅ Valid: $target"
        fi
    fi
done

# Check dependencies
echo "→ Checking dependencies..."
# Fixed: Added quotes to grep pattern to avoid matching 'brewfile' or 'cask' entries
while IFS= read -r dep; do
    if command -v "$dep" &>/dev/null; then
        echo "  ✅ $dep"
    else
        echo "  ❌ Missing: $dep"
    fi
done < <(grep '^brew "' Brewfile | awk -F'"' '{print $2}')

# ZSH startup time
echo "→ Testing ZSH startup time..."
for i in {1..3}; do
    time=$(/usr/bin/time zsh -i -c exit 2>&1 | grep real | awk '{print $1}')
    echo "  Run $i: ${time}s"
done