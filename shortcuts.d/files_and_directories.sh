#!/bin/bash
# File and Directory Operations Functions
#
# Description: Enhanced file and directory manipulation utilities including
# universal archive extraction, directory creation with navigation, file search,
# find-and-replace operations, and automated file backup with timestamps.
#
# Functions:
#   extract    - Extract any type of archive file
#   compress   - Create any type of archive file
#   mkcd       - Create directory and navigate into it
#   ff         - Find files by name pattern
#   replace    - Find and replace text in files, strings, or stdin
#   backup     - Create timestamped backup of file
#
# Usage Examples:
#   $ extract archive.tar.gz    # Extract any archive type
#   $ compress myfiles.tar.gz file1 file2 dir1  # Create tar.gz archive
#   $ compress backup.zip *.txt                 # Create zip archive
#   $ mkcd new_project          # Create and enter directory
#   $ ff "*.py"                 # Find Python files
#   $ replace "old" "new" "*.txt"  # Replace text in files
#   $ replace - "old" "new"     # Replace text from stdin
#   $ echo "hello world" | replace - "world" "universe"  # Replace from stdin
#   $ backup important.txt      # Create timestamped backup

# File and Directory Operations
if ! should_exclude "ll" 2>/dev/null; then alias ll='ls -lh'; fi
if ! should_exclude "la" 2>/dev/null; then alias la='ls -la'; fi
if ! should_exclude "l" 2>/dev/null; then alias l='ls -CF'; fi
if ! should_exclude ".." 2>/dev/null; then alias ..='cd ..'; fi
if ! should_exclude "..." 2>/dev/null; then alias ...='cd ../..'; fi
if ! should_exclude "...." 2>/dev/null; then alias ....='cd ../../..'; fi
if ! should_exclude "~" 2>/dev/null; then alias ~='cd ~'; fi
if ! should_exclude "mkdir" 2>/dev/null; then alias mkdir='mkdir -pv'; fi
if ! should_exclude "cp" 2>/dev/null; then alias cp='cp -iv'; fi
if ! should_exclude "mv" 2>/dev/null; then alias mv='mv -iv'; fi
if ! should_exclude "rm" 2>/dev/null; then alias rm='rm -iv'; fi
if ! should_exclude "grep" 2>/dev/null; then alias grep='grep --color=auto'; fi
if ! should_exclude "tree" 2>/dev/null; then alias tree='tree -C'; fi
if ! should_exclude "chown" 2>/dev/null; then alias chown='chown --preserve-root'; fi
if ! should_exclude "chmod" 2>/dev/null; then alias chmod='chmod --preserve-root'; fi
if ! should_exclude "chgrp" 2>/dev/null; then alias chgrp='chgrp --preserve-root'; fi

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

# Compress files/directories into any archive type
if ! should_exclude "compress" 2>/dev/null; then
  compress() {
    if [[ $# -lt 2 ]]; then
      echo "Usage: compress <archive_name> <files_or_directories...>"
      echo "Supported formats:"
      echo "  .tar.gz, .tgz    - Gzip compressed tar archive"
      echo "  .tar.bz2, .tbz2  - Bzip2 compressed tar archive"
      echo "  .tar             - Uncompressed tar archive"
      echo "  .zip             - ZIP archive"
      echo "  .7z              - 7-Zip archive"
      echo "  .gz              - Gzip single file (first file only)"
      echo "  .bz2             - Bzip2 single file (first file only)"
      echo ""
      echo "Examples:"
      echo "  compress backup.tar.gz file1.txt file2.txt dir1/"
      echo "  compress project.zip src/ docs/ README.md"
      echo "  compress data.7z *.csv *.json"
      return 1
    fi
    
    local archive_name="$1"
    shift
    local files=("$@")
    
    # Check if files/directories exist
    for item in "${files[@]}"; do
      if [[ ! -e "$item" ]]; then
        echo "Error: '$item' does not exist"
        return 1
      fi
    done
    
    case "$archive_name" in
      *.tar.gz|*.tgz)
        tar czf "$archive_name" "${files[@]}"
        echo "Created gzip compressed tar archive: $archive_name"
        ;;
      *.tar.bz2|*.tbz2)
        tar cjf "$archive_name" "${files[@]}"
        echo "Created bzip2 compressed tar archive: $archive_name"
        ;;
      *.tar)
        tar cf "$archive_name" "${files[@]}"
        echo "Created tar archive: $archive_name"
        ;;
      *.zip)
        if command -v zip >/dev/null 2>&1; then
          zip -r "$archive_name" "${files[@]}"
          echo "Created ZIP archive: $archive_name"
        else
          echo "Error: 'zip' command not found. Please install zip utility."
          return 1
        fi
        ;;
      *.7z)
        if command -v 7z >/dev/null 2>&1; then
          7z a "$archive_name" "${files[@]}"
          echo "Created 7-Zip archive: $archive_name"
        else
          echo "Error: '7z' command not found. Please install p7zip utility."
          return 1
        fi
        ;;
      *.gz)
        if [[ ${#files[@]} -gt 1 ]]; then
          echo "Warning: gzip can only compress single files. Using first file: ${files[0]}"
        fi
        if [[ -f "${files[0]}" ]]; then
          gzip -c "${files[0]}" > "$archive_name"
          echo "Created gzip compressed file: $archive_name"
        else
          echo "Error: '${files[0]}' is not a regular file"
          return 1
        fi
        ;;
      *.bz2)
        if [[ ${#files[@]} -gt 1 ]]; then
          echo "Warning: bzip2 can only compress single files. Using first file: ${files[0]}"
        fi
        if [[ -f "${files[0]}" ]]; then
          bzip2 -c "${files[0]}" > "$archive_name"
          echo "Created bzip2 compressed file: $archive_name"
        else
          echo "Error: '${files[0]}' is not a regular file"
          return 1
        fi
        ;;
      *)
        echo "Error: Unsupported archive format for '$archive_name'"
        echo "Supported formats: .tar.gz, .tgz, .tar.bz2, .tbz2, .tar, .zip, .7z, .gz, .bz2"
        return 1
        ;;
    esac
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
      echo "Usage: replace <string_or_file|-> <search_pattern> <replacement>"
      echo "Examples:"
      echo "  replace \"hello world\" \"world\" \"universe\"    # Replace in string"
      echo "  replace myfile.txt \"old_text\" \"new_text\"     # Replace in file"
      echo "  replace myfile.txt \"pattern\" \"replacement\" --backup  # Create backup first"
      echo "  echo \"text\" | replace - \"old\" \"new\"        # Replace from stdin"
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
    
    # Check if input is stdin
    if [[ "$input" == "-" ]]; then
      # Replace in stdin and output result
      sed "s/${search//\//\\/}/${replacement//\//\\/}/g"
    # Check if input is a file
    elif [[ -f "$input" ]]; then
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

# Monitor log file
if ! should_exclude "watchlog" 2>/dev/null; then
  watchlog() {
    if [[ -f "$1" ]]; then
      tail -f "$1"
    else
      echo "File not found: $1"
    fi
  }
fi
