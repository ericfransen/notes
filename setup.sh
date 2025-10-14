#!/bin/bash

# --- Helper Functions ---
echo_green() { echo -e "\033[0;32m$1\033[0m"; }
echo_bold() { echo -e "\033[1m$1\033[0m"; }

# --- Introduction ---
echo_green "Welcome to the Frictionless Note-Taking System Setup!"
echo "This script will configure your self-contained note-taking environment."
chmod +x note note-sync
echo ""

# --- 1. Configure Vault Path ---
echo_bold "Step 1: Configure your Obsidian Vault"
./note -vault # This command now creates the local config.sh
if [ ! -f "./config.sh" ]; then
    echo "Vault configuration failed. Exiting." >&2; exit 1
fi
source "./config.sh"
echo ""

# --- 2. Copy Template File ---
echo_bold "Step 2: Set up the Note Template"
# The template is now sourced from the script directory, not the vault
if [ ! -f "./note_template.md" ]; then
    echo "Error: note_template.md not found in project directory." >&2
fi
echo "Note template is kept within the project directory."
echo ""

# --- 3. Install Commands ---
echo_bold "Step 3: Install Commands via Symbolic Links"
read -p "Link 'note' and 'note-sync' to /usr/local/bin? (Requires sudo) (Y/n) " install_link
if [[ ! "$install_link" =~ ^[nN]$ ]]; then
    sudo ln -sf "$(pwd)/note" /usr/local/bin/note
    sudo ln -sf "$(pwd)/note-sync" /usr/local/bin/note-sync
    echo "Commands linked. You can now use 'note' globally."
fi
echo ""

# --- 4. Configure Smart Sync ---
echo_bold "Step 4: Configure Smart Sync (Local Cron Job)"
read -p "Set up a local cron job for nightly backups at 11:59 PM? (Y/n) " setup_cron
if [[ ! "$setup_cron" =~ ^[nN]$ ]]; then
    if ! command -v git &> /dev/null; then echo "Error: git is not installed." >&2; else
        CRON_CMD="59 23 * * * /usr/local/bin/note-sync"
        (crontab -l 2>/dev/null | grep -Fv "note-sync" ; echo "$CRON_CMD") | crontab -
        echo "Cron job installed. Your notes will be synced nightly if changes are detected."
        echo "Please ensure your vault is a git repository with a configured remote."
    fi
fi
echo ""

# --- Completion ---
echo_green "Setup complete!"
echo "- Your vault is configured in the local 'config.sh' file."
echo "- Use 'note' to create notes and 'note -vault' to reconfigure."
