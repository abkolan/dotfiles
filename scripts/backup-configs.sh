#!/usr/bin/env bash
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "📦 Backing up current configurations to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

for dir in */; do
    [[ "$dir" == ".git/" || "$dir" == "scripts/" ]] && continue
    config_path="$HOME/.config/${dir%/}"
    if [[ -e "$config_path" ]]; then
        cp -R "$config_path" "$BACKUP_DIR/"
        echo "  ✅ Backed up ${dir%/}"
    fi
done

echo "💾 Backup complete: $BACKUP_DIR"