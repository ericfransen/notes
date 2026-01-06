#!/bin/bash

# --- Test Atomic Note Creation with Title ---
echo "--- Running Atomic Note Creation with Title Test ---"
note_content="My Titled Note: This is an atomic note with a title."
"$PROJECT_ROOT/scripts/note" "$note_content"

# --- Assertions ---
# Find the created file
note_file=$(find "$VAULT_PATH" -name "*my-titled-note*.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: My Titled Note"
assert_file_contains "$note_file" "This is an atomic note with a title."
assert_file_does_not_contain "$note_file" "My Titled Note:"
echo "--- Atomic Note Creation with Title Test Passed ---"
