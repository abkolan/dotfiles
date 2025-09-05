#!/bin/bash
# =============================================================================
# Main Test Runner Script
#
# This script serves as the single entry point for running all dotfiles tests.
# It supports different scopes to allow for flexible testing scenarios, from
# quick local checks to comprehensive CI runs.
#
# Usage:
#   ./run-tests.sh                # Run all tests by default
#   ./run-tests.sh --scope fast   # Run only the fast, essential tests
#   ./run-tests.sh --scope all    # Run the full test suite
#   ./run-tests.sh --help         # Show help message
#
# Test Scopes:
#   - fast: Runs critical, low-latency tests suitable for quick validation
#           (e.g., on every branch push). Includes Zsh and Git component tests.
#   - all:  Runs the entire test suite, including component, integration,
#           and functional tests. Ideal for pull requests and nightly builds.
# =============================================================================

set -euo pipefail # Exit on error, undefined variable, or pipe failure

# --- Configuration ---
# Get the root directory of the dotfiles repository
# This allows the script to be run from any directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
TEST_DIR="$ROOT_DIR/tests"
FRAMEWORK_PATH="$TEST_DIR/test-framework.sh"

# --- Helper Functions ---

# Function to print messages
print_message() {
  echo "================================================================================"
  echo " $1"
  echo "================================================================================"
}

# Function to display help message
show_help() {
  echo "Usage: ./run-tests.sh [--scope <fast|all>] [--help]"
  echo ""
  echo "Options:"
  echo "  --scope   Specify the test scope to run. Defaults to 'all'."
  echo "            'fast': Runs only essential, low-latency tests."
  echo "            'all':  Runs the complete test suite."
  echo "  --help    Show this help message."
}

# --- Test Execution ---

# Source the test framework which contains helper functions for tests
# shellcheck source=tests/test-framework.sh
source "$FRAMEWORK_PATH"

# Global test counters
FAILURES=0
SUCCESSES=0

# Wrapper to run a test script and track its result
run_test() {
  local test_name="$1"
  local test_script="$2"

  echo -e "\n--- Running: $test_name ---"
  if "$test_script"; then
    echo "--- Result: SUCCESS ---"
    SUCCESSES=$((SUCCESSES + 1))
  else
    echo "--- Result: FAILURE ---"
    FAILURES=$((FAILURES + 1))
  fi
}

# Define fast tests (critical components)
run_fast_tests() {
  print_message "🚀 Starting FAST test suite..."
  run_test "Zsh component tests" "$TEST_DIR/components/test-zsh.sh"
  run_test "Git component tests" "$TEST_DIR/components/test-git.sh"
}

# Define all tests (comprehensive suite)
run_all_tests() {
  print_message "🚀 Starting COMPREHENSIVE test suite..."
  
  # Component Tests
  run_test "Atuin component tests" "$TEST_DIR/components/test-atuin.sh"
  run_test "Git component tests" "$TEST_DIR/components/test-git.sh"
  run_test "Kitty component tests" "$TEST_DIR/components/test-kitty.sh"
  run_test "Nvim component tests" "$TEST_DIR/components/test-nvim.sh"
  run_test "Zsh component tests" "$TEST_DIR/components/test-zsh.sh"

  # Integration Tests
  run_test "Aliases integration tests" "$TEST_DIR/integration/test-aliases.sh"

  # Functional Tests
  run_test "Commands functional tests" "$TEST_DIR/functional/test-commands.sh"

  # Negative Tests
  run_test "Error handling tests" "$TEST_DIR/negative/test-error-handling.sh"
}

# --- Main Execution Logic ---

# Default scope
SCOPE="all"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      SCOPE="$2"
      shift 2
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

# Execute tests based on the selected scope
case "$SCOPE" in
  fast)
    run_fast_tests
    ;;
  all)
    run_all_tests
    ;;
  *)
    echo "Error: Invalid scope '$SCOPE'. Please use 'fast' or 'all'."
    exit 1
    ;;
esac

# Final check for test failures
if [[ $FAILURES -gt 0 ]]; then
  echo ""
  print_message "❌ Test suite finished with $FAILURES failure(s)."
  exit 1
else
  echo ""
  print_message "✅ All tests passed successfully!"
fi