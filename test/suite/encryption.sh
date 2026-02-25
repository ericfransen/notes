#!/bin/bash

echo "--- Running Encryption Setup & Recovery Test ---"

# 1. Clean the environment explicitly for this test
rm -rf "$VAULT_PATH/.git"
rm -rf "$VAULT_PATH/.gitattributes"
rm -f "$CONFIG_FILE"

# Pre-populate config to bypass some prompts
echo 'DAILY_DIR="daily"' > "$CONFIG_FILE"
echo 'CLEANUP_EMPTY_NOTES="false"' >> "$CONFIG_FILE"

# 2. Simulate initial setup flow
echo "- Testing Initial Setup Flow"
# Inputs:
# - 'n' (for note -vault change prompt)
# - '\n' (absorbed by note -vault open prompt)
# 1. y (Init Git Repo)
# 2. y (Enable encryption)
# 3. n (Setup cron)
echo -e "nny\ny\nn\n" | bash "$PROJECT_ROOT/scripts/setup.sh" > /dev/null

# Assertions for initial setup
assert_file_exists "$VAULT_PATH/.gitattributes"
assert_file_exists "$VAULT_PATH/.git/git-crypt/keys/default"
assert_file_contains "$CONFIG_FILE" "GIT_CRYPT_KEY_B64="

# Extract the key to use in recovery
export GIT_CRYPT_KEY_B64=$(grep "GIT_CRYPT_KEY_B64=" "$CONFIG_FILE" | cut -d'"' -f2)

if [ -z "$GIT_CRYPT_KEY_B64" ]; then
    echo "✗ ERROR: Failed to extract base64 key from config."
    exit 1
fi
echo "✓ Extracted base64 encryption key."

# Write a secret file and commit it
echo "My secret data" > "$VAULT_PATH/secret.md"
(cd "$VAULT_PATH" && git add . && git commit -m "add secret") >/dev/null

# 3. Simulate recovery flow
echo "- Testing Recovery Flow on New Machine"
# Clone the vault as if on a new computer
rm -rf "$PROJECT_ROOT/test/vault_clone"
(cd "$PROJECT_ROOT/test" && git clone "vault" "vault_clone") >/dev/null 2>&1

# Switch environment to the clone
export VAULT_PATH="$PROJECT_ROOT/test/vault_clone"
export CONFIG_FILE="$PROJECT_ROOT/test/config_clone.sh"
rm -f "$CONFIG_FILE"

# Pre-populate config again
echo 'DAILY_DIR="daily"' > "$CONFIG_FILE"
echo 'CLEANUP_EMPTY_NOTES="false"' >> "$CONFIG_FILE"

# At this point, secret.md should be encrypted binary garbage
if grep -q "My secret data" "$VAULT_PATH/secret.md"; then
    echo "✗ ERROR: Cloned file is NOT encrypted!"
    exit 1
fi
echo "✓ Cloned file is correctly encrypted."

# Run setup for the clone
# Inputs:
# 1. n (for note -vault change prompt)
# 2. \n (absorbed by note -vault open prompt)
# 3. y (Has key to unlock?)
# 4. $GIT_CRYPT_KEY_B64 (Paste key)
# 5. n (Setup cron)
echo -e "nny\n$GIT_CRYPT_KEY_B64\nn\n" | bash "$PROJECT_ROOT/scripts/setup.sh" > /dev/null

# Assertions for recovery
assert_file_contains "$VAULT_PATH/secret.md" "My secret data"
assert_file_contains "$CONFIG_FILE" "GIT_CRYPT_KEY_B64="
echo "✓ Cloned file is correctly decrypted!"

echo "--- Encryption Setup & Recovery Test Passed ---"

# Cleanup
rm -rf "$PROJECT_ROOT/test/vault_clone"
rm -f "$PROJECT_ROOT/test/config_clone.sh"
