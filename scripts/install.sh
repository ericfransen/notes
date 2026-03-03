#!/bin/bash

# This script idempotently installs the 'note' and 'note-sync' commands.

echo "--- Command Installation ---"

# Find the project root directory relative to this script
SCRIPT_DIR=$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
PROJECT_ROOT=$( cd -P "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd )

# Path to the stable shim
SHIM_PATH="$PROJECT_ROOT/scripts/note-shim.sh"

LINK_NOTE_PATH="/usr/local/bin/note"
LINK_SYNC_PATH="/usr/local/bin/note-sync"

# Function to register project root
register_root() {
    REGISTRY_DIR="$HOME/.config/note"
    REGISTRY_FILE="$REGISTRY_DIR/root_path"
    mkdir -p "$REGISTRY_DIR"
    echo "$PROJECT_ROOT" > "$REGISTRY_FILE"
    echo "✓ Project root registered: $PROJECT_ROOT"
}

# --- 1. Path Update Check (Move-Resiliency) ---
# If shims are already installed, just update the registry and exit (No sudo needed)
if [ -f "$LINK_NOTE_PATH" ] && ! [ -L "$LINK_NOTE_PATH" ] && grep -q "note-shim.sh" "$LINK_NOTE_PATH" 2>/dev/null; then
    register_root
    echo "✓ Project path updated. (No sudo required as stable shims were already found)"
    exit 0
fi

# --- 2. Fresh Installation (Requires Sudo) ---
read -p "Install stable 'note' and 'note-sync' shims to /usr/local/bin? (Requires sudo) (Y/n) " install_link
if [[ "$install_link" =~ ^[nN]$ ]]; then
    echo "Skipping command installation."
    exit 0
fi

if [ ! -d "/usr/local/bin" ]; then
    echo "Error: /usr/local/bin directory not found." >&2; exit 1
fi

# Register root before installing shims
register_root

echo "Installing stable shims..."
# We MUST remove any existing symlink FIRST, otherwise 'cp' might follow it and overwrite the project file!
sudo rm -f "$LINK_NOTE_PATH"
sudo rm -f "$LINK_SYNC_PATH"

# Now copy the shim as a permanent, stable file
sudo cp "$SHIM_PATH" "$LINK_NOTE_PATH"
sudo cp "$SHIM_PATH" "$LINK_SYNC_PATH"
sudo chmod +x "$LINK_NOTE_PATH" "$LINK_SYNC_PATH"

if [ -f "$LINK_NOTE_PATH" ]; then
    echo "✓ 'note' and 'note-sync' commands installed successfully (as stable shims)."
else
    echo "✗ Failed to install commands." >&2; exit 1
fi

exit 0
