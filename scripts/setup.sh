#!/bin/bash

# --- Helper Functions ---
echo_green() { echo -e "\033[0;32m$1\033[0m"; }
echo_bold() { echo -e "\033[1m$1\033[0m"; }

# --- Introduction ---
echo_green "Welcome to the Frictionless Note-Taking System Setup!"
PROJECT_ROOT=$( cd -P "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )
# Fix for the permission denied error
chmod +x "$PROJECT_ROOT/scripts/note" "$PROJECT_ROOT/scripts/note-sync" "$PROJECT_ROOT/scripts/install.sh"

# --- 1. Create Initial Config File ---
echo_bold "Step 1: Initializing Configuration"
CONFIG_FILE="$PROJECT_ROOT/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "# Main configuration for the note-taking system" > "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo "# Path to your Obsidian vault. This will be set by the setup process." >> "$CONFIG_FILE"
    echo "#VAULT_PATH=\"\"" >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo 'EDITOR_CMD="code"' >> "$CONFIG_FILE"
    echo 'NOTE_TEMPLATE_PATH="templates/note_template.md"' >> "$CONFIG_FILE"
    echo 'DAILY_TEMPLATE_PATH="templates/daily_note_template.md"' >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo "# Cron schedule for nightly sync. Default is 11:59 PM daily." >> "$CONFIG_FILE"
    echo 'CRON_SCHEDULE="59 23 * * *"' >> "$CONFIG_FILE"
    echo_green "✓ Created new config.sh file."
else
    echo "✓ config.sh already exists."
fi
echo ""

# --- 2. Configure Vault Path ---
echo_bold "Step 2: Configure your Obsidian Vault"
"$PROJECT_ROOT/scripts/note" -vault
source "$CONFIG_FILE"
if [ -z "$VAULT_PATH" ] || [ ! -d "$VAULT_PATH" ]; then
    echo "✗ No valid vault path was configured. Please re-run the setup." >&2; exit 1
fi
echo_green "✓ Vault path is configured."

# --- 3. Configure Daily Notes Directory ---
# Only ask if DAILY_DIR is not already set
if [ -z "$DAILY_DIR" ]; then
    read -p "Enter path for your daily notes directory (e.g., 10 - Dailies): " daily_dir
    echo "DAILY_DIR=\"$daily_dir\"" >> "$CONFIG_FILE"
fi
echo ""

# --- 4. Set up Git Repository ---
echo_bold "Step 4: Set up Private Git Repository for Notes"
if [ -d "$VAULT_PATH/.git" ]; then
    echo "✓ Your vault at '$VAULT_PATH' is already a Git repository."
else
    read -p "Initialize a new private Git repository in '$VAULT_PATH'? (Y/n) " init_git
    if [[ ! "$init_git" =~ ^[nN]$ ]]; then
        (cd "$VAULT_PATH" && git init)
        echo "Initialized a new Git repository for your notes."
        echo_green "To link a private GitHub repo for backup, run 'note -git-setup' at any time."
    fi
fi
echo ""

# --- 5. Install Commands & Cron Job ---
echo_bold "Step 5: Install Global Commands & Cron Job"
"$PROJECT_ROOT/scripts/install.sh"
echo ""
source "$CONFIG_FILE" # Re-source to get the CRON_SCHEDULE

CRON_CMD="$CRON_SCHEDULE /usr/local/bin/note-sync"
EXISTING_CRON=$(crontab -l 2>/dev/null | grep 'note-sync')

if [ -n "$EXISTING_CRON" ]; then
    echo "A cron job for note-sync already exists:"
    echo "  $EXISTING_CRON"
    read -p "Do you want to overwrite it with the schedule from your config file? (y/N) " overwrite_cron
    if [[ "$overwrite_cron" =~ ^[yY]$ ]]; then
        (crontab -l 2>/dev/null | grep -v 'note-sync' ; echo "$CRON_CMD") | crontab -
        echo "✓ Cron job updated."
    fi
else
    read -p "Set up a local cron job for automatic backups? (Y/n) " setup_cron
    if [[ ! "$setup_cron" =~ ^[nN]$ ]]; then
        (crontab -l 2>/dev/null ; echo "$CRON_CMD") | crontab -
        echo "✓ Cron job installed."
    fi
fi
echo ""

echo_green "Setup complete!"