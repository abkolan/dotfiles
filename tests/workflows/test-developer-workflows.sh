#!/usr/bin/env bash
# Workflow Tests - Test real developer workflows end-to-end
# Simulates actual development scenarios

source "$(dirname "$0")/../test-framework.sh"

start_component "Developer Workflow Tests"

# ===========================
# Helper Functions
# ===========================
setup_test_project() {
    local project_dir=$(mktemp -d "/tmp/workflow-test.XXXXX")
    cd "$project_dir"
    
    # Create a realistic project structure
    mkdir -p myapp/{src,tests,docs,.github/workflows}
    
    cat > myapp/README.md << 'EOF'
# MyApp
A test application for workflow testing.

## Features
- Feature 1
- Feature 2

## Installation
```bash
npm install
```
EOF

    cat > myapp/package.json << 'EOF'
{
  "name": "myapp",
  "version": "1.0.0",
  "description": "Test application",
  "main": "src/index.js",
  "scripts": {
    "test": "echo 'Tests pass'",
    "start": "node src/index.js"
  }
}
EOF

    cat > myapp/src/index.js << 'EOF'
console.log("Hello from MyApp!");

function processData(data) {
    return data.map(item => item * 2);
}

module.exports = { processData };
EOF

    cat > myapp/tests/index.test.js << 'EOF'
const { processData } = require('../src/index');

test('processData doubles values', () => {
    expect(processData([1, 2, 3])).toEqual([2, 4, 6]);
});
EOF
    
    echo "$project_dir"
}

measure_time() {
    local start=$(date +%s)
    "$@"
    local end=$(date +%s)
    echo $((end - start))
}

# ===========================
# Workflow 1: New Project Setup
# ===========================
echo ""
echo "  Testing new project setup workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

# Initialize git repository
if git init --quiet 2>/dev/null; then
    test_case "Git repository initialized" "true"
    
    # Configure git
    git config user.email "test@example.com"
    git config user.name "Test Developer"
    
    # Stage and commit initial files
    git add .
    if git commit -m "Initial commit" --quiet 2>/dev/null; then
        test_case "Initial commit successful" "true"
        
        # Verify commit exists
        if git log --oneline | grep -q "Initial commit"; then
            test_case "Commit history verified" "true"
        else
            test_case "Commit history verified" "false"
        fi
    else
        test_case "Initial commit successful" "false"
    fi
else
    test_case "Git repository initialized" "false"
fi

# Test file navigation with modern tools
if command_exists fd; then
    if fd_output=$(fd ".js$" 2>/dev/null); then
        if echo "$fd_output" | grep -q "index.js" && echo "$fd_output" | grep -q "test.js"; then
            test_case "File discovery with fd works" "true"
        else
            test_case "File discovery with fd works" "false"
        fi
    else
        test_case "fd command execution" "false"
    fi
else
    skip_test "File discovery with fd" "fd not installed"
fi

# Test code search with ripgrep
if command_exists rg; then
    if rg_output=$(rg "processData" 2>/dev/null); then
        if echo "$rg_output" | grep -q "src/index.js" && echo "$rg_output" | grep -q "tests/index.test.js"; then
            test_case "Code search with ripgrep works" "true"
        else
            test_case "Code search with ripgrep works" "false"
        fi
    else
        test_case "ripgrep command execution" "false"
    fi
else
    skip_test "Code search with ripgrep" "ripgrep not installed"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 2: Feature Development
# ===========================
echo ""
echo "  Testing feature development workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

# Initialize git
git init --quiet
git config user.email "test@example.com"
git config user.name "Test Developer"
git add .
git commit -m "Initial commit" --quiet

# Create feature branch
if git checkout -b feature/new-feature 2>/dev/null; then
    test_case "Feature branch created" "true"
    
    # Add new feature file
    cat > src/feature.js << 'EOF'
