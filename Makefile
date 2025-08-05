# Ultimate DevOps Neovim Dotfiles
# GNU Stow based dotfiles management

.PHONY: help install uninstall nvim deps check clean restow dry-run

# Default target
help:
	@echo "🚀 Ultimate DevOps Neovim Dotfiles"
	@echo ""
	@echo "Available targets:"
	@echo "  install     - Install all dotfiles using stow"
	@echo "  nvim        - Install only Neovim configuration"
	@echo "  uninstall   - Remove all dotfiles symlinks"
	@echo "  deps        - Install system dependencies"
	@echo "  check       - Check system requirements"
	@echo "  clean       - Clean up broken symlinks"
	@echo "  restow      - Restow dotfiles (useful after updates)"
	@echo "  dry-run     - Show what would be installed"
	@echo ""
	@echo "Quick setup:"
	@echo "  make deps && make install"

# Check if stow is installed
check-stow:
	@command -v stow >/dev/null 2>&1 || { echo "❌ GNU Stow is required. Install with: brew install stow (macOS) or apt install stow (Linux)"; exit 1; }

# Install system dependencies
deps:
	@echo "📦 Installing system dependencies..."
	@if [[ "$$OSTYPE" == "darwin"* ]]; then \
		echo "🍺 Installing via Homebrew..."; \
		command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		brew install stow neovim fd ripgrep fzf git curl wget node; \
	elif [[ "$$OSTYPE" == "linux-gnu"* ]]; then \
		echo "📦 Installing via apt..."; \
		sudo apt update; \
		sudo apt install -y stow neovim fd-find ripgrep fzf git curl wget nodejs npm build-essential; \
		command -v fd >/dev/null 2>&1 || sudo ln -sf $$(which fdfind) /usr/local/bin/fd; \
	else \
		echo "❌ Unsupported OS. Please install manually: stow, neovim, fd, ripgrep, fzf, git, curl, wget, node"; \
		exit 1; \
	fi
	@echo "✅ Dependencies installed!"

# Check system requirements
check:
	@echo "🔍 Checking system requirements..."
	@command -v stow >/dev/null 2>&1 && echo "✅ GNU Stow" || echo "❌ GNU Stow (required)"
	@command -v nvim >/dev/null 2>&1 && echo "✅ Neovim" || echo "❌ Neovim (required)"
	@command -v fd >/dev/null 2>&1 && echo "✅ fd" || echo "❌ fd (required)"
	@command -v rg >/dev/null 2>&1 && echo "✅ ripgrep" || echo "❌ ripgrep (required)"
	@command -v fzf >/dev/null 2>&1 && echo "✅ fzf" || echo "❌ fzf (required)"
	@command -v git >/dev/null 2>&1 && echo "✅ git" || echo "❌ git (required)"
	@command -v node >/dev/null 2>&1 && echo "✅ Node.js" || echo "⚠️  Node.js (recommended)"

# Install Neovim configuration only
nvim: check-stow
	@echo "⚙️  Installing Neovim configuration..."
	@stow -v nvim
	@echo "✅ Neovim configuration installed!"
	@echo ""
	@echo "🎯 Next steps:"
	@echo "1. Run: nvim"
	@echo "2. Wait for plugins to install automatically"
	@echo "3. LSP servers will install automatically"
	@echo "4. Use <C-p> to start file navigation"

# Install all dotfiles
install: check-stow nvim
	@echo "✅ All dotfiles installed!"
	@echo ""
	@echo "🎯 Configuration installed to:"
	@echo "  ~/.config/nvim -> $(PWD)/nvim/.config/nvim"
	@echo ""
	@echo "🚀 Start Neovim: nvim"

# Uninstall all dotfiles
uninstall: check-stow
	@echo "🗑️  Removing dotfiles symlinks..."
	@stow -D nvim
	@echo "✅ Dotfiles uninstalled!"

# Clean up broken symlinks
clean:
	@echo "🧹 Cleaning up broken symlinks..."
	@find ~/ -maxdepth 3 -type l -exec test ! -e {} \; -delete 2>/dev/null || true
	@echo "✅ Cleanup complete!"

# Restow (useful after updates)
restow: check-stow
	@echo "🔄 Restowing dotfiles..."
	@stow -R nvim
	@echo "✅ Dotfiles restowed!"

# Show what would be installed
dry-run: check-stow
	@echo "🔍 Dry run - showing what would be installed:"
	@stow -n -v nvim