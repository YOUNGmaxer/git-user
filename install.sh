#!/bin/bash

# Target directory
TARGET_DIR="/usr/local/bin"

# Target command name
TARGET_CMD="gu"

# Remote script location
SCRIPT_URL="https://raw.githubusercontent.com/YOUNGmaxer/git-user/main/git-user.sh"

echo "Installing $TARGET_CMD"

# Download the script using curl
curl -o "$TARGET_CMD" "$SCRIPT_URL" || {
    echo "Failed to download $TARGET_CMD from $SCRIPT_URL."
    exit 1
}

# Grant script execution permission
chmod +x "$TARGET_CMD" || {
    echo "Failed to set executable permission for $TARGET_CMD."
    exit 1
}

# Inform the user that sudo permission may be needed
echo "The script will now be installed to $TARGET_DIR. Your password may be required to grant permission for this operation."

# Move the script to /usr/local/bin using sudo
sudo mv "$TARGET_CMD" "$TARGET_DIR/$TARGET_CMD" || {
    echo "Failed to install $TARGET_CMD to $TARGET_DIR."
    exit 1
}

# Check if successfully installed
if [ -f "$TARGET_DIR/$TARGET_CMD" ]; then
    echo "Installation successful. You can now use '$TARGET_CMD' command anywhere."
else
    echo "Installation failed."
fi