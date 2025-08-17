#!/usr/bin/env bash
# Fast testing script - uses pre-built Docker base image

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if base image exists
check_base_image() {
    if docker images | grep -q "dotfiles-base"; then
        return 0
    else
        return 1
    fi
}

# Build base image (only needed once)
build_base_image() {
    echo -e "${CYAN}Building base Docker image (one-time setup)...${NC}"
    echo -e "${YELLOW}This will take a few minutes but only needs to be done once.${NC}"
    
    if docker buildx version &>/dev/null; then
        docker buildx build --load -t dotfiles-base -f "$SCRIPT_DIR/Dockerfile.base" "$DOTFILES_DIR"
    else
        docker build -t dotfiles-base -f "$SCRIPT_DIR/Dockerfile.base" "$DOTFILES_DIR"
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Base image built successfully"
        echo -e "${GREEN}Future tests will be much faster!${NC}"
    else
        print_error "Failed to build base image"
        exit 1
    fi
}

# Run fast test
run_fast_test() {
    echo -e "${CYAN}Running fast Docker test...${NC}"
    
    # Build test image using base (this is fast - only copies files)
    if docker buildx version &>/dev/null; then
        docker buildx build --load -t dotfiles-test -f "$SCRIPT_DIR/Dockerfile.fast" "$DOTFILES_DIR"
    else
        docker build -t dotfiles-test -f "$SCRIPT_DIR/Dockerfile.fast" "$DOTFILES_DIR"
    fi
    
    if [ $? -ne 0 ]; then
        print_error "Failed to build test image"
        exit 1
    fi
    
    # Run tests
    echo -e "${CYAN}Running tests in container...${NC}"
    if [ -t 0 ]; then
        docker run --rm -it dotfiles-test "$@"
    else
        docker run --rm dotfiles-test "$@"
    fi
}

# Main
main() {
    clear
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}              FAST DOCKER INTEGRATION TEST                      ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check for Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed"
        exit 1
    fi
    
    # Check if base image exists
    if ! check_base_image; then
        print_info "Base image not found"
        echo ""
        read -p "Build base image now? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            build_base_image
        else
            print_error "Cannot run tests without base image"
            exit 1
        fi
    else
        print_success "Base image found"
    fi
    
    echo ""
    run_fast_test "$@"
}

# Show usage if --help
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    cat << EOF
Usage: $0 [COMPONENT]

Fast Docker testing for dotfiles using pre-built base image.

First run will build the base image (slow, ~2-3 minutes).
Subsequent runs are fast (~10-20 seconds).

COMPONENTS:
  all         Run all tests (default)
  zsh         Test ZSH configuration
  nvim        Test Neovim configuration
  git         Test Git configuration

To rebuild base image:
  docker build -t dotfiles-base -f tests/Dockerfile.base .

To remove base image:
  docker rmi dotfiles-base

EOF
    exit 0
fi

main "$@"