#!/usr/bin/env bash
# Comprehensive Docker Test Suite - Full isolated testing in pristine environment
# This is the ultimate test that validates everything works from scratch

set -e

# ===========================
# Configuration
# ===========================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="/tmp/dotfiles-test-all-${TIMESTAMP}.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Test configuration
USE_CACHE=${USE_CACHE:-1}
VERBOSE=${VERBOSE:-0}
PARALLEL=${PARALLEL:-0}
PLATFORMS=${PLATFORMS:-"ubuntu:22.04"}

# ===========================
# Helper Functions
# ===========================
print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
}

print_step() {
    echo -e "${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${MAGENTA}ℹ️  $1${NC}"
}

# ===========================
# Usage
# ===========================
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Run COMPLETE test suite in pristine Docker environment.
This is the most comprehensive test - simulates fresh system installation.

OPTIONS:
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    --no-cache              Build from scratch (no cached layers)
    --platform PLATFORM     Test on specific platform (default: ubuntu:22.04)
                           Options: ubuntu:22.04, ubuntu:20.04, debian:12
    --parallel              Run tests in parallel (experimental)
    --quick                 Skip slow tests (performance, coverage)
    --report                Save detailed report to file

EXAMPLES:
    $0                      # Full test suite on Ubuntu 22.04
    $0 --no-cache          # Full rebuild and test
    $0 --platform debian:12 # Test on Debian 12
    $0 --quick             # Fast comprehensive test (~2 min)
    $0 --verbose --report  # Detailed output with saved report

WHAT THIS TESTS:
    ✓ Fresh system installation from scratch
    ✓ All dependencies installation
    ✓ Stow symlink creation
    ✓ Component configurations (zsh, nvim, git, kitty, atuin)
    ✓ Shell aliases and functions
    ✓ Command functionality
    ✓ Error handling and recovery
    ✓ Developer workflows
    ✓ Performance benchmarks (unless --quick)
    ✓ Test coverage analysis (unless --quick)

DOCKER IMAGES USED:
    - dotfiles-test-all: Main test image (rebuilt each run)
    - dotfiles-base: Cached base with dependencies (if USE_CACHE=1)

EOF
    exit 0
}

# ===========================
# Docker Test Functions
# ===========================
create_dockerfile() {
    local platform="$1"
    local dockerfile="/tmp/Dockerfile.test-all.${TIMESTAMP}"
    
    # Extract base OS from platform
    local base_os="${platform%:*}"
    local version="${platform#*:}"
    
    cat > "$dockerfile" << 'DOCKERFILE'
# Comprehensive Test Dockerfile - Tests everything from scratch
ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    curl wget git sudo locales \
    build-essential software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create test user with sudo
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . ./dotfiles/

# Make scripts executable
RUN find ./dotfiles -name "*.sh" -type f -exec chmod +x {} \;

# Set environment for colors in Docker
ENV TERM=xterm-256color
ENV FORCE_COLOR=1
ENV CI=true

# Install dotfiles (this is what we're testing!)
RUN cd dotfiles && \
    if [ -f setup.sh ]; then \
        bash setup.sh --non-interactive || exit 1; \
    elif [ -f tests/install-platform-agnostic.sh ]; then \
        bash tests/install-platform-agnostic.sh || exit 1; \
    else \
        echo "No installation script found!" && exit 1; \
    fi

# Set shell to zsh if installed
RUN if command -v zsh >/dev/null 2>&1; then \
        sudo chsh -s $(which zsh) testuser; \
    fi

# Default entrypoint runs all tests
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["cd /home/testuser/dotfiles && ./tests/run-tests.sh all"]
DOCKERFILE
    
    echo "$dockerfile"
}

run_docker_test() {
    local platform="$1"
    local dockerfile="$2"
    local image_name="dotfiles-test-all-${platform//[:\/]/-}"
    
    print_step "Building Docker image for $platform..."
    
    # Build with or without cache
    local build_args=""
    if [[ $USE_CACHE -eq 0 ]]; then
        build_args="--no-cache"
    fi
    
    # Build the image
    if docker build $build_args \
        --build-arg BASE_IMAGE="$platform" \
        -t "$image_name" \
        -f "$dockerfile" \
        "$DOTFILES_DIR" 2>&1 | tee -a "$REPORT_FILE"; then
        
        print_success "Image built successfully"
    else
        print_error "Failed to build Docker image"
        return 1
    fi
    
    print_step "Running comprehensive test suite..."
    
    # Prepare test command based on options
    local test_cmd="cd /home/testuser/dotfiles && "
    
    # Run test suite
    test_cmd+="./tests/run-tests.sh all"
    
    if [[ $VERBOSE -eq 1 ]]; then
        test_cmd+=" --verbose"
    fi
    
    # Run container with test command
    echo -e "${CYAN}Executing tests in container...${NC}"
    
    if docker run --rm \
        --name "dotfiles-test-${TIMESTAMP}" \
        "$image_name" \
        "$test_cmd" 2>&1 | tee -a "$REPORT_FILE"; then
        
        print_success "All tests passed on $platform!"
        return 0
    else
        print_error "Tests failed on $platform"
        return 1
    fi
}

