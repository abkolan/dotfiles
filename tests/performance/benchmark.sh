#!/usr/bin/env bash
# Performance Benchmark Suite
# Tracks performance metrics over time and detects regressions

source "$(dirname "$0")/../test-framework.sh"

# ===========================
# Configuration
# ===========================
BENCHMARK_DIR="$HOME/.dotfiles-benchmarks"
BENCHMARK_FILE="$BENCHMARK_DIR/benchmarks.json"
BENCHMARK_HISTORY="$BENCHMARK_DIR/history.csv"
REGRESSION_THRESHOLD=20  # Percent increase that triggers alert

# ===========================
# Helper Functions
# ===========================
init_benchmark_dir() {
    mkdir -p "$BENCHMARK_DIR"
    
    # Initialize history file with headers if doesn't exist
    if [[ ! -f "$BENCHMARK_HISTORY" ]]; then
        echo "timestamp,test_name,duration_ms,git_commit,status" > "$BENCHMARK_HISTORY"
    fi
}

get_current_commit() {
    git rev-parse --short HEAD 2>/dev/null || echo "unknown"
}

get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

measure_ms() {
    local start end duration_ns duration_ms
    
    # macOS and Linux compatible timing
    if [[ "$OSTYPE" == "darwin"* ]]; then
        start=$(python3 -c 'import time; print(int(time.time() * 1000000000))')
        "$@" >/dev/null 2>&1
        end=$(python3 -c 'import time; print(int(time.time() * 1000000000))')
    else
        start=$(date +%s%N)
        "$@" >/dev/null 2>&1
        end=$(date +%s%N)
    fi
    
    duration_ns=$((end - start))
    duration_ms=$((duration_ns / 1000000))
    echo "$duration_ms"
}

save_benchmark() {
    local test_name="$1"
    local duration="$2"
    local status="$3"
    local timestamp=$(get_timestamp)
    local commit=$(get_current_commit)
    
    echo "$timestamp,$test_name,$duration,$commit,$status" >> "$BENCHMARK_HISTORY"
}

get_baseline() {
    local test_name="$1"
    
    # Get median of last 5 successful runs
    if [[ -f "$BENCHMARK_HISTORY" ]]; then
        tail -100 "$BENCHMARK_HISTORY" | \
            grep ",$test_name," | \
            grep ",success$" | \
            tail -5 | \
            cut -d',' -f3 | \
            sort -n | \
            awk '{a[NR]=$1} END {print (NR%2)?a[(NR+1)/2]:(a[NR/2]+a[NR/2+1])/2}'
    else
        echo "0"
    fi
}

check_regression() {
    local test_name="$1"
    local current="$2"
    local baseline=$(get_baseline "$test_name")
    
    if [[ -z "$baseline" ]] || [[ "$baseline" == "0" ]]; then
        echo "NEW"
        return 0
    fi
    
    local increase=$(( (current - baseline) * 100 / baseline ))
    
    if [[ $increase -gt $REGRESSION_THRESHOLD ]]; then
        echo "REGRESSION"
        return 1
    elif [[ $increase -lt -10 ]]; then
        echo "IMPROVED"
        return 0
    else
        echo "OK"
        return 0
    fi
}

# ===========================
# Benchmarks
# ===========================
start_component "Performance Benchmarks"

init_benchmark_dir

echo ""
echo "  Running performance benchmarks..."
echo "  Baseline data: $BENCHMARK_DIR"
echo ""

TOTAL_BENCHMARKS=0
REGRESSIONS=0
IMPROVEMENTS=0

# ===========================
# Benchmark: ZSH Startup Time
# ===========================
echo -e "${CYAN}Benchmark: ZSH Startup Time${NC}"

# Warm up
zsh -i -c "exit" 2>/dev/null

# Run multiple iterations
total_time=0
iterations=5
for i in $(seq 1 $iterations); do
    iter_time=$(measure_ms zsh -i -c "exit")
    total_time=$((total_time + iter_time))
    echo -n "."
done
echo ""

avg_time=$((total_time / iterations))
status=$(check_regression "zsh_startup" "$avg_time")
save_benchmark "zsh_startup" "$avg_time" "success"

baseline=$(get_baseline "zsh_startup")
if [[ "$baseline" != "0" ]]; then
    echo "  Current: ${avg_time}ms | Baseline: ${baseline}ms | Status: $status"
