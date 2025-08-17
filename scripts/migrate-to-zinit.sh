#!/bin/bash
# Script to migrate from Oh My Zsh to Zinit

echo "🚀 ZSH Configuration Migration Tool"
echo "=================================="
echo ""

# Check if backups exist
if [[ ! -f ~/.zshrc.omz-backup ]]; then
    echo "⚠️  Creating backups first..."
    cp ~/.zshrc ~/.zshrc.omz-backup
    cp ~/.zshenv ~/.zshenv.omz-backup
    echo "✅ Backups created"
fi

echo ""
echo "Choose an option:"
echo "1) Switch to Zinit (high-performance)"
echo "2) Restore Oh My Zsh configuration"
echo "3) Compare startup times"
echo "4) Exit"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🔄 Switching to Zinit configuration..."
        cp ~/.zshrc.zinit ~/.zshrc
        echo "✅ Zinit configuration activated"
        echo ""
        echo "📝 Next steps:"
        echo "1. Open a new terminal to use the new configuration"
        echo "2. Run 'zinit self-update' to ensure Zinit is up to date"
        echo "3. If you see any errors, run this script and choose option 2 to restore"
        ;;
    2)
        echo ""
        echo "🔄 Restoring Oh My Zsh configuration..."
        cp ~/.zshrc.omz-backup ~/.zshrc
        cp ~/.zshenv.omz-backup ~/.zshenv
        echo "✅ Oh My Zsh configuration restored"
        ;;
    3)
        echo ""
        echo "📊 Comparing startup times..."
        echo ""
        echo "Oh My Zsh configuration:"
        cp ~/.zshrc.omz-backup ~/.zshrc
        time zsh -i -c exit 2>&1 | grep real
        echo ""
        echo "Zinit configuration:"
        cp ~/.zshrc.zinit ~/.zshrc
        time zsh -i -c exit 2>&1 | grep real
        echo ""
        echo "💡 Lower time is better!"
        ;;
    4)
        echo "👋 Exiting..."
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac