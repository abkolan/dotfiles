# 🔧 Scripts

## Overview
Collection of automation and utility scripts for dotfiles management, performance monitoring, and system configuration.

## Installation
Scripts are included with the dotfiles repository. Many are referenced by shell aliases or used during installation/testing.

## 📊 Performance & Benchmarking

### benchmark.sh
ZSH shell startup performance benchmark.
```bash
./scripts/benchmark.sh
```
- Uses `hyperfine` for accurate measurements if available
- Falls back to basic timing if hyperfine not installed
- Measures both cold and warm start times
- Provides statistics across multiple runs

### profile-zsh-startup.sh
Detailed ZSH startup profiler showing component-level timing.
```bash
./scripts/profile-zsh-startup.sh
```
- Tests basic shell without config
- Tests with .zshenv only
- Tests full interactive shell
- Shows detailed component timing
- Useful for identifying slow startup components

### zsh-benchmark-advanced.sh
Advanced ZSH performance benchmarking with detailed analysis.
```bash
./scripts/zsh-benchmark-advanced.sh
```
- More comprehensive than basic benchmark
- Analyzes individual component load times
- Provides optimization suggestions

## 🔄 Configuration Management

### backup-configs.sh
Creates timestamped backup of all configuration files.
```bash
./scripts/backup-configs.sh
```
- Backs up configs to `~/.dotfiles-backup/<timestamp>/`
- Excludes `.git/` and `scripts/` directories
- Useful before major configuration changes

### sync.sh
Synchronize dotfiles across machines.
```bash
./scripts/sync.sh
```
- Pulls latest changes from git
- Runs `brew bundle` to install/update packages
- Re-stows all configurations
- Ideal for keeping multiple machines in sync

### health-check.sh
Verifies dotfiles installation health.
```bash
./scripts/health-check.sh
```
- Checks for Stow conflicts
- Verifies symlink validity
- Validates installed dependencies
- Tests ZSH startup time
- Identifies broken or missing configurations

## ⚙️  ZSH Configuration

### migrate-to-zinit.sh
Switch between Oh My Zsh and Zinit plugin managers.
```bash
./scripts/migrate-to-zinit.sh
```
- Interactive menu for configuration switching
- Option 1: Switch to Zinit (high performance)
- Option 2: Switch back to Oh My Zsh
- Option 3: Compare performance between configurations

### test-completion-demo.sh
Test ZSH completion system functionality.
```bash
./scripts/test-completion-demo.sh [directory]
```
- Tests completion behavior in specified directory
- Validates ZSH completion system
- Useful for debugging completion issues

## 🎨 Theme & Display

### ghostty-theme-switcher.sh
Ghostty terminal theme management.
```bash
# Quick theme switch
ghostty-theme nord

# Auto theme based on time
ghostty-auto-theme

# Sync with system theme
ghostty-sync-system

# List available themes
./scripts/ghostty-theme-switcher.sh --list
```
- Switches Ghostty terminal themes
- Supports auto-switching based on time of day
- System theme synchronization
- Available as aliases: `gt`, `gta`, `gts`

## 🍎 macOS Utilities

### mac/toggle_dark_mode.sh
Toggle macOS dark mode.
```bash
./scripts/mac/toggle_dark_mode.sh
```
- Switches between light and dark mode
- Updates system appearance

### mac/toggle_dock_position.sh
Change macOS Dock position.
```bash
./scripts/mac/toggle_dock_position.sh
```
- Cycles through left, bottom, right positions
- Automatically restarts Dock

### mac/set_sound_io_studio_display.sh
Set audio to Studio Display.
```bash
./scripts/mac/set_sound_io_studio_display.sh
```
- Sets both input and output to Studio Display
- macOS-specific audio configuration

### mac/switch_audio_source.sh
Interactive audio source switcher.
```bash
./scripts/mac/switch_audio_source.sh
```
- Lists available audio sources
- Allows selection of input/output devices

## Usage in Dotfiles

### Referenced by Aliases
- `benchmark-shell` - Links to benchmark.sh
- `gt`, `gta`, `gts` - Ghostty theme switching
- `test-completion` - Links to test-completion-demo.sh

### Used by Installation
- `sync.sh` - Manual sync workflow
- `health-check.sh` - Verify installation
- `backup-configs.sh` - Pre-installation backup

### Development Tools
- `profile-zsh-startup.sh` - Performance optimization
- `migrate-to-zinit.sh` - Configuration testing
- `zsh-benchmark-advanced.sh` - Detailed analysis

## Tips
- Run `health-check.sh` after installing dotfiles
- Use `backup-configs.sh` before major changes
- Run `benchmark.sh` to verify performance improvements
- Use `migrate-to-zinit.sh` to test performance differences
