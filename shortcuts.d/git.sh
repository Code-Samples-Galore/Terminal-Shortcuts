#!/bin/bash
# Git Enhancement Functions
#
# Description: Enhanced Git utilities that extend basic Git functionality
# with automated commit messages, repository information display, and
# streamlined workflow shortcuts for faster development cycles.
#
# Functions:
#   gac        - Git add all and commit with auto-generated message
#   gitinfo    - Display comprehensive Git repository information
#
# Aliases:
#   gs         - Git status
#   gc         - Git commit with message
#   gp         - Git push
#   gu         - Git pull
#   ga         - Git add
#   gaa        - Git add all files
#   gb         - Git branch
#   gco        - Git checkout
#   gcb        - Git checkout new branch
#   gl         - Git log one line
#   gd         - Git diff
#   gdc        - Git diff cached
#   gr         - Git remove from cache
#
# Usage Examples:
#   $ gs                         # Show git status
#   $ gc "commit message"        # Commit with message
#   $ gaa                        # Add all files
#   $ gac                        # Add all files and commit with auto message
#   $ gitinfo                    # Show current repo status and info
#   $ gcb feature-branch         # Create and checkout new branch
#   $ gr file.txt                # Remove file from git cache

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "gs"
cleanup_shortcut "gc"
cleanup_shortcut "gp"
cleanup_shortcut "gu"
cleanup_shortcut "ga"
cleanup_shortcut "gaa"
cleanup_shortcut "gb"
cleanup_shortcut "gco"
cleanup_shortcut "gcb"
cleanup_shortcut "gl"
cleanup_shortcut "gd"
cleanup_shortcut "gdc"
cleanup_shortcut "gr"
cleanup_shortcut "gac"
cleanup_shortcut "gitinfo"

# Git Operations
if ! should_exclude "gs" 2>/dev/null; then alias gs='git status'; fi
if ! should_exclude "gc" 2>/dev/null; then alias gc='git commit -m'; fi
if ! should_exclude "gp" 2>/dev/null; then alias gp='git push'; fi
if ! should_exclude "gu" 2>/dev/null; then alias gu='git pull'; fi
if ! should_exclude "ga" 2>/dev/null; then alias ga='git add'; fi
if ! should_exclude "gaa" 2>/dev/null; then alias gaa='git add .'; fi
if ! should_exclude "gb" 2>/dev/null; then alias gb='git branch'; fi
if ! should_exclude "gco" 2>/dev/null; then alias gco='git checkout'; fi
if ! should_exclude "gcb" 2>/dev/null; then alias gcb='git checkout -b'; fi
if ! should_exclude "gl" 2>/dev/null; then alias gl='git log --oneline'; fi
if ! should_exclude "gd" 2>/dev/null; then alias gd='git diff'; fi
if ! should_exclude "gdc" 2>/dev/null; then alias gdc='git diff --cached'; fi
if ! should_exclude "gr" 2>/dev/null; then alias gr='git rm --cached'; fi

# Git commit with auto-generated message based on changes
if ! should_exclude "gac" 2>/dev/null; then
  gac() {
    git add .
    local files_changed=$(git diff --cached --name-only | wc -l)
    local message="Auto commit: $files_changed files changed"
    git commit -m "$message"
  }
fi

# Show git branch info in a nice format
if ! should_exclude "gitinfo" 2>/dev/null; then
  gitinfo() {
    # Check if we're in a git repository first
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
      echo "Not a git repository"
      return 1
    fi
    
    echo "=== GIT REPOSITORY INFO ==="
    echo "Current branch: $(git branch --show-current)"
    echo "Repository: $(basename $(git rev-parse --show-toplevel))"
    echo "Last commit: $(git log -1 --format='%h - %s (%cr)' 2>/dev/null || echo 'No commits yet')"
    echo "Status:"
    local status_output=$(git status -s)
    if [ -z "$status_output" ]; then
      echo "  Working tree clean - no changes to commit"
    else
      echo "$status_output"
    fi
  }
fi
