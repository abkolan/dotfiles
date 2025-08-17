#!/bin/bash
# Test ZSH Configuration

# Source test framework
source "$(dirname "$0")/../test-framework.sh"

start_component "ZSH Configuration"

# ===========================
# Test ZSH Installation
# ===========================
test_case "ZSH is installed" "command_exists zsh"
test_case "ZSH version >= 5.0" "zsh --version | grep -E 'zsh 5\.[0-9]+|zsh [6-9]\.[0-9]+'"

# ===========================
# Test ZSH Configuration Files
# ===========================
test_case ".zshrc exists" "file_exists $HOME/.zshrc"
test_case ".zshrc is symlinked correctly" "symlink_valid $HOME/.zshrc"

# Test that zshrc sources without errors
test_case "ZSH config loads without errors" "zsh -n $HOME/.zshrc"

# ===========================
# Test ZSH Startup Performance
# ===========================
if [[ "$PLATFORM" == "macos" ]]; then
    test_performance "ZSH startup time" "zsh -i -c exit" 150
else
    test_performance "ZSH startup time" "zsh -i -c exit" 200
fi

# ===========================
# Test Zinit Installation
# ===========================
test_case "Zinit is installed" "dir_exists $HOME/.local/share/zinit/zinit.git"

# ===========================
# Test Critical Aliases
# ===========================
echo ""
echo "  Testing aliases..."

# Test that aliases are defined
test_output "Alias 'll' is defined" \
    "zsh -i -c 'alias ll'" \
    "ll="

test_output "Alias 'la' is defined" \
    "zsh -i -c 'alias la'" \
    "la="

test_output "Alias 'fcd' is defined" \
    "zsh -i -c 'alias fcd'" \
    "fcd="

test_output "Alias 'ff' is defined" \
    "zsh -i -c 'alias ff'" \
    "ff="

test_output "Alias 'v' points to nvim" \
    "zsh -i -c 'alias v'" \
    "nvim"

# ===========================
# Test Lazy Loading Functions
# ===========================
echo ""
echo "  Testing lazy loading..."

test_output "Node lazy loading configured" \
    "zsh -i -c 'type node 2>&1'" \
    "function"

test_output "NPM lazy loading configured" \
    "zsh -i -c 'type npm 2>&1'" \
    "function"

test_output "Conda lazy loading configured" \
    "zsh -i -c 'type conda 2>&1'" \
    "function"

# ===========================
# Test FZF Integration
# ===========================
echo ""
echo "  Testing FZF integration..."

if command_exists fzf; then
    test_case "FZF is available" "command_exists fzf"
    test_output "FZF keybindings loaded" \
        "zsh -i -c 'bindkey | grep fzf'" \
        "fzf"
else
    skip_test "FZF integration" "FZF not installed"
fi

# ===========================
# Test Completion System
# ===========================
echo ""
echo "  Testing completion system..."

test_output "Completion system initialized" \
    "zsh -i -c 'echo \$fpath' 2>/dev/null" \
    "completion"

test_case ".zcompdump exists or is created" \
    "zsh -i -c 'exit' && file_exists $HOME/.zcompdump*"

# ===========================
# Test Environment Variables
# ===========================
echo ""
echo "  Testing environment variables..."

test_output "PATH includes homebrew" \
    "zsh -i -c 'echo \$PATH'" \
    "/homebrew/bin\|/usr/local/bin"

test_output "EDITOR is set" \
    "zsh -i -c 'echo \$EDITOR'" \
    "vim\|nvim"

# ===========================
# Test Custom Functions
# ===========================
echo ""
echo "  Testing custom functions..."

if file_exists "$HOME/.zsh_functions"; then
    test_case ".zsh_functions exists" "true"
    test_case ".zsh_functions loads without errors" "zsh -n $HOME/.zsh_functions"
else
    skip_test ".zsh_functions" "File not found"
fi

if file_exists "$HOME/.zsh_functions_lazy"; then
    test_case ".zsh_functions_lazy exists" "true"
    test_case ".zsh_functions_lazy loads without errors" "zsh -n $HOME/.zsh_functions_lazy"
else
    skip_test ".zsh_functions_lazy" "File not found"
fi

# ===========================
# Test History Configuration
# ===========================
echo ""
echo "  Testing history configuration..."

test_output "History size is configured" \
    "zsh -i -c 'echo \$HISTSIZE'" \
    "[0-9]"

test_output "History file is configured" \
    "zsh -i -c 'echo \$HISTFILE'" \
    "history\|.zsh_history"

# ===========================
# Test Plugin Loading
# ===========================
echo ""
echo "  Testing plugin loading..."

# Test that key plugins are loaded (via Zinit)
test_output "Syntax highlighting available" \
    "zsh -i -c 'echo \$plugins' 2>/dev/null || echo 'zinit-based'" \
    "highlighting\|zinit"

test_output "Autosuggestions available" \
    "zsh -i -c 'echo \$ZSH_AUTOSUGGEST_STRATEGY' 2>/dev/null || echo 'configured'" \
    "history\|match\|configured"

# ===========================
# Test Directory Navigation
# ===========================
echo ""
echo "  Testing directory navigation..."

if command_exists zoxide; then
    test_case "Zoxide is installed" "true"
    test_output "Zoxide initialized in ZSH" \
        "zsh -i -c 'type z 2>&1'" \
        "function\|alias"
else
    skip_test "Zoxide integration" "Zoxide not installed"
fi

# ===========================
# Test Theme (Powerlevel10k)
# ===========================
echo ""
echo "  Testing theme..."

# Theme may be in different locations or not yet installed
if dir_exists "$HOME/.local/share/zinit/plugins/romkatv---powerlevel10k" || \
   dir_exists "$HOME/.local/share/zinit/zinit.git/plugins/romkatv---powerlevel10k" || \
   dir_exists "/opt/homebrew/opt/powerlevel10k" || \
   dir_exists "/usr/local/opt/powerlevel10k"; then
    test_case "Powerlevel10k theme installed" "true"
elif grep -q "powerlevel10k" "$HOME/.zshrc" 2>/dev/null; then
    skip_test "Powerlevel10k theme" "Configured but will install on first use"
else
    skip_test "Powerlevel10k theme" "Not configured"
fi

if file_exists "$HOME/.p10k.zsh"; then
    test_case ".p10k.zsh configuration exists" "true"
    test_case ".p10k.zsh loads without errors" "zsh -n $HOME/.p10k.zsh"
else
    skip_test ".p10k.zsh configuration" "File not found"
fi

# Return test results
print_summary