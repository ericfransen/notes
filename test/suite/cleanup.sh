#!/bin/bash

# --- Test Cleanup Empty Notes ---
echo "--- Running Cleanup Empty Notes Test ---"

# --- Setup ---
# Initialize git in the test vault to simulate a real environment
(cd "$VAULT_PATH" && git init && git config user.email "test@example.com" && git config user.name "Test User" && git remote add origin https://example.com/test.git)

# Create a test note with content
mkdir -p "$VAULT_PATH/00__Inbox"
VALID_NOTE="$VAULT_PATH/00__Inbox/valid_note.md"
echo "## Body" > "$VALID_NOTE"
echo "Some content" >> "$VALID_NOTE"
echo "---" >> "$VALID_NOTE"

# Create a truly empty note (just title/structure but empty body)
EMPTY_NOTE="$VAULT_PATH/00__Inbox/empty_note.md"
echo "---" > "$EMPTY_NOTE"
echo "title: empty" >> "$EMPTY_NOTE"
echo "---" >> "$EMPTY_NOTE"
echo "" >> "$EMPTY_NOTE"
echo "## Body" >> "$EMPTY_NOTE"
echo "" >> "$EMPTY_NOTE"
echo "---" >> "$EMPTY_NOTE"

# --- Test Case 1: CLEANUP_EMPTY_NOTES=false (Default) ---
echo "Test Case 1: Cleanup Disabled"
echo 'CLEANUP_EMPTY_NOTES="false"' > "$CONFIG_FILE"
"$PROJECT_ROOT/scripts/note-sync"

assert_file_exists "$VALID_NOTE"
assert_file_exists "$EMPTY_NOTE"
echo "✓ Cleanup disabled: Preserved both notes."

# --- Test Case 2: CLEANUP_EMPTY_NOTES=true ---
echo "Test Case 2: Cleanup Enabled"
echo 'CLEANUP_EMPTY_NOTES="true"' > "$CONFIG_FILE"
"$PROJECT_ROOT/scripts/note-sync"

assert_file_exists "$VALID_NOTE"
if [ -f "$EMPTY_NOTE" ]; then
    echo "✗ ERROR: Empty note should have been deleted."
    exit 1
else
    echo "✓ SUCCESS: Empty note deleted."
fi
echo "✓ Cleanup enabled: Deleted empty note, preserved valid note."

echo "--- Cleanup Empty Notes Test Passed ---"
