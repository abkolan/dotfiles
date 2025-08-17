#!/bin/bash
# Main Test Runner - Platform-agnostic test orchestrator

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Source test framework
source "$SCRIPT_DIR/test-framework.sh"

# ===========================
# Configuration
# ===========================
VERBOSE=${VERBOSE:-0}
DOCKER_TEST=${DOCKER_TEST:-0}
COMPONENT=${1:-all}
TEST_INSTALL=${TEST_INSTALL:-0}

# Smart color detection
# Keep colors if: we have a TTY, or FORCE_COLOR is set, or TERM supports colors
if [ -t 1 ] || [ -n "$FORCE_COLOR" ] || [[ "$TERM" == *"color"* ]]; then
    # Colors are already set by test-framework.sh, keep them
    :
else
    # Disable colors for non-terminal output
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
fi

# ===========================
# Usage
# ===========================
usage() {
    cat << EOF
Usage: $0 [OPTIONS] [COMPONENT]

Run comprehensive tests for dotfiles configuration

COMPONENTS:
  all         Run all tests (default)
  zsh         Test ZSH configuration
  nvim        Test Neovim configuration
  kitty       Test Kitty configuration
  git         Test Git configuration
  fzf         Test FZF integration
  install     Test fresh installation
  
OPTIONS:
  -v, --verbose      Enable verbose output
  -d, --docker       Run tests in Docker container
  -i, --install      Test fresh installation first
  -h, --help         Show this help message

EXAMPLES:
  $0                  # Run all tests
  $0 zsh              # Test only ZSH
  $0 --verbose        # Run with detailed output
  $0 --docker         # Run in Docker (Linux environment)
  $0 --install        # Test fresh install then run tests

EOF
    exit 0
}

# ===========================
# Parse Arguments
# ===========================
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=1
            export VERBOSE
            shift
            ;;
        -d|--docker)
            DOCKER_TEST=1
            shift
            ;;
        -i|--install)
            TEST_INSTALL=1
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            COMPONENT=$1
            shift
            ;;
    esac
done

# ===========================
# Docker Testing
# ===========================
run_docker_tests() {
    echo -e "${BLUE}🐳 Running tests in Docker container...${NC}"
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker is not installed${NC}"
        exit 1
    fi
    
    # Build test image if Dockerfile exists
    if [[ -f "$SCRIPT_DIR/Dockerfile" ]]; then
        echo "Building test Docker image..."
        # Use buildx if available, fallback to regular build
        if docker buildx version &>/dev/null; then
            docker buildx build --load -t dotfiles-test -f "$SCRIPT_DIR/Dockerfile" "$DOTFILES_DIR"
        else
            docker build -t dotfiles-test -f "$SCRIPT_DIR/Dockerfile" "$DOTFILES_DIR"
        fi
    else
        echo "Creating temporary Docker test environment..."
        # Create inline Dockerfile
        cat > /tmp/Dockerfile.dotfiles-test << 'EOF'
FROM ubuntu:22.04

# Install base dependencies
RUN apt-get update && apt-get install -y \
    git curl wget sudo zsh build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create test user
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . ./dotfiles/

# Run installation
RUN cd dotfiles && ./tests/install-platform-agnostic.sh

# Force color output in Docker
ENV TERM=xterm-256color
ENV FORCE_COLOR=1

# Set entrypoint
ENTRYPOINT ["./dotfiles/tests/run-tests.sh"]
EOF
        # Use buildx if available, fallback to regular build
        if docker buildx version &>/dev/null; then
            docker buildx build --load -t dotfiles-test -f /tmp/Dockerfile.dotfiles-test "$DOTFILES_DIR"
        else
            docker build -t dotfiles-test -f /tmp/Dockerfile.dotfiles-test "$DOTFILES_DIR"
        fi
        rm /tmp/Dockerfile.dotfiles-test
    fi
    
    # Run tests in container
    # Remove -it flags when not in a TTY (e.g., CI environments)
    # Pass the actual component, not --docker flag
    local test_component="${COMPONENT}"
    if [[ "$test_component" == "--docker" ]]; then
        test_component="all"
    fi
    
    if [ -t 0 ]; then
        docker run --rm -it dotfiles-test "$test_component"
    else
        docker run --rm dotfiles-test "$test_component"
    fi
    exit $?
}

