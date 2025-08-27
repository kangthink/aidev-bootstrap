#!/bin/bash

# AI Development Bootstrap - Simple Remote Installer
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash -s -- my-project
#   curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash -s -- .

set -e

REPO_URL="https://github.com/kangthink/aidev-bootstrap.git"
PROJECT_NAME="${1:-ai-project-$(date +%s)}"
TEMP_DIR="/tmp/aidev-bootstrap-$$"
CURRENT_DIR_MODE=false

echo "🚀 AI Development Bootstrap"

# Check for current directory mode
if [ "$PROJECT_NAME" = "." ]; then
    CURRENT_DIR_MODE=true
    PROJECT_NAME=$(basename "$PWD")
    echo "📦 Installing to current directory: $PROJECT_NAME"
    
    # Check if current directory has files that might conflict
    if [ -d ".claude" ] || [ -d ".aidev" ]; then
        echo "⚠️  Warning: .claude or .aidev folder already exists in current directory"
        read -p "Continue and overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    echo "📦 Project: $PROJECT_NAME"
    
    # Check if project directory exists
    if [ -d "$PROJECT_NAME" ]; then
        echo "❌ Directory '$PROJECT_NAME' already exists"
        exit 1
    fi
fi

# Clone template to temp directory
echo "📥 Downloading template..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

# Create project directory (unless current dir mode)
if [ "$CURRENT_DIR_MODE" = false ]; then
    mkdir -p "$PROJECT_NAME"
    TARGET_DIR="$PROJECT_NAME"
else
    TARGET_DIR="."
fi

# Copy specific folders (.claude, .aidev, etc.)
for folder in .claude .aidev; do
    if [ -d "$TEMP_DIR/$folder" ]; then
        echo "📁 Copying $folder..."
        cp -r "$TEMP_DIR/$folder" "$TARGET_DIR/"
        echo "✅ $folder ready"
    fi
done

# Copy any other important files (only if not current dir mode to avoid overwriting)
if [ "$CURRENT_DIR_MODE" = false ]; then
    for file in .gitignore README.md; do
        if [ -f "$TEMP_DIR/$file" ]; then
            cp "$TEMP_DIR/$file" "$TARGET_DIR/"
        fi
    done
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Initialize new git repository
cd "$TARGET_DIR"

if [ "$CURRENT_DIR_MODE" = true ]; then
    # Check if already a git repository
    if [ ! -d ".git" ]; then
        git init
        git add .
        git commit -m "Initial commit: bootstrapped AI project

Template: $REPO_URL"
        echo "✅ Git repository initialized"
    else
        echo "ℹ️  Git repository already exists, skipping initialization"
        echo "💡 You can manually commit the new files if needed"
    fi
else
    git init
    git add .
    git commit -m "Initial commit: bootstrapped AI project

Template: $REPO_URL"
fi

echo ""
echo "🎉 Success! Project '$PROJECT_NAME' is ready"
echo "📍 $(pwd)"
echo ""
if [ "$CURRENT_DIR_MODE" = false ]; then
    echo "Get started:"
    echo "  cd $PROJECT_NAME"
else
    echo "Ready to use! Your AI development environment is set up."
fi