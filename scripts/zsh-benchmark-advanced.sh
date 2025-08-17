#!/usr/bin/env bash
# ============================================================================
# ADVANCED ZSH PERFORMANCE BENCHMARKING SUITE
# Comprehensive analysis of shell startup time and plugin loading
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Configuration
BENCHMARK_DIR="/tmp/zsh-benchmark-$$"
PROFILE_LOG="$BENCHMARK_DIR/profile.log"
TIMING_LOG="$BENCHMARK_DIR/timing.log"

# Create temporary directory
mkdir -p "$BENCHMARK_DIR"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
  echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${CYAN}$1${RESET}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

print_subheader() {
  echo -e "\n${YELLOW}▶ $1${RESET}"
}

cleanup() {
  rm -rf "$BENCHMARK_DIR"
}

trap cleanup EXIT

# ============================================================================
# STARTUP TIME BENCHMARK
# ============================================================================

benchmark_startup() {
  print_header "📊 ZSH STARTUP TIME BENCHMARK"
  
  # Check for hyperfine
  if command -v hyperfine &>/dev/null; then
    print_subheader "Using hyperfine for precise measurements"
    hyperfine --warmup 3 --min-runs 10 --export-json "$BENCHMARK_DIR/hyperfine.json" \
      'zsh -i -c exit' \
      'zsh -c exit'
    
    # Parse and display results
    if command -v jq &>/dev/null; then
      echo -e "\n${GREEN}Results:${RESET}"
      jq -r '.results[] | "  \(.command): \(.mean) ± \(.stddev) seconds"' "$BENCHMARK_DIR/hyperfine.json"
    fi
  else
    print_subheader "Basic timing (install hyperfine for better results: brew install hyperfine)"
    
    echo -e "\n${CYAN}Interactive shell:${RESET}"
    local total=0
    for i in {1..10}; do
      local start=$(perl -MTime::HiRes=time -e 'print time')
      zsh -i -c exit 2>/dev/null
      local end=$(perl -MTime::HiRes=time -e 'print time')
      local duration=$(echo "$end - $start" | bc -l)
      printf "  Run %2d: %.3fs\n" "$i" "$duration"
      total=$(echo "$total + $duration" | bc -l)
    done
    local avg=$(echo "scale=3; $total / 10" | bc -l)
    echo -e "${GREEN}  Average: ${avg}s${RESET}"
    
    echo -e "\n${CYAN}Non-interactive shell:${RESET}"
    total=0
    for i in {1..10}; do
      local start=$(perl -MTime::HiRes=time -e 'print time')
      zsh -c exit 2>/dev/null
      local end=$(perl -MTime::HiRes=time -e 'print time')
      local duration=$(echo "$end - $start" | bc -l)
      printf "  Run %2d: %.3fs\n" "$i" "$duration"
      total=$(echo "$total + $duration" | bc -l)
    done
    avg=$(echo "scale=3; $total / 10" | bc -l)
    echo -e "${GREEN}  Average: ${avg}s${RESET}"
  fi
}

# ============================================================================
# PLUGIN LOADING ANALYSIS
# ============================================================================

analyze_plugins() {
  print_header "🔌 PLUGIN LOADING ANALYSIS"
  
  print_subheader "Creating profiling script"
  
  cat > "$BENCHMARK_DIR/profile.zsh" << 'EOF'
#!/usr/bin/env zsh
zmodload zsh/zprof

# Source the zshrc
source ~/.zshrc

# Output profiling data
zprof
EOF
  
  chmod +x "$BENCHMARK_DIR/profile.zsh"
  
  print_subheader "Running profiling"
  zsh "$BENCHMARK_DIR/profile.zsh" > "$PROFILE_LOG" 2>&1
  
  if [[ -s "$PROFILE_LOG" ]]; then
    echo -e "\n${CYAN}Top 10 slowest operations:${RESET}"
    head -20 "$PROFILE_LOG" | tail -10
  else
    echo -e "${RED}No profiling data collected${RESET}"
  fi
}

# ============================================================================
# COMPONENT TIMING
# ============================================================================

time_components() {
  print_header "⏱️  COMPONENT TIMING ANALYSIS"
  
  print_subheader "Testing individual components"
  
  # Test completion system
  echo -e "\n${CYAN}Completion system:${RESET}"
  local start=$(perl -MTime::HiRes=time -e 'print time')
  zsh -c 'autoload -Uz compinit && compinit -C' 2>/dev/null
  local end=$(perl -MTime::HiRes=time -e 'print time')
  local duration=$(echo "$end - $start" | bc -l)
  printf "  Time: %.3fs\n" "$duration"
  
  # Test syntax highlighting
  if [[ -d "${ZINIT_HOME:-$HOME/.local/share/zinit/zinit.git}" ]]; then
    echo -e "\n${CYAN}Zinit initialization:${RESET}"
    start=$(perl -MTime::HiRes=time -e 'print time')
    zsh -c 'source ${ZINIT_HOME:-$HOME/.local/share/zinit/zinit.git}/zinit.zsh' 2>/dev/null
    end=$(perl -MTime::HiRes=time -e 'print time')
    duration=$(echo "$end - $start" | bc -l)
    printf "  Time: %.3fs\n" "$duration"
  fi
  
  # Test history loading
  echo -e "\n${CYAN}History loading:${RESET}"
  start=$(perl -MTime::HiRes=time -e 'print time')
  zsh -c 'HISTFILE=~/.zsh_history; HISTSIZE=10000; SAVEHIST=10000; fc -R' 2>/dev/null
  end=$(perl -MTime::HiRes=time -e 'print time')
  duration=$(echo "$end - $start" | bc -l)
  printf "  Time: %.3fs\n" "$duration"
}

# ============================================================================
# OPTIMIZATION SUGGESTIONS
# ============================================================================

suggest_optimizations() {
  print_header "💡 OPTIMIZATION SUGGESTIONS"
  
  echo -e "${YELLOW}Based on the analysis, consider these optimizations:${RESET}\n"
  
  # Check for slow plugins
  if grep -q "oh-my-zsh" ~/.zshrc 2>/dev/null; then
    echo "  ⚠️  Oh-My-Zsh detected - Consider migrating to Zinit for faster loading"
  fi
  
  # Check for NVM
  if grep -q "nvm.sh" ~/.zshrc 2>/dev/null; then
    echo "  ⚠️  NVM loading detected - Implement lazy loading for better performance"
  fi
  
  # Check for completion dump
  if [[ ! -f ~/.zcompdump.zwc ]]; then
    echo "  ⚠️  No compiled completion dump - Run: zcompile ~/.zcompdump"
  fi
  
  # Check for history size
  local histsize=$(grep "HISTSIZE" ~/.zshrc | grep -o '[0-9]*' | head -1)
  if [[ -n "$histsize" && "$histsize" -gt 50000 ]]; then
    echo "  ⚠️  Large history size ($histsize) - Consider reducing to 10000-20000"
  fi
  
  echo -e "\n${GREEN}General recommendations:${RESET}"
  echo "  ✓ Use lazy loading for heavy tools (NVM, Conda, etc.)"
  echo "  ✓ Compile zsh files with zcompile"
  echo "  ✓ Use Zinit turbo mode for deferred plugin loading"
  echo "  ✓ Minimize synchronous operations in .zshrc"
  echo "  ✓ Cache expensive computations"
}

# ============================================================================
# COMPARISON MODE
# ============================================================================

