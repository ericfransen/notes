#!/bin/bash

# --- Test Command Installation ---
echo "--- Running Installation Check Test ---"

# Check if 'note' command is in PATH
assert_command_exists "note"

# Check if 'note-sync' command is in PATH
assert_command_exists "note-sync"

# Check if 'note' is a symlink and where it points
LINK_NOTE_PATH="/usr/local/bin/note"
if [ ! -L "$LINK_NOTE_PATH" ]; then
    echo "✗ ERROR: $LINK_NOTE_PATH is not a symbolic link."
    exit 1
fi

# Verify the link points to the current project
TARGET_NOTE_PATH="$PROJECT_ROOT/scripts/note"
RESOLVED_PATH=$(readlink "$LINK_NOTE_PATH")

if [[ "$RESOLVED_PATH" != "$TARGET_NOTE_PATH" ]]; then
    echo "✗ ERROR: 'note' symlink points to incorrect location."
    echo "  Expected: $TARGET_NOTE_PATH"
    echo "  Actual:   $RESOLVED_PATH"
    exit 1
fi

echo "✓ SUCCESS: 'note' symlink is correctly installed and points to the current project."
echo "--- Installation Check Test Passed ---"
