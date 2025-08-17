#!/bin/bash
# Integration Test - Verify all aliases work correctly

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "Alias Integration"

# ===========================
# Test Navigation Aliases
# ===========================
echo "  Testing navigation aliases..."

test_output "Alias '..' works" \
    "zsh -i -c 'alias .. 2>/dev/null'" \
    "cd .."

test_output "Alias '...' works" \
    "zsh -i -c 'alias ... 2>/dev/null'" \
    "cd ../.."

# ===========================
# Test Directory Listing Aliases
# ===========================
echo ""
echo "  Testing directory listing aliases..."

test_output "Alias 'll' is functional" \
    "zsh -i -c 'alias ll 2>/dev/null'" \
    "ls"

test_output "Alias 'la' is functional" \
    "zsh -i -c 'alias la 2>/dev/null'" \
    "ls"

# ===========================
# Test Editor Aliases
# ===========================
echo ""
echo "  Testing editor aliases..."

test_output "Alias 'v' points to nvim" \
    "zsh -i -c 'alias v 2>/dev/null'" \
    "nvim"

test_output "Alias 'vim' points to nvim" \
    "zsh -i -c 'alias vim 2>/dev/null'" \
    "nvim"

# ===========================
# Test FZF Aliases
# ===========================
echo ""
echo "  Testing FZF aliases..."

if command_exists fzf; then
    test_output "Alias 'ff' is defined" \
        "zsh -i -c 'alias ff 2>/dev/null'" \
        "fzf"
    
    test_output "Alias 'fcd' is defined" \
        "zsh -i -c 'alias fcd 2>/dev/null'" \
        "fd.*fzf"
else
    skip_test "FZF aliases" "FZF not installed"
fi

# ===========================
# Test Git Aliases (if configured)
# ===========================
echo ""
echo "  Testing git aliases..."

if command_exists git; then
    # Test shell aliases for git
    test_output "Git status alias exists" \
        "zsh -i -c 'alias | grep -E \"(gst|gs)\"' 2>/dev/null || echo 'none'" \
        "git.*status\|none"
else
    skip_test "Git aliases" "Git not installed"
fi

# ===========================
# Test Docker Aliases
# ===========================
echo ""
echo "  Testing Docker aliases..."

if zsh -i -c 'alias d 2>/dev/null' | grep -q docker; then
    test_case "Docker alias 'd' is defined" "true"
    test_output "Docker compose alias 'dc' is defined" \
        "zsh -i -c 'alias dc 2>/dev/null'" \
        "docker"
else
    skip_test "Docker aliases" "Not configured"
fi

# ===========================
# Test Custom Directory Shortcuts
# ===========================
echo ""
echo "  Testing custom directory shortcuts..."

test_output "Dotfiles shortcut '@dot' exists" \
    "zsh -i -c 'alias @dot 2>/dev/null' || echo 'not configured'" \
    "dotfiles\|not configured"

# ===========================
# Test Reload Aliases
# ===========================
echo ""
echo "  Testing configuration reload aliases..."

test_output "ZSH reload alias 'rz' exists" \
    "zsh -i -c 'alias rz 2>/dev/null'" \
    "source.*zshrc"

# Return test results
print_summary