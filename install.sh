#!/bin/zsh

# install.sh
# This script automates the setup of a new macOS development environment
# by installing Homebrew software and creating symbolic links for dotfiles.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Define the directory where your dotfiles repository is cloned.
# This script assumes it's cloned to ~/dotfiles.
DOTFILES_DIR="$HOME/dotfiles"

# --- Helper Functions ---

# Function to print messages with a consistent format
log_message() {
    echo "✨ $1"
}

# Function to print success messages
log_success() {
    echo "✅ $1"
}

# Function to print error messages and exit
log_error() {
    echo "❌ ERROR: $1" >&2
    exit 1
}

# --- Main Setup Process ---

log_message "Starting macOS development environment setup..."

# 1. Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
    log_message "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    log_success "Homebrew installed successfully."
else
    log_message "Homebrew is already installed. Updating it..."
    brew update
    log_success "Homebrew updated."
fi

# 2. Check for mas (Mac App Store CLI) and install if not found
# This is crucial if your Brewfile includes 'mas' entries.
if ! command -v mas &> /dev/null; then
    log_message "mas (Mac App Store CLI) not found. Installing mas..."
    brew install mas
    log_success "mas installed successfully."
else
    log_message "mas is already installed."
fi

# 3. Navigate to the dotfiles directory
if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Dotfiles directory not found at $DOTFILES_DIR. Please clone your dotfiles repo there first."
fi
cd "$DOTFILES_DIR" || log_error "Failed to change directory to $DOTFILES_DIR."

# 4. Install software from Brewfile
if [ -f "$DOTFILES_DIR/homebrew/Brewfile" ]; then
    log_message "Installing software from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile" --no-upgrade
    log_success "Software installed/updated from Brewfile."
else
    log_error "Brewfile not found at $DOTFILES_DIR/homebrew/Brewfile. Please ensure it exists."
fi

# 5. Create symbolic links for dotfiles
log_message "Creating symbolic links for dotfiles..."

# Symlink .zshrc from dotfiles
ln -sfv "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

# Symlink .vimrc from dotfiles
ln -sfv "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

# Symlink .gitconfig from dotfiles
ln -sfv "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# Symlink .p10k.zsh from dotfiles (for Powerlevel10k configuration)
if [ -f "$DOTFILES_DIR/zsh/p10k.zsh" ]; then
    ln -sfv "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    log_message "Symlinked ~/.p10k.zsh for Powerlevel10k."
else
    log_message "No p10k.zsh found in dotfiles. Powerlevel10k will generate a default."
fi

# Optional: Custom aliases and functions (assuming they are sourced by .zshrc)
if [ -f "$DOTFILES_DIR/zsh/aliases" ]; then
    ln -sfv "$DOTFILES_DIR/zsh/aliases" "$HOME/.aliases"
fi
if [ -f "$DOTFILES_DIR/zsh/functions" ]; then
    ln -sfv "$DOTFILES_DIR/zsh/functions" "$HOME/.functions"
fi

# Symlink NAVI configuration and cheatsheets
# Ensure ~/.config/navi exists
mkdir -p "$HOME/.config/navi"
if [ -f "$DOTFILES_DIR/navi/config.yaml" ]; then
    ln -sfv "$DOTFILES_DIR/navi/config.yaml" "$HOME/.config/navi/config.yaml"
    log_message "Symlinked NAVI config.yaml."
fi
if [ -d "$DOTFILES_DIR/navi/cheats" ]; then
    ln -sfv "$DOTFILES_DIR/navi/cheats" "$HOME/.config/navi/cheats"
    log_message "Symlinked NAVI cheatsheets."
fi

log_success "Core symbolic links created."

# 6. Install Oh My Zsh and symlink custom components
log_message "Setting up Oh My Zsh..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_message "Oh My Zsh not found. Installing Oh My Zsh..."
    # Use the official Oh My Zsh installer script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed."
else
    log_message "Oh My Zsh is already installed."
    # Optionally update Oh My Zsh if it's already there
    # $ZSH/tools/upgrade.sh --unattended
fi

# Create custom directory if it doesn't exist (Oh My Zsh installer might create it)
mkdir -p "$HOME/.oh-my-zsh/custom"

# Symlink custom oh-my-zsh themes and plugins from dotfiles
# Ensure these target directories exist in your dotfiles repo:
# ~/dotfiles/zsh/oh-my-zsh-custom/themes
# ~/dotfiles/zsh/oh-my-zsh-custom/plugins

if [ -d "$DOTFILES_DIR/zsh/oh-my-zsh-custom/themes" ]; then
    log_message "Symlinking custom Oh My Zsh themes..."
    ln -sfv "$DOTFILES_DIR/zsh/oh-my-zsh-custom/themes" "$HOME/.oh-my-zsh/custom/themes"
fi

if [ -d "$DOTFILES_DIR/zsh/oh-my-zsh-custom/plugins" ]; then
    log_message "Symlinking custom Oh My Zsh plugins..."
    ln -sfv "$DOTFILES_DIR/zsh/oh-my-zsh-custom/plugins" "$HOME/.oh-my-zsh/custom/plugins"
fi

# Install Powerlevel10k theme
log_message "Installing Powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    log_success "Powerlevel10k cloned."
else
    log_message "Powerlevel10k is already cloned."
fi

log_success "Oh My Zsh setup complete."

# 7. Reload Zsh profile
log_message "Reloading Zsh profile..."
# This ensures the changes take effect in the current terminal session.
# Note: This will source ~/.zshrc, which contains the Powerlevel10k instant prompt logic.
source "$HOME/.zshrc"
log_success "Zsh profile reloaded."

log_success "Setup complete! Your macOS development environment is ready."
echo "Please restart your terminal or open a new one for all changes to take full effect."
echo ""
echo "--- Post-Setup Instructions for Powerlevel10k & NAVI ---"
echo "1. Install a recommended font (e.g., MesloLGS NF) for proper glyph rendering:"
echo "   Download from: https://github.com/romkatv/powerlevel10k/blob/master/font.md"
echo "   Install by opening the .ttf files on your Mac."
echo "2. Restart your terminal (close and open a new window/tab)."
echo "3. Run 'p10k configure' to start the interactive configuration wizard."
echo "   This will guide you through customizing your prompt and save settings to ~/.p10k.zsh."
echo "   If you want to version control this generated file, ensure it's copied to ~/dotfiles/zsh/p10k.zsh"
echo "   and committed to your repository."
echo "4. For NAVI, if you have custom cheatsheets or config, ensure they are in ~/dotfiles/navi/."
echo "   The setup script symlinks them to ~/.config/navi/."
echo "   You can then run 'navi' in your terminal to explore your cheatsheets."
echo ""
echo "--- Machine-Specific Local Configuration ---"
echo "If you have aliases, path exports, or other settings unique to this machine,"
echo "create a file at ~/.zshrc.local and add them there."
echo "This file is NOT part of your dotfiles repository and will not be synced."
echo "--------------------------------------------"
