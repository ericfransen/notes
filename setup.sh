#!/bin/bash

# --- Helper Functions ---
echo_green() { echo -e "\033[0;32m$1\033[0m"; }
echo_bold() { echo -e "\033[1m$1\033[0m"; }

# --- Introduction ---
echo_green "Welcome to the Note-Taking CLI Tool Setup"
echo "This script will configure a secure, private repository for your notes."
chmod +x note note-sync
echo ""

# --- 1. Configure Vault Path ---
echo_bold "Step 1: Configure your Obsidian Vault"
./note -vault
if [ ! -f "./config.sh" ]; then echo "Vault configuration failed. Exiting." >&2; exit 1; fi
source "./config.sh"

read -p "Enter path for your daily notes directory (e.g., 10 - Dailies): " daily_dir
echo "DAILY_DIR=\"$daily_dir\"" >> "./config.sh"

echo ""

# --- 2. Initialize Private Notes Repository ---
echo_bold "Step 2: Set up Private Git Repository for Notes"
if [ -d "$VAULT_PATH/.git" ]; then
    echo "Your vault is already a Git repository. Skipping initialization."
else
    read -p "Initialize a new private Git repository in '$VAULT_PATH'? (Y/n) " init_git
    if [[ ! "$init_git" =~ ^[nN]$ ]]; then
        (cd "$VAULT_PATH" && git init)
        echo "Initialized a new Git repository for your notes."
        echo_green "To create and link a private GitHub repository for backup, run 'note -git-setup' at any time."
    fi
fi
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
    CRON_CMD="59 23 * * * /usr/local/bin/note-sync"
    (crontab -l 2>/dev/null | grep -Fv "note-sync" ; echo "$CRON_CMD") | crontab -
    echo "Cron job installed. Your notes will be synced nightly if changes are detected."
fi
echo ""

# --- Completion ---
echo_green "Setup complete!"
