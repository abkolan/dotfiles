#!/usr/bin/env bash
# Functional Tests - Verify commands actually work, not just exist
# This tests real functionality, not just presence

source "$(dirname "$0")/../test-framework.sh"

start_component "Functional Command Tests"

# ===========================
# Helper Functions
# ===========================
create_test_directory() {
    local test_dir=$(mktemp -d "/tmp/dotfiles-func-test.XXXXX")
    cd "$test_dir"
    
    # Create test file structure
    mkdir -p project/{src,docs,tests}
    touch project/README.md
    touch project/src/{main.go,utils.go,config.yaml}
    touch project/docs/{api.md,guide.md}
    touch project/tests/{unit_test.go,integration_test.go}
    echo "package main" > project/src/main.go
    echo "# Test Project" > project/README.md
    
    echo "$test_dir"
}

cleanup_test_directory() {
    rm -rf "$1" 2>/dev/null
}

# ===========================
# Test Directory Navigation
# ===========================
echo ""
echo "  Testing directory navigation commands..."

TEST_DIR=$(create_test_directory)
cd "$TEST_DIR"

# Test 'll' command produces output with details
if output=$(zsh -i -c "ll project" 2>/dev/null); then
    if echo "$output" | grep -q "src" && echo "$output" | grep -q "docs"; then
        test_case "Command 'll' lists directories with details" "true"
    else
        test_case "Command 'll' lists directories with details" "false"
    fi
else
    test_case "Command 'll' executes successfully" "false"
fi

# Test 'la' shows hidden files
cd project
touch .hidden .gitignore
if output=$(zsh -i -c "la" 2>/dev/null); then
    if echo "$output" | grep -q ".hidden" && echo "$output" | grep -q ".gitignore"; then
        test_case "Command 'la' shows hidden files" "true"
    else
        test_case "Command 'la' shows hidden files" "false"
    fi
else
    test_case "Command 'la' executes successfully" "false"
fi

cleanup_test_directory "$TEST_DIR"

# ===========================
# Test FZF Integration
# ===========================
echo ""
echo "  Testing FZF integration..."

if command_exists fzf; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR/project"
    
    # Test fzf file finding (ff alias)
    # We'll simulate by checking the command expands correctly
    if zsh -i -c "type ff" 2>/dev/null | grep -q "fzf"; then
        test_case "FZF file finder (ff) is functional" "true"
        
        # Test that ff can actually find files
        if echo "main.go" | zsh -i -c "fzf" 2>/dev/null | grep -q "main.go"; then
            test_case "FZF can search and filter files" "true"
        else
            test_case "FZF can search and filter files" "false"
        fi
    else
        test_case "FZF file finder (ff) is functional" "false"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "FZF integration" "FZF not installed"
fi

# ===========================
# Test Git Aliases
# ===========================
echo ""
echo "  Testing git aliases functionality..."

if command_exists git; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR/project"
    
    # Initialize git repo
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Test git status alias
    if git_alias=$(git config --get alias.st 2>/dev/null); then
        # Run the actual alias
        git add README.md
        if output=$(git st 2>/dev/null); then
            if echo "$output" | grep -q "README.md"; then
                test_case "Git alias 'st' shows status correctly" "true"
            else
                test_case "Git alias 'st' shows status correctly" "false"
            fi
        else
            test_case "Git alias 'st' executes successfully" "false"
        fi
    else
        skip_test "Git alias 'st'" "Not configured"
    fi
    
    # Test git log alias if exists
    git commit -m "Initial commit" --quiet
    if git_alias=$(git config --get alias.lg 2>/dev/null); then
        if output=$(git lg -1 2>/dev/null); then
            if echo "$output" | grep -q "Initial commit"; then
                test_case "Git alias 'lg' shows formatted log" "true"
            else
                test_case "Git alias 'lg' shows formatted log" "false"
            fi
        else
            test_case "Git alias 'lg' executes successfully" "false"
        fi
    else
        skip_test "Git alias 'lg'" "Not configured"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "Git aliases" "Git not installed"
fi

# ===========================
# Test Editor Commands
# ===========================
echo ""
echo "  Testing editor commands..."

if command_exists nvim; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR/project"
    
    # Test 'v' alias opens nvim
    if zsh -i -c "type v" 2>/dev/null | grep -q "nvim"; then
        # Test nvim can open and exit cleanly
        if echo ':q' | zsh -i -c "v -" 2>/dev/null; then
            test_case "Editor alias 'v' launches nvim successfully" "true"
        else
            test_case "Editor alias 'v' launches nvim successfully" "false"
        fi
    else
        test_case "Editor alias 'v' points to nvim" "false"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "Editor commands" "Neovim not installed"
