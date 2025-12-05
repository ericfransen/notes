#!/bin/bash

# --- Test Untitled Note Creation ---
echo "--- Running Untitled Note Creation Test ---"
"$PROJECT_ROOT/scripts/note"

# --- Assertions ---
# Find the created file
note_file=$(find "$VAULT_PATH/00__Inbox" -name "*untitled*.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: untitled"
echo "--- Untitled Note Creation Test Passed ---"
