# 🚀 Ultimate DevOps Dotfiles

My personal dotfiles setup optimized for DevOps workflows, managed with GNU Stow.

## 📦 What's Included

### 🔧 Neovim Configuration
- **Lightning-fast navigation** with FZF and Telescope
- **Kubernetes LSP support** with auto-schema validation  
- **Multi-file management** (splits, tabs, buffers)
- **DevOps workflows** (Terraform, Docker, Go, Python, Helm)
- **Auto-installing LSP servers** for zero-config setup
- **Git integration** with diff views
- **Harpoon** for instant file switching

### 🐚 Shell & Terminal (if added)
- [**zsh**](https://www.zsh.org/) - Extended shell with improvements
- Custom aliases and functions for DevOps workflows

### 🛠️ Development Tools
- [**git**](https://git-scm.com/) - Version control configuration
- Modern CLI tools (fd, ripgrep, fzf)

## Installation

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   ```

2. Install GNU Stow:
   ```bash
   # macOS
   brew install stow
   
   # Debian/Ubuntu
   sudo apt-get install stow
   ```

3. Use Stow to create symlinks for each configuration:
   ```bash
   cd ~/dotfiles
   stow zsh          # For zsh configuration
   stow nvim         # For Neovim configuration
   stow git          # For git configuration
   # etc...
   ```

## Sync Between Machines

This repository includes a script to synchronize dotfiles between machines:

```bash
#!/bin/bash
# sync.sh - Simple dotfiles sync

# Pull latest changes
cd ~/dotfiles && git pull

# Install/update packages
brew bundle

# Stow all configs (except .git and scripts)
for dir in */; do
  dir=${dir%/}
  if [[ "$dir" != ".git" && "$dir" != "scripts" ]]; then
    stow -R "$dir"
  fi
done

echo "✅ Sync complete!"
```

### Usage:

**On primary machine (when adding new tools):**
```bash
brew install new-tool
cd ~/dotfiles
brew bundle dump --force
git add .
git commit -m "Add new-tool"
git push
```

**On secondary machine (to sync):**
```bash
~/dotfiles/sync.sh
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.