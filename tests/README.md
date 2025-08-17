# Dotfiles Test Suite

A comprehensive, MECE (Mutually Exclusive, Collectively Exhaustive) test framework for dotfiles configuration.

## ✅ Features

- **MECE Architecture**: No gaps, no overlaps in test coverage
- **Platform-agnostic**: Works on macOS and Linux
- **Complete Isolation**: Test in pristine Docker environments
- **Component testing**: Each dotfile component tested independently
- **Integration testing**: Validates that components work together
- **Performance testing**: Ensures fast shell startup times
- **CI/CD ready**: GitHub Actions workflow included

## 🚀 Quick Start

```bash
# Run EVERYTHING in pristine Docker environment (recommended)
./tests/test-all.sh

# Fast test with cached Docker base (~20 seconds)
./tests/test-fast.sh

# Run specific component tests locally
./tests/run-tests.sh zsh
```

## 🎯 Test Structure (MECE)

### Primary Test Runners

| Script | Purpose | Environment | Use When |
|--------|---------|-------------|----------|
| **`test-all.sh`** | Complete validation in pristine environment | Docker (fresh) | Final validation, CI/CD |
| **`test-fast.sh`** | Quick validation with cached base | Docker (cached) | Development iterations |
| **`run-tests.sh`** | Component-specific testing | Local or Docker | Testing specific changes |

### Test Execution Matrix

```
┌─────────────┬────────────┬───────────┬──────────┐
│   Runner    │ Isolation  │   Speed   │ Coverage │
├─────────────┼────────────┼───────────┼──────────┤
│ test-all    │ Complete   │ ~3-5 min  │   100%   │
│ test-fast   │ High       │ ~20 sec   │    95%   │
│ run-tests   │ Variable   │ ~10 sec   │ Component│
└─────────────┴────────────┴───────────┴──────────┘
```

## 📁 Test Structure

### Test Categories (MECE)

```
tests/
├── test-all.sh                     # Complete Docker validation (NEW)
├── test-fast.sh                    # Quick Docker test with cache
├── run-tests.sh                    # Component runner (local/Docker)
├── test-framework.sh               # Core testing utilities
│
├── components/                     # Individual tool tests
│   ├── test-zsh.sh                # Shell configuration
│   ├── test-nvim.sh               # Neovim setup
│   ├── test-git.sh                # Git configuration
│   ├── test-kitty.sh              # Terminal config
│   └── test-atuin.sh              # History database
│
├── integration/                    # Cross-component tests
│   └── test-aliases.sh            # Alias functionality
│
├── functional/                     # Command execution tests
│   └── test-commands.sh           # Verify commands work
│
├── workflows/                      # Real-world scenarios
│   └── test-developer-workflows.sh # Developer tasks
│
├── negative/                       # Error handling tests
│   └── test-error-handling.sh     # Failure recovery
│
├── performance/                    # Speed & resources
│   └── benchmark.sh               # Performance metrics
│
├── coverage/                       # Test completeness
│   └── coverage.sh                # Coverage analysis
│
└── Docker/                         # Container configs
    ├── Dockerfile.base            # Cached dependencies
    └── Dockerfile.fast            # Quick test image
```

## 🧪 What Gets Tested

### ZSH Configuration
- ✅ Installation and version
- ✅ Startup performance (<150ms on macOS, <200ms on Linux)
- ✅ Zinit plugin manager
- ✅ All aliases defined correctly
- ✅ Lazy loading (Node, NPM, Conda)
- ✅ FZF integration
- ✅ Completion system
- ✅ Theme (Powerlevel10k)

### Neovim Configuration
- ✅ Installation and version
- ✅ Config loads without errors
- ✅ Startup performance (<500ms)
- ✅ Plugin manager (Lazy.nvim)
- ✅ LSP configuration
- ✅ Key mappings
- ✅ File type detection
- ✅ Health check

### Kitty Terminal (macOS only)
- ✅ Installation check
- ✅ Configuration syntax
- ✅ Theme configuration
- ✅ Font settings
- ✅ Key mappings
- ✅ Shell integration

### Git Configuration
- ✅ Installation and version
- ✅ User configuration
- ✅ Aliases
- ✅ Tools (delta, credential helper)
- ✅ Pull strategy
- ✅ Global gitignore

## 🐳 Docker Testing

Test in a clean Linux environment:

```bash
# Run tests in Docker
./tests/run-tests.sh --docker

# Or manually:
docker build -f tests/Dockerfile -t dotfiles-test .
docker run --rm -it dotfiles-test
```

## 🔄 GitHub Actions

The test suite runs automatically on:
- Every push to main/master branches
- Every pull request
- Manual workflow dispatch

### Workflow Jobs
1. **test-macos**: Tests on macOS-latest
2. **test-ubuntu**: Tests on Ubuntu-latest
3. **test-docker**: Full containerized Linux test
4. **lint**: Shellcheck and syntax validation
5. **summary**: Aggregates results and comments on PRs

## 🎯 Platform-Agnostic Design

### How It Works
1. **Platform detection**: Automatically detects macOS/Linux
2. **Conditional testing**: Skips platform-specific tests appropriately
3. **Package manager abstraction**: Uses Homebrew on macOS, apt/yum/pacman on Linux
4. **Path fixing**: Automatically fixes hardcoded paths

### Key Differences Handled
- **macOS**: Tests GUI apps (Kitty, Ghostty), uses Homebrew
- **Linux**: Skips GUI apps, uses system package manager
- **CI Environment**: Skips cask installations, uses headless testing

## 📊 Test Framework Features

### Test Functions
```bash
test_case "Test name" "command"           # Basic test
test_output "Test name" "command" "pattern" # Test output contains pattern
test_performance "Test name" "command" 100  # Test completes within 100ms
skip_test "Test name" "reason"            # Skip with reason
```

### Helper Functions
```bash
command_exists "git"              # Check if command exists
file_exists "$HOME/.zshrc"       # Check if file exists
dir_exists "$HOME/.config"       # Check if directory exists
symlink_valid "$HOME/.zshrc"     # Check if symlink is valid
```

## 🔧 Troubleshooting

### Common Issues

1. **Permission denied**
   ```bash
   chmod +x tests/*.sh tests/**/*.sh
   ```

2. **Command not found**
   - Ensure dependencies are installed
   - Run `./tests/install-platform-agnostic.sh` first

3. **Tests fail on fresh system**
   - This is expected! Run installation first:
   ```bash
   ./tests/run-tests.sh --install
   ```

4. **Docker tests fail**
   - Ensure Docker is installed and running
   - Check Docker permissions

## 🤝 Contributing

When adding new dotfile configurations:

1. Create a test file: `tests/components/test-[component].sh`
2. Use the test framework functions
3. Add to GitHub Actions workflow if needed
4. Ensure tests pass on both macOS and Linux

## 📈 Performance Targets

- **ZSH startup**: <150ms (macOS), <200ms (Linux)
- **Neovim startup**: <500ms (macOS), <700ms (Linux)
- **Test suite runtime**: <2 minutes
- **CI pipeline**: <5 minutes

## 📝 License

Same as parent dotfiles repository.