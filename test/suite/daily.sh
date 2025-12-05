#!/bin/bash

# --- Test Daily Note Creation ---
echo "--- Running Daily Note Creation Test ---"
# Remove existing daily notes
find "$VAULT_PATH/daily" -name "*.md" -delete
"$PROJECT_ROOT/scripts/note" -daily

# --- Assertions ---
# Find the created file
note_file=$(find "$VAULT_PATH/daily" -name "*.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: $(date +'%a' | perl -ne 'print ucfirst(lc)')_daily"
echo "--- Daily Note Creation Test Passed ---"
