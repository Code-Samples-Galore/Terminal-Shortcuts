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
if ! should_exclude "extract" 2>/dev/null; then
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
fi

# Create directory and cd into it
if ! should_exclude "mkcd" 2>/dev/null; then
  mkcd() {
    mkdir -p "$1" && cd "$1"
  }
fi

# Find files by name
if ! should_exclude "ff" 2>/dev/null; then
  ff() {
    find . -type f -name "*$1*" 2>/dev/null
  }
fi

# Replace text in strings or files
if ! should_exclude "replace" 2>/dev/null; then
  replace() {
    if [[ $# -lt 3 ]]; then
      echo "Usage: replace <string_or_file> <search_pattern> <replacement>"
      echo "Examples:"
      echo "  replace \"hello world\" \"world\" \"universe\"    # Replace in string"
      echo "  replace myfile.txt \"old_text\" \"new_text\"     # Replace in file"
      echo "  replace myfile.txt \"pattern\" \"replacement\" --backup  # Create backup first"
      return 1
    fi
    
    local input="$1"
    local search="$2"
    local replacement="$3"
    local create_backup=false
    
    # Check for backup flag
    if [[ "$4" == "--backup" ]]; then
      create_backup=true
    fi
    
    # Check if input is a file
    if [[ -f "$input" ]]; then
      # Create backup if requested
      if [[ "$create_backup" == true ]]; then
        local backup_name="${input}.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$input" "$backup_name"
        echo "Backup created: $backup_name"
      fi
      
      # Replace in file using sed (cross-platform compatible)
      if command -v gsed >/dev/null 2>&1; then
        # Use GNU sed if available (macOS with homebrew)
        gsed -i "s/${search//\//\\/}/${replacement//\//\\/}/g" "$input"
      else
        # Use system sed
        sed -i.tmp "s/${search//\//\\/}/${replacement//\//\\/}/g" "$input" && rm "${input}.tmp"
      fi
      
      echo "Replaced '${search}' with '${replacement}' in file: $input"
    else
      # Treat as string and output result
      echo "$input" | sed "s/${search//\//\\/}/${replacement//\//\\/}/g"
    fi
  }
fi

# Backup file with timestamp
if ! should_exclude "backup" 2>/dev/null; then
  backup() {
    if [[ -f "$1" ]]; then
      cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
      echo "Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
    else
      echo "File not found: $1"
    fi
  }
fi