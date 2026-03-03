#!/bin/bash

# This is a stable 'shim' for the note-taking CLI.
# It is installed to /usr/local/bin and finds the actual project using the registry.

REGISTRY_FILE="$HOME/.config/note/root_path"

if [ ! -f "$REGISTRY_FILE" ]; then
    echo "Error: Project root not registered." >&2
    echo "Please navigate to your _notes repository and run: bash scripts/setup.sh" >&2
    exit 1
fi

PROJECT_ROOT=$(cat "$REGISTRY_FILE")

if [ ! -d "$PROJECT_ROOT" ]; then
    echo "Error: The registered project root does not exist: $PROJECT_ROOT" >&2
    echo "It looks like you moved the _notes repository." >&2
    echo "To fix this, navigate to the new location and run: bash scripts/install.sh" >&2
    exit 1
fi

# Determine which command to run based on how this shim was called (note or note-sync)
COMMAND_NAME=$(basename "$0")
TARGET_SCRIPT="$PROJECT_ROOT/scripts/$COMMAND_NAME"

if [ ! -x "$TARGET_SCRIPT" ]; then
    echo "Error: Target script not found or not executable: $TARGET_SCRIPT" >&2
    exit 1
fi

# Execute the actual script with all arguments
exec "$TARGET_SCRIPT" "$@"
