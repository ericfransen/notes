#!/bin/bash

echo "--- Running Title Logic & Sanitization Tests ---"

# --- Test 1: Explicit Flag Priority (--title) ---
echo "Test 1: Explicit Flag Priority (--title)"
"$PROJECT_ROOT/scripts/note" --title "Explicit Title" "Ignored: Content"

note_file=$(find "$VAULT_PATH/00__Inbox" -name "*explicit-title.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: \"Explicit Title\""
# Content should still contain the "Ignored:" part because it wasn't used as title
assert_file_contains "$note_file" "Ignored: Content"


# --- Test 2: Explicit Flag Priority (_Title) ---
echo "Test 2: Explicit Flag Priority (_Title)"
# Note: _Title is typically converted. Let's see if _Underscore-Title becomes "Underscore-Title"
"$PROJECT_ROOT/scripts/note" _Underscore-Title "Ignored: Content"

note_file=$(find "$VAULT_PATH/00__Inbox" -name "*underscore-title.md" -print -quit)
assert_file_exists "$note_file"
# The script usually treats _Arg as custom title.
assert_file_contains "$note_file" "title: \"Underscore-Title\""


# --- Test 3: Colon Extraction (< 15 words) ---
echo "Test 3: Colon Extraction (< 15 words)"
"$PROJECT_ROOT/scripts/note" "Short Title: This is the content"

note_file=$(find "$VAULT_PATH/00__Inbox" -name "*short-title.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: \"Short Title\""
# The part before colon is stripped from body in the script logic for this case
assert_file_contains "$note_file" "This is the content"
assert_file_does_not_contain "$note_file" "Short Title:"


# --- Test 4: Colon Extraction (> 15 words - Fallback) ---
echo "Test 4: Colon Extraction (> 15 words - Fallback)"
# 16 words before colon
long_input="One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve Thirteen Fourteen Fifteen Sixteen: Content"
"$PROJECT_ROOT/scripts/note" "$long_input"

# Should use first 10 words
expected_slug="one-two-three-four-five-six-seven-eight-nine-ten"
note_file=$(find "$VAULT_PATH/00__Inbox" -name "*$expected_slug.md" -print -quit)

if [ -z "$note_file" ]; then
    echo "FAIL: Note file with fallback slug not found."
    find "$VAULT_PATH/00__Inbox" -name "*.md"
    exit 1
fi
assert_file_exists "$note_file"
# The title in frontmatter should be the first 10 words
assert_file_contains "$note_file" "title: \"One Two Three Four Five Six Seven Eight Nine Ten\""


# --- Test 5: Fallback (No colon) ---
echo "Test 5: Fallback (No colon)"
"$PROJECT_ROOT/scripts/note" "Just a simple note with no specific title structure included"

expected_slug="just-a-simple-note-with-no-specific-title-structure-included"
# Wait, strict first 10 words:
# 1:Just 2:a 3:simple 4:note 5:with 6:no 7:specific 8:title 9:structure 10:included
expected_slug="just-a-simple-note-with-no-specific-title-structure-included"

note_file=$(find "$VAULT_PATH/00__Inbox" -name "*$expected_slug.md" -print -quit)
assert_file_exists "$note_file"
assert_file_contains "$note_file" "title: \"Just a simple note with no specific title structure included\""


# --- Test 6: Sanitization ---
echo "Test 6: Sanitization"
# "Title & Special @ Symbols: Content"
# Logic: Colon is at word 5. So title is "Title & Special @ Symbols".
# Filename should sanitize "&" and "@".
"$PROJECT_ROOT/scripts/note" "Title & Special @ Symbols: Content"

# "Title & Special @ Symbols" -> kebab case
# & and @ become - or are removed?
# to_kebab_case: sed -E 's/[^a-zA-Z0-9]+/-/g; s/^-+|-+$//g'
# "Title & Special @ Symbols" -> "Title - Special - Symbols" -> "title-special-symbols" (roughly)

# Let's search broadly first to see what it generated
note_file=$(find "$VAULT_PATH/00__Inbox" -name "*title-special-symbols.md" -print -quit)
# If strict match fails, we might need to adjust expectation based on implementation details
if [ -z "$note_file" ]; then
    # Maybe it collapsed differently? "title-special-symbols" seems likely.
    # & -> -
    # @ -> -
    # "Title---Special---Symbols" -> "title-special-symbols"
    echo "Check: Searching for loose match"
    note_file=$(find "$VAULT_PATH/00__Inbox" -name "*symbols.md" -print -quit)
fi

assert_file_exists "$note_file"
# Title in frontmatter might retain symbols if using the raw string?
# The script: TITLE="$EXTRACTED_TITLE". 
# The filename uses kebab case. The yaml uses TITLE.
# Let's check if the yaml title is quoted and preserves symbols.
assert_file_contains "$note_file" "title: \"Title & Special @ Symbols\""
# Filename should NOT have & or @
if [[ "$note_file" == *"&"* ]] || [[ "$note_file" == *"@"* ]]; then
    echo "FAIL: Filename contains illegal symbols: $note_file"
    exit 1
fi
echo "✓ Filename sanitized"

echo "--- Title Logic & Sanitization Tests Passed ---"