// New feature implementation
export function newFeature() {
    return "Feature implemented!";
}
EOF
    
    # Stage and commit feature
    git add src/feature.js
    git commit -m "Add new feature" --quiet
    
    # Switch back to main and merge
    git checkout main --quiet 2>/dev/null || git checkout master --quiet 2>/dev/null
    if git merge feature/new-feature --no-ff -m "Merge feature/new-feature" --quiet 2>/dev/null; then
        test_case "Feature branch merged successfully" "true"
        
        # Verify merge in history
        if git log --oneline | grep -q "Merge feature/new-feature"; then
            test_case "Merge commit exists" "true"
        else
            test_case "Merge commit exists" "false"
        fi
    else
        test_case "Feature branch merged successfully" "false"
    fi
else
    test_case "Feature branch created" "false"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 3: Code Review Process
# ===========================
echo ""
echo "  Testing code review workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

git init --quiet
git config user.email "test@example.com"
git config user.name "Test Developer"
git add .
git commit -m "Initial commit" --quiet

# Create changes for review
cat >> src/index.js << 'EOF'

// TODO: Implement caching
function fetchData(url) {
    // FIXME: Add error handling
    return fetch(url);
}
EOF

# Check for TODOs and FIXMEs
if command_exists rg; then
    todos=$(rg "TODO|FIXME" 2>/dev/null | wc -l)
    if [[ $todos -gt 0 ]]; then
        test_case "Code review markers detected" "true"
    else
        test_case "Code review markers detected" "false"
    fi
else
    if grep -r "TODO\|FIXME" . 2>/dev/null | grep -q "TODO\|FIXME"; then
        test_case "Code review markers detected" "true"
    else
        test_case "Code review markers detected" "false"
    fi
fi

# Test diff viewing
git add -A
if git diff --cached | grep -q "TODO\|FIXME"; then
    test_case "Git diff shows review comments" "true"
else
    test_case "Git diff shows review comments" "false"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 4: Debugging Session
# ===========================
echo ""
echo "  Testing debugging workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

# Add code with intentional issues
cat > src/buggy.js << 'EOF'
function calculateTotal(items) {
    let total = 0;
    for (let i = 0; i <= items.length; i++) {  // Off-by-one error
        total += items[i].price;  // Will throw on last iteration
    }
    return total;
}

function processUser(user) {
    console.log("Processing user: " + user.name);  // Will fail if user is null
    return user.id;
}
EOF

# Search for console.log statements (common debugging artifacts)
if rg_output=$(rg "console.log" 2>/dev/null || grep -r "console.log" . 2>/dev/null); then
    if echo "$rg_output" | grep -q "Processing user"; then
        test_case "Debug statements found in code" "true"
    else
        test_case "Debug statements found in code" "false"
    fi
else
    test_case "Debug statement search" "false"
fi

# Test viewing specific line ranges (useful for debugging)
if command_exists bat; then
    if bat --line-range 3:5 src/buggy.js 2>/dev/null | grep -q "i <= items.length"; then
        test_case "Line-specific file viewing works" "true"
    else
        test_case "Line-specific file viewing works" "false"
    fi
else
    skip_test "Line-specific viewing with bat" "bat not installed"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 5: Performance Optimization
# ===========================
echo ""
echo "  Testing performance optimization workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

# Create a large file to test performance tools
for i in {1..1000}; do
    echo "function process$i() { return $i * 2; }" >> src/large.js
done

# Measure file operations performance
if command_exists fd; then
    fd_time=$(measure_time fd ".js$" 2>/dev/null)
    if [[ $fd_time -lt 2 ]]; then
        test_case "Fast file search performance (<2s)" "true"
    else
        test_case "Fast file search performance (<2s)" "false"
    fi
else
    skip_test "File search performance" "fd not installed"
fi

if command_exists rg; then
    rg_time=$(measure_time rg "process500" 2>/dev/null)
    if [[ $rg_time -lt 1 ]]; then
        test_case "Fast code search performance (<1s)" "true"
    else
        test_case "Fast code search performance (<1s)" "false"
    fi