# ===========================
# Installation Test
# ===========================
test_fresh_install() {
    echo -e "${BLUE}🔧 Testing fresh installation...${NC}"
    
    # Create temporary test environment
    TEST_HOME=$(mktemp -d "/tmp/dotfiles-test.XXXXX")
    echo "Test environment: $TEST_HOME"
    
    # Backup current home files
    BACKUP_DIR=$(mktemp -d "/tmp/dotfiles-backup.XXXXX")
    for file in .zshrc .config/nvim .gitconfig; do
        if [[ -e "$HOME/$file" ]]; then
            cp -r "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done
    
    # Run installation in test environment
    (
        export HOME="$TEST_HOME"
        cd "$DOTFILES_DIR"
        
        # Use platform-agnostic installer if available
        if [[ -f "tests/install-platform-agnostic.sh" ]]; then
            ./tests/install-platform-agnostic.sh
        else
            ./install.sh
        fi
    )
    
    # Check installation results
    echo "Verifying installation..."
    export HOME="$TEST_HOME"
    
    # Run basic tests
    "$SCRIPT_DIR/components/test-install.sh" 2>/dev/null || true
    
    # Cleanup
    rm -rf "$TEST_HOME"
    export HOME="$REAL_HOME"
    
    echo -e "${GREEN}✓ Installation test complete${NC}"
}

# ===========================
# Component Testing
# ===========================
run_component_tests() {
    local component=$1
    local test_file="$SCRIPT_DIR/components/test-${component}.sh"
    
    if [[ -f "$test_file" ]]; then
        echo -e "${CYAN}Running $component tests...${NC}"
        bash "$test_file"
        return $?
    else
        echo -e "${YELLOW}Warning: Test file not found: $test_file${NC}"
        return 1
    fi
}

# ===========================
# Integration Tests
# ===========================
run_integration_tests() {
    echo -e "${BLUE}Running integration tests...${NC}"
    
    for test_file in "$SCRIPT_DIR/integration"/*.sh; do
        if [[ -f "$test_file" ]]; then
            echo -e "${CYAN}Running $(basename "$test_file")...${NC}"
            bash "$test_file"
        fi
    done
}

# ===========================
# Main Test Execution
# ===========================
main() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                    Dotfiles Test Suite                         ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Platform: $PLATFORM"
    echo "Component: $COMPONENT"
    echo "Verbose: $VERBOSE"
    echo ""
    
    # Save real HOME
    REAL_HOME="$HOME"
    
    # Run Docker tests if requested
    if [[ $DOCKER_TEST -eq 1 ]]; then
        run_docker_tests
        exit $?
    fi
    
    # Run installation test if requested
    if [[ $TEST_INSTALL -eq 1 ]]; then
        test_fresh_install
    fi
    
    # Track overall results
    TOTAL_PASSED=0
    TOTAL_FAILED=0
    TOTAL_SKIPPED=0
    FAILED_COMPONENTS=()
    
    # Run tests based on component selection
    if [[ "$COMPONENT" == "all" ]]; then
        # Run all component tests
        for test_file in "$SCRIPT_DIR/components"/test-*.sh; do
            if [[ -f "$test_file" ]]; then
                component_name=$(basename "$test_file" .sh | sed 's/test-//')
                
                # Run test and capture result
                if bash "$test_file"; then
                    TOTAL_PASSED=$((TOTAL_PASSED + TESTS_PASSED))
                else
                    FAILED_COMPONENTS+=("$component_name")
                fi
                
                TOTAL_FAILED=$((TOTAL_FAILED + TESTS_FAILED))
                TOTAL_SKIPPED=$((TOTAL_SKIPPED + TESTS_SKIPPED))
                
                # Reset counters for next component
                TESTS_PASSED=0
                TESTS_FAILED=0
                TESTS_SKIPPED=0
            fi
        done
        
        # Run integration tests
        run_integration_tests
        
    else
        # Run specific component test
        if run_component_tests "$COMPONENT"; then
            TOTAL_PASSED=$TESTS_PASSED
        else
            FAILED_COMPONENTS+=("$COMPONENT")
        fi
        TOTAL_FAILED=$TESTS_FAILED
        TOTAL_SKIPPED=$TESTS_SKIPPED
    fi
    
    # Print final summary
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                      Final Summary                             ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  Total Passed:  ${GREEN}$TOTAL_PASSED${NC}"
    echo -e "  Total Failed:  ${RED}$TOTAL_FAILED${NC}"
    echo -e "  Total Skipped: ${YELLOW}$TOTAL_SKIPPED${NC}"
    
    if [[ ${#FAILED_COMPONENTS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}Failed Components:${NC}"
        for comp in "${FAILED_COMPONENTS[@]}"; do
            echo "  • $comp"
        done
        exit 1
    else
        echo ""
        echo -e "${GREEN}✅ All tests passed successfully!${NC}"
        exit 0
    fi
}

# Run main function
main