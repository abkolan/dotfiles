#!/bin/bash
# Profile ZSH startup components

echo "🔍 ZSH Startup Profiler"
echo "======================"
echo ""

# Test basic shell without rc files
echo "⏱️  Basic shell (no config):"
time zsh -f -c 'exit' 2>&1 | grep real

# Test with only .zshenv
echo ""
echo "⏱️  With .zshenv only:"
time zsh --no-rcs -c 'source ~/.zshenv; exit' 2>&1 | grep real

# Test full interactive shell
echo ""
echo "⏱️  Full interactive shell:"
time zsh -i -c 'exit' 2>&1 | grep real

# Detailed profiling
echo ""
echo "📊 Detailed component timing:"
echo "-----------------------------"

# Create a temporary profiling zshrc
cat > /tmp/profile-zshrc << 'EOF'
# Profiling wrapper
zmodload zsh/zprof

# Source the actual zshrc
source ~/.zshrc

# Show profiling results
zprof
EOF

echo ""
echo "Top 10 slowest functions/commands:"
zsh -c 'source /tmp/profile-zshrc' 2>&1 | head -20

# Cleanup
rm -f /tmp/profile-zshrc

echo ""
echo "💡 Tips:"
echo "  - Functions taking >50ms should be optimized"
echo "  - Consider lazy-loading slow plugins"
echo "  - Use 'zsh -xvs' for line-by-line tracing"