# Dotfiles Test Suite

A compact, macOS-first harness that keeps these dotfiles healthy without leaving residue on your system.

## ✅ Features

- **macOS native**: Verified regularly on Apple Silicon macOS (Ventura/Sonoma)
- **Composable**: Run fast smoke tests or the full integration flow
- **Optional isolation**: Use Docker Desktop when you want a disposable sandbox
- **Extensible**: Same framework powers component, integration, and performance checks

## 🚀 Quick Start

```bash
# Fast sanity sweep
./tests/run-tests.sh --scope fast

# Full local validation
./tests/run-tests.sh --scope all

# Optional Docker run (requires Docker Desktop)
./tests/test-fast.sh
```

## 🗂️ Key Scripts

| Script | Purpose | Notes |
|--------|---------|-------|
| `run-tests.sh` | Entry point for fast/all suites | Supports `--scope fast`/`--scope all` |
| `test-integration.sh` | End-to-end install verification | Uses `tests/install-platform-agnostic.sh` under the hood |
| `install-platform-agnostic.sh` | macOS bootstrap used by tests | Safe subset of the main installer |
| `showcase-tests.sh` | Guided tour of the framework | Optional; intended for demos |

## 🧪 What Gets Tested

### ZSH Configuration
- Installation check and syntax validation
- Startup performance (<150ms target)
- Zinit plugin manager, aliases, completions, history tooling

### Neovim Configuration
- Headless startup health
- Lazy.nvim plugin sync
- DevOps-oriented LSP defaults (Terraform, Go, YAML, etc.)
- Key mappings, filetype detection, Treesitter, Telescope

### Kitty & Ghostty (macOS)
- Config presence and syntax
- Theme/profile switches

### Git Configuration
- Global config symlinks
- Delta-based diff tooling
- Alias sanity checks

## 🧰 Troubleshooting

1. **`permission denied` when running scripts**
   ```bash
   chmod +x tests/*.sh tests/**/*.sh
   ```
2. **Missing dependencies**
   ```bash
   ./tests/install-platform-agnostic.sh
   ```
3. **Slow or flaky runs**
   - Use `--scope fast` for rapid feedback
   - Run inside Docker Desktop to isolate from your host environment

## 🤝 CI/CD

GitHub Actions runs `./tests/run-tests.sh --scope all` on macOS runners. Use the same command locally before pushing.
