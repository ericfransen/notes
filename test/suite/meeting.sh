#!/bin/bash

# --- Test Meeting Note Creation ---
echo "--- Running Meeting Note Creation Test ---"
note_content="Meeting with John Doe"
"$PROJECT_ROOT/scripts/note" %meeting "$note_content"

# --- Assertions ---
# Find the created file
note_file=$(find "$VAULT_PATH/meetings" -name "*mtg.md" -print -quit)
assert_file_exists "$note_file"
echo "--- Content of $note_file ---"
cat "$note_file"
echo "--- End of content ---"
assert_file_contains "$note_file" "Title: meeting"
assert_file_contains "$note_file" "$note_content"
echo "--- Meeting Note Creation Test Passed ---"
