#!/usr/bin/env bash
# Negative Tests - Verify system handles errors gracefully
# Tests recovery, error messages, and edge cases

source "$(dirname "$0")/../test-framework.sh"

start_component "Error Handling & Recovery Tests"

# ===========================
# Helper Functions
# ===========================
backup_file() {
    if [[ -f "$1" ]]; then
        cp "$1" "$1.backup.$$"
        echo "$1.backup.$$"
    fi
}

restore_file() {
    if [[ -f "$1" ]]; then
        mv "$1" "${1%.backup.*}"
    fi
}

create_corrupt_config() {
    echo "#!/bin/bash" > "$1"
    echo "This is intentionally broken syntax {{{" >> "$1"
    echo "unclosed quote'" >> "$1"
    echo "!@#$%^&*()" >> "$1"
}

# ===========================
# Test Corrupted Configurations
# ===========================
echo ""
echo "  Testing handling of corrupted configs..."

# Test ZSH with syntax errors
TEST_ZSHRC="$HOME/.zshrc.test"
create_corrupt_config "$TEST_ZSHRC"

if output=$(zsh -n "$TEST_ZSHRC" 2>&1); then
    test_case "ZSH detects syntax errors" "false"
else
    # Should fail - that's what we want
    test_case "ZSH detects syntax errors" "true"
    
    # Check error message is helpful
    if echo "$output" | grep -q "syntax error\|parse error"; then
        test_case "ZSH provides helpful error messages" "true"
    else
        test_case "ZSH provides helpful error messages" "false"
    fi
fi
rm -f "$TEST_ZSHRC"

# ===========================
# Test Missing Dependencies
# ===========================
echo ""
echo "  Testing missing dependency handling..."

# Test what happens when a required tool is missing
# Simulate by checking for a non-existent command
if output=$(zsh -i -c "fake_command_that_doesnt_exist" 2>&1); then
    test_case "Shell handles missing commands gracefully" "false"
else
    # Should fail, check if error is clear
    if echo "$output" | grep -q "command not found\|not found"; then
        test_case "Missing command error is clear" "true"
    else
        test_case "Missing command error is clear" "false"
    fi
fi

# ===========================
# Test Stow Conflicts
# ===========================
echo ""
echo "  Testing GNU Stow conflict handling..."

TEST_DIR=$(mktemp -d "/tmp/stow-test.XXXXX")
cd "$TEST_DIR"

# Create a dotfiles structure
mkdir -p dotfiles/test/.config
echo "test content" > dotfiles/test/.config/testfile

# Create conflicting file
mkdir -p .config
echo "existing content" > .config/testfile

# Try to stow - should detect conflict
if output=$(stow -d dotfiles test 2>&1); then
    test_case "Stow detects file conflicts" "false"
else
    # Should fail due to conflict
    if echo "$output" | grep -q "conflict\|existing"; then
        test_case "Stow reports conflicts clearly" "true"
    else
        test_case "Stow reports conflicts clearly" "false"
    fi
fi

# Test stow with --adopt (should resolve conflict)
if stow -d dotfiles --adopt test 2>/dev/null; then
    test_case "Stow --adopt resolves conflicts" "true"
else
    test_case "Stow --adopt resolves conflicts" "false"
fi

cd - > /dev/null
rm -rf "$TEST_DIR"

# ===========================
# Test Partial Installation Recovery
# ===========================
echo ""
echo "  Testing partial installation recovery..."

TEST_DIR=$(mktemp -d "/tmp/partial-install.XXXXX")
ORIG_HOME="$HOME"
export HOME="$TEST_DIR"

# Simulate partial installation
mkdir -p "$HOME/.local/share/zinit"
touch "$HOME/.zshrc"
# Don't create .gitconfig - simulating partial install

# Check if setup script handles partial state
cd "$ORIG_HOME/dotfiles" 2>/dev/null || cd "$(dirname "$(dirname "$0")")"
if [[ -f "setup.sh" ]]; then
    # Run setup in test environment (dry run)
    if FORCE_COLOR=0 bash setup.sh 2>&1 | grep -q "already\|exists\|skip"; then
        test_case "Setup handles partial installations" "true"
    else
        test_case "Setup handles partial installations" "false"
    fi
else
    skip_test "Partial installation recovery" "setup.sh not found"
fi

export HOME="$ORIG_HOME"
rm -rf "$TEST_DIR"

# ===========================
# Test Permission Issues
# ===========================
echo ""
echo "  Testing permission error handling..."

TEST_DIR=$(mktemp -d "/tmp/perm-test.XXXXX")
cd "$TEST_DIR"

# Create read-only directory
mkdir readonly_dir
chmod 444 readonly_dir

