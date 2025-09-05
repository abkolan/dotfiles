#!/bin/bash
# Test Git Configuration

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "Git Configuration"

# --- Configuration ---
GITCONFIG_PATH="$(dirname "$0")/../../git/.gitconfig"

# --- Pre-flight Checks ---
test_case "Git is installed" "command_exists git"
test_case ".gitconfig exists in repo" "[[ -f '$GITCONFIG_PATH' ]]"

# --- Main Test Logic ---

# Check for the presence of key configuration sections and values
# This is more robust for a template repo than checking for specific values.
test_output "User section is configured" "grep '\[user\]' '$GITCONFIG_PATH'" "\[user\]"
test_output "Name is present" "grep 'name =' '$GITCONFIG_PATH'" "name ="
test_output "Email is present" "grep 'email =' '$GITCONFIG_PATH'" "email ="

test_output "Alias section is configured" "grep '\[alias\]' '$GITCONFIG_PATH'" "\[alias\]"
test_output "Pull section is configured" "grep '\[pull\]' '$GITCONFIG_PATH'" "\[pull\]"
test_output "Rebase setting is present" "grep 'rebase =' '$GITCONFIG_PATH'" "rebase ="

# --- Integration Test ---
echo ""
echo "  Testing git integration..."

# Create a temporary repo to test if git commands can run with the config
test_repo=$(create_test_env)
cd "$test_repo" || exit 1

# Initialize repo and use the repo's gitconfig
git init --quiet
git config --local include.path "$GITCONFIG_PATH"
# Temporarily set user info to allow commits
git config --local user.name "Test User"
git config --local user.email "test@example.com"

echo "test" > test.txt
git add test.txt

# Test that a commit can be made with the configuration applied
test_case "Git commit works with repo config" "git commit -m 'Test commit' --quiet"

# Cleanup
cd - > /dev/null
cleanup_test_env "$test_repo"

# --- Final Summary ---
print_summary