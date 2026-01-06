#!/bin/bash

# --- Test Sync Script ---
echo "--- Running Sync Script Test ---"
# Create an untitled note
"$PROJECT_ROOT/scripts/note" --title "My Test Note" "This is a test note."

# Run the sync script
"$PROJECT_ROOT/scripts/note-sync"

# --- Assertions ---
# Find the renamed file
note_file=$(find "$VAULT_PATH" -name "*my-test-note*.md" -print -quit)
assert_file_exists "$note_file"
echo "--- Sync Script Test Passed ---"
