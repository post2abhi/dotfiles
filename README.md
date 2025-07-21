# My macOS Dotfiles

This repository contains my personal macOS development environment configuration, including Homebrew software installations, Zsh profile settings, and other custom configurations. The goal is to provide a declarative and reproducible way to set up a new Mac, ensuring consistency across all my machines.

## ✨ Features

* **Homebrew Software Management:** Installs command-line tools and macOS applications (including Mac App Store apps via `mas`) using a `Brewfile`.

* **Zsh Configuration:** Manages my custom Zsh shell profile, aliases, and functions for a personalized and efficient command-line experience.

* **Git Configuration:** Synchronizes my global Git settings.

* **Reproducible Setup:** Easily replicate my entire development environment on any new macOS machine.

* **Version Controlled:** All configurations are tracked with Git, allowing for easy updates and rollbacks.

## 🚀 Getting Started (New Machine Setup)

Follow these steps to set up a new macOS machine with my dotfiles:

1.  **Install Git:**
    If you don't have Git installed (it usually comes with Xcode Command Line Tools), you might need to install it first. The easiest way is to try running `git` in your terminal; macOS will prompt you to install the command line developer tools if they're missing.

2.  **Clone this Repository:**
    Open your Terminal and clone this repository to your home directory. It's recommended to clone it to `~/dotfiles`:

    ```bash
    git clone [https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git](https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git) ~/dotfiles

    ```

    (Remember to replace `YOUR_GITHUB_USERNAME` with your actual GitHub username.)

3.  **Run the Setup Script:**
    Navigate into the cloned directory and execute the `install.sh` script:

    ```bash
    cd ~/dotfiles
    ./install.sh

    ```

    **What the `install.sh` script does:**

    * Checks for and installs/updates Homebrew.

    * Checks for and installs `mas` (Mac App Store command-line interface), if needed.

    * Installs all software listed in `homebrew/Brewfile` (formulae, casks, and `mas` apps).

    * Creates symbolic links from the files in this repository to their correct locations in your home directory (e.g., `~/dotfiles/zsh/zshrc` becomes `~/.zshrc`).

    * Reloads your Zsh profile to apply the new configurations.

4.  **Restart Terminal:**
    For all changes to take full effect, it's recommended to close and reopen your Terminal application or open a new terminal window.

## 🔄 Ongoing Maintenance

### Updating Your `Brewfile`

When you install new software via `brew install` or `brew install --cask` and want to add it to your `Brewfile` for future replication:

1.  Navigate to your `dotfiles` directory:

    ```bash
    cd ~/dotfiles

    ```

2.  Run `brew bundle dump --force`:

    ```bash
    brew bundle dump --force --file=homebrew/Brewfile

    ```

    This command will update `homebrew/Brewfile` with your currently installed Homebrew software. The `--force` flag ensures it overwrites the existing file, and the `--file` flag specifies the correct path within your repo.

    * **Important:** If you have apps that you *don't* want managed by `Brewfile` (e.g., pre-installed Apple apps like Numbers, GarageBand), ensure you've added `# dump_ignore` to their lines in `homebrew/Brewfile`. This flag tells `brew bundle dump` to ignore those entries when updating the file.

3.  Commit and push the changes to your GitHub repository:

    ```bash
    git add homebrew/Brewfile
    git commit -m "Updated Brewfile with new software"
    git push

    ```

### Updating Other Dotfiles

For changes to your Zsh profile, Git config, or other custom files:

1.  Make your edits directly in the files within your `~/dotfiles` repository (e.g., `~/dotfiles/zsh/zshrc`).

2.  Commit and push the changes to your GitHub repository:

    ```bash
    cd ~/dotfiles
    git add . # Adds all modified files
    git commit -m "Updated Zsh profile" # Use a descriptive message
    git push

    ```

### Syncing Changes on Other Machines

To pull the latest changes from your GitHub repository to another machine:

1.  Navigate to your `dotfiles` directory:

    ```bash
    cd ~/dotfiles

    ```

2.  Pull the latest changes:

    ```bash
    git pull origin main # Or whatever your main branch is called

    ```

3.  Re-run the `install.sh` script to apply new software installations and update symbolic links:

    ```bash
    ./install.sh

    ```

## 📂 Repository Structure

```
dotfiles/
├── zsh/
│   ├── zshrc            # Main Zsh configuration
│   ├── aliases          # Custom aliases (sourced by zshrc)
│   └── functions        # Custom functions/scripts (sourced by zshrc)
├── git/
│   └── gitconfig        # Global Git configuration
├── homebrew/
│   └── Brewfile         # List of Homebrew formulae, casks, and mas apps
├── install.sh           # The main setup script
└── README.md            # This file


