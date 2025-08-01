#!/bin/bash
# File and Directory Operations Functions
#
# Description: Enhanced file and directory manipulation utilities including
# universal archive extraction, directory creation with navigation, file search,
# find-and-replace operations, and automated file backup with timestamps.
#
# Functions:
#   extract    - Extract any type of archive file
#   mkcd       - Create directory and navigate into it
#   ff         - Find files by name pattern
#   replace    - Find and replace text in files
#   backup     - Create timestamped backup of file
#
# Usage Examples:
#   $ extract archive.tar.gz    # Extract any archive type
#   $ mkcd new_project          # Create and enter directory
#   $ ff "*.py"                 # Find Python files
#   $ replace "old" "new" "*.txt"  # Replace text in files
#   $ backup important.txt      # Create timestamped backup

# Extract any archive type
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find files by name
ff() {
  find . -type f -name "*$1*" 2>/dev/null
}

# Find and replace in files
replace() {
  if [[ $# -ne 3 ]]; then
    echo "Usage: replace <search> <replace> <file_pattern>"
    return 1
  fi
  grep -rl "$1" . --include="$3" | xargs sed -i "s/$1/$2/g"
}

# Backup file with timestamp
backup() {
  if [[ -f "$1" ]]; then
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
  else
    echo "File not found: $1"
  fi
}