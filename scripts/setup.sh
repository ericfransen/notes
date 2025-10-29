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
    echo 'CRON_SCHEDULE="59 23 * * *"' >> "$CONFIG_FILE"
    echo_green "✓ Created new config.sh file."
else
    echo "✓ config.sh already exists."
fi
echo ""

# --- 2. Add Template Mapping Section (if missing) ---
if ! grep -q "# --- Template Mappings ---" "$CONFIG_FILE"; then
    echo "" >> "$CONFIG_FILE"
    echo "# --- Template Mappings ---" >> "$CONFIG_FILE"
    echo "# Create shortcuts for your most used templates." >> "$CONFIG_FILE"
    echo "# This system uses a simple multi-line string for compatibility with all Bash versions." >> "$CONFIG_FILE"
    echo "# The alternative, an associative array, is not used because it requires Bash 4.0+." >> "$CONFIG_FILE"
    echo "#" >> "$CONFIG_FILE"
    echo "# To add a mapping, just add a new line inside the quotes with the format:" >> "$CONFIG_FILE"
    echo "# ALIAS PATH/TO/TEMPLATE.md" >> "$CONFIG_FILE"
    echo "#" >> "$CONFIG_FILE"
    echo "# Example:" >> "$CONFIG_FILE"
    echo "# TEMPLATE_MAPPINGS=\"" >> "$CONFIG_FILE"
    echo "# meeting templates/meeting_template.md" >> "$CONFIG_FILE"
    echo "# book templates/book_review_template.md" >> "$CONFIG_FILE"
    echo "# \"" >> "$CONFIG_FILE"
    echo "TEMPLATE_MAPPINGS=\"\"" >> "$CONFIG_FILE"
fi

# --- 3. Configure Vault Path ---
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

# Create the daily notes directory if it doesn't exist
if [ ! -d "$VAULT_PATH/$DAILY_DIR" ]; then
    mkdir -p "$VAULT_PATH/$DAILY_DIR"
    echo "✓ Created daily notes directory at '$VAULT_PATH/$DAILY_DIR'."
fi
echo ""

# --- 4. Set up Git Repository ---
echo_bold "Step 3: Set up Private Git Repository for Notes"
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
echo_bold "Step 4: Install Global Commands & Cron Job"
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