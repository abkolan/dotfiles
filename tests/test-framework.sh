#!/bin/bash
# Test Framework - Shared utilities for all tests
# Platform-agnostic testing utilities

# ===========================
# Color Output
# ===========================
# Smart color detection - support Docker, CI, and piped output
if [ -t 1 ] || [ -n "$FORCE_COLOR" ] || [[ "$TERM" == *"color"* ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
else
    # No colors for non-terminal output
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
fi

# ===========================
# Test Counters
# ===========================
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0
CURRENT_COMPONENT=""
FAILED_TESTS=()

# ===========================
# Platform Detection
# ===========================
detect_platform() {
    case "$OSTYPE" in
        darwin*)  echo "macos" ;;
        linux*)   echo "linux" ;;
        *)        echo "unknown" ;;
    esac
}

PLATFORM=$(detect_platform)

# ===========================
# Test Functions
# ===========================

# Start a test component
start_component() {
    local component="$1"
    CURRENT_COMPONENT="$component"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Testing: ${CYAN}$component${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Run a test
test_case() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="${3:-0}"  # Default to expecting success (0)
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo -n "  ▶ $test_name... "
    
    # Run the test command
    if eval "$test_command" >/dev/null 2>&1; then
        local actual_result=0
    else
        local actual_result=$?
    fi
    
    if [[ $actual_result -eq $expected_result ]]; then
        echo -e "${GREEN}✓ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("[$CURRENT_COMPONENT] $test_name")
        return 1
    fi
}

# Run a test with output capture
test_output() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo -n "  ▶ $test_name... "
    
    local output
    output=$(eval "$test_command" 2>&1)
    
    if echo "$output" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✓ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} (expected pattern: $expected_pattern)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("[$CURRENT_COMPONENT] $test_name")
        return 1
    fi
}

# Skip a test
skip_test() {
    local test_name="$1"
    local reason="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    
    echo -e "  ▶ $test_name... ${YELLOW}⊘ SKIP${NC} ($reason)"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a file exists
file_exists() {
    [[ -f "$1" ]]
}

# Check if a directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Check if a symlink exists and is valid
symlink_valid() {
    [[ -L "$1" ]] && [[ -e "$1" ]]
}

# Measure command execution time in milliseconds
measure_time() {
    local command="$1"
    local start_time
    local end_time
    
    if [[ "$PLATFORM" == "macos" ]]; then
        start_time=$(perl -MTime::HiRes -e 'print int(Time::HiRes::time()*1000)')
        eval "$command" >/dev/null 2>&1
        end_time=$(perl -MTime::HiRes -e 'print int(Time::HiRes::time()*1000)')
    else
        start_time=$(date +%s%3N)
        eval "$command" >/dev/null 2>&1
        end_time=$(date +%s%3N)
    fi
    
    echo $((end_time - start_time))
}

# Test performance with threshold
test_performance() {
    local test_name="$1"
    local test_command="$2"
    local threshold_ms="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo -n "  ▶ $test_name (threshold: ${threshold_ms}ms)... "
    
    local duration
    duration=$(measure_time "$test_command")
    
    if [[ $duration -le $threshold_ms ]]; then
        echo -e "${GREEN}✓ PASS${NC} (${duration}ms)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} (${duration}ms > ${threshold_ms}ms)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("[$CURRENT_COMPONENT] $test_name: ${duration}ms > ${threshold_ms}ms")
        return 1
    fi
}

# Create a temporary test environment
create_test_env() {
    local test_home="/tmp/dotfiles-test-$$"
    mkdir -p "$test_home"
    echo "$test_home"
}

# Cleanup test environment
cleanup_test_env() {
    local test_home="$1"
    [[ -d "$test_home" ]] && rm -rf "$test_home"
}

# Run a test in isolated environment
test_isolated() {
    local test_name="$1"
    local test_command="$2"
    
    local test_home
    test_home=$(create_test_env)
    
    HOME="$test_home" test_case "$test_name" "$test_command"
    local result=$?
    
    cleanup_test_env "$test_home"
    return $result
}

# Print test summary
print_summary() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Total:   $TESTS_TOTAL"
    echo -e "  Passed:  ${GREEN}$TESTS_PASSED${NC}"
    echo -e "  Failed:  ${RED}$TESTS_FAILED${NC}"
    echo -e "  Skipped: ${YELLOW}$TESTS_SKIPPED${NC}"
    
    if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}Failed Tests:${NC}"
        for test in "${FAILED_TESTS[@]}"; do
            echo "  • $test"
        done
    fi
    
    echo ""
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✅ All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}❌ Some tests failed${NC}"
        return 1
    fi
}

# Check dependencies for a component
check_dependencies() {
    local deps=("$@")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${YELLOW}Missing dependencies: ${missing[*]}${NC}"
        return 1
    fi
    return 0
}

# Verbose output (if enabled)
verbose() {
    if [[ "${VERBOSE:-0}" == "1" ]]; then
        echo -e "${CYAN}[DEBUG]${NC} $*"
    fi
}

# Export functions for use in test scripts
export -f test_case test_output skip_test command_exists file_exists dir_exists
export -f symlink_valid measure_time test_performance test_isolated
export -f create_test_env cleanup_test_env check_dependencies verbose
export -f start_component print_summary detect_platform