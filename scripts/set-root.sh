#!/bin/bash

# This script sets the project root path in a global registry file (~/.config/note/root_path).
# This allows the 'note' shim to find the project even if it's moved.

REGISTRY_DIR="$HOME/.config/note"
REGISTRY_FILE="$REGISTRY_DIR/root_path"

# Find current project root
SCRIPT_DIR=$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
PROJECT_ROOT=$( cd -P "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd )

# Ensure the registry directory exists
if [ ! -d "$REGISTRY_DIR" ]; then
    mkdir -p "$REGISTRY_DIR"
    echo "Created registry directory: $REGISTRY_DIR"
fi

# Write the current project root to the registry file
echo "$PROJECT_ROOT" > "$REGISTRY_FILE"
echo "✓ Project root registered: $PROJECT_ROOT"
echo "  Registered at: $REGISTRY_FILE"
