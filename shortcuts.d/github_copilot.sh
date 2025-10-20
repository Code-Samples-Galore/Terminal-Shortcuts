#!/bin/bash
# GitHub Copilot Git Integration Functions
#
# Description: AI-powered Git workflow using GitHub Copilot CLI to automatically
# stage all changes and generate intelligent commit messages through interactive
# AI analysis of your code changes.
#
# Functions:
#   gcm        - Git add all changes and commit with AI-generated message
#
# Requirements:
#   - GitHub Copilot CLI installed: npm install -g @githubnext/github-copilot-cli
#   - Authenticated with GitHub Copilot
#
# Usage Examples:
#   $ gcm                        # Stage all changes and commit with AI-generated message

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "gcm"

# Git commit with Copilot-generated message
if ! should_exclude "gcm" 2>/dev/null; then
  gcm() {
    if ! command -v copilot >/dev/null 2>&1; then
      echo "copilot CLI not found in PATH. Install and authenticate Copilot CLI first."
      return 1
    fi

    # First, stage all changes
    echo "Staging all changes..."
    git add -A

    # Check if there are any staged changes
    if git diff --cached --quiet; then
      echo "No changes to commit."
      return 1
    fi

    # Use Copilot to generate commit message and commit
    copilot --model gpt-5 --allow-tool 'shell(git commit)' --prompt "Commit staged changes"
  }
fi
