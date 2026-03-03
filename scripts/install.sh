#!/bin/bash

# This script idempotently installs the 'note' and 'note-sync' commands.

echo "--- Command Installation ---"

# Find the project root directory relative to this script
SCRIPT_DIR=$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
PROJECT_ROOT="$SCRIPT_DIR/.."

# Path to the stable shim
SHIM_PATH="$PROJECT_ROOT/scripts/note-shim.sh"

LINK_NOTE_PATH="/usr/local/bin/note"
LINK_SYNC_PATH="/usr/local/bin/note-sync"

should_install=true
# Check if links already exist and are our stable shim (not a broken symlink)
if [ -f "$LINK_NOTE_PATH" ] && ! [ -L "$LINK_NOTE_PATH" ] && grep -q "note-shim.sh" "$LINK_NOTE_PATH" 2>/dev/null; then
    echo "✓ Stable 'note' shim is already installed."
    # Even if installed, we should make sure the root is registered
    bash "$PROJECT_ROOT/scripts/set-root.sh"
    should_install=false
fi

if [ "$should_install" = true ]; then
    read -p "Install stable 'note' and 'note-sync' shims to /usr/local/bin? (Requires sudo) (Y/n) " install_link
    if [[ "$install_link" =~ ^[nN]$ ]]; then
        echo "Skipping command installation."
        exit 0
    fi

    if [ ! -d "/usr/local/bin" ]; then
        echo "Error: /usr/local/bin directory not found." >&2; exit 1
    fi

    # First, ensure the project root is registered
    bash "$PROJECT_ROOT/scripts/set-root.sh"

    echo "Installing stable shims..."
    # We COPY the shim instead of symlinking it, so it's a permanent, stable file
    sudo cp "$SHIM_PATH" "$LINK_NOTE_PATH"
    sudo cp "$SHIM_PATH" "$LINK_SYNC_PATH"
    sudo chmod +x "$LINK_NOTE_PATH" "$LINK_SYNC_PATH"

    if [ -f "$LINK_NOTE_PATH" ]; then
        echo "✓ 'note' command installed successfully (as a stable shim)."
    else
        echo "✗ Failed to install 'note' command." >&2; exit 1
    fi
else
    # Ensure note-sync is also the shim
    if [ ! -f "$LINK_SYNC_PATH" ] || [ -L "$LINK_SYNC_PATH" ]; then
        echo "Updating 'note-sync' to stable shim..."
        sudo cp "$SHIM_PATH" "$LINK_SYNC_PATH"
        sudo chmod +x "$LINK_SYNC_PATH"
    fi
fi

exit 0