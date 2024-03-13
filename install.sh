#!/bin/bash

# Installation script name
SCRIPT_NAME="git-user.sh"

# Target directory
TARGET_DIR="/usr/local/bin"

# Target command name
TARGET_CMD="gu"

# Check if the git-user.sh script exists in the current directory
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME does not exist in the current directory."
    exit 1
fi

# Grant script execution permission
chmod +x "$SCRIPT_NAME" || { echo "Failed to set executable permission for $SCRIPT_NAME."; exit 1; }

# Inform the user that sudo permission may be needed
echo "Installing $TARGET_CMD to $TARGET_DIR. You may need to enter your password to grant permission."

# Copy the script to /usr/local/bin using sudo
sudo cp "$SCRIPT_NAME" "$TARGET_DIR/$TARGET_CMD" || { echo "Failed to install $TARGET_CMD to $TARGET_DIR."; exit 1; }

# Check if successfully installed
if [ -f "$TARGET_DIR/$TARGET_CMD" ]; then
    echo "Installation successful. You can now use '$TARGET_CMD' command anywhere."
else
    echo "Installation failed."
fi
