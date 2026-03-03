#!/bin/bash

# --- Test Command Installation ---
echo "--- Running Installation Check Test ---"

# Check if 'note' command is in PATH
assert_command_exists "note"

# Check if 'note-sync' command is in PATH
assert_command_exists "note-sync"

# Check if 'note' is a stable shim (not a symlink)
LINK_NOTE_PATH="/usr/local/bin/note"
if [ -L "$LINK_NOTE_PATH" ]; then
    echo "✗ ERROR: $LINK_NOTE_PATH is still a symbolic link. It should be a stable shim script."
    exit 1
fi

if ! grep -q "note-shim.sh" "$LINK_NOTE_PATH" 2>/dev/null; then
    echo "✗ ERROR: $LINK_NOTE_PATH does not appear to be the stable shim."
    exit 1
fi

# Verify the registry exists and points to the current project
REGISTRY_FILE="$HOME/.config/note/root_path"
if [ ! -f "$REGISTRY_FILE" ]; then
    echo "✗ ERROR: Registry file not found: $REGISTRY_FILE"
    exit 1
fi

REGISTERED_PATH=$(cat "$REGISTRY_FILE")
# Normalize paths for comparison
NORMALIZED_EXPECTED=$(cd "$PROJECT_ROOT" && pwd)
NORMALIZED_ACTUAL=$(cd "$REGISTERED_PATH" && pwd)

if [[ "$NORMALIZED_ACTUAL" != "$NORMALIZED_EXPECTED" ]]; then
    echo "✗ ERROR: Registered path is incorrect."
    echo "  Expected: $NORMALIZED_EXPECTED"
    echo "  Actual:   $NORMALIZED_ACTUAL"
    exit 1
fi

echo "✓ SUCCESS: 'note' is installed as a stable shim and registry is correct."
echo "--- Installation Check Test Passed ---"
