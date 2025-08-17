#!/usr/bin/env bash
# Test GitHub Actions Locally using act
# https://github.com/nektos/act

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ===========================
# Install act if not present
# ===========================
install_act() {
    echo -e "${CYAN}Installing act (GitHub Actions local runner)...${NC}"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install act
        else
            curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
        fi
    else
        # Linux
        curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
    fi
    
    echo -e "${GREEN}✅ act installed successfully${NC}"
}

# Check if act is installed
if ! command -v act &> /dev/null; then
    echo -e "${YELLOW}act is not installed.${NC}"
    read -p "Install act now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_act
    else
        echo -e "${RED}Cannot test GitHub Actions without act. Exiting.${NC}"
        exit 1
    fi
fi

# ===========================
# Configuration
# ===========================
GITHUB_ACTIONS_DIR=".github/workflows"
ACT_CONFIG=".actrc"

# Create act configuration if it doesn't exist
if [[ ! -f "$ACT_CONFIG" ]]; then
    echo -e "${CYAN}Creating act configuration...${NC}"
    cat > "$ACT_CONFIG" << 'EOF'
# Default image for ubuntu-latest
-P ubuntu-latest=catthehacker/ubuntu:act-latest
-P ubuntu-22.04=catthehacker/ubuntu:act-22.04
-P ubuntu-20.04=catthehacker/ubuntu:act-20.04

# macOS runners (Note: these use Linux, not actual macOS)
-P macos-latest=catthehacker/ubuntu:act-latest
-P macos-13=catthehacker/ubuntu:act-latest
-P macos-12=catthehacker/ubuntu:act-latest

# Use Docker to run actions
--container-architecture linux/amd64

# Reuse containers for faster runs
--reuse
EOF
    echo -e "${GREEN}✅ Created .actrc configuration${NC}"
fi

# ===========================
# Menu
# ===========================
show_menu() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}GitHub Actions Local Testing${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "1) List all workflows"
    echo "2) Test specific workflow"
    echo "3) Test specific job"
    echo "4) Test with specific event (push/pull_request/schedule)"
    echo "5) Test with custom inputs"
    echo "6) Dry run (show what would be executed)"
    echo "7) Test all workflows"
    echo "8) Clean up containers"
    echo "9) Exit"
    echo ""
    read -p "Select option: " choice
}

# ===========================
# Functions
# ===========================
list_workflows() {
    echo -e "${CYAN}Available workflows:${NC}"
    for workflow in $GITHUB_ACTIONS_DIR/*.yml $GITHUB_ACTIONS_DIR/*.yaml; do
        if [[ -f "$workflow" ]]; then
            name=$(basename "$workflow")
            echo "  • $name"
        fi
    done
}

test_workflow() {
    local workflow=$1
    echo -e "${CYAN}Testing workflow: $workflow${NC}"
    
    # Run with act
    act -W "$GITHUB_ACTIONS_DIR/$workflow" --verbose
}

test_job() {
    local workflow=$1
    local job=$2
    echo -e "${CYAN}Testing job '$job' in workflow '$workflow'${NC}"
    
    act -W "$GITHUB_ACTIONS_DIR/$workflow" -j "$job" --verbose
}

test_event() {
    local workflow=$1
    local event=$2
    echo -e "${CYAN}Testing workflow '$workflow' with event '$event'${NC}"
    
    # Create event payload
    case "$event" in
        push)
            cat > /tmp/act-event.json << 'EOF'
{
  "push": {
    "ref": "refs/heads/main",
    "repository": {
      "name": "dotfiles",
      "full_name": "user/dotfiles"
    }
  }
}
EOF
            ;;
        pull_request)
            cat > /tmp/act-event.json << 'EOF'
{
  "pull_request": {
    "number": 1,
    "head": {
      "ref": "feature-branch"
    },
    "base": {
      "ref": "main"
    }
  }
}
EOF
            ;;
        schedule)
            cat > /tmp/act-event.json << 'EOF'
{
  "schedule": {}
}
EOF
            ;;
    esac
    
    act "$event" -W "$GITHUB_ACTIONS_DIR/$workflow" -e /tmp/act-event.json --verbose
}

test_with_inputs() {
    local workflow=$1
    echo -e "${CYAN}Enter workflow inputs (JSON format):${NC}"
    echo "Example: {\"test_type\":\"all\",\"verbose\":\"true\"}"
    read -p "> " inputs
    
    echo "$inputs" > /tmp/act-inputs.json
    act workflow_dispatch -W "$GITHUB_ACTIONS_DIR/$workflow" -e /tmp/act-inputs.json --verbose
}

dry_run() {
    local workflow=$1
    echo -e "${CYAN}Dry run for workflow: $workflow${NC}"
    
    act -W "$GITHUB_ACTIONS_DIR/$workflow" --dryrun
}

test_all() {
    echo -e "${CYAN}Testing all workflows...${NC}"
    
    for workflow in $GITHUB_ACTIONS_DIR/*.yml $GITHUB_ACTIONS_DIR/*.yaml; do
        if [[ -f "$workflow" ]]; then
            name=$(basename "$workflow")
            echo ""
            echo -e "${BLUE}Testing: $name${NC}"
            act -W "$workflow" || echo -e "${YELLOW}Warning: $name had issues${NC}"
        fi
    done
}

cleanup() {
    echo -e "${CYAN}Cleaning up Docker containers...${NC}"
    docker rm -f $(docker ps -a | grep act | awk '{print $1}') 2>/dev/null || true
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

# ===========================
# Main Loop
# ===========================
while true; do
    show_menu
    
    case $choice in
        1)
            list_workflows
            ;;
        2)
            list_workflows
            echo ""
            read -p "Enter workflow filename: " workflow
            test_workflow "$workflow"
            ;;
        3)
            list_workflows
            echo ""
            read -p "Enter workflow filename: " workflow
            read -p "Enter job name: " job
            test_job "$workflow" "$job"
            ;;
        4)
            list_workflows
            echo ""
            read -p "Enter workflow filename: " workflow
            echo "Select event type:"
            echo "1) push"
            echo "2) pull_request"
            echo "3) schedule"
            read -p "> " event_choice
            case $event_choice in
                1) event="push" ;;
                2) event="pull_request" ;;
                3) event="schedule" ;;
                *) event="push" ;;
            esac
            test_event "$workflow" "$event"
            ;;
        5)
            list_workflows
            echo ""
            read -p "Enter workflow filename: " workflow
            test_with_inputs "$workflow"
            ;;
        6)
            list_workflows
            echo ""
            read -p "Enter workflow filename: " workflow
            dry_run "$workflow"
            ;;
        7)
            test_all
            ;;
        8)
            cleanup
            ;;
        9)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done