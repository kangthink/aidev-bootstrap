#!/bin/bash

# AI Development Bootstrap - Simple Remote Installer
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash -s -- my-project
#   curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash -s -- .

set -e

REPO_URL="https://github.com/kangthink/aidev-bootstrap.git"
PROJECT_ARG="${1:-}"
TEMP_DIR="/tmp/aidev-bootstrap-$$"

echo "🚀 AI Development Bootstrap"

# Determine installation mode
if [ "$PROJECT_ARG" = "." ]; then
    # Current directory mode
    PROJECT_NAME=$(basename "$PWD")
    TARGET_DIR="."
    echo "📦 Installing to current directory: $PROJECT_NAME"
    
    # Check for conflicts
    if [ -d ".claude" ] || [ -d ".aidev" ]; then
        echo "⚠️  Warning: .claude or .aidev folder already exists"
        read -p "Continue and overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
elif [ -n "$PROJECT_ARG" ]; then
    # Custom project name
    PROJECT_NAME="$PROJECT_ARG"
    TARGET_DIR="$PROJECT_NAME"
    echo "📦 Project: $PROJECT_NAME"
    
    if [ -d "$PROJECT_NAME" ]; then
        echo "❌ Directory '$PROJECT_NAME' already exists"
        exit 1
    fi
else
    # Default project name
    PROJECT_NAME="ai-project-$(date +%s)"
    TARGET_DIR="$PROJECT_NAME"
    echo "📦 Project: $PROJECT_NAME"
fi

# Clone template to temp directory
echo "📥 Downloading template..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

# Create target directory if needed
if [ "$TARGET_DIR" != "." ]; then
    mkdir -p "$TARGET_DIR"
fi

# Copy specific folders (.claude, .aidev, etc.)
for folder in .claude .aidev; do
    if [ -d "$TEMP_DIR/$folder" ]; then
        echo "📁 Copying $folder..."
        cp -r "$TEMP_DIR/$folder" "$TARGET_DIR/"
        echo "✅ $folder ready"
    fi
done

# Copy important files only for new project mode
if [ "$TARGET_DIR" != "." ]; then
    for file in .gitignore README.md; do
        if [ -f "$TEMP_DIR/$file" ]; then
            cp "$TEMP_DIR/$file" "$TARGET_DIR/"
        fi
    done
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Initialize git repository
cd "$TARGET_DIR"

if [ "$TARGET_DIR" = "." ]; then
    # Current directory mode - check if git repo exists
    if [ ! -d ".git" ]; then
        git init
        git add .
        git commit -m "Initial commit: bootstrapped AI project

Template: $REPO_URL"
        echo "✅ Git repository initialized"
    else
        echo "ℹ️  Existing git repository detected"
        echo "💡 You can manually commit the new files: git add . && git commit -m 'Add AI dev tools'"
    fi
else
    # New project mode - always init new repo
    git init
    git add .
    git commit -m "Initial commit: bootstrapped AI project

Template: $REPO_URL"
fi

echo ""
echo "🎉 Success! Project '$PROJECT_NAME' is ready"
echo "📍 $(pwd)"
echo ""

if [ "$TARGET_DIR" != "." ]; then
    echo "Get started:"
    echo "  cd $PROJECT_NAME"
else
    echo "Ready to use! Your AI development environment is set up."
fi