# Try to write to read-only directory
if output=$(touch readonly_dir/testfile 2>&1); then
    test_case "System detects permission issues" "false"
else
    # Should fail with permission error
    if echo "$output" | grep -q "permission denied\|Permission denied"; then
        test_case "Permission errors are clear" "true"
    else
        test_case "Permission errors are clear" "false"
    fi
fi

chmod 755 readonly_dir
cd - > /dev/null
rm -rf "$TEST_DIR"

# ===========================
# Test Resource Limits
# ===========================
echo ""
echo "  Testing resource limit handling..."

# Test with extremely long PATH
ORIGINAL_PATH="$PATH"
LONG_PATH="$PATH"
for i in {1..100}; do
    LONG_PATH="$LONG_PATH:/fake/path/$i"
done

export PATH="$LONG_PATH"
if zsh -i -c "echo 'test'" 2>/dev/null | grep -q "test"; then
    test_case "Shell handles long PATH variable" "true"
else
    test_case "Shell handles long PATH variable" "false"
fi
export PATH="$ORIGINAL_PATH"

# Test deeply nested directory
TEST_DIR=$(mktemp -d "/tmp/nested-test.XXXXX")
NESTED_PATH="$TEST_DIR"
for i in {1..50}; do
    NESTED_PATH="$NESTED_PATH/level$i"
done
mkdir -p "$NESTED_PATH" 2>/dev/null

if cd "$NESTED_PATH" 2>/dev/null; then
    test_case "Shell handles deeply nested directories" "true"
    cd - > /dev/null
else
    test_case "Shell handles deeply nested directories" "false"
fi
rm -rf "$TEST_DIR"

# ===========================
# Test Circular Symlinks
# ===========================
echo ""
echo "  Testing circular symlink handling..."

TEST_DIR=$(mktemp -d "/tmp/symlink-test.XXXXX")
cd "$TEST_DIR"

# Create circular symlinks
ln -s link2 link1
ln -s link1 link2

# Test if commands handle circular links gracefully
if timeout 2 ls -la link1 2>&1 | grep -q "link1 -> link2"; then
    test_case "System detects circular symlinks" "true"
else
    test_case "System detects circular symlinks" "false"
fi

cd - > /dev/null
rm -rf "$TEST_DIR"

# ===========================
# Test Disk Space Issues
# ===========================
echo ""
echo "  Testing disk space error handling..."

# Try to create a file in /dev/full (always reports disk full)
if [[ -e /dev/full ]]; then
    if output=$(echo "test" > /dev/full 2>&1); then
        test_case "System detects disk full errors" "false"
    else
        if echo "$output" | grep -q "No space left\|disk full"; then
            test_case "Disk full errors are clear" "true"
        else
            test_case "Disk full errors are clear" "false"
        fi
    fi
else
    skip_test "Disk space handling" "/dev/full not available"
fi

# ===========================
# Test Network Failures
# ===========================
echo ""
echo "  Testing network failure handling..."

# Test git clone with invalid URL
if output=$(git clone https://invalid.fake.url.that.does.not.exist/repo.git 2>&1); then
    test_case "Git handles invalid URLs" "false"
else
    # Should fail
    if echo "$output" | grep -q "unable to access\|Could not resolve\|failed"; then
        test_case "Network errors are reported clearly" "true"
    else
        test_case "Network errors are reported clearly" "false"
    fi
fi

# ===========================
# Test Signal Handling
# ===========================
echo ""
echo "  Testing signal handling..."

# Test SIGINT handling
(
    sleep 10 &
    SLEEP_PID=$!
    sleep 0.1
    kill -INT $SLEEP_PID 2>/dev/null
    wait $SLEEP_PID 2>/dev/null
    EXIT_CODE=$?
    if [[ $EXIT_CODE -eq 130 ]] || [[ $EXIT_CODE -eq 2 ]]; then
        echo "SIGINT handled correctly"
        exit 0
    else
        exit 1
    fi
) 2>/dev/null

if [[ $? -eq 0 ]]; then
    test_case "SIGINT (Ctrl+C) handled properly" "true"
else
    test_case "SIGINT (Ctrl+C) handled properly" "false"
fi

# ===========================
# Test Unicode Handling
# ===========================
echo ""
echo "  Testing unicode and special character handling..."

TEST_DIR=$(mktemp -d "/tmp/unicode-test.XXXXX")
cd "$TEST_DIR"

# Create files with unicode names
touch "文件.txt" "файл.txt" "αρχείο.txt" "🚀.txt" 2>/dev/null

if ls *.txt 2>/dev/null | grep -q "🚀"; then
    test_case "Shell handles unicode filenames" "true"
else
    test_case "Shell handles unicode filenames" "false"
fi

cd - > /dev/null
rm -rf "$TEST_DIR"

# Return test results
print_summary