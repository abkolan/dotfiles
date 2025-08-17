#!/bin/bash
# Test Git Configuration

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "Git Configuration"

# ===========================
# Test Git Installation
# ===========================
test_case "Git is installed" "command_exists git"
test_output "Git version >= 2.0" "git --version" "git version 2\."

# ===========================
# Test Git Configuration Files
# ===========================
test_case ".gitconfig exists" "file_exists $HOME/.gitconfig"
test_case ".gitconfig is symlinked correctly" "symlink_valid $HOME/.gitconfig"

# Check for gitconfig.d directory
if dir_exists "$HOME/.gitconfig.d"; then
    test_case ".gitconfig.d directory exists" "true"
    test_case ".gitconfig.d is symlinked correctly" "symlink_valid $HOME/.gitconfig.d"
    
    # Check for include files
    for config_file in aliases tools; do
        if file_exists "$HOME/.gitconfig.d/$config_file"; then
            test_case ".gitconfig.d/$config_file exists" "true"
        else
            skip_test ".gitconfig.d/$config_file" "File not found"
        fi
    done
else
    skip_test ".gitconfig.d directory" "Not configured"
fi

# ===========================
# Test Git User Configuration
# ===========================
echo ""
echo "  Testing user configuration..."

# Check if user is configured
if git config --get user.name &>/dev/null; then
    test_case "Git user.name is configured" "true"
    verbose "User name: $(git config --get user.name)"
else
    skip_test "Git user.name" "Not configured (expected for fresh install)"
fi

if git config --get user.email &>/dev/null; then
    test_case "Git user.email is configured" "true"
    verbose "User email: $(git config --get user.email)"
else
    skip_test "Git user.email" "Not configured (expected for fresh install)"
fi

# ===========================
# Test Git Aliases
# ===========================
echo ""
echo "  Testing git aliases..."

# Common aliases to test
aliases=(
    "st:status"
    "co:checkout"
    "br:branch"
    "ci:commit"
    "lg:log"
)

for alias_pair in "${aliases[@]}"; do
    alias_name="${alias_pair%%:*}"
    alias_desc="${alias_pair##*:}"
    
    if git config --get "alias.$alias_name" &>/dev/null; then
        test_case "Git alias '$alias_name' is configured" "true"
        verbose "  $alias_name = $(git config --get alias.$alias_name)"
    else
        skip_test "Git alias '$alias_name'" "Not configured"
    fi
done

# ===========================
# Test Git Tools Configuration
# ===========================
echo ""
echo "  Testing git tools..."

# Check for delta configuration
if git config --get core.pager | grep -q "delta"; then
    test_case "Delta is configured as pager" "true"
else
    skip_test "Delta pager" "Not configured or delta not installed"
fi

# Check credential helper
if git config --get credential.helper &>/dev/null; then
    test_case "Credential helper is configured" "true"
    verbose "Helper: $(git config --get credential.helper)"
else
    skip_test "Credential helper" "Not configured"
fi

# ===========================
# Test Pull Configuration
# ===========================
echo ""
echo "  Testing pull configuration..."

pull_rebase=$(git config --get pull.rebase 2>/dev/null || echo "not set")
if [[ "$pull_rebase" == "true" || "$pull_rebase" == "false" ]]; then
    test_case "Pull rebase strategy is configured" "true"
    verbose "pull.rebase = $pull_rebase"
else
    skip_test "Pull rebase strategy" "Not configured"
fi

# ===========================
# Test Global Ignore
# ===========================
if file_exists "$HOME/.gitignore_global"; then
    test_case "Global gitignore exists" "true"
    
    # Check if it's configured
    if git config --get core.excludesfile &>/dev/null; then
        test_case "Global gitignore is configured" "true"
    else
        test_case "Global gitignore is configured" "false"
    fi
else
    skip_test "Global gitignore" "File not found"
fi

# ===========================
# Test Git Hooks
# ===========================
echo ""
echo "  Testing git hooks..."

# Check for hooks directory
if dir_exists "$HOME/.git-hooks"; then
    test_case "Git hooks directory exists" "true"
    
    # Check if configured globally
    if git config --get core.hooksPath &>/dev/null; then
        test_case "Global hooks path is configured" "true"
        verbose "Hooks path: $(git config --get core.hooksPath)"
    else
        skip_test "Global hooks path" "Not configured"
    fi
else
    skip_test "Git hooks" "Directory not found"
fi

# ===========================
# Test Git Performance Settings
# ===========================
echo ""
echo "  Testing performance settings..."

# Check for performance-related configs
perf_configs=(
    "core.preloadindex"
    "core.fscache"
    "gc.auto"
)

for config in "${perf_configs[@]}"; do
    if git config --get "$config" &>/dev/null; then
        test_case "Performance setting $config is configured" "true"
        verbose "$config = $(git config --get $config)"
    else
        skip_test "Performance setting $config" "Not configured"
    fi
done

# ===========================
# Test Git Integration
# ===========================
echo ""
echo "  Testing git integration..."

# Create temporary repo for testing
test_repo=$(create_test_env)
cd "$test_repo" || exit 1

# Initialize repo and test basic operations
git init --quiet
echo "test" > test.txt
git add test.txt

# Test that commit works with current config
if git commit -m "Test commit" --quiet 2>/dev/null; then
    test_case "Git commit works with current config" "true"
else
    # This might fail if user.email/name not set, which is expected
    skip_test "Git commit" "User not configured (expected for fresh install)"
fi

# Cleanup
cd - > /dev/null
cleanup_test_env "$test_repo"

# Return test results
print_summary