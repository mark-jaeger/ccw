#!/bin/bash
# Install ccw - Claude Code Worktree Manager

set -e

CCW_DIR="$HOME/.ccw"

echo "Installing ccw..."

# Clone or update
if [ -d "$CCW_DIR" ]; then
    echo "Updating existing installation..."
    git -C "$CCW_DIR" pull --quiet
else
    echo "Cloning ccw..."
    git clone --quiet https://github.com/mark-jaeger/ccw.git "$CCW_DIR"
fi

# Make executable
chmod +x "$CCW_DIR/ccw"

# Check if already in PATH
if [[ ":$PATH:" != *":$CCW_DIR:"* ]]; then
    # Detect shell config file
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi

    echo "" >> "$SHELL_RC"
    echo "# ccw - Claude Code Worktree Manager" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/.ccw:\$PATH\"" >> "$SHELL_RC"

    echo "Added to PATH in $SHELL_RC"
    echo ""
    echo "Run this to use ccw now:"
    echo "  source $SHELL_RC"
else
    echo "Already in PATH"
fi

echo ""
echo "✓ Installed! Run 'ccw' to get started."
