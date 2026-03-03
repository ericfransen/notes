#!/bin/bash

assert_file_exists() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        echo "✗ ERROR: File does not exist: $file_path"
        exit 1
    fi
    echo "✓ SUCCESS: File exists: $file_path"
}

assert_file_contains() {
    local file_path="$1"
    local expected_string="$2"
    if ! grep -q "$expected_string" "$file_path"; then
        echo "✗ ERROR: File does not contain expected string: $expected_string"
        exit 1
    fi
    echo "✓ SUCCESS: File contains expected string: $expected_string"
}

assert_file_does_not_contain() {
    local file_path="$1"
    local unexpected_string="$2"
    if grep -q "$unexpected_string" "$file_path"; then
        echo "✗ ERROR: File contains unexpected string: $unexpected_string"
        exit 1
    fi
    echo "✓ SUCCESS: File does not contain unexpected string: $unexpected_string"
}

assert_command_exists() {
    local command_name="$1"
    if ! command -v "$command_name" &> /dev/null; then
        echo "✗ ERROR: Command not found: $command_name"
        exit 1
    fi
    echo "✓ SUCCESS: Command found: $command_name"
}
