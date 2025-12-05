#!/bin/bash

# --- Find Project Root & Source Config ---
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
done
SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
PROJECT_ROOT="$SCRIPT_DIR/.."

# --- Source Dependencies ---
source "$SCRIPT_DIR/setup.sh"
source "$SCRIPT_DIR/teardown.sh"
source "$SCRIPT_DIR/assertions.sh"

# --- Run Tests ---
for test_suite in "$SCRIPT_DIR"/suite/*.sh; do
    source "$test_suite"
done

# --- Run Teardown ---
teardown
