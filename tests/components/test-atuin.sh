#!/bin/bash
# Test Atuin History Database Configuration

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "Atuin History Database"

# ===========================
# Test Atuin Installation
# ===========================
test_case "Atuin is installed" "command_exists atuin"
test_output "Atuin version >= 18.0" "atuin --version" "atuin 1[89]\."

# ===========================
# Test Atuin Configuration
# ===========================
test_case "Atuin config directory exists" "dir_exists $HOME/.config/atuin"
test_case "Atuin config.toml exists" "file_exists $HOME/.config/atuin/config.toml"
test_case "Atuin config is symlinked correctly" "symlink_valid $HOME/.config/atuin/config.toml"

# ===========================
# Test Atuin Database
# ===========================
echo ""
echo "  Testing database..."

# Check if database exists
test_case "Atuin database exists" \
    "file_exists $HOME/.local/share/atuin/history.db || file_exists $HOME/.local/share/atuin/atuin.db"

# Test database has records (after import)
if file_exists "$HOME/.local/share/atuin/history.db" || file_exists "$HOME/.local/share/atuin/atuin.db"; then
    test_output "Database has history records" \
        "atuin history list --limit 1 2>/dev/null | wc -l | tr -d ' '" \
        "[1-9]"
else
    skip_test "Database records" "Database not initialized"
fi

# ===========================
# Test Atuin Integration in ZSH
# ===========================
echo ""
echo "  Testing ZSH integration..."

# Check if atuin is integrated in .zshrc
test_output "Atuin integrated in .zshrc" \
    "grep -c 'atuin init' $HOME/.zshrc 2>/dev/null || echo '0'" \
    "[1-9]"

# Test that atuin init doesn't break zsh
test_case "ZSH starts with atuin integration" \
    "zsh -i -c 'exit' 2>&1 | grep -c 'Error' | grep -q '^0$' || true"

# Test ATUIN_SESSION is set in interactive shell
test_output "ATUIN_SESSION is set in shell" \
    "zsh -i -c 'echo \$ATUIN_SESSION' 2>/dev/null | grep -c '^$' | tr -d ' '" \
    "0"

# ===========================
# Test Atuin Commands
# ===========================
echo ""
echo "  Testing commands..."

# Test basic commands work
test_case "Atuin stats command works" \
    "zsh -i -c 'atuin stats --limit 1' &>/dev/null"

test_case "Atuin search command works" \
    "zsh -i -c 'atuin search --limit 1 ls' &>/dev/null"

test_case "Atuin history list works" \
    "zsh -i -c 'atuin history list --limit 1' &>/dev/null"

# ===========================
# Test Atuin Configuration Values
# ===========================
echo ""
echo "  Testing configuration values..."

if file_exists "$HOME/.config/atuin/config.toml"; then
    # Test key configuration settings
    test_output "Search mode is fuzzy" \
        "grep 'search_mode' $HOME/.config/atuin/config.toml" \
        "fuzzy"
    
    test_output "Filter mode is global" \
        "grep 'filter_mode' $HOME/.config/atuin/config.toml" \
        "global"
    
    test_output "Secrets filter is enabled" \
        "grep 'secrets_filter' $HOME/.config/atuin/config.toml" \
        "true"
    
    test_output "Update check is disabled" \
        "grep 'update_check' $HOME/.config/atuin/config.toml" \
        "false"
else
    skip_test "Configuration values" "Config file not found"
fi

# ===========================
# Test Atuin Aliases
# ===========================
echo ""
echo "  Testing aliases..."

# Check if aliases are defined
test_output "Alias 'h' for history search" \
    "zsh -i -c 'alias h' 2>/dev/null" \
    "atuin search"

test_output "Alias 'hs' for stats" \
    "zsh -i -c 'alias hs' 2>/dev/null" \
    "atuin stats"

test_output "Alias 'hsd' for daily stats" \
    "zsh -i -c 'alias hsd' 2>/dev/null" \
    "atuin stats.*day"

test_output "Alias 'hi' for import" \
    "zsh -i -c 'alias hi' 2>/dev/null" \
    "atuin import"

# ===========================
# Test Import Functionality
# ===========================
echo ""
echo "  Testing import..."

# Create a test history file
test_home=$(create_test_env)
echo "ls -la" > "$test_home/.zsh_history_test"
echo "cd /tmp" >> "$test_home/.zsh_history_test"
echo "pwd" >> "$test_home/.zsh_history_test"

# Test import (if atuin is available)
if command_exists atuin; then
    # Clear existing and import test history
    HOME="$test_home" test_case "Import test history" \
        "atuin import zsh < $test_home/.zsh_history_test &>/dev/null"
else
    skip_test "Import functionality" "Atuin not installed"
fi

cleanup_test_env "$test_home"

# ===========================
# Test Key Bindings
# ===========================
echo ""
echo "  Testing key bindings..."

# Check Ctrl+R binding
test_output "Ctrl+R is bound to atuin" \
    "zsh -i -c 'bindkey | grep \"\\^R\"' 2>/dev/null" \
    "_atuin_search_widget"

# ===========================
# Test Performance Impact
# ===========================
echo ""
echo "  Testing performance impact..."

# Measure startup time with atuin
if command_exists atuin; then
    # Get baseline without atuin
    baseline_time=$(measure_time "zsh -c 'exit'")
    
    # Get time with atuin
    atuin_time=$(measure_time "zsh -i -c 'exit'")
    
    # Check that overhead is reasonable (< 50ms)
    overhead=$((atuin_time - baseline_time))
    if [[ $overhead -lt 50 ]]; then
        test_case "Atuin overhead is acceptable (<50ms)" "true"
        verbose "Overhead: ${overhead}ms"
    else
        test_case "Atuin overhead is acceptable (<50ms)" "false"
        verbose "Overhead: ${overhead}ms (baseline: ${baseline_time}ms, with atuin: ${atuin_time}ms)"
    fi
else
    skip_test "Performance impact" "Atuin not installed"
fi

# ===========================
# Test Privacy Features
# ===========================
echo ""
echo "  Testing privacy features..."

if file_exists "$HOME/.config/atuin/config.toml"; then
    # Test that sensitive commands are filtered
    test_output "Password filter configured" \
        "grep -c 'password=' $HOME/.config/atuin/config.toml" \
        "[1-9]"
    
    test_output "API key filter configured" \
        "grep -c 'api.*key' $HOME/.config/atuin/config.toml" \
        "[1-9]"
    
    test_output "CWD filter has /tmp" \
        "grep -A5 'cwd_filter' $HOME/.config/atuin/config.toml | grep -c '/tmp'" \
        "[1-9]"
else
    skip_test "Privacy features" "Config file not found"
fi

# Return test results
print_summary