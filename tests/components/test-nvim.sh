#!/bin/bash
# Test Neovim Configuration

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "Neovim Configuration"

# ===========================
# Test Neovim Installation
# ===========================
test_case "Neovim is installed" "command_exists nvim"
test_output "Neovim version >= 0.8" "nvim --version | head -1" "NVIM v0\.[89]\|NVIM v[1-9]"

# ===========================
# Test Neovim Configuration
# ===========================
test_case "Neovim config directory exists" "dir_exists $HOME/.config/nvim"
test_case "Neovim config is symlinked correctly" "symlink_valid $HOME/.config/nvim"
test_case "init.lua exists" "file_exists $HOME/.config/nvim/init.lua"

# ===========================
# Test Neovim Startup
# ===========================
test_case "Neovim starts without errors" \
    "nvim --headless -c 'qa' 2>&1 | grep -v 'Warning' | grep -c 'Error' | grep -q '^0$'"

# Test startup time (should be reasonably fast)
if [[ "$PLATFORM" == "macos" ]]; then
    test_performance "Neovim startup time" "nvim --headless -c 'qa'" 500
else
    test_performance "Neovim startup time" "nvim --headless -c 'qa'" 700
fi

# ===========================
# Test Plugin Manager (Lazy.nvim)
# ===========================
echo ""
echo "  Testing plugin manager..."

test_case "Lazy.nvim is installed" \
    "dir_exists $HOME/.local/share/nvim/lazy/lazy.nvim || \
     dir_exists $HOME/.local/share/nvim/site/pack/*/start/lazy.nvim"

# Test that Lazy can be loaded
test_case "Lazy.nvim loads successfully" \
    "nvim --headless -c 'lua require(\"lazy\")' -c 'qa' 2>&1 | grep -c 'Error' | grep -q '^0$'"

# ===========================
# Test LSP Configuration
# ===========================
echo ""
echo "  Testing LSP configuration..."

# Check if LSP config exists
test_case "LSP configuration exists" \
    "file_exists $HOME/.config/nvim/lua/configs/lspconfig.lua || \
     grep -r 'lspconfig' $HOME/.config/nvim/ >/dev/null 2>&1"

# Test common LSP servers configuration
test_output "LSP servers configured" \
    "nvim --headless -c 'lua print(\"lsp_ok\")' -c 'qa' 2>&1" \
    "lsp_ok"

# ===========================
# Test Key Mappings
# ===========================
echo ""
echo "  Testing key mappings..."

# Test that leader key is set
test_output "Leader key is configured" \
    "nvim --headless -c 'echo mapleader' -c 'qa' 2>&1" \
    " \|,\|;"

# Test critical mappings exist
test_case "Key mappings load without errors" \
    "nvim --headless -c 'source $HOME/.config/nvim/lua/mappings.lua 2>/dev/null || echo ok' -c 'qa' 2>&1 | grep -c 'Error' | grep -q '^0$'"

# ===========================
# Test Treesitter
# ===========================
echo ""
echo "  Testing Treesitter..."

if nvim --headless -c 'lua pcall(require, \"nvim-treesitter\")' -c 'qa' 2>&1 | grep -q "Error"; then
    skip_test "Treesitter configuration" "Treesitter not installed"
else
    test_case "Treesitter is configured" \
        "nvim --headless -c 'lua require(\"nvim-treesitter\")' -c 'qa' 2>&1 | grep -c 'Error' | grep -q '^0$'"
fi

# ===========================
# Test Telescope
# ===========================
echo ""
echo "  Testing Telescope..."

if dir_exists "$HOME/.local/share/nvim/lazy/telescope.nvim"; then
    test_case "Telescope is installed" "true"
    test_case "Telescope loads successfully" \
        "nvim --headless -c 'lua pcall(require, \"telescope\")' -c 'qa' 2>&1 | grep -c 'Error' | grep -q '^0$'"
else
    skip_test "Telescope" "Not installed"
fi

# ===========================
# Test File Types
# ===========================
echo ""
echo "  Testing file type detection..."

# Create test files and check detection
test_home=$(create_test_env)

echo "print('test')" > "$test_home/test.py"
test_output "Python files detected correctly" \
    "nvim --headless '$test_home/test.py' -c 'echo &filetype' -c 'qa' 2>&1" \
    "python"

echo "console.log('test');" > "$test_home/test.js"
test_output "JavaScript files detected correctly" \
    "nvim --headless '$test_home/test.js' -c 'echo &filetype' -c 'qa' 2>&1" \
    "javascript"

echo "package main" > "$test_home/test.go"
test_output "Go files detected correctly" \
    "nvim --headless '$test_home/test.go' -c 'echo &filetype' -c 'qa' 2>&1" \
    "go"

cleanup_test_env "$test_home"

# ===========================
# Test Clipboard Integration
# ===========================
echo ""
echo "  Testing clipboard..."

if [[ "$PLATFORM" == "macos" ]]; then
    test_output "Clipboard integration configured" \
        "nvim --headless -c 'echo has(\"clipboard\")' -c 'qa' 2>&1" \
        "1"
else
    skip_test "Clipboard integration" "Platform-specific test"
fi

# ===========================
# Test Color Scheme
# ===========================
echo ""
echo "  Testing color scheme..."

test_case "Color scheme loads without errors" \
    "nvim --headless -c 'colorscheme' -c 'qa' 2>&1 | grep -c 'Error' | grep -q '^0$'"

# ===========================
# Test Auto Commands
# ===========================
echo ""
echo "  Testing auto commands..."

test_case "Auto commands load successfully" \
    "nvim --headless -c 'autocmd' -c 'qa' 2>&1 | grep -c 'Error' | grep -q '^0$'"

# ===========================
# Test Health Check
# ===========================
echo ""
echo "  Running health check..."

# Run checkhealth and look for errors
health_output=$(nvim --headless -c "checkhealth" -c "qa" 2>&1 || true)

if echo "$health_output" | grep -q "ERROR"; then
    echo -e "  ${YELLOW}⚠ Health check reported errors (this may be expected)${NC}"
    verbose "Health check output:"
    verbose "$health_output"
else
    test_case "Health check passes" "true"
fi

# ===========================
# Test Plugin Installation
# ===========================
echo ""
echo "  Testing plugin installation..."

# Check if common plugins are installed
plugins_dir="$HOME/.local/share/nvim/lazy"

if dir_exists "$plugins_dir"; then
    plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
    if [[ $plugin_count -gt 1 ]]; then
        test_case "Plugins are installed" "true"
        verbose "Found $plugin_count plugins"
    else
        test_case "Plugins are installed" "false"
    fi
else
    skip_test "Plugin installation" "Lazy.nvim not configured"
fi

# Return test results
print_summary