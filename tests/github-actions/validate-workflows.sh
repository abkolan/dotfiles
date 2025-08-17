#!/usr/bin/env bash
# Validate GitHub Actions Workflows
# Tests workflow syntax, structure, and best practices

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
TOTAL_WORKFLOWS=0
VALID_WORKFLOWS=0
INVALID_WORKFLOWS=0
WARNINGS=0

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}         GitHub Actions Workflow Validation                     ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to validate YAML syntax
validate_yaml() {
    local file=$1
    
    # Check if file exists
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}✗ File not found: $file${NC}"
        return 1
    fi
    
    # Basic YAML validation using Python
    if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check workflow structure
check_workflow_structure() {
    local file=$1
    local name=$(basename "$file" .yml)
    
    echo -e "${CYAN}Checking: $name${NC}"
    ((TOTAL_WORKFLOWS++))
    
    local issues=()
    local warnings=()
    
    # Check YAML syntax
    if ! validate_yaml "$file"; then
        issues+=("Invalid YAML syntax")
    fi
    
    # Check for required fields
    if ! grep -q "^name:" "$file"; then
        issues+=("Missing 'name' field")
    fi
    
    if ! grep -q "^on:" "$file"; then
        issues+=("Missing 'on' trigger field")
    fi
    
    if ! grep -q "^jobs:" "$file"; then
        issues+=("Missing 'jobs' field")
    fi
    
    # Check for best practices
    if ! grep -q "actions/checkout@v" "$file"; then
        warnings+=("No checkout action found - might be intentional")
    fi
    
    # Check for deprecated actions
    if grep -q "actions/checkout@v1\|actions/checkout@v2" "$file"; then
        warnings+=("Using deprecated checkout version (use @v4)")
    fi
    
    if grep -q "actions/upload-artifact@v1\|actions/upload-artifact@v2" "$file"; then
        warnings+=("Using deprecated upload-artifact version (use @v3 or @v4)")
    fi
    
    # Check for secrets usage
    if grep -q '\${{ secrets\.' "$file" && ! grep -q '\${{ secrets\.GITHUB_TOKEN }}' "$file"; then
        echo "  ℹ️  Uses custom secrets"
    fi
    
    # Check for matrix strategy
    if grep -q "strategy:" "$file" && grep -q "matrix:" "$file"; then
        echo "  ℹ️  Uses matrix strategy"
    fi
    
    # Report results
    if [[ ${#issues[@]} -eq 0 ]]; then
        echo -e "  ${GREEN}✓ Valid workflow${NC}"
        ((VALID_WORKFLOWS++))
        
        # Show job count
        local job_count=$(grep -E "^  [a-zA-Z0-9_-]+:" "$file" | grep -v "steps:" | wc -l)
        echo "  ${CYAN}Jobs: $job_count${NC}"
        
        # Show triggers
        local triggers=$(grep -A10 "^on:" "$file" | grep -E "^\s+(push|pull_request|schedule|workflow_dispatch):" | sed 's/://g' | xargs)
        if [[ -n "$triggers" ]]; then
            echo "  ${CYAN}Triggers: $triggers${NC}"
        fi
    else
        echo -e "  ${RED}✗ Invalid workflow${NC}"
        ((INVALID_WORKFLOWS++))
        for issue in "${issues[@]}"; do
            echo -e "    ${RED}• $issue${NC}"
        done
    fi
    
    # Show warnings
    if [[ ${#warnings[@]} -gt 0 ]]; then
        ((WARNINGS+=${#warnings[@]}))
        for warning in "${warnings[@]}"; do
            echo -e "    ${YELLOW}⚠ $warning${NC}"
        done
    fi
    
    echo ""
}

# Function to test with act (if available)
test_with_act() {
    local file=$1
    
    if command -v act &> /dev/null; then
        echo -e "${CYAN}Testing with act (dry run):${NC}"
        
        if act -n -W "$file" 2>&1 | grep -q "Error"; then
            echo -e "  ${RED}✗ Act validation failed${NC}"
            return 1
        else
            echo -e "  ${GREEN}✓ Act validation passed${NC}"
            
            # List jobs
            local jobs=$(act -l -W "$file" 2>/dev/null | tail -n +2 | awk '{print $2}' | xargs)
            if [[ -n "$jobs" ]]; then
                echo "  ${CYAN}Detected jobs: $jobs${NC}"
            fi
            return 0
        fi
    else
        echo -e "  ${YELLOW}⚠ Act not available for testing${NC}"
        return 2
    fi
}

# Function to generate test commands
generate_test_commands() {
    local file=$1
    local name=$(basename "$file" .yml)
    
    echo -e "${CYAN}Test commands for $name:${NC}"
    echo ""
    echo "  # Dry run (syntax check):"
    echo "  act -n -W $file"
    echo ""
    echo "  # Test push event:"
    echo "  act push -W $file"
    echo ""
    echo "  # Test pull_request event:"
    echo "  act pull_request -W $file"
    echo ""
    echo "  # Test specific job:"
    echo "  act -j <job-name> -W $file"
    echo ""
    echo "  # Test with custom event:"
    echo "  act -e event.json -W $file"
    echo ""
}

# Main validation
echo -e "${CYAN}Validating workflows in .github/workflows/${NC}"
echo ""

for workflow in .github/workflows/*.yml .github/workflows/*.yaml; do
    if [[ -f "$workflow" ]]; then
        check_workflow_structure "$workflow"
    fi
done

# Summary
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                    Validation Summary                          ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Total workflows: $TOTAL_WORKFLOWS"
echo -e "  Valid: ${GREEN}$VALID_WORKFLOWS${NC}"
echo -e "  Invalid: ${RED}$INVALID_WORKFLOWS${NC}"
echo -e "  Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [[ $INVALID_WORKFLOWS -eq 0 ]]; then
    echo -e "${GREEN}✅ All workflows are valid!${NC}"
else
    echo -e "${RED}❌ Some workflows have issues that need fixing${NC}"
fi

# Test with act if available
if command -v act &> /dev/null; then
    echo ""
    echo -e "${CYAN}Testing with act...${NC}"
    echo ""
    
    for workflow in .github/workflows/*.yml; do
        if [[ -f "$workflow" ]]; then
            name=$(basename "$workflow" .yml)
            echo -e "${CYAN}Testing $name:${NC}"
            
            # Just do a dry run
            if act -n -W "$workflow" 2>&1 | grep -q "Job '.*' succeeded\|Success"; then
                echo -e "  ${GREEN}✓ Can be run with act${NC}"
            else
                echo -e "  ${YELLOW}⚠ May have issues with act${NC}"
            fi
        fi
    done
fi

# Generate test instructions
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                  How to Test These Workflows                   ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo "1. ${GREEN}Using act (recommended for local testing):${NC}"
echo "   brew install act"
echo "   act -W .github/workflows/test.yml"
echo ""
echo "2. ${GREEN}Push to a test branch:${NC}"
echo "   git checkout -b test-actions"
echo "   git push origin test-actions"
echo "   # Check Actions tab on GitHub"
echo ""
echo "3. ${GREEN}Use workflow_dispatch (manual trigger):${NC}"
echo "   # Go to Actions tab on GitHub"
echo "   # Select workflow"
echo "   # Click 'Run workflow'"
echo ""
echo "4. ${GREEN}GitHub CLI:${NC}"
echo "   gh workflow run test.yml"
echo "   gh run watch"
echo ""

# Exit with appropriate code
if [[ $INVALID_WORKFLOWS -gt 0 ]]; then
    exit 1
else
    exit 0
fi