else
    echo "  Current: ${avg_time}ms | Status: $status (no baseline)"
fi

((TOTAL_BENCHMARKS++))
[[ "$status" == "REGRESSION" ]] && ((REGRESSIONS++))
[[ "$status" == "IMPROVED" ]] && ((IMPROVEMENTS++))

# ===========================
# Benchmark: Neovim Startup Time
# ===========================
if command_exists nvim; then
    echo ""
    echo -e "${CYAN}Benchmark: Neovim Startup Time${NC}"
    
    # Warm up
    nvim --headless +quit 2>/dev/null
    
    total_time=0
    for i in $(seq 1 $iterations); do
        iter_time=$(measure_ms nvim --headless +quit)
        total_time=$((total_time + iter_time))
        echo -n "."
    done
    echo ""
    
    avg_time=$((total_time / iterations))
    status=$(check_regression "nvim_startup" "$avg_time")
    save_benchmark "nvim_startup" "$avg_time" "success"
    
    baseline=$(get_baseline "nvim_startup")
    if [[ "$baseline" != "0" ]]; then
        echo "  Current: ${avg_time}ms | Baseline: ${baseline}ms | Status: $status"
    else
        echo "  Current: ${avg_time}ms | Status: $status (no baseline)"
    fi
    
    ((TOTAL_BENCHMARKS++))
    [[ "$status" == "REGRESSION" ]] && ((REGRESSIONS++))
    [[ "$status" == "IMPROVED" ]] && ((IMPROVEMENTS++))
fi

# ===========================
# Benchmark: Git Status Performance
# ===========================
echo ""
echo -e "${CYAN}Benchmark: Git Status Performance${NC}"

# Create test repository
TEST_REPO=$(mktemp -d "/tmp/git-bench.XXXXX")
cd "$TEST_REPO"
git init --quiet
for i in {1..100}; do
    echo "content $i" > "file$i.txt"
done
git add .
git commit -m "Benchmark commit" --quiet

total_time=0
for i in $(seq 1 $iterations); do
    iter_time=$(measure_ms git status)
    total_time=$((total_time + iter_time))
    echo -n "."
done
echo ""

avg_time=$((total_time / iterations))
status=$(check_regression "git_status" "$avg_time")
save_benchmark "git_status" "$avg_time" "success"

baseline=$(get_baseline "git_status")
if [[ "$baseline" != "0" ]]; then
    echo "  Current: ${avg_time}ms | Baseline: ${baseline}ms | Status: $status"
else
    echo "  Current: ${avg_time}ms | Status: $status (no baseline)"
fi

((TOTAL_BENCHMARKS++))
[[ "$status" == "REGRESSION" ]] && ((REGRESSIONS++))
[[ "$status" == "IMPROVED" ]] && ((IMPROVEMENTS++))

cd - >/dev/null
rm -rf "$TEST_REPO"

# ===========================
# Benchmark: File Search (fd)
# ===========================
if command_exists fd; then
    echo ""
    echo -e "${CYAN}Benchmark: File Search Performance (fd)${NC}"
    
    # Create test directory structure
    TEST_DIR=$(mktemp -d "/tmp/fd-bench.XXXXX")
    cd "$TEST_DIR"
    for dir in {1..10}; do
        mkdir -p "dir$dir/subdir"
        for file in {1..20}; do
            touch "dir$dir/file$file.txt"
            touch "dir$dir/subdir/sub$file.txt"
        done
    done
    
    total_time=0
    for i in $(seq 1 $iterations); do
        iter_time=$(measure_ms fd ".txt$")
        total_time=$((total_time + iter_time))
        echo -n "."
    done
    echo ""
    
    avg_time=$((total_time / iterations))
    status=$(check_regression "fd_search" "$avg_time")
    save_benchmark "fd_search" "$avg_time" "success"
    
    baseline=$(get_baseline "fd_search")
    if [[ "$baseline" != "0" ]]; then
        echo "  Current: ${avg_time}ms | Baseline: ${baseline}ms | Status: $status"
    else
        echo "  Current: ${avg_time}ms | Status: $status (no baseline)"
    fi
    
    ((TOTAL_BENCHMARKS++))
    [[ "$status" == "REGRESSION" ]] && ((REGRESSIONS++))
    [[ "$status" == "IMPROVED" ]] && ((IMPROVEMENTS++))
    
    cd - >/dev/null
    rm -rf "$TEST_DIR"
