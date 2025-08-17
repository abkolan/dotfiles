#!/usr/bin/env bash
echo "📊 ZSH Performance Benchmark"
echo "============================"

# Check if hyperfine is available for better measurements
if command -v hyperfine &>/dev/null; then
    echo "Using hyperfine for accurate measurements..."
    hyperfine --warmup 3 --min-runs 10 'zsh -i -c exit'
else
    echo "Install hyperfine for better benchmarking: brew install hyperfine"
    echo "Falling back to basic timing..."
    
    # Cold start (clear cache)
    echo "Cold start times:"
    for i in {1..5}; do
        /usr/bin/time -p zsh -i -c 'exit' 2>&1 | grep real | awk '{print "  Run '$i': " $2 "s"}'
    done
    
    # Warm start
    echo -e "\nWarm start times:"
    for i in {1..5}; do
        /usr/bin/time -p zsh -i -c 'exit' 2>&1 | grep real | awk '{print "  Run '$i': " $2 "s"}'
    done
fi

# Plugin load times
echo -e "\nPlugin load analysis:"
PROFILE_STARTUP=true zsh -i -c 'exit' 2>&1 | grep -E "^[0-9]+" | head -10