fi

# ===========================
# Test Modern CLI Tools
# ===========================
echo ""
echo "  Testing modern CLI tools..."

# Test ripgrep functionality
if command_exists rg; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR/project"
    
    echo "function testFunction() {}" > src/utils.go
    echo "const testConst = 42" >> src/utils.go
    
    if output=$(rg "testFunction" 2>/dev/null); then
        if echo "$output" | grep -q "utils.go"; then
            test_case "Ripgrep searches file contents correctly" "true"
        else
            test_case "Ripgrep searches file contents correctly" "false"
        fi
    else
        test_case "Ripgrep executes successfully" "false"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "Ripgrep functionality" "Not installed"
fi

# Test fd functionality
if command_exists fd; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR/project"
    
    if output=$(fd ".go$" 2>/dev/null); then
        if echo "$output" | grep -q "main.go" && echo "$output" | grep -q "utils.go"; then
            test_case "fd finds files by pattern correctly" "true"
        else
            test_case "fd finds files by pattern correctly" "false"
        fi
    else
        test_case "fd executes successfully" "false"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "fd functionality" "Not installed"
fi

# Test bat functionality
if command_exists bat; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR/project"
    
    if output=$(bat --plain README.md 2>/dev/null); then
        if echo "$output" | grep -q "Test Project"; then
            test_case "bat displays file contents correctly" "true"
        else
            test_case "bat displays file contents correctly" "false"
        fi
    else
        test_case "bat executes successfully" "false"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "bat functionality" "Not installed"
fi

# ===========================
# Test Shell Functions
# ===========================
echo ""
echo "  Testing custom shell functions..."

# Test mkcd function (make directory and cd into it)
if zsh -i -c "type mkcd" 2>/dev/null | grep -q "function"; then
    TEST_DIR=$(create_test_directory)
    cd "$TEST_DIR"
    
    # Run mkcd and check we're in the new directory
    if output=$(zsh -i -c "mkcd newdir && pwd" 2>/dev/null); then
        if echo "$output" | grep -q "newdir"; then
            test_case "Function 'mkcd' creates and enters directory" "true"
        else
            test_case "Function 'mkcd' creates and enters directory" "false"
        fi
    else
        test_case "Function 'mkcd' executes successfully" "false"
    fi
    
    cleanup_test_directory "$TEST_DIR"
else
    skip_test "mkcd function" "Not defined"
fi

# ===========================
# Test ZSH Features
# ===========================
echo ""
echo "  Testing ZSH-specific features..."

# Test command history works
TEST_DIR=$(create_test_directory)
cd "$TEST_DIR"

# Execute commands and test history
if zsh -i -c "echo 'test1'; echo 'test2'; history | tail -2" 2>/dev/null | grep -q "test1"; then
    test_case "ZSH history tracking works" "true"
else
    test_case "ZSH history tracking works" "false"
fi

# Test directory stack (pushd/popd)
if output=$(zsh -i -c "cd /tmp; pushd /var > /dev/null; popd > /dev/null; pwd" 2>/dev/null); then
    if echo "$output" | grep -q "/tmp"; then
        test_case "Directory stack (pushd/popd) works" "true"
    else
        test_case "Directory stack (pushd/popd) works" "false"
    fi
else
    test_case "Directory stack operations" "false"
fi

cleanup_test_directory "$TEST_DIR"

# ===========================
# Test Environment Variables
# ===========================
echo ""
echo "  Testing environment variables..."

# Test PATH includes expected directories
if output=$(zsh -i -c 'echo $PATH' 2>/dev/null); then
    if echo "$output" | grep -q "local/bin"; then
        test_case "PATH includes local/bin directory" "true"
    else
        test_case "PATH includes local/bin directory" "false"
    fi
else
    test_case "PATH variable accessible" "false"
fi

# Test EDITOR is set correctly
if output=$(zsh -i -c 'echo $EDITOR' 2>/dev/null); then
    if echo "$output" | grep -E -q "nvim|vim"; then
        test_case "EDITOR set to vim/nvim" "true"
    else
        test_case "EDITOR set to vim/nvim" "false"
    fi
else
    test_case "EDITOR variable accessible" "false"
fi

# Return test results
print_summary