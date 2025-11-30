#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "=== dot-devx installer ==="
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# Backup existing files
backup_if_exists() {
    if [[ -f "$1" ]] || [[ -d "$1" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$1" "$BACKUP_DIR/"
        echo "Backed up: $1"
    fi
}

# Install Homebrew packages
install_deps() {
    echo ""
    echo "=== Installing dependencies ==="
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew install zoxide fzf fd bat direnv tmux starship git
}

# Install Nerd Fonts (required for iTerm2 profile and Starship)
install_fonts() {
    echo ""
    echo "=== Installing Fonts ==="

    # Install Nerd Fonts via Homebrew cask
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font
    brew install --cask font-hack-nerd-font
    brew install --cask font-jetbrains-mono-nerd-font

    echo "Installed Nerd Fonts (MesloLGS NF, Hack, JetBrains Mono)"
    echo "Note: You may need to restart iTerm2 and select the font"
}

# Install Oh-My-Zsh and custom plugins
setup_omz() {
    echo ""
    echo "=== Oh-My-Zsh Setup ==="

    # Install Oh-My-Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh-My-Zsh already installed"
    fi

    # Install custom plugins
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    mkdir -p "$plugins_dir"

    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
        echo "Installed: zsh-autosuggestions"
    else
        echo "zsh-autosuggestions already installed"
    fi

    if [[ ! -d "$plugins_dir/zsh-completions" ]]; then
        git clone https://github.com/zsh-users/zsh-completions "$plugins_dir/zsh-completions"
        echo "Installed: zsh-completions"
    else
        echo "zsh-completions already installed"
    fi

    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"
        echo "Installed: zsh-syntax-highlighting"
    else
        echo "zsh-syntax-highlighting already installed"
    fi
}

# Setup git config with prompts
setup_git() {
    echo ""
    echo "=== Git Configuration ==="

    read -p "Git username [pproenca]: " git_user
    git_user="${git_user:-pproenca}"

    read -p "Git email [8202400+pproenca@users.noreply.github.com]: " git_email
    git_email="${git_email:-8202400+pproenca@users.noreply.github.com}"

    read -p "Use 1Password SSH signing? [y/N]: " use_1pass

    backup_if_exists "$HOME/.gitconfig"

    sed -e "s|{{GIT_USER}}|$git_user|g" \
        -e "s|{{GIT_EMAIL}}|$git_email|g" \
        "$DOTFILES_DIR/git/gitconfig.template" > "$HOME/.gitconfig"

    if [[ "$use_1pass" =~ ^[Yy]$ ]]; then
        # Add SSH signing config
        git config --global gpg.format ssh
        git config --global user.signingkey "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKq/lMh7xJihmQaGjdfVx+l/L2yc+hPgJNdL5EYLYq/"
        git config --global commit.gpgsign true
        echo "SSH signing enabled"
    fi

    echo "Git configured: $git_user <$git_email>"
}

# Copy shell config
setup_shell() {
    echo ""
    echo "=== Shell Configuration ==="

    backup_if_exists "$HOME/.zshrc"
    cp "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc"
    echo "Installed: ~/.zshrc"
}

# Copy tmux config
setup_tmux() {
    echo ""
    echo "=== tmux Configuration ==="

    backup_if_exists "$HOME/.tmux.conf"
    cp "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Install TPM
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        echo "Installed TPM (run 'tmux' then Ctrl-a I to install plugins)"
    fi

    echo "Installed: ~/.tmux.conf"
}

# Copy config directory files
setup_config() {
    echo ""
    echo "=== Config Files ==="

    # direnv
    mkdir -p "$HOME/.config/direnv/templates"
    cp "$DOTFILES_DIR/config/direnv/direnvrc" "$HOME/.config/direnv/"
    cp "$DOTFILES_DIR/config/direnv/templates/"* "$HOME/.config/direnv/templates/"
    echo "Installed: ~/.config/direnv/"

    # claude-templates
    mkdir -p "$HOME/.config/claude-templates"
    cp "$DOTFILES_DIR/config/claude-templates/"* "$HOME/.config/claude-templates/"
    echo "Installed: ~/.config/claude-templates/"

    # starship (if exists)
    if [[ -f "$DOTFILES_DIR/config/starship.toml" ]]; then
        cp "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/"
        echo "Installed: ~/.config/starship.toml"
    fi
}

# Copy bin scripts
setup_bin() {
    echo ""
    echo "=== Scripts ==="

    mkdir -p "$HOME/.local/bin"
    cp "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/"*
    echo "Installed: ~/.local/bin/"
}

# iTerm2 setup
setup_iterm() {
    echo ""
    echo "=== iTerm2 ==="

    if [[ -f "$DOTFILES_DIR/iterm2/profiles.json" ]]; then
        echo "iTerm2 profiles available at: $DOTFILES_DIR/iterm2/profiles.json"
        echo "To import: iTerm2 > Preferences > Profiles > Other Actions > Import JSON Profiles"
    fi
}

# Main
main() {
    install_deps
    install_fonts
    setup_omz
    setup_git
    setup_shell
    setup_tmux
    setup_config
    setup_bin
    setup_iterm

    echo ""
    echo "=== Installation Complete ==="
    echo ""
    echo "Backed up files to: $BACKUP_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Restart terminal or run: source ~/.zshrc"
    echo "  2. Start tmux and press Ctrl-a I to install plugins"
    echo "  3. Import iTerm2 profiles if desired"
    echo ""
}

main "$@"