else
    skip_test "Code search performance" "ripgrep not installed"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 6: Multi-file Refactoring
# ===========================
echo ""
echo "  Testing multi-file refactoring workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

# Create multiple files with old function name
echo "function oldName() { return 1; }" > src/file1.js
echo "const result = oldName();" > src/file2.js
echo "export { oldName };" > src/file3.js
echo "import { oldName } from './file1';" > tests/test1.js

# Count occurrences before refactoring
if command_exists rg; then
    old_count=$(rg "oldName" --count-matches . 2>/dev/null | grep -o '[0-9]' | paste -sd+ | bc 2>/dev/null || echo "0")
    
    if [[ $old_count -eq 4 ]]; then
        test_case "Found all occurrences to refactor" "true"
        
        # Simulate refactoring (would use sed/perl in real scenario)
        find . -name "*.js" -type f -exec sed -i.bak 's/oldName/newName/g' {} \;
        
        new_count=$(rg "newName" --count-matches . 2>/dev/null | grep -o '[0-9]' | paste -sd+ | bc 2>/dev/null || echo "0")
        if [[ $new_count -eq 4 ]]; then
            test_case "Refactoring applied to all files" "true"
        else
            test_case "Refactoring applied to all files" "false"
        fi
    else
        test_case "Found all occurrences to refactor" "false"
    fi
else
    skip_test "Multi-file refactoring" "ripgrep not installed"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 7: Documentation Generation
# ===========================
echo ""
echo "  Testing documentation workflow..."

PROJECT_DIR=$(setup_test_project)
cd "$PROJECT_DIR/myapp"

# Create documented code
cat > src/documented.js << 'EOF'
/**
 * Calculate the sum of an array
 * @param {number[]} numbers - Array of numbers to sum
 * @returns {number} The sum of all numbers
 */
function sum(numbers) {
    return numbers.reduce((a, b) => a + b, 0);
}

/**
 * User class
 * @class
 */
class User {
    /**
     * Create a user
     * @param {string} name - User name
     * @param {string} email - User email
     */
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }
}
EOF

# Search for JSDoc comments
if doc_count=$(rg "/\*\*" src/documented.js 2>/dev/null | wc -l); then
    if [[ $doc_count -ge 3 ]]; then
        test_case "Documentation comments found" "true"
    else
        test_case "Documentation comments found" "false"
    fi
else
    test_case "Documentation search" "false"
fi

# Test markdown rendering with bat
if command_exists bat; then
    if bat README.md --style=plain 2>/dev/null | grep -q "## Features"; then
        test_case "Markdown documentation viewable" "true"
    else
        test_case "Markdown documentation viewable" "false"
    fi
else
    skip_test "Markdown viewing with bat" "bat not installed"
fi

cd - > /dev/null
rm -rf "$PROJECT_DIR"

# ===========================
# Workflow 8: Environment Setup
# ===========================
echo ""
echo "  Testing environment setup workflow..."

# Test PATH manipulation
ORIGINAL_PATH="$PATH"
export PATH="/custom/bin:$PATH"

if echo "$PATH" | grep -q "^/custom/bin"; then
    test_case "PATH modification works" "true"
else
    test_case "PATH modification works" "false"
fi

export PATH="$ORIGINAL_PATH"

# Test environment variable management
export TEST_VAR="test_value"
if [[ "$TEST_VAR" == "test_value" ]]; then
    test_case "Environment variable setting works" "true"
else
    test_case "Environment variable setting works" "false"
fi
unset TEST_VAR

# Test alias creation and usage
if zsh -i -c "alias testcmd='echo success'" 2>/dev/null; then
    if zsh -i -c "alias testcmd='echo success'; testcmd" 2>/dev/null | grep -q "success"; then
        test_case "Dynamic alias creation works" "true"
    else
        test_case "Dynamic alias creation works" "false"
    fi
else
    test_case "Alias creation" "false"
fi

# Return test results
print_summary