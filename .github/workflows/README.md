# GitHub Actions Workflows

This directory contains the CI/CD workflows for testing the dotfiles configuration. The workflows use our MECE (Mutually Exclusive, Collectively Exhaustive) test suite structure.

## Workflow Overview

### 🚀 Primary Workflows

| Workflow | Trigger | Duration | Purpose |
|----------|---------|----------|---------|
| **Fast Test** | Push, PR | ~30s | Quick validation for development |
| **Test Suite** | Push, PR, Manual | ~2-5min | Comprehensive testing with options |
| **Comprehensive Test** | Nightly, Manual | ~10-20min | Multi-platform validation |
| **Smoke Test** | Manual | ~30s | Repository health check |

### ⚡ Fast Test (`fast-test.yml`)

**Triggers:** Push to main branches, Pull requests  
**Purpose:** Quick validation for every change

```yaml
on:
  push:
    branches: [ main, master, develop, aug_workflow_claude ]
  pull_request:
    branches: [ main, master ]
```

**What it tests:**
- ✅ Fast Docker test with cached base (`test-fast.sh`)
- ✅ Security scan (ShellCheck, sensitive data)
- ✅ 95% functionality coverage in ~20 seconds

**Perfect for:** PR validation, development iterations

### 🧪 Test Suite (`test.yml`) 

**Triggers:** Push, PR, Manual with options  
**Purpose:** Flexible testing with multiple strategies

**Test Types:**
- `fast` (default) - Quick Docker validation
- `complete` - Full pristine environment test  
- `components` - Platform-specific testing (macOS + Ubuntu)

**Manual Options:**
- Test type selection
- Verbose output
- Platform targeting

**What it tests:**
- ✅ Docker testing (`test-fast.sh` or `test-all.sh`)
- ✅ Component tests on native macOS/Ubuntu
- ✅ Lint and security validation
- ✅ Comprehensive PR comments

### 🐳 Comprehensive Test (`comprehensive-test.yml`)

**Triggers:** Nightly cron, Manual  
**Purpose:** Thorough multi-platform validation

**Features:**
- Platform matrix (Ubuntu 22.04, 20.04, Debian 12)
- Complete Docker testing (`test-all.sh`)
- Performance benchmarking
- Quick mode option

**What it tests:**
- ✅ Full pristine environment validation
- ✅ Cross-platform compatibility
- ✅ Performance regression detection
- ✅ Complete installation simulation

### 💨 Smoke Test (`test-simple.yml`)

**Triggers:** Manual, specific branches  
**Purpose:** Repository health validation

**What it validates:**
- ✅ Repository structure
- ✅ Test infrastructure integrity  
- ✅ Docker configuration
- ✅ Security basics
- ✅ Configuration syntax
- ✅ Documentation completeness

## Test Strategy Matrix

```
┌─────────────────┬─────────┬───────────┬──────────┬─────────────┐
│    Workflow     │  Speed  │ Coverage  │ Platform │   Usage     │
├─────────────────┼─────────┼───────────┼──────────┼─────────────┤
│ Fast Test       │  ~30s   │    95%    │  Docker  │ Development │
│ Test Suite      │ 30s-5m  │   100%    │  Multi   │ Validation  │
│ Comprehensive   │ 10-20m  │   100%    │  Multi   │ Thorough    │
│ Smoke Test      │  ~30s   │  Health   │  None    │ Structure   │
└─────────────────┴─────────┴───────────┴──────────┴─────────────┘
```

## Workflow Features

### 🎯 Smart Test Selection

**For Pull Requests:**
- Automatic fast test for quick feedback
- Option to run complete tests manually
- Intelligent comments with test coverage info

**For Pushes:**
- Fast test on feature branches
- Complete test on main branches
- Automatic artifact collection

### 📊 Rich Reporting

**GitHub Step Summary:**
- Visual test results matrix
- Coverage breakdown  
- Performance metrics
- Next steps guidance

**PR Comments:**
- Test status with emojis
- Coverage explanation
- Local testing instructions
- Documentation links

### 🔧 Manual Controls

**Test Type Selection:**
```yaml
inputs:
  test_type:
    type: choice
    options:
      - fast       # Quick validation (~20 sec)
      - complete   # Full pristine environment (~5 min)  
      - components # Individual component tests
```

**Platform Selection:**
```yaml
inputs:
  platform:
    type: choice
    options:
      - ubuntu:22.04
      - ubuntu:20.04
      - debian:12
      - ubuntu:22.04,debian:12
```

## Integration with Test Suite

### Direct Usage

The workflows directly use our MECE test runners:

- `./tests/test-fast.sh` - Fast Docker validation
- `./tests/test-all.sh` - Complete pristine testing
- `./tests/run-tests.sh` - Component-specific testing

### Docker Integration

**Base Images:**
- `dotfiles-base` - Cached dependencies for speed
- `dotfiles-test-all` - Fresh build for complete validation

**Test Environments:**
- Ubuntu 22.04, 20.04
- Debian 12
- macOS (native component testing)

## Usage Examples

### Development Workflow

1. **Make changes** to dotfiles
2. **Push branch** → Fast test runs automatically (~30s)
3. **Create PR** → Fast test + security validation
4. **Manual trigger** complete test if needed
5. **Merge** after tests pass

### Release Workflow

1. **Create release branch**
2. **Manual trigger** comprehensive test
3. **Review** multi-platform results  
4. **Validate** performance benchmarks
5. **Release** with confidence

### Debugging Workflow

1. **Smoke test** first to check repository health
2. **Fast test** to identify functional issues
3. **Component test** to isolate problems
4. **Complete test** to validate fixes

## Monitoring and Alerts

### Success Indicators
- ✅ All tests pass
- ✅ No security issues
- ✅ Performance within bounds
- ✅ All platforms supported

### Failure Indicators  
- ❌ Test failures with specific error logs
- ⚠️ Security warnings with file locations
- 📉 Performance regressions with metrics
- 🚫 Platform compatibility issues

## Best Practices

### For Contributors

1. **Always check** fast test results before requesting review
2. **Run locally** with `./tests/test-fast.sh` before pushing
3. **Use complete test** for significant changes
4. **Read PR comments** for detailed test breakdown

### For Maintainers

1. **Monitor nightly** comprehensive test results
2. **Review security** scan findings regularly
3. **Track performance** trends over time
4. **Update workflows** when adding new test categories

## Troubleshooting

### Common Issues

**Fast test failures:**
- Check `test-fast.sh` locally
- Review Docker build logs
- Verify test infrastructure

**Component test failures:**
- Platform-specific issues
- Dependency installation problems
- Configuration conflicts

**Comprehensive test timeouts:**
- Docker resource constraints
- Network connectivity issues
- Test suite performance

### Getting Help

1. Check [test documentation](../tests/README.md)
2. Review workflow run logs
3. Download test artifacts
4. Run tests locally for debugging

## Metrics

- **Test Execution Time:** 30s (fast) to 20min (comprehensive)
- **Test Coverage:** 95% (fast) to 100% (complete)
- **Platform Support:** Ubuntu, Debian, macOS
- **Artifact Retention:** 30 days
- **Success Rate:** >99% when repository is healthy