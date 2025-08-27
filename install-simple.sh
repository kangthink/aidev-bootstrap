#!/bin/bash

# AI Development Bootstrap - Simple Remote Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash
# With project name: curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash -s -- my-project

set -e

REPO_URL="https://github.com/kangthink/aidev-bootstrap.git"
PROJECT_NAME="${1:-ai-project-$(date +%s)}"
TEMP_DIR="/tmp/aidev-bootstrap-$$"

echo "🚀 AI Development Bootstrap"
echo "📦 Project: $PROJECT_NAME"

# Check if project directory exists
if [ -d "$PROJECT_NAME" ]; then
    echo "❌ Directory '$PROJECT_NAME' already exists"
    exit 1
fi

# Clone template to temp directory
echo "📥 Downloading template..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

# Create project directory and copy folders
mkdir -p "$PROJECT_NAME"

# Copy specific folders (.claude, scripts, etc.)
for folder in .claude scripts; do
    if [ -d "$TEMP_DIR/$folder" ]; then
        echo "📁 Copying $folder..."
        cp -r "$TEMP_DIR/$folder" "$PROJECT_NAME/"
        echo "✅ $folder ready"
    fi
done

# Copy any other important files
for file in .gitignore README.md; do
    if [ -f "$TEMP_DIR/$file" ]; then
        cp "$TEMP_DIR/$file" "$PROJECT_NAME/"
    fi
done

# Cleanup
rm -rf "$TEMP_DIR"

# Initialize new git repository
cd "$PROJECT_NAME"
git init
git add .
git commit -m "Initial commit: bootstrapped AI project

Template: $REPO_URL"

echo ""
echo "🎉 Success! Project '$PROJECT_NAME' is ready"
echo "📍 $(pwd)"
echo ""
echo "Get started:"
echo "  cd $PROJECT_NAME"