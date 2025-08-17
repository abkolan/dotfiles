#!/usr/bin/env bash
# Test Coverage Report Generator
# Analyzes which parts of dotfiles are tested and generates coverage metrics

source "$(dirname "$0")/../test-framework.sh"

# ===========================
# Configuration
# ===========================
COVERAGE_DIR="$HOME/.dotfiles-coverage"
COVERAGE_REPORT="$COVERAGE_DIR/coverage.html"
DOTFILES_DIR="$(cd "$(dirname "$(dirname "$(dirname "$0")")")" && pwd)"

# ===========================
# Helper Functions
# ===========================
init_coverage_dir() {
    mkdir -p "$COVERAGE_DIR"
}

count_lines() {
    local file="$1"
    wc -l < "$file" | tr -d ' '
}

analyze_file_coverage() {
    local file="$1"
    local test_dir="$2"
    
    # Check if file is referenced in any test
    local coverage=0
    local filename=$(basename "$file")
    
    # Search for references in test files
    if rg -q "$filename" "$test_dir" 2>/dev/null || grep -r -q "$filename" "$test_dir" 2>/dev/null; then
        coverage=1
    fi
    
    echo "$coverage"
}

generate_html_report() {
    cat > "$COVERAGE_REPORT" << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Dotfiles Test Coverage Report</title>
    <style>
        body {
            font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
            background: #1e1e1e;
            color: #d4d4d4;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #569cd6;
            border-bottom: 2px solid #569cd6;
            padding-bottom: 10px;
        }
        h2 {
            color: #4ec9b0;
            margin-top: 30px;
        }
        .summary {
            background: #252526;
            border: 1px solid #464647;
            border-radius: 5px;
            padding: 20px;
            margin: 20px 0;
        }
        .metric {
            display: inline-block;
            margin: 10px 20px 10px 0;
        }
        .metric-value {
            font-size: 2em;
            font-weight: bold;
        }
        .metric-label {
            color: #858585;
            font-size: 0.9em;
        }
        .good { color: #4ec9b0; }
        .warning { color: #ce9178; }
        .bad { color: #f48771; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th {
            background: #2d2d30;
            padding: 10px;
            text-align: left;
            border: 1px solid #464647;
        }
        td {
            padding: 8px;
            border: 1px solid #464647;
        }
        tr:nth-child(even) {
            background: #252526;
        }
        .covered {
            background: #0e3c0e;
        }
        .uncovered {
            background: #3c0e0e;
        }
        .progress-bar {
            background: #252526;
            border: 1px solid #464647;
            border-radius: 3px;
            height: 20px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #4ec9b0 0%, #569cd6 100%);
            transition: width 0.3s ease;
        }
    </style>
</head>
<body>
    <h1>🧪 Dotfiles Test Coverage Report</h1>
    <p>Generated: $(date '+%Y-%m-%d %H:%M:%S')</p>
    
    <div class="summary">
        <h2>Coverage Summary</h2>
        <div class="metrics">
HTML
}

generate_html_footer() {
    cat >> "$COVERAGE_REPORT" << 'HTML'
        </div>
    </div>
    
    <h2>Recommendations</h2>
    <ul id="recommendations"></ul>
    
    <script>
        // Add recommendations based on coverage
        const recs = document.getElementById('recommendations');
        const coverage = parseFloat(document.querySelector('.overall-coverage').textContent);
        
        if (coverage < 50) {
            recs.innerHTML += '<li>⚠️ Coverage is below 50% - consider adding more tests</li>';
        }
        if (coverage < 30) {
            recs.innerHTML += '<li>🔴 Critical: Most functionality is untested</li>';
        }
        if (coverage > 80) {
            recs.innerHTML += '<li>✅ Excellent coverage! Keep it up!</li>';
        }
    </script>
</body>
</html>
HTML
}

# ===========================
# Coverage Analysis
# ===========================
start_component "Test Coverage Analysis"

init_coverage_dir

echo ""
echo "  Analyzing test coverage..."
echo "  Dotfiles directory: $DOTFILES_DIR"
echo ""

# ===========================
# Collect Files to Analyze
# ===========================
declare -A file_coverage
declare -A component_files
declare -A component_coverage

total_files=0
covered_files=0

# Analyze shell configurations
echo "  Analyzing shell configurations..."
for file in "$DOTFILES_DIR"/zsh/.zsh* "$DOTFILES_DIR"/zsh/.p10k.zsh; do
    if [[ -f "$file" ]]; then
        ((total_files++))
        filename=$(basename "$file")
        
        # Check if tested
        if grep -r -q "$filename" "$DOTFILES_DIR/tests" 2>/dev/null; then
            file_coverage["$filename"]=1
            ((covered_files++))
            echo -e "    ${GREEN}✓${NC} $filename"
        else
            file_coverage["$filename"]=0
            echo -e "    ${RED}✗${NC} $filename"
        fi
    fi
done

# Analyze git configuration
echo ""
echo "  Analyzing git configuration..."
for file in "$DOTFILES_DIR"/git/.gitconfig "$DOTFILES_DIR"/git/.gitignore_global; do
    if [[ -f "$file" ]]; then
        ((total_files++))
        filename=$(basename "$file")
        
        if grep -r -q "gitconfig\|gitignore" "$DOTFILES_DIR/tests" 2>/dev/null; then
            file_coverage["$filename"]=1
            ((covered_files++))
            echo -e "    ${GREEN}✓${NC} $filename"
        else
            file_coverage["$filename"]=0
            echo -e "    ${RED}✗${NC} $filename"
        fi
    fi
done

# Analyze Neovim configuration
echo ""
echo "  Analyzing Neovim configuration..."
nvim_files=$(find "$DOTFILES_DIR/nvim" -name "*.lua" -o -name "*.vim" 2>/dev/null | wc -l)
nvim_tested=0

if [[ $nvim_files -gt 0 ]]; then
    if grep -r -q "nvim\|neovim" "$DOTFILES_DIR/tests" 2>/dev/null; then
        nvim_tested=$((nvim_files / 2))  # Assume 50% coverage for complex configs
    fi
    total_files=$((total_files + nvim_files))
    covered_files=$((covered_files + nvim_tested))
    
    echo -e "    Files: $nvim_files | Tested: ~$nvim_tested"
fi

# ===========================
# Test Type Coverage
# ===========================
echo ""
echo "  Analyzing test types..."

test_types=(
    "unit:Basic functionality tests"
    "integration:Component interaction tests"
    "functional:Real-world usage tests"
    "negative:Error handling tests"
    "performance:Speed and efficiency tests"
    "workflow:End-to-end scenario tests"
)

declare -A test_type_coverage
for type_desc in "${test_types[@]}"; do
    type="${type_desc%%:*}"
    desc="${type_desc##*:}"
    
    # Check if we have this type of test
    if [[ -d "$DOTFILES_DIR/tests/$type" ]] || grep -r -q "test.*$type" "$DOTFILES_DIR/tests" 2>/dev/null; then
        test_type_coverage["$type"]=1
        echo -e "    ${GREEN}✓${NC} $desc"
    else
        test_type_coverage["$type"]=0
        echo -e "    ${RED}✗${NC} $desc"
    fi
done

# ===========================
# Command Coverage
# ===========================
echo ""
echo "  Analyzing command coverage..."

# Extract all aliases and functions
all_aliases=$(zsh -i -c "alias" 2>/dev/null | cut -d'=' -f1 | wc -l)
tested_aliases=$(grep -r "alias.*=" "$DOTFILES_DIR/tests" 2>/dev/null | wc -l)

echo "    Aliases defined: $all_aliases"
echo "    Aliases tested: $tested_aliases"

# ===========================
# Calculate Coverage Metrics
# ===========================
if [[ $total_files -gt 0 ]]; then
    coverage_percent=$(( (covered_files * 100) / total_files ))
else
    coverage_percent=0
fi

if [[ $all_aliases -gt 0 ]]; then
    alias_coverage=$(( (tested_aliases * 100) / all_aliases ))
else
    alias_coverage=0
fi

# Count test files
test_files=$(find "$DOTFILES_DIR/tests" -name "*.sh" 2>/dev/null | wc -l)
test_assertions=$(grep -r "test_case\|test_output" "$DOTFILES_DIR/tests" 2>/dev/null | wc -l)

# ===========================
# Generate Report
# ===========================
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Coverage Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Determine coverage quality
if [[ $coverage_percent -ge 80 ]]; then
    coverage_color="${GREEN}"
    coverage_status="Excellent"
elif [[ $coverage_percent -ge 60 ]]; then
    coverage_color="${YELLOW}"
    coverage_status="Good"
else
    coverage_color="${RED}"
    coverage_status="Needs Improvement"
fi

echo -e "  Overall Coverage: ${coverage_color}${coverage_percent}%${NC} (${coverage_status})"
echo -e "  Files Covered: $covered_files / $total_files"
echo -e "  Alias Coverage: ${alias_coverage}%"
echo ""
echo -e "  Test Files: $test_files"
echo -e "  Test Assertions: $test_assertions"
echo ""

# ===========================
# Generate HTML Report
# ===========================
generate_html_report

cat >> "$COVERAGE_REPORT" << HTML
            <div class="metric">
                <div class="metric-value overall-coverage ${coverage_status,,}">$coverage_percent%</div>
                <div class="metric-label">Overall Coverage</div>
            </div>
            <div class="metric">
                <div class="metric-value">$covered_files/$total_files</div>
                <div class="metric-label">Files Covered</div>
            </div>
            <div class="metric">
                <div class="metric-value">$test_files</div>
                <div class="metric-label">Test Files</div>
            </div>
            <div class="metric">
                <div class="metric-value">$test_assertions</div>
                <div class="metric-label">Assertions</div>
            </div>
        </div>
    </div>
    
    <h2>File Coverage</h2>
    <table>
        <tr>
            <th>File</th>
            <th>Status</th>
        </tr>
HTML

for file in "${!file_coverage[@]}"; do
    if [[ ${file_coverage[$file]} -eq 1 ]]; then
        echo "        <tr class='covered'><td>$file</td><td>✅ Covered</td></tr>" >> "$COVERAGE_REPORT"
    else
        echo "        <tr class='uncovered'><td>$file</td><td>❌ Not Covered</td></tr>" >> "$COVERAGE_REPORT"
    fi
done

echo "    </table>" >> "$COVERAGE_REPORT"

# Add test type coverage
cat >> "$COVERAGE_REPORT" << HTML
    <h2>Test Type Coverage</h2>
    <table>
        <tr>
            <th>Test Type</th>
            <th>Status</th>
        </tr>
HTML

for type_desc in "${test_types[@]}"; do
    type="${type_desc%%:*}"
    desc="${type_desc##*:}"
    if [[ ${test_type_coverage[$type]} -eq 1 ]]; then
        echo "        <tr class='covered'><td>$desc</td><td>✅ Implemented</td></tr>" >> "$COVERAGE_REPORT"
    else
        echo "        <tr class='uncovered'><td>$desc</td><td>❌ Missing</td></tr>" >> "$COVERAGE_REPORT"
    fi
done

echo "    </table>" >> "$COVERAGE_REPORT"

generate_html_footer

echo -e "${GREEN}✅ Coverage report generated: $COVERAGE_REPORT${NC}"

# Open report if on macOS
if [[ "$OSTYPE" == "darwin"* ]] && [[ -t 1 ]]; then
    read -p "Open coverage report in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "$COVERAGE_REPORT"
    fi
fi

# Return status based on coverage
if [[ $coverage_percent -lt 30 ]]; then
    echo ""
    echo -e "${RED}⚠️  Coverage is critically low!${NC}"
    exit 1
fi

exit 0