# My macOS Dotfiles

This repository contains my personal macOS development environment configuration, including Homebrew software installations, Zsh profile settings, and other custom configurations. The goal is to provide a declarative and reproducible way to set up a new Mac, ensuring consistency across all my machines.

## ✨ Features

* **Homebrew Software Management:** Installs command-line tools and macOS applications (including Mac App Store apps via `mas`) using a `Brewfile`.

* **Zsh Configuration:** Manages my custom Zsh shell profile, aliases, functions, and includes **Oh My Zsh** with the **Powerlevel10k** theme.

* **NAVI Cheatsheet Tool:** Integrates the `navi` command-line interactive cheatsheet tool for quick command references, including a custom Zsh widget for quick access.

* **Git Configuration:** Synchronizes my global Git settings, with robust support for **machine-specific overrides**.

* **Reproducible Setup:** Easily replicate my entire development environment on any new macOS machine.

* **Version Controlled:** All configurations are tracked with Git, allowing for easy updates and rollbacks.

* **Machine-Specific Configuration:** Supports local-only settings that are not synced across all machines, ideal for sensitive data or unique machine setups.

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

    * Installs all software listed in `homebrew/Brewfile` (formulae, casks, and `mas` apps), including `navi`.

    * Creates symbolic links from the files in this repository to their correct locations in your home directory (e.g., `~/dotfiles/zsh/zshrc` becomes `~/.zshrc`).

    * Installs Oh My Zsh and clones the Powerlevel10k theme.

    * If `~/dotfiles/zsh/p10k.zsh` exists, it symlinks it. Otherwise, Powerlevel10k will prompt for configuration on first Zsh launch.

    * Symlinks NAVI's configuration (`config.yaml`) and custom cheatsheets (`cheats/`) from your dotfiles to `~/.config/navi/`.

    * Reloads your Zsh profile to apply the new configurations.

4.  **Post-Setup for Powerlevel10k & NAVI (Important!):**
    For Powerlevel10k to display correctly and for you to customize its appearance:

    * **Install a recommended font:** Powerlevel10k heavily relies on Nerd Fonts for its icons and glyphs. The recommended font is **MesloLGS NF**.

        * Download the font files (all four `.ttf` files) from the official Powerlevel10k repository: [https://github.com/romkatv/powerlevel10k/blob/master/font.md](https://github.com/romkatv/powerlevel10k/blob/master/font.md)

        * Open each `.ttf` file on your Mac and click "Install Font".

    * **Restart your terminal:** Close your current terminal window/tab and open a new one. This is crucial for the new font and Zsh theme to load properly.

    * **Powerlevel10k Configuration:**

        * If you copied your existing `.p10k.zsh` to `~/dotfiles/zsh/p10k.zsh` and committed it: Your prompt should now look identical to your configured Mac.

        * If you did NOT copy an existing `.p10k.zsh`: Run the Powerlevel10k configuration wizard:

            ```bash
            p10k configure
            ```

            Follow the interactive prompts to customize your prompt style. This wizard will generate a `~/.p10k.zsh` file. If you want to version control this newly generated file, remember to copy it to `~/dotfiles/zsh/p10k.zsh` and commit it.

    * **NAVI Configuration:**

        * If you have custom NAVI configuration (`config.yaml`) or cheatsheets, ensure they are placed in `~/dotfiles/navi/`. The setup script symlinks them to `~/.config/navi/`.

        * You can then run `navi` in your terminal to explore your cheatsheets interactively.

5.  **Machine-Specific Local Configuration:**
    For any aliases, path exports, or other settings that are unique to a particular machine and should **not** be synced through Git:

    * **For Zsh:** Create a file named `.zshrc.local` directly in your home directory (e.g., `~/.zshrc.local`). Your main `~/.zshrc` will automatically source this file if it exists.

    * **For Git:** Create a file named `.gitconfig.local` directly in your home directory (e.g., `~/.gitconfig.local`). Your global `~/.gitconfig` (symlinked from your dotfiles) is configured to include this file.

    * These local files are **ignored by Git** (via your `.gitignore`) and will not be pushed to your `dotfiles` repository.

6.  **Git Authentication (One-Time Setup):**
    To avoid entering your username and Personal Access Token (PAT) every time you push or pull code from GitHub:

    * **Option A (Recommended for HTTPS):** Configure Git to use the macOS Keychain:

        ```bash
        git config --global credential.helper osxkeychain
        ```

        The next time you perform a Git operation, enter your GitHub username and PAT when prompted. macOS will save it securely.

    * **Option B (Robust Alternative, using SSH):**

        1.  Generate an SSH key pair: `ssh-keygen -t ed25519 -C "your_email@example.com"` (follow prompts, set passphrase).

        2.  Start SSH agent and add key: `eval "$(ssh-agent -s)"` and `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`.

        3.  Copy public key: `pbcopy < ~/.ssh/id_ed25519.pub`.

        4.  Add public key to your GitHub account settings (Settings > SSH and GPG keys > New SSH key).

        5.  Change your local repository's remote URL from HTTPS to SSH:

            ```bash
            cd ~/dotfiles
            git remote set-url origin git@github.com:YOUR_GITHUB_USERNAME/dotfiles.git
            ```

        6.  Test: `ssh -T git@github.com`

## 🔄 Ongoing Maintenance

### Updating Your `Brewfile`

When you install new software via `brew install` or `brew install --cask` and want to add it to your `Brewfile` for future replication:

1.  Navigate to your `dotfiles` directory:

    ```bash
    cd ~/dotfiles
    ```

2.  Run `brew bundle dump --force --file=homebrew/Brewfile`:

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

For changes to your Zsh profile, Git config, or other custom files (including your `p10k.zsh` or NAVI configs):

1.  Make your edits directly in the files within your `~/dotfiles` repository (e.g., `~/dotfiles/zsh/zshrc`, `~/dotfiles/zsh/p10k.zsh`, `~/dotfiles/navi/config.yaml`, `~/dotfiles/navi/cheats/`, `~/dotfiles/git/gitconfig`).

2.  Commit and push the changes to your GitHub repository:

    ```bash
    cd ~/dotfiles
    git add . # Adds all modified files
    git commit -m "Updated Zsh profile, p10k config, or NAVI config" # Use a descriptive message
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
│   ├── functions        # Custom functions/scripts (sourced by zshrc)
│   ├── p10k.zsh         # Powerlevel10k configuration (symlinked to ~/.p10k.zsh)
│   └── oh-my-zsh-custom/ # Your custom Oh My Zsh themes/plugins
│       ├── themes/
│       └── plugins/
├── git/
│   └── gitconfig        # Global Git configuration (symlinked to ~/.gitconfig)
├── homebrew/
│   └── Brewfile         # List of Homebrew formulae, casks, and mas apps
├── navi/                # NAVI configuration and cheatsheets
│   ├── config.yaml      # NAVI's configuration file
│   └── cheats/          # Your custom NAVI cheatsheets
├── install.sh           # The main setup script
└── README.md            # This file
