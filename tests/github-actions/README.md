# 🧪 Testing GitHub Actions Before Merging

There are several ways to test GitHub Actions before merging to your repository. This guide covers all the best approaches.

## 📋 Table of Contents
- [Method 1: Act (Recommended)](#method-1-act-recommended)
- [Method 2: Feature Branch Testing](#method-2-feature-branch-testing)
- [Method 3: Workflow Dispatch](#method-3-workflow-dispatch)
- [Method 4: GitHub CLI](#method-4-github-cli)
- [Method 5: Forked Repository](#method-5-forked-repository)

---

## Method 1: Act (Recommended)

**Act** runs GitHub Actions locally using Docker. It's the fastest way to test without pushing to GitHub.

### Installation

```bash
# macOS
brew install act

# Linux
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Or use our helper script
./tests/github-actions/test-locally.sh
```

### Basic Usage

```bash
# List all workflows
act -l

# Run default push event
act

# Run specific workflow
act -W .github/workflows/test.yml

# Run specific job
act -j test-macos

# Run pull_request event
act pull_request

# Run with specific event payload
act -e event.json

# Dry run (see what would execute)
act -n
```

### Interactive Testing

Use our interactive test script:

```bash
./tests/github-actions/test-locally.sh
```

This provides a menu-driven interface to:
- Test specific workflows
- Test specific jobs
- Simulate different events (push, PR, schedule)
- Pass custom inputs
- Run dry runs
- Clean up containers

### Example: Testing Your Comprehensive Workflow

```bash
# Test the comprehensive test suite locally
act -W .github/workflows/comprehensive-test.yml

# Test just the benchmark job
act -W .github/workflows/comprehensive-test.yml -j benchmark

# Test with custom inputs
echo '{"test_type":"functional"}' > inputs.json
act workflow_dispatch -W .github/workflows/comprehensive-test.yml -e inputs.json
```

### Limitations of Act

- Uses Linux containers even for macOS runners
- Some Actions may not work identically
- Secrets need to be provided via `.secrets` file
- Large workflows may be slow

---

## Method 2: Feature Branch Testing

Test workflows in a feature branch before merging to main.

### Setup

1. **Modify workflow triggers** to include your branch:

```yaml
on:
  push:
    branches: [ main, master, develop, feature/test-actions ]  # Add your branch
  pull_request:
    branches: [ main, master ]
```

2. **Push to your branch**:

```bash
git checkout -b feature/test-actions
# Make changes to workflows
git add .github/workflows/
git commit -m "Test GitHub Actions"
git push origin feature/test-actions
```

3. **Check Actions tab** on GitHub to see results

### Pro Tip: Temporary Test Workflow

Create a temporary test workflow that only runs on your branch:

```yaml
# .github/workflows/test-only.yml
name: Test Workflow (Delete Before Merge)

on:
  push:
    branches: [ feature/test-actions ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Test something
        run: echo "Testing..."
```

---

## Method 3: Workflow Dispatch

Add manual trigger to test on demand:

```yaml
on:
  workflow_dispatch:
    inputs:
      debug:
        description: 'Enable debug mode'
        required: false
        default: 'false'
        type: boolean
      test_type:
        description: 'Test type'
        required: true
        default: 'all'
        type: choice
        options:
          - all
          - unit
          - integration
```

Then trigger from GitHub UI:
1. Go to Actions tab
2. Select workflow
3. Click "Run workflow"
4. Fill inputs
5. Run

Or use GitHub CLI:

```bash
gh workflow run test.yml -f debug=true -f test_type=unit
```

---

## Method 4: GitHub CLI Testing

Use `gh` to test workflows programmatically:

```bash
# List workflows
gh workflow list

# View workflow
gh workflow view test.yml

# Run workflow
gh workflow run test.yml

# Run with inputs
gh workflow run test.yml -f input1=value1 -f input2=value2

# Watch run
gh run watch

# View logs
gh run view --log
```

### Script for Testing PRs

```bash
#!/bin/bash
# Test workflow on a PR

# Create PR
gh pr create --title "Test Actions" --body "Testing workflows"

# Get PR number
PR=$(gh pr list --head "$(git branch --show-current)" --json number -q '.[0].number')

# Trigger tests
gh workflow run test.yml -f pr_number=$PR

# Watch results
gh run list --workflow=test.yml --limit 1
gh run watch
```

---

## Method 5: Forked Repository

Test in a personal fork before contributing:

1. **Fork the repository**
2. **Enable Actions** in fork settings
3. **Push changes** to fork
4. **Test thoroughly**
5. **Create PR** from fork to original

### Benefits
- Complete isolation
- No impact on main repository
- Can test secrets separately
- Good for external contributors

---

## 🔧 Best Practices

### 1. Use Matrix Strategy for Testing

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    node: [14, 16, 18]
```

### 2. Add Debugging

```yaml
- name: Debug - Show environment
  if: ${{ github.event.inputs.debug == 'true' }}
  run: |
    echo "=== Environment ==="
    env | sort
    echo "=== GitHub Context ==="
    echo '${{ toJSON(github) }}'
```

### 3. Use Composite Actions for Reusability

```yaml
# .github/actions/setup-test/action.yml
name: 'Setup Test Environment'
description: 'Set up test environment'
runs:
  using: 'composite'
  steps:
    - name: Install dependencies
      shell: bash
      run: |
        npm install
        npm run build
```

### 4. Test with Different Events

Create test event payloads:

```json
// test-events/push.json
{
  "ref": "refs/heads/feature-branch",
  "repository": {
    "name": "dotfiles",
    "owner": {
      "login": "testuser"
    }
  }
}
```

Test locally:
```bash
act push -e test-events/push.json
```

### 5. Use Workflow Call for Testing

```yaml
# .github/workflows/reusable-test.yml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string

# .github/workflows/test-caller.yml
jobs:
  test:
    uses: ./.github/workflows/reusable-test.yml
    with:
      environment: testing
```

---

## 📊 Testing Checklist

Before merging, ensure:

- [ ] Workflow syntax is valid (`act -n` or GitHub's workflow editor)
- [ ] All jobs pass in `act` locally
- [ ] Tested with different trigger events
- [ ] Secrets are handled properly (use `${{ secrets.NAME }}`)
- [ ] Matrix combinations work
- [ ] Artifacts upload/download correctly
- [ ] Caching works as expected
- [ ] Conditional logic (`if:`) behaves correctly
- [ ] Error handling is robust
- [ ] Workflow completes in reasonable time

---

## 🛠️ Troubleshooting

### Common Issues

1. **"Docker not found"**
   - Install Docker Desktop
   - Ensure Docker daemon is running

2. **"Workflow not found"**
   - Check workflow file path
   - Ensure `.github/workflows/` directory exists

3. **"Job failed in act but works on GitHub"**
   - Check for GitHub-specific features
   - Use `--platform` flag for better compatibility
   - Some actions need `--privileged` flag

4. **"Secrets not working"**
   - Create `.secrets` file:
   ```
   MY_SECRET=value
   GITHUB_TOKEN=ghp_xxxx
   ```
   - Or pass inline: `act -s MY_SECRET=value`

### Debug Commands

```bash
# Verbose output
act -v

# Very verbose (debug)
act -vv

# List what would run
act -l

# Use specific Docker image
act -P ubuntu-latest=ubuntu:22.04

# Keep containers after run (for debugging)
act --rm=false
```

---

## 📚 Resources

- [Act Documentation](https://github.com/nektos/act)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)

---

## 💡 Pro Tips

1. **Start Simple**: Test basic workflow first, then add complexity
2. **Use Caching**: Cache dependencies to speed up tests
3. **Parallel Testing**: Use matrix strategy for parallel execution
4. **Fail Fast**: Add `fail-fast: false` to continue on errors
5. **Timeout**: Set reasonable timeouts to prevent hanging
6. **Artifacts**: Upload logs and test results for debugging

---

Happy Testing! 🚀