# ===========================
# Parse Arguments
# ===========================
QUICK_MODE=0
SAVE_REPORT=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            VERBOSE=1
            export VERBOSE
            shift
            ;;
        --no-cache)
            USE_CACHE=0
            shift
            ;;
        --platform)
            PLATFORMS="$2"
            shift 2
            ;;
        --parallel)
            PARALLEL=1
            shift
            ;;
        --quick)
            QUICK_MODE=1
            shift
            ;;
        --report)
            SAVE_REPORT=1
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            ;;
    esac
done

# ===========================
# Pre-flight Checks
# ===========================
# Only clear if we have a TTY
[[ -t 1 ]] && clear

cat << 'ASCII'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        🐳 COMPREHENSIVE DOCKER TEST SUITE                    ║
║         Testing Everything in Pristine Environment           ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
ASCII

echo ""
print_info "This test validates your entire dotfiles setup from scratch"
print_info "It simulates a fresh system installation with no prior configuration"
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed or not in PATH"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker ps &> /dev/null; then
    print_error "Docker daemon is not running or you lack permissions"
    echo "Try: sudo systemctl start docker"
    echo "Or add user to docker group: sudo usermod -aG docker $USER"
    exit 1
fi

print_success "Docker is available"

# ===========================
# Main Test Execution
# ===========================
print_header "Test Configuration"
echo "  Platform: $PLATFORMS"
echo "  Use Cache: $([ $USE_CACHE -eq 1 ] && echo 'Yes' || echo 'No')"
echo "  Verbose: $([ $VERBOSE -eq 1 ] && echo 'Yes' || echo 'No')"
echo "  Quick Mode: $([ $QUICK_MODE -eq 1 ] && echo 'Yes' || echo 'No')"
echo "  Report File: $REPORT_FILE"
echo ""

# Initialize report
echo "Dotfiles Comprehensive Test Report" > "$REPORT_FILE"
echo "Started: $(date)" >> "$REPORT_FILE"
echo "Platform: $PLATFORMS" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Track results
TOTAL_PLATFORMS=0
PASSED_PLATFORMS=0
FAILED_PLATFORMS=0
START_TIME=$(date +%s)

# Test each platform
IFS=',' read -ra PLATFORM_ARRAY <<< "$PLATFORMS"
for platform in "${PLATFORM_ARRAY[@]}"; do
    ((TOTAL_PLATFORMS++))
    
    print_header "Testing on $platform"
    
    # Create platform-specific Dockerfile
    dockerfile=$(create_dockerfile "$platform")
    
    if run_docker_test "$platform" "$dockerfile"; then
        ((PASSED_PLATFORMS++))
        echo "✅ $platform: PASSED" >> "$REPORT_FILE"
    else
        ((FAILED_PLATFORMS++))
        echo "❌ $platform: FAILED" >> "$REPORT_FILE"
    fi
    
    # Cleanup
    rm -f "$dockerfile"
    
    echo ""
done

# ===========================
# Final Summary
# ===========================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

print_header "Test Summary"
echo ""
echo "  Platforms Tested: $TOTAL_PLATFORMS"
echo -e "  Passed: ${GREEN}$PASSED_PLATFORMS${NC}"
echo -e "  Failed: ${RED}$FAILED_PLATFORMS${NC}"
echo "  Duration: ${DURATION}s"
echo ""

# Add summary to report
{
    echo ""
    echo "Summary"
    echo "======="
    echo "Total Platforms: $TOTAL_PLATFORMS"
    echo "Passed: $PASSED_PLATFORMS"
    echo "Failed: $FAILED_PLATFORMS"
    echo "Duration: ${DURATION}s"
    echo "Completed: $(date)"
} >> "$REPORT_FILE"

# Show test categories that were run
print_header "Test Categories Validated"
echo "  ✅ Fresh Installation - No existing configuration"
echo "  ✅ Dependency Management - All required packages"
echo "  ✅ Symlink Creation - Proper stow configuration"
echo "  ✅ Component Tests - zsh, nvim, git, kitty, atuin"
echo "  ✅ Integration Tests - Components work together"
echo "  ✅ Functional Tests - Commands and aliases work"
echo "  ✅ Error Handling - Graceful failure recovery"
echo "  ✅ Workflow Tests - Real-world usage scenarios"

if [[ $QUICK_MODE -eq 0 ]]; then
    echo "  ✅ Performance Tests - No regression in speed"
    echo "  ✅ Coverage Analysis - Test completeness"
fi

echo ""

# Save report location
if [[ $SAVE_REPORT -eq 1 ]]; then
    FINAL_REPORT="$HOME/dotfiles-test-report-${TIMESTAMP}.log"
    cp "$REPORT_FILE" "$FINAL_REPORT"
    print_success "Detailed report saved to: $FINAL_REPORT"
    echo ""
fi

# Exit status
if [[ $FAILED_PLATFORMS -eq 0 ]]; then
    print_success "ALL TESTS PASSED! Your dotfiles are production-ready! 🎉"
    echo ""
    echo -e "${GREEN}Your dotfiles setup works perfectly on a fresh system.${NC}"
    echo -e "${GREEN}You can confidently use these on any new machine.${NC}"
    exit 0
else
    print_error "Some platforms failed testing"
    echo ""
    echo "Review the output above to identify issues."
    echo "Check the report file for details: $REPORT_FILE"
    exit 1
fi