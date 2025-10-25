# 🔧 Go Configuration

## Overview
Go development environment configuration including linter settings, environment variables, and tool configurations.

## Features
- Revive linter configuration for code quality
- GOPATH and module settings
- Development tool configurations

## Installation
```bash
# Install Go
brew install go

# Install development tools
go install github.com/mgechev/revive@latest
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# Symlink configuration (handled by stow)
cd ~/dotfiles
stow go
```

## Directory Structure
- `revive/` - Revive linter configuration

## Environment Variables
Typically set in shell configuration:
```bash
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
```

## Revive Linter
Custom rules for Go code quality:
- Enforces naming conventions
- Checks for unused code
- Ensures proper error handling
- Validates comments and documentation

## Common Commands
```bash
go mod init     # Initialize new module
go mod tidy     # Clean up dependencies
go test ./...   # Run all tests
go build        # Build current package
go run .        # Run current package
revive ./...    # Run linter
```

## Tools Ecosystem
- **gopls** - Language server for IDE support
- **delve** - Debugger
- **revive** - Linter (faster than golint)
- **gofumpt** - Stricter formatter than gofmt

## Tips
- Use `go mod vendor` for offline builds
- Run `go mod download` to pre-cache dependencies
- Use `go test -cover` for coverage reports