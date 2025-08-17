#!/usr/bin/env bash
# Integration Test - Simulates a fresh git clone on a new system

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}         INTEGRATION TEST: Fresh System Installation            ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Create a temporary test environment
TEST_DIR=$(mktemp -d "/tmp/dotfiles-integration-test.XXXXX")
echo -e "${YELLOW}Test directory:${NC} $TEST_DIR"

# Save current directory
ORIGINAL_DIR=$(pwd)

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Cleaning up test environment...${NC}"
    cd "$ORIGINAL_DIR"
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# Simulate a fresh git clone
echo -e "\n${CYAN}Step 1: Simulating fresh git clone...${NC}"
cp -r . "$TEST_DIR/dotfiles"
cd "$TEST_DIR/dotfiles"

# Remove any existing symlinks or test artifacts
find "$TEST_DIR/dotfiles" -type l -delete 2>/dev/null || true
rm -rf "$TEST_DIR/dotfiles/.git" 2>/dev/null || true

# Create a fake HOME for testing
export TEST_HOME="$TEST_DIR/home"
mkdir -p "$TEST_HOME"
export ORIGINAL_HOME="$HOME"
export HOME="$TEST_HOME"

echo -e "${GREEN}✓${NC} Fresh clone simulated"

# Run the setup script
echo -e "\n${CYAN}Step 2: Running setup.sh...${NC}"
if [[ -f "setup.sh" ]]; then
    # Run setup in non-interactive mode
    bash setup.sh
    SETUP_RESULT=$?
else
    echo -e "${RED}✗${NC} setup.sh not found!"
    exit 1
fi

if [[ $SETUP_RESULT -eq 0 ]]; then
    echo -e "${GREEN}✓${NC} Setup completed successfully"
else
    echo -e "${RED}✗${NC} Setup failed with exit code: $SETUP_RESULT"
    exit 1
fi

# Verify installation
echo -e "\n${CYAN}Step 3: Verifying installation...${NC}"

TESTS_PASSED=0
TESTS_FAILED=0

# Check if essential files are symlinked
check_file() {
    local file=$1
    local description=$2
    
    if [[ -e "$HOME/$file" ]]; then
        echo -e "  ${GREEN}✓${NC} $description"
        ((TESTS_PASSED++))
    else
        echo -e "  ${RED}✗${NC} $description"
        ((TESTS_FAILED++))
    fi
}

check_dir() {
    local dir=$1
    local description=$2
    
    if [[ -d "$HOME/$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $description"
        ((TESTS_PASSED++))
    else
        echo -e "  ${RED}✗${NC} $description"
        ((TESTS_FAILED++))
    fi
}

# Check installations
echo -e "\n${YELLOW}Checking dotfile installations:${NC}"
check_file ".zshrc" "ZSH configuration installed"
check_file ".gitconfig" "Git configuration installed"
check_dir ".config/nvim" "Neovim configuration installed"
check_file ".p10k.zsh" "Powerlevel10k configuration installed"

echo -e "\n${YELLOW}Checking tool installations:${NC}"
check_dir ".local/share/zinit/zinit.git" "Zinit plugin manager installed"

# Check if configs load without errors
echo -e "\n${YELLOW}Checking configuration validity:${NC}"

if zsh -n "$HOME/.zshrc" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} ZSH config syntax valid"
    ((TESTS_PASSED++))
else
    echo -e "  ${RED}✗${NC} ZSH config has syntax errors"
    ((TESTS_FAILED++))
fi

# Summary
echo -e "\n${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                     TEST SUMMARY                               ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "  Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "  Tests Failed: ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}✅ Integration test PASSED!${NC}"
    echo -e "${GREEN}Fresh installation works perfectly!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Integration test FAILED${NC}"
    echo -e "${RED}Some components did not install correctly${NC}"
    exit 1
fi