compare_configs() {
  print_header "🔄 CONFIGURATION COMPARISON"
  
  if [[ ! -f "$1" ]]; then
    echo -e "${RED}Error: Configuration file $1 not found${RESET}"
    return 1
  fi
  
  print_subheader "Backing up current configuration"
  cp ~/.zshrc ~/.zshrc.benchmark-backup
  
  print_subheader "Testing current configuration"
  local current_time=$(zsh -i -c exit 2>&1 | grep real | awk '{print $2}')
  
  print_subheader "Testing alternative configuration: $1"
  cp "$1" ~/.zshrc
  local alt_time=$(zsh -i -c exit 2>&1 | grep real | awk '{print $2}')
  
  print_subheader "Restoring original configuration"
  cp ~/.zshrc.benchmark-backup ~/.zshrc
  rm ~/.zshrc.benchmark-backup
  
  echo -e "\n${CYAN}Results:${RESET}"
  echo "  Current config: $current_time"
  echo "  Alternative config: $alt_time"
  
  # Calculate difference
  local diff=$(echo "$current_time - $alt_time" | bc -l)
  if (( $(echo "$diff > 0" | bc -l) )); then
    echo -e "  ${GREEN}Alternative is faster by ${diff}s${RESET}"
  else
    echo -e "  ${RED}Current is faster by ${diff#-}s${RESET}"
  fi
}

# ============================================================================
# DETAILED TRACE
# ============================================================================

detailed_trace() {
  print_header "🔍 DETAILED STARTUP TRACE"
  
  print_subheader "Generating trace (this may take a moment)"
  
  cat > "$BENCHMARK_DIR/trace.zsh" << 'EOF'
#!/usr/bin/env zsh
PS4=$'+%D{%s.%6.} %N:%i> '
exec 3>&2 2>/tmp/zsh-trace-$$.log
setopt XTRACE PROMPT_SUBST
source ~/.zshrc
unsetopt XTRACE
exec 2>&3 3>&-
EOF
  
  chmod +x "$BENCHMARK_DIR/trace.zsh"
  zsh -i "$BENCHMARK_DIR/trace.zsh" 2>/dev/null
  
  local trace_file="/tmp/zsh-trace-$$.log"
  if [[ -f "$trace_file" ]]; then
    echo -e "\n${CYAN}Slowest operations (>10ms):${RESET}"
    awk '{
      split($1, time, ".")
      ms = (time[2] / 1000)
      if (ms > 10) {
        printf "  %.1fms: %s\n", ms, substr($0, index($0, $2))
      }
    }' "$trace_file" | sort -rn | head -20
    
    rm -f "$trace_file"
  fi
}

# ============================================================================
# MAIN MENU
# ============================================================================

show_menu() {
  echo -e "${MAGENTA}"
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║         ZSH PERFORMANCE BENCHMARKING SUITE          ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
  echo "1) Quick benchmark (startup times)"
  echo "2) Full analysis (all tests)"
  echo "3) Plugin loading analysis"
  echo "4) Component timing"
  echo "5) Detailed trace"
  echo "6) Compare configurations"
  echo "7) Optimization suggestions"
  echo "8) Exit"
  echo
  read -p "Select option: " choice
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
  if [[ $# -gt 0 ]]; then
    case "$1" in
      --quick|-q)
        benchmark_startup
        ;;
      --full|-f)
        benchmark_startup
        analyze_plugins
        time_components
        suggest_optimizations
        ;;
      --compare|-c)
        if [[ -n "${2:-}" ]]; then
          compare_configs "$2"
        else
          echo "Usage: $0 --compare <config-file>"
          exit 1
        fi
        ;;
      --trace|-t)
        detailed_trace
        ;;
      --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo "Options:"
        echo "  --quick, -q       Quick startup benchmark"
        echo "  --full, -f        Full analysis"
        echo "  --compare, -c     Compare configurations"
        echo "  --trace, -t       Detailed startup trace"
        echo "  --help, -h        Show this help"
        ;;
      *)
        echo "Unknown option: $1"
        echo "Run $0 --help for usage"
        exit 1
        ;;
    esac
  else
    # Interactive mode
    while true; do
      show_menu
      case $choice in
        1) benchmark_startup ;;
        2) benchmark_startup
           analyze_plugins
           time_components
           suggest_optimizations ;;
        3) analyze_plugins ;;
        4) time_components ;;
        5) detailed_trace ;;
        6) read -p "Enter config file path: " config_file
           compare_configs "$config_file" ;;
        7) suggest_optimizations ;;
        8) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
      esac
      echo
      read -p "Press Enter to continue..."
    done
  fi
}

main "$@"