fi

# ===========================
# Benchmark: Code Search (ripgrep)
# ===========================
if command_exists rg; then
    echo ""
    echo -e "${CYAN}Benchmark: Code Search Performance (ripgrep)${NC}"
    
    # Create test codebase
    TEST_DIR=$(mktemp -d "/tmp/rg-bench.XXXXX")
    cd "$TEST_DIR"
    for file in {1..50}; do
        cat > "code$file.js" << EOF
function process$file() {
    const data = fetchData();
    const result = transform(data);
    return result;
}

class Handler$file {
    constructor() {
        this.id = $file;
    }
    
    handle(request) {
        return process$file(request);
    }
}
EOF
    done
    
    total_time=0
    for i in $(seq 1 $iterations); do
        iter_time=$(measure_ms rg "fetchData")
        total_time=$((total_time + iter_time))
        echo -n "."
    done
    echo ""
    
    avg_time=$((total_time / iterations))
    status=$(check_regression "rg_search" "$avg_time")
    save_benchmark "rg_search" "$avg_time" "success"
    
    baseline=$(get_baseline "rg_search")
    if [[ "$baseline" != "0" ]]; then
        echo "  Current: ${avg_time}ms | Baseline: ${baseline}ms | Status: $status"
    else
        echo "  Current: ${avg_time}ms | Status: $status (no baseline)"
    fi
    
    ((TOTAL_BENCHMARKS++))
    [[ "$status" == "REGRESSION" ]] && ((REGRESSIONS++))
    [[ "$status" == "IMPROVED" ]] && ((IMPROVEMENTS++))
    
    cd - >/dev/null
    rm -rf "$TEST_DIR"
fi

# ===========================
# Benchmark: Directory Navigation
# ===========================
echo ""
echo -e "${CYAN}Benchmark: Directory Navigation${NC}"

TEST_DIR=$(mktemp -d "/tmp/nav-bench.XXXXX")
cd "$TEST_DIR"
mkdir -p deep/nested/directory/structure/here

total_time=0
for i in $(seq 1 $iterations); do
    start_time=$(measure_ms cd deep/nested/directory/structure/here)
    cd "$TEST_DIR"
    total_time=$((total_time + start_time))
    echo -n "."
done
echo ""

avg_time=$((total_time / iterations))
status=$(check_regression "dir_navigation" "$avg_time")
save_benchmark "dir_navigation" "$avg_time" "success"

baseline=$(get_baseline "dir_navigation")
if [[ "$baseline" != "0" ]]; then
    echo "  Current: ${avg_time}ms | Baseline: ${baseline}ms | Status: $status"
else
    echo "  Current: ${avg_time}ms | Status: $status (no baseline)"
fi

((TOTAL_BENCHMARKS++))
[[ "$status" == "REGRESSION" ]] && ((REGRESSIONS++))
[[ "$status" == "IMPROVED" ]] && ((IMPROVEMENTS++))

cd - >/dev/null
rm -rf "$TEST_DIR"

# ===========================
# Generate Performance Report
# ===========================
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Performance Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Total Benchmarks: $TOTAL_BENCHMARKS"
echo -e "  Regressions: ${RED}$REGRESSIONS${NC}"
echo -e "  Improvements: ${GREEN}$IMPROVEMENTS${NC}"
echo ""

if [[ $REGRESSIONS -gt 0 ]]; then
    echo -e "${RED}⚠️  Performance regressions detected!${NC}"
    echo "  Review recent changes that might have impacted performance."
    echo "  History: $BENCHMARK_HISTORY"
    exit 1
else
    echo -e "${GREEN}✅ All performance benchmarks passed${NC}"
fi

# Generate trend report
if [[ -f "$BENCHMARK_HISTORY" ]]; then
    echo ""
    echo -e "${CYAN}Recent Trends (last 5 runs):${NC}"
    for test in zsh_startup nvim_startup git_status fd_search rg_search dir_navigation; do
        if grep -q ",$test," "$BENCHMARK_HISTORY"; then
            recent=$(tail -100 "$BENCHMARK_HISTORY" | grep ",$test," | tail -5 | cut -d',' -f3 | tr '\n' ' ')
            if [[ -n "$recent" ]]; then
                echo "  $test: $recent ms"
            fi
        fi
    done
fi

# Return success
exit 0