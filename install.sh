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
    # --no-upgrade prevents Homebrew from upgrading already installed software,
    # focusing only on installing missing ones.
    # --force overwrites the Brewfile if it exists, but in this context,
    # it's usually run from the cloned repo, so it's fine.
    brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile" --no-upgrade
    log_success "Software installed/updated from Brewfile."
else
    log_error "Brewfile not found at $DOTFILES_DIR/homebrew/Brewfile. Please ensure it exists."
fi

# 5. Create symbolic links for dotfiles
log_message "Creating symbolic links for dotfiles..."

# Common dotfiles
ln -sfv "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sfv "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# Optional: Custom aliases and functions (assuming they are sourced by .zshrc)
if [ -f "$DOTFILES_DIR/zsh/aliases" ]; then
    ln -sfv "$DOTFILES_DIR/zsh/aliases" "$HOME/.aliases"
fi
if [ -f "$DOTFILES_DIR/zsh/functions" ]; then
    ln -sfv "$DOTFILES_DIR/zsh/functions" "$HOME/.functions"
fi

# Add more symlinks here for any other dotfiles you manage, e.g.:
# ln -sfv "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
# ln -sfv "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

log_success "Symbolic links created."

# 6. Reload Zsh profile
log_message "Reloading Zsh profile..."
# This ensures the changes take effect in the current terminal session.
source "$HOME/.zshrc"
log_success "Zsh profile reloaded."

log_success "Setup complete! Your macOS development environment is ready."
echo "Please restart your terminal or open a new one for all changes to take full effect."


