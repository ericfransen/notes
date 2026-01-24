#!/bin/bash

# --- Test Daily Note Creation ---
echo "--- Running Daily Note Creation Test ---"
# Remove existing daily notes
find "$VAULT_PATH/daily" -name "*.md" -delete
"$PROJECT_ROOT/scripts/note" -daily --weather "Sunny"

# --- Assertions ---
# Find the created file
note_file=$(find "$VAULT_PATH/daily" -name "*.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: \"$(date +'%a' | tr '[:lower:]' '[:upper:]')_daily\""
assert_file_contains "$note_file" "day: $(date +'%A')"
assert_file_contains "$note_file" "folder: daily"
assert_file_contains "$note_file" "weather: \"Sunny\""
echo "✓ Daily Note Creation Test Passed"

# --- Test Re-opening Existing Daily Note ---
echo "--- Running Idempotency Test (Re-open Daily) ---"
output=$("$PROJECT_ROOT/scripts/note" -daily)
if echo "$output" | grep -q "Found existing daily note"; then
    echo "✓ SUCCESS: Detected existing daily note."
else
    echo "✗ ERROR: Did not detect existing daily note."
    echo "Output: $output"
    exit 1
fi
file_count=$(find "$VAULT_PATH/daily" -name "*.md" | wc -l)
if [ "$file_count" -eq 1 ]; then
    echo "✓ SUCCESS: Still only one daily note exists."
else
    echo "✗ ERROR: Expected 1 daily note, found $file_count."
    exit 1
fi

# --- Test Yesterday (Exists) ---
echo "--- Running Yesterday (Exists) Test ---"
find "$VAULT_PATH/daily" -name "*.md" -delete

if date -v -1d >/dev/null 2>&1; then
    # BSD date (macOS)
    YESTERDAY_DATE=$(date -v -1d +'%y-%m-%d')
else
    # GNU date (Linux)
    YESTERDAY_DATE=$(date -d "yesterday" +'%y-%m-%d')
fi

YESTERDAY_FILE="$VAULT_PATH/daily/${YESTERDAY_DATE}__Sun_daily.md"
touch "$YESTERDAY_FILE"

output=$("$PROJECT_ROOT/scripts/note" -yesterday)
if echo "$output" | grep -q "$YESTERDAY_FILE"; then
    echo "✓ SUCCESS: Opened yesterday's note."
else
    echo "✗ ERROR: Did not open yesterday's note."
    echo "Output: $output"
    exit 1
fi

# --- Test Yesterday (Fallback) ---
echo "--- Running Yesterday (Fallback) Test ---"
find "$VAULT_PATH/daily" -name "*.md" -delete
# Create a note from 5 days ago
if date -v -5d >/dev/null 2>&1; then
    # BSD date (macOS)
    OLDER_DATE=$(date -v -5d +'%y-%m-%d')
else
    # GNU date (Linux)
    OLDER_DATE=$(date -d "5 days ago" +'%y-%m-%d')
fi
OLDER_FILE="$VAULT_PATH/daily/${OLDER_DATE}__Tue_daily.md"
touch "$OLDER_FILE"

output=$("$PROJECT_ROOT/scripts/note" -yesterday)
if echo "$output" | grep -q "No daily note was captured for yesterday, opening last daily note"; then
     if echo "$output" | grep -q "$OLDER_FILE"; then
        echo "✓ SUCCESS: Fell back to older note."
     else
        echo "✗ ERROR: Did not open the specific older note."
        echo "Output: $output"
        exit 1
     fi
else
    echo "✗ ERROR: Did not trigger fallback logic."
    echo "Output: $output"
    exit 1
fi

# --- Test Yesterday (None) ---
echo "--- Running Yesterday (None) Test ---"
find "$VAULT_PATH/daily" -name "*.md" -delete
output=$("$PROJECT_ROOT/scripts/note" -yesterday)
if echo "$output" | grep -q "No daily notes found"; then
    echo "✓ SUCCESS: Correctly reported no notes found."
else
    echo "✗ ERROR: Failed to report no notes."
    echo "Output: $output"
    exit 1
fi

echo "--- All Daily Tests Passed ---"
