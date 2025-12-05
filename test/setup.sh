#!/bin/bash

setup() {
    # --- Create a temporary vault directory ---
    export VAULT_PATH="$PROJECT_ROOT/test/vault"
    mkdir -p "$VAULT_PATH"

    # --- Create a temporary config file ---
    export CONFIG_FILE="$PROJECT_ROOT/test/config.sh"
    touch "$CONFIG_FILE"

    # --- Set the NOTE_TEMPLATE_PATH variable ---
    export NOTE_TEMPLATE_PATH="templates/note_template.md"

    # --- Set the DAILY_DIR variable ---
    export DAILY_DIR="daily"

    # --- Set the EDITOR_CMD variable ---
    export EDITOR_CMD="vim"

    # --- Set the VAULT_NAME variable ---
    export VAULT_NAME="test-vault"
    
    # --- Set the TEMPLATE_MAPPINGS variable ---
    export TEMPLATE_MAPPINGS="daily templates/daily_note_template.md
meeting templates/meetings/meeting_template.md"

    # --- Set the TEMPLATE_OUTPUT_DIRS variable ---
    export TEMPLATE_OUTPUT_DIRS="daily daily
meeting meetings"
}

setup
