#!/bin/bash
# GitHub Copilot Git Integration Functions
#
# Description: AI-powered Git commit message generation using GitHub Copilot CLI
# to create meaningful conventional commit messages based on staged changes.
#
# Functions:
#   gcm        - Git commit with Copilot-generated message
#
# Requirements:
#   - GitHub Copilot CLI installed: npm install -g @githubnext/github-copilot-cli
#   - Authenticated with GitHub Copilot
#   - Staged changes in git repository
#
# Usage Examples:
#   $ git add .                  # Stage your changes
#   $ gcm                        # Generate commit message and commit
#   $ gcm --no-verify           # Commit with additional git flags

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "gcm"

# Git commit with Copilot-generated message
if ! should_exclude "gcm" 2>/dev/null; then
  gcm() {
    # allow passing extra git commit flags, e.g. gcm --no-verify
    extra_args=("$@")

    if ! command -v copilot >/dev/null 2>&1; then
      echo "copilot CLI not found in PATH. Install and authenticate Copilot CLI first."
      return 1
    fi

    # ensure we have staged changes
    if git diff --cached --quiet; then
      echo "No staged changes to commit. Stage files first (git add ...)."
      return 1
    fi

    # get staged diff (limit to avoid too much text)
    staged_diff=$(git diff --staged --stat)
    staged_files=$(git diff --staged --name-only | tr '\n' ', ' | sed 's/,$//')

    # Generate a simple conventional commit message based on file changes
    # Since copilot chat is interactive, we'll use a simpler heuristic approach
    num_files=$(git diff --staged --name-only | wc -l | tr -d ' ')
    
    # Try to determine the type based on files changed
    if echo "$staged_files" | grep -q "test\|spec"; then
      commit_type="test"
    elif echo "$staged_files" | grep -q "\.md$\|README\|doc"; then
      commit_type="docs"
    elif echo "$staged_files" | grep -q "\.json$\|\.yml$\|\.yaml$\|config"; then
      commit_type="chore"
    elif git diff --staged | grep -q "^+.*function\|^+.*def \|^+.*class "; then
      commit_type="feat"
    elif git diff --staged | grep -q "^-.*function\|^-.*def \|^-.*class "; then
      commit_type="refactor"
    else
      commit_type="chore"
    fi
    
    # Create a meaningful message
    if [ "$num_files" -eq 1 ]; then
      generated="$commit_type: update $staged_files"
    else
      generated="$commit_type: update $num_files files"
    fi

    # Show message and confirm before committing
    echo "Generated commit message:"
    echo "  $generated"
    echo ""
    echo "Files changed:"
    echo "$staged_diff" | sed 's/^/  /'
    echo ""
    # Ask for confirmation using printf instead of read -p for better compatibility
    printf "Use this message and commit now? [y/N] "
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      git commit -m "$generated" "${extra_args[@]}"
    else
      echo "Aborted. You can run 'git commit -m \"$generated\"' manually or edit the message."
      return 1
    fi
  }
fi
