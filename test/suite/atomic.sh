#!/bin/bash

# --- Test Atomic Note Creation ---
echo "--- Running Atomic Note Creation Test ---"
note_content="This is an atomic note."
"$PROJECT_ROOT/scripts/note" "$note_content"

# --- Assertions ---
# Find the created file
note_file=$(find "$VAULT_PATH" -name "*.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "$note_content"
echo "--- Atomic Note Creation Test Passed ---"
