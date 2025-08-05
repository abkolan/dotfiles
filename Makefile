.PHONY: help install update sync clean list backup restore

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Install all dotfiles using stow
	@echo "📦 Installing dotfiles..."
	@for dir in */; do \
		dir=$${dir%/}; \
		if [[ "$$dir" != ".git" && "$$dir" != "scripts" ]]; then \
			echo "  Installing $$dir..."; \
			stow -v "$$dir"; \
		fi \
	done
	@echo "✅ Installation complete!"

update: ## Update packages and pull latest changes
	@echo "🔄 Updating dotfiles repository..."
	@git pull
	@echo "🍺 Updating Homebrew packages..."
	@brew bundle
	@echo "✅ Update complete!"

sync: update install ## Sync dotfiles (update + install)
	@echo "🔄 Sync complete!"

clean: ## Remove all symlinks created by stow
	@echo "🧹 Cleaning up dotfiles..."
	@for dir in */; do \
		dir=$${dir%/}; \
		if [[ "$$dir" != ".git" && "$$dir" != "scripts" ]]; then \
			echo "  Removing $$dir..."; \
			stow -D -v "$$dir" 2>/dev/null || true; \
		fi \
	done
	@echo "✅ Cleanup complete!"

list: ## List all available dotfile configurations
	@echo "📋 Available configurations:"
	@for dir in */; do \
		dir=$${dir%/}; \
		if [[ "$$dir" != ".git" && "$$dir" != "scripts" ]]; then \
			echo "  - $$dir"; \
		fi \
	done

backup: ## Create a backup of current dotfiles
	@echo "💾 Creating backup..."
	@mkdir -p ~/.dotfiles-backup-$$(date +%Y%m%d-%H%M%S)
	@for dir in */; do \
		dir=$${dir%/}; \
		if [[ "$$dir" != ".git" && "$$dir" != "scripts" ]]; then \
			find "$$dir" -name ".*" -type f | while read file; do \
				target="$$HOME/$${file#*/}"; \
				if [[ -f "$$target" && ! -L "$$target" ]]; then \
					cp "$$target" "~/.dotfiles-backup-$$(date +%Y%m%d-%H%M%S)/" 2>/dev/null || true; \
				fi \
			done \
		fi \
	done
	@echo "✅ Backup complete!"

restore: ## Restore dotfiles from backup (specify BACKUP_DIR)
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "❌ Please specify BACKUP_DIR: make restore BACKUP_DIR=~/.dotfiles-backup-YYYYMMDD-HHMMSS"; \
		exit 1; \
	fi
	@echo "🔄 Restoring from $(BACKUP_DIR)..."
	@cp -r $(BACKUP_DIR)/* ~ 2>/dev/null || true
	@echo "✅ Restore complete!"

# Install specific configuration
install-%: ## Install specific dotfile configuration (e.g., make install-zsh)
	@if [ -d "$*" ]; then \
		echo "📦 Installing $*..."; \
		stow -v "$*"; \
		echo "✅ $* installed!"; \
	else \
		echo "❌ Configuration '$*' not found!"; \
		exit 1; \
	fi

# Remove specific configuration
remove-%: ## Remove specific dotfile configuration (e.g., make remove-zsh)
	@if [ -d "$*" ]; then \
		echo "🗑️  Removing $*..."; \
		stow -D -v "$*"; \
		echo "✅ $* removed!"; \
	else \
		echo "❌ Configuration '$*' not found!"; \
		exit 1; \
	fi