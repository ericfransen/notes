#!/bin/bash

teardown() {
    # --- Remove the temporary vault directory ---
    rm -rf "$VAULT_PATH"

    # --- Remove the temporary config file ---
    rm -f "$CONFIG_FILE"
}
