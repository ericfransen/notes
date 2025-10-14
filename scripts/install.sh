#!/bin/bash

# This script idempotently installs the 'note' and 'note-sync' commands.

echo "--- Command Installation ---"

# Find the project root directory relative to this script
SCRIPT_DIR=$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
PROJECT_ROOT="$SCRIPT_DIR/.."

TARGET_NOTE_PATH="$PROJECT_ROOT/scripts/note"
TARGET_SYNC_PATH="$PROJECT_ROOT/scripts/note-sync"
LINK_NOTE_PATH="/usr/local/bin/note"
LINK_SYNC_PATH="/usr/local/bin/note-sync"

should_install=true
# Check if links already exist and point to the correct place
if [ -L "$LINK_NOTE_PATH" ] && [ "$(readlink $LINK_NOTE_PATH)" == "$TARGET_NOTE_PATH" ]; then
    echo "✓ 'note' command is already correctly installed."
    should_install=false
fi

if [ "$should_install" = true ]; then
    read -p "Link 'note' and 'note-sync' to /usr/local/bin? (Requires sudo) (Y/n) " install_link
    if [[ "$install_link" =~ ^[nN]$ ]]; then
        echo "Skipping command installation."
        exit 0
    fi

    if [ ! -d "/usr/local/bin" ]; then
        echo "Error: /usr/local/bin directory not found." >&2; exit 1
    fi

    echo "Creating symbolic links..."
    sudo ln -sf "$TARGET_NOTE_PATH" "$LINK_NOTE_PATH"
    sudo ln -sf "$TARGET_SYNC_PATH" "$LINK_SYNC_PATH"

    if [ -L "$LINK_NOTE_PATH" ]; then
        echo "✓ 'note' command installed successfully."
    else
        echo "✗ Failed to install 'note' command." >&2; exit 1
    fi
else
    # If we skipped the main install, still ensure note-sync is linked for the cron job
    if [ ! -L "$LINK_SYNC_PATH" ] || [ "$(readlink $LINK_SYNC_PATH)" != "$TARGET_SYNC_PATH" ]; then
        echo "Updating 'note-sync' command link for cron job..."
        sudo ln -sf "$TARGET_SYNC_PATH" "$LINK_SYNC_PATH"
    fi
fi

exit 0