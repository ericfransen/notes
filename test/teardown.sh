#!/bin/bash

teardown() {
    # --- Remove the temporary vault directories ---
    rm -rf "$PROJECT_ROOT/test/vault"
    rm -rf "$PROJECT_ROOT/test/vault_clone"

    # --- Remove the temporary config files and keys ---
    rm -f "$CONFIG_FILE"
    rm -f "$PROJECT_ROOT/test/config.sh"
    rm -f "$PROJECT_ROOT/test/config_clone.sh"
    rm -f "$PROJECT_ROOT/.tmp-git-crypt-key"
}
