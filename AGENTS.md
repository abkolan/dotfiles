# Repository Guidelines

## Project Structure & Module Organization
This repository is a chezmoi-managed dotfiles repo. The source directory uses chezmoi naming conventions: `dot_` prefix for dotfiles, `.tmpl` suffix for templates.

Source directory layout:
- `dot_config/` -- maps to `~/.config/` (nvim, kitty, ghostty, atuin, etc.)
- `dot_zshrc`, `dot_zshenv` -- shell config files
- `dot_gitconfig.tmpl` -- templated git config
- `scripts/` -- utility scripts, on PATH via `.zshenv`
- `run_` scripts at repo root -- chezmoi bootstrap/run-once scripts
- `Brewfile` -- package dependencies

## Build, Test, and Development Commands
- `chezmoi apply` -- apply configs to `$HOME`.
- `chezmoi diff` -- preview changes before applying.
- `chezmoi doctor` / `chezmoi verify` -- health checks and diagnostics.
- `chezmoi managed` -- list all managed files.
- `chezmoi edit <file>` -- edit a managed file in the source directory.
- `brew bundle --file Brewfile` -- install/update declared CLI tools.
- `zsh -n ~/.zshenv ~/.zshrc` -- syntax-check Zsh config changes.
- `nvim --headless "+Lazy! sync" +qa` -- sync Neovim plugins.
- `hyperfine 'zsh -i -c exit'` -- benchmark shell startup.

## Coding Style & Naming Conventions
Follow `.editorconfig`:
- 2 spaces for most files (Shell, JSON, YAML, Markdown)
- 4 spaces for Python
- tabs for Go and Makefiles
Use LF endings, trim trailing whitespace (except Markdown), and always end files with a newline.
Name scripts with lowercase kebab-case (for example `toggle-dark-mode.sh`). Keep paths portable (`$HOME`, not hardcoded `/Users/<name>`).

## Testing Guidelines
There is no single unit-test framework; use targeted validation:
- Run `chezmoi verify` after structural changes.
- Run `chezmoi doctor` for environment diagnostics.
- Run `zsh -n ~/.zshenv ~/.zshrc` for shell config edits.
- Run `nvim --headless "+Lazy! sync" +qa` after Neovim plugin/config updates.

## Commit & Pull Request Guidelines
History favors short, imperative commit subjects (for example `fix ghostty theme sync`, `docs: standardize README`). Keep commits focused to one logical area.
PRs should include:
- concise summary of what changed
- verification commands executed
- linked issue (if applicable)
- screenshots/terminal captures for UI-facing changes (Kitty/Ghostty/Neovim themes).

## Security & Configuration Tips
Do not commit secrets, tokens, or machine-specific credentials. Chezmoi templates use `promptStringOnce` for per-machine values. `.chezmoi.toml` (generated local config) is local-only and never committed. Secrets stay in `~/.secrets/` via direnv. Sanitize personal paths before committing.
