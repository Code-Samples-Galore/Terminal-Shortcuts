#!/bin/bash
# Git Enhancement Functions
#
# Description: Advanced Git utilities that extend basic Git functionality
# with automated commit messages, repository information display, and
# workflow improvements for faster development cycles.
#
# Functions:
#   gac        - Git add all and commit with auto-generated message
#   gitinfo    - Display comprehensive Git repository information
#
# Usage Examples:
#   $ gac                 # Add all files and commit with auto message
#   $ gitinfo             # Show current repo status and info

# Git commit with auto-generated message based on changes
gac() {
  git add .
  local files_changed=$(git diff --cached --name-only | wc -l)
  local message="Auto commit: $files_changed files changed"
  git commit -m "$message"
}

# Show git branch info in a nice format
gitinfo() {
  echo "=== GIT REPOSITORY INFO ==="
  echo "Current branch: $(git branch --show-current 2>/dev/null || echo 'Not a git repo')"
  echo "Repository: $(basename $(git rev-parse --show-toplevel 2>/dev/null) || echo 'Not a git repo')"
  echo "Last commit: $(git log -1 --format='%h - %s (%cr)' 2>/dev/null || echo 'No commits')"
  echo "Status:"
  git status -s 2>/dev/null || echo "Not a git repository"
}
