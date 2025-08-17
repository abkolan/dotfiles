#!/usr/bin/env bash
# Test GitHub Actions Locally
# Uses act to run GitHub Actions without pushing to GitHub

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

clear

cat << 'ASCII'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        🧪 GITHUB ACTIONS LOCAL TESTING                       ║
║           Test Your CI/CD Pipeline Locally                   ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
ASCII

echo ""

# Check prerequisites
check_prerequisites() {
    local missing=()
    
    if ! command -v act &> /dev/null; then
        missing+=("act")
    fi
    
    if ! command -v docker &> /dev/null; then
        missing+=("docker")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}Missing prerequisites: ${missing[*]}${NC}"
        echo ""
        echo "Install with:"
        for tool in "${missing[@]}"; do
            echo "  brew install $tool"
        done
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running!${NC}"
        echo "Please start Docker Desktop or Colima"
        exit 1
    fi
    
    echo -e "${GREEN}✓ All prerequisites met${NC}"
}

# List workflows
list_workflows() {
    echo -e "${CYAN}Available GitHub Actions Workflows:${NC}"
    echo ""
    
    for workflow in "$DOTFILES_DIR"/.github/workflows/*.yml; do
        if [[ -f "$workflow" ]]; then
            local name=$(basename "$workflow" .yml)
            local desc=$(grep -m1 "^name:" "$workflow" | cut -d: -f2- | xargs)
            echo -e "  ${GREEN}$name${NC}"
            echo -e "    ${YELLOW}$desc${NC}"
            
            # Show jobs
            echo -e "    ${CYAN}Jobs:${NC}"
            grep "^\s*[a-zA-Z0-9_-]*:" "$workflow" | grep -v "name:\|on:\|env:\|steps:" | head -5 | while read -r job; do
                echo "      • $(echo "$job" | cut -d: -f1 | xargs)"
            done
            echo ""
        fi
    done
}

# Test specific workflow
test_workflow() {
    local workflow=$1
    local event=${2:-push}
    
    echo -e "${CYAN}Testing workflow: $workflow${NC}"
    echo -e "${YELLOW}Event: $event${NC}"
    echo ""
    
    # Create event file if needed
    local event_file="/tmp/act-event-$$.json"
    case "$event" in
        push)
            cat > "$event_file" << 'EOF'
{
  "push": {
    "ref": "refs/heads/main",
    "before": "0000000000000000000000000000000000000000",
    "after": "1234567890abcdef1234567890abcdef12345678",
    "repository": {
      "name": "dotfiles",
      "full_name": "user/dotfiles",
      "owner": {
        "name": "user",
        "login": "user"
      }
    },
    "pusher": {
      "name": "Test User",
      "email": "test@example.com"
    },
    "head_commit": {
      "message": "Test commit",
      "timestamp": "2024-01-01T00:00:00Z"
    }
  }
}
EOF
            ;;
        pull_request)
            cat > "$event_file" << 'EOF'
{
  "pull_request": {
    "number": 1,
    "title": "Test PR",
    "body": "Testing GitHub Actions",
    "head": {
      "ref": "feature-branch",
      "sha": "1234567890abcdef1234567890abcdef12345678"
    },
    "base": {
      "ref": "main",
      "sha": "0000000000000000000000000000000000000000"
    },
    "user": {
      "login": "testuser"
    }
  },
  "repository": {
    "name": "dotfiles",
    "full_name": "user/dotfiles"
  }
}
EOF
            ;;
        workflow_dispatch)
            cat > "$event_file" << 'EOF'
{
  "workflow_dispatch": {
    "inputs": {
      "test_type": "all",
      "verbose": "true"
    }
  },
  "repository": {
    "name": "dotfiles",
    "full_name": "user/dotfiles"
  }
}
EOF
            ;;
    esac
    
    # Run with act
    cd "$DOTFILES_DIR"
    act "$event" -W ".github/workflows/$workflow" -e "$event_file" --verbose
    
    rm -f "$event_file"
}

# Quick test all workflows
quick_test_all() {
    echo -e "${CYAN}Quick testing all workflows (dry run)...${NC}"
    echo ""
    
    for workflow in "$DOTFILES_DIR"/.github/workflows/*.yml; do
        if [[ -f "$workflow" ]]; then
            local name=$(basename "$workflow")
            echo -e "${GREEN}Testing: $name${NC}"
            
            # Dry run to check syntax
            if act -n -W "$workflow" 2>&1 | grep -q "Error"; then
                echo -e "  ${RED}✗ Workflow has errors${NC}"
            else
                echo -e "  ${GREEN}✓ Workflow syntax valid${NC}"
            fi
            
            # List jobs
            echo -e "  ${CYAN}Jobs:${NC}"
            act -l -W "$workflow" 2>/dev/null | tail -n +2 | awk '{print "    • " $2}'
            echo ""
        fi
    done
}

# Test specific job
test_job() {
    local workflow=$1
    local job=$2
    
    echo -e "${CYAN}Testing job '$job' in workflow '$workflow'${NC}"
    echo ""
    
    cd "$DOTFILES_DIR"
    act -j "$job" -W ".github/workflows/$workflow"
}

# Interactive menu
show_menu() {
    echo -e "${CYAN}Select test option:${NC}"
    echo ""
    echo "1) List all workflows"
    echo "2) Quick test all (syntax check)"
    echo "3) Test specific workflow"
    echo "4) Test specific job"
    echo "5) Test with pull_request event"
    echo "6) Test with workflow_dispatch"
    echo "7) Run comprehensive test workflow"
    echo "8) Run basic test workflow"
    echo "9) Generate test report"
    echo "0) Exit"
    echo ""
    read -p "Select option: " choice
}

# Generate test report
generate_report() {
    local report_file="/tmp/github-actions-test-report-$$.md"
    
    echo "# GitHub Actions Test Report" > "$report_file"
    echo "" >> "$report_file"
    echo "Generated: $(date)" >> "$report_file"
    echo "" >> "$report_file"
    
    echo "## Workflows" >> "$report_file"
    echo "" >> "$report_file"
    
    for workflow in "$DOTFILES_DIR"/.github/workflows/*.yml; do
        if [[ -f "$workflow" ]]; then
            local name=$(basename "$workflow" .yml)
            echo "### $name" >> "$report_file"
            
            # Check syntax
            if act -n -W "$workflow" 2>&1 | grep -q "Error"; then
                echo "- **Status:** ❌ Has errors" >> "$report_file"
            else
                echo "- **Status:** ✅ Valid" >> "$report_file"
            fi
            
            # Count jobs
            local job_count=$(act -l -W "$workflow" 2>/dev/null | tail -n +2 | wc -l)
            echo "- **Jobs:** $job_count" >> "$report_file"
            
            # List triggers
            local triggers=$(grep -A10 "^on:" "$workflow" | grep -E "^\s+(push|pull_request|schedule|workflow_dispatch):" | sed 's/://g' | xargs)
            echo "- **Triggers:** $triggers" >> "$report_file"
            echo "" >> "$report_file"
        fi
    done
    
    echo -e "${GREEN}Report generated: $report_file${NC}"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$report_file"
    else
        cat "$report_file"
    fi
}

# Main execution
main() {
    check_prerequisites
    echo ""
    
    while true; do
        show_menu
        
        case $choice in
            1)
                list_workflows
                ;;
            2)
                quick_test_all
                ;;
            3)
                list_workflows
                read -p "Enter workflow filename (e.g., test.yml): " workflow
                test_workflow "$workflow"
                ;;
            4)
                list_workflows
                read -p "Enter workflow filename: " workflow
                read -p "Enter job name: " job
                test_job "$workflow" "$job"
                ;;
            5)
                list_workflows
                read -p "Enter workflow filename: " workflow
                test_workflow "$workflow" "pull_request"
                ;;
            6)
                list_workflows
                read -p "Enter workflow filename: " workflow
                test_workflow "$workflow" "workflow_dispatch"
                ;;
            7)
                echo -e "${CYAN}Running comprehensive test workflow...${NC}"
                test_workflow "comprehensive-test.yml" "push"
                ;;
            8)
                echo -e "${CYAN}Running basic test workflow...${NC}"
                test_workflow "test.yml" "push"
                ;;
            9)
                generate_report
                ;;
            0)
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
    done
}

# Run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi