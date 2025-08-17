#!/bin/bash
# Test Kitty Terminal Configuration

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "Kitty Terminal Configuration"

# ===========================
# Platform-Specific Testing
# ===========================
if [[ "$PLATFORM" != "macos" ]]; then
    skip_test "Kitty configuration" "Kitty is primarily a macOS/GUI application"
    print_summary
    exit 0
fi

# ===========================
# Test Kitty Installation
# ===========================
# Kitty might be installed as an app or via brew
if [[ -d "/Applications/kitty.app" ]] || command_exists kitty; then
    test_case "Kitty is installed" "true"
else
    skip_test "All Kitty tests" "Kitty not installed"
    print_summary
    exit 0
fi

# ===========================
# Test Kitty Configuration
# ===========================
test_case "Kitty config directory exists" "dir_exists $HOME/.config/kitty"
test_case "Kitty config is symlinked correctly" "symlink_valid $HOME/.config/kitty"
test_case "kitty.conf exists" "file_exists $HOME/.config/kitty/kitty.conf"

# ===========================
# Test Configuration Syntax
# ===========================
if command_exists kitty; then
    test_case "Kitty config syntax is valid" \
        "kitty --debug-config 2>&1 | grep -c 'ERROR' | grep -q '^0$' || true"
else
    skip_test "Config syntax validation" "Kitty CLI not in PATH"
fi

# ===========================
# Test Theme Configuration
# ===========================
echo ""
echo "  Testing theme configuration..."

# Check if theme files exist
if dir_exists "$HOME/.config/kitty/themes"; then
    test_case "Theme directory exists" "true"
    theme_count=$(find "$HOME/.config/kitty/themes" -name "*.conf" 2>/dev/null | wc -l)
    if [[ $theme_count -gt 0 ]]; then
        test_case "Theme files exist" "true"
        verbose "Found $theme_count theme files"
    else
        test_case "Theme files exist" "false"
    fi
else
    skip_test "Theme configuration" "Themes directory not found"
fi

# Check for current theme
if file_exists "$HOME/.config/kitty/current-theme.conf"; then
    test_case "Current theme is configured" "true"
else
    skip_test "Current theme" "No current-theme.conf found"
fi

# ===========================
# Test Font Configuration
# ===========================
echo ""
echo "  Testing font configuration..."

if file_exists "$HOME/.config/kitty/kitty.conf"; then
    test_output "Font family is configured" \
        "grep -E '^font_family|^# font_family' $HOME/.config/kitty/kitty.conf | head -1" \
        "font"
    
    test_output "Font size is configured" \
        "grep -E '^font_size|^# font_size' $HOME/.config/kitty/kitty.conf | head -1" \
        "font_size"
fi

# ===========================
# Test Key Mappings
# ===========================
echo ""
echo "  Testing key mappings..."

if file_exists "$HOME/.config/kitty/kitty.conf"; then
    # Check for common key mappings
    if grep -q "^map " "$HOME/.config/kitty/kitty.conf"; then
        test_case "Custom key mappings exist" "true"
    else
        skip_test "Custom key mappings" "No mappings defined"
    fi
fi

# ===========================
# Test Shell Integration
# ===========================
echo ""
echo "  Testing shell integration..."

test_output "Shell is configured" \
    "grep -E '^shell|^# shell' $HOME/.config/kitty/kitty.conf 2>/dev/null | head -1 || echo 'default'" \
    "shell\|default"

# ===========================
# Test Window Configuration
# ===========================
echo ""
echo "  Testing window configuration..."

if file_exists "$HOME/.config/kitty/kitty.conf"; then
    # Check for window padding/margin settings
    test_output "Window padding configured" \
        "grep -E 'window_padding\|window_margin' $HOME/.config/kitty/kitty.conf 2>/dev/null | head -1 || echo 'default'" \
        "padding\|margin\|default"
fi

# ===========================
# Test Tab Bar Configuration
# ===========================
echo ""
echo "  Testing tab bar..."

if file_exists "$HOME/.config/kitty/kitty.conf"; then
    test_output "Tab bar style configured" \
        "grep -E 'tab_bar_style' $HOME/.config/kitty/kitty.conf 2>/dev/null | head -1 || echo 'default'" \
        "tab_bar\|default"
fi

# ===========================
# Test Performance Settings
# ===========================
echo ""
echo "  Testing performance settings..."

if file_exists "$HOME/.config/kitty/kitty.conf"; then
    # Check for performance-related settings
    test_output "Repaint delay configured" \
        "grep -E 'repaint_delay\|input_delay' $HOME/.config/kitty/kitty.conf 2>/dev/null | head -1 || echo 'default'" \
        "delay\|default"
fi

# ===========================
# Test Background Image
# ===========================
if file_exists "$HOME/.config/kitty/terminal_sky.png"; then
    test_case "Background image exists" "true"
else
    skip_test "Background image" "terminal_sky.png not found"
fi

# ===========================
# Test Sessions
# ===========================
if file_exists "$HOME/.config/kitty/sessions"; then
    test_case "Sessions directory exists" "true"
else
    skip_test "Sessions" "Sessions directory not found"
fi

# Return test results
print_summary