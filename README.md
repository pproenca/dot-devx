# dot-devx

Personal development environment configuration for macOS.

## Quick Install

```bash
git clone git@github.com:pproenca/dot-devx.git
cd dot-devx
./install.sh
```

## What's Included

- **Shell**: Zsh with Oh-My-Zsh, Starship prompt, productivity functions
- **tmux**: Session management with auto-save/restore
- **Git**: Template config with SSH signing support
- **direnv**: Auto-environment loading for Python/Node projects
- **Claude Code**: CLAUDE.md templates for project context
- **iTerm2**: Exportable profiles

## Commands After Install

| Command | Description |
|---------|-------------|
| `pj` | Fuzzy-find and jump to project |
| `pjr` | Jump to recent project |
| `tp` | Create/attach tmux project session |
| `claude-init` | Create CLAUDE.md from template |
| `envrc-init` | Create .envrc for auto-env |
| `Ctrl-R` | fzf history search |
| `Ctrl-T` | fzf file finder |

## Dependencies

Installed automatically by `install.sh`:
- zoxide, fzf, fd, bat, direnv, tmux, starship, git

## Manual Steps

1. **1Password SSH Agent**: Configure in 1Password settings
2. **iTerm2 Profiles**: Import from `iterm2/profiles.json`
3. **tmux Plugins**: Start tmux, press `Ctrl-a I`

## Structure

```
dot-devx/
├── install.sh           # Bootstrap script
├── shell/zshrc          # Shell configuration
├── tmux/tmux.conf       # tmux configuration
├── git/gitconfig.template
├── config/
│   ├── direnv/          # Auto-environment templates
│   └── claude-templates/ # CLAUDE.md templates
├── bin/                 # Helper scripts
└── iterm2/              # iTerm2 profiles (export manually)
```
