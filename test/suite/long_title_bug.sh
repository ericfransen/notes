#!/bin/bash

# --- Test Long Title with Colon and Newlines ---
echo "--- Running Long Title Bug Test ---"
note_content="_notes_app things you want to remember & be quizzed on: you can save to a quiz repo and then we could have a cli tool to run through your quiz items for later\n\nBATTLE BEAVER - create your own personalized quizes"

# Run the note command
"$PROJECT_ROOT/scripts/note" "$note_content" +battlebeaver +quiz +notes_app

# --- Assertions ---
# Find the created file. 
# We expect the title to be derived from "_notes_app things you want to remember & be quizzed on"
# The filename should NOT contain "battle-beaver" from the second line.

# Expected part of filename
expected_slug="notes-app-things-you-want-to-remember-be-quizzed-on"
unexpected_slug="battle-beaver"

# Search for the file
# Using find to look for the file created today
note_file=$(find "$VAULT_PATH" -name "*$expected_slug*.md" -print -quit)

if [ -z "$note_file" ]; then
  echo "FAIL: Note file with expected title slug '$expected_slug' not found."
  # Debug: list all files
  echo "Files in vault:"
  find "$VAULT_PATH" -name "*.md"
  exit 1
fi

if [[ "$note_file" == *"$unexpected_slug"* ]]; then
  echo "FAIL: Note file contains unexpected text '$unexpected_slug' in filename: $note_file"
  exit 1
fi

assert_file_exists "$note_file"
# Check content
# The title should be quoted in the frontmatter
assert_file_contains "$note_file" "title: \"_notes_app things you want to remember & be quizzed on\""

assert_file_contains "$note_file" "BATTLE BEAVER"

echo "--- Long Title Bug Test Passed ---"
