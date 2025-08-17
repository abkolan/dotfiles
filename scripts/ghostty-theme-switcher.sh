#!/bin/bash

# ===========================
# GHOSTTY THEME SWITCHER - PERFORMANCE OPTIMIZED
# Quick theme switching with system integration
# ===========================

GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
BACKUP_CONFIG="$HOME/.config/ghostty/config.backup"

# PERFORMANCE: Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# PERFORMANCE: Function to safely backup config
backup_config() {
  if [[ ! -f "$BACKUP_CONFIG" ]]; then
    cp "$GHOSTTY_CONFIG" "$BACKUP_CONFIG"
    echo -e "${GREEN}✅ Config backed up${NC}"
  fi
}

# PERFORMANCE: Function to change theme
change_theme() {
  local theme="$1"
  
  if [[ -z "$theme" ]]; then
    echo -e "${RED}❌ Error: No theme specified${NC}"
    return 1
  fi
  
  # PERFORMANCE: Backup before making changes
  backup_config
  
  # PERFORMANCE: Use sed for fast in-place editing
  if sed -i '' "s/^theme = .*/theme = $theme/" "$GHOSTTY_CONFIG" 2>/dev/null; then
    echo -e "${GREEN}🎨 Theme changed to: $theme${NC}"
    
    # PERFORMANCE: Optional - reload Ghostty windows (requires AppleScript)
    if command -v osascript >/dev/null 2>&1; then
      osascript -e 'tell application "Ghostty" to quit' 2>/dev/null
      sleep 0.5
      open -a Ghostty 2>/dev/null
    fi
  else
    echo -e "${RED}❌ Error: Failed to change theme${NC}"
    return 1
  fi
}

# PERFORMANCE: Function to detect system appearance
detect_system_theme() {
  if command -v defaults >/dev/null 2>&1; then
    local appearance
    appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
    
    if [[ "$appearance" == "Dark" ]]; then
      echo "nord"
    else
      echo "solarized-light"
    fi
  else
    echo "nord"  # Default fallback
  fi
}

# PERFORMANCE: Function to show current theme
show_current_theme() {
  local current_theme
  current_theme=$(grep "^theme = " "$GHOSTTY_CONFIG" | cut -d' ' -f3)
  
  if [[ -n "$current_theme" ]]; then
    echo -e "${BLUE}📱 Current theme: $current_theme${NC}"
  else
    echo -e "${YELLOW}⚠️ No theme found in config${NC}"
  fi
}

# PERFORMANCE: Function to list available themes
list_themes() {
  echo -e "${BLUE}🎨 Available themes:${NC}"
  echo "  🌙 Dark themes:"
  echo "    - nord"
  echo "    - one-dark" 
  echo "    - dracula"
  echo "    - gruvbox-dark"
  echo "    - tokyo-night"
  echo ""
  echo "  ☀️ Light themes:"
  echo "    - solarized-light"
  echo "    - one-light"
  echo "    - gruvbox-light"
  echo ""
  echo "  🎯 Usage: $0 <theme-name>"
}

# PERFORMANCE: Function to auto-switch based on time
auto_switch() {
  local hour
  hour=$(date +%H)
  
  if [[ $hour -ge 20 || $hour -lt 8 ]]; then
    # Night time - use dark theme
    change_theme "nord"
    echo -e "${BLUE}🌙 Auto-switched to dark theme (night mode)${NC}"
  else
    # Day time - use light theme  
    change_theme "solarized-light"
    echo -e "${YELLOW}☀️ Auto-switched to light theme (day mode)${NC}"
  fi
}

# PERFORMANCE: Function to switch based on system appearance
system_sync() {
  local system_theme
  system_theme=$(detect_system_theme)
  change_theme "$system_theme"
  echo -e "${GREEN}🔄 Synced with system theme${NC}"
}

# PERFORMANCE: Main function with argument parsing
main() {
  case "${1:-}" in
    "list"|"-l"|"--list")
      list_themes
      ;;
    "current"|"-c"|"--current")
      show_current_theme
      ;;
    "auto"|"-a"|"--auto")
      auto_switch
      ;;
    "system"|"-s"|"--system")
      system_sync
      ;;
    "backup"|"-b"|"--backup")
      backup_config
      ;;
    "restore"|"-r"|"--restore")
      if [[ -f "$BACKUP_CONFIG" ]]; then
        cp "$BACKUP_CONFIG" "$GHOSTTY_CONFIG"
        echo -e "${GREEN}✅ Config restored from backup${NC}"
      else
        echo -e "${RED}❌ No backup found${NC}"
      fi
      ;;
    "help"|"-h"|"--help"|"")
      echo "🚀 Ghostty Theme Switcher"
      echo ""
      echo "Usage: $0 [OPTION|THEME]"
      echo ""
      echo "Options:"
      echo "  -l, --list     List available themes"
      echo "  -c, --current  Show current theme"
      echo "  -a, --auto     Auto-switch based on time"
      echo "  -s, --system   Sync with system appearance"
      echo "  -b, --backup   Backup current config"
      echo "  -r, --restore  Restore from backup"
      echo "  -h, --help     Show this help"
      echo ""
      echo "Themes:"
      echo "  nord, one-dark, dracula, gruvbox-dark, tokyo-night"
      echo "  solarized-light, one-light, gruvbox-light"
      echo ""
      echo "Examples:"
      echo "  $0 nord                # Switch to Nord theme"
      echo "  $0 --auto             # Auto-switch based on time"
      echo "  $0 --system           # Sync with system appearance"
      ;;
    *)
      # PERFORMANCE: Treat argument as theme name
      change_theme "$1"
      ;;
  esac
}

# PERFORMANCE: Error handling for missing config
if [[ ! -f "$GHOSTTY_CONFIG" ]]; then
  echo -e "${RED}❌ Error: Ghostty config not found at $GHOSTTY_CONFIG${NC}"
  exit 1
fi

# PERFORMANCE: Run main function with all arguments
main "$@"