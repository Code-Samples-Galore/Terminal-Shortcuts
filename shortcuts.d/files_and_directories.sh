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

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "ll"
cleanup_shortcut "la"
cleanup_shortcut "l"
cleanup_shortcut ".."
cleanup_shortcut "..."
cleanup_shortcut "...."
cleanup_shortcut "~"
cleanup_shortcut "mkdir"
cleanup_shortcut "cp"
cleanup_shortcut "mv"
cleanup_shortcut "rm"
cleanup_shortcut "grep"
cleanup_shortcut "tree"
cleanup_shortcut "chown"
cleanup_shortcut "chmod"
cleanup_shortcut "chgrp"
cleanup_shortcut "extract"
cleanup_shortcut "compress"
cleanup_shortcut "mkcd"
cleanup_shortcut "ff"
cleanup_shortcut "replace"
cleanup_shortcut "backup"
cleanup_shortcut "watchlog"

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
        *.7z)        
          local sevenzip_cmd=""
          if command -v 7z >/dev/null 2>&1; then
            sevenzip_cmd="7z"
          elif command -v 7zz >/dev/null 2>&1; then
            sevenzip_cmd="7zz"
          elif command -v 7za >/dev/null 2>&1; then
            sevenzip_cmd="7za"
          else
            echo "Error: No 7-Zip command found. Please install 7-Zip (7z, 7zz, or 7za)."
            return 1
          fi
          "$sevenzip_cmd" x "$1"
          ;;
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
      echo "Usage: compress [--split <size>] <archive_name> <files_or_directories...>"
      echo "Supported formats:"
      echo "  .tar.gz, .tgz    - Gzip compressed tar archive"
      echo "  .tar.bz2, .tbz2  - Bzip2 compressed tar archive"
      echo "  .tar             - Uncompressed tar archive"
      echo "  .zip             - ZIP archive"
      echo "  .7z              - 7-Zip archive"
      echo "  .gz              - Gzip single file (first file only)"
      echo "  .bz2             - Bzip2 single file (first file only)"
      echo ""
      echo "Volume splitting (--split <size>):"
      echo "  Supported units: b, k, m, g (bytes, KB, MB, GB)"
      echo "  Examples: 100m, 1g, 500k, 1024b"
      echo "  Supported formats: .tar.gz, .tgz, .tar.bz2, .tbz2, .tar, .zip, .7z"
      echo ""
      echo "Examples:"
      echo "  compress backup.tar.gz file1.txt file2.txt dir1/"
      echo "  compress project.zip src/ docs/ README.md"
      echo "  compress data.7z *.csv *.json"
      echo "  compress --split 100m large.tar.gz bigdir/"
      echo "  compress -s 1g archive.zip files/"
      return 1
    fi
    
    local split_size=""
    local archive_name=""
    local files=()
    
    # Parse arguments for split option
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --split|-s)
          if [[ -n "$2" ]]; then
            split_size="$2"
            shift 2
          else
            echo "Error: --split requires a size argument"
            return 1
          fi
          ;;
        *)
          if [[ -z "$archive_name" ]]; then
            archive_name="$1"
          else
            files+=("$1")
          fi
          shift
          ;;
      esac
    done
    
    if [[ -z "$archive_name" || ${#files[@]} -eq 0 ]]; then
      echo "Error: Archive name and files are required"
      return 1
    fi
    
    # Check if files/directories exist
    for item in "${files[@]}"; do
      if [[ ! -e "$item" ]]; then
        echo "Error: '$item' does not exist"
        return 1
      fi
    done
    
    # Validate split size format if provided
    if [[ -n "$split_size" ]]; then
      if ! [[ "$split_size" =~ ^[0-9]+[bkmg]?$ ]]; then
        echo "Error: Invalid split size format. Use format like: 100m, 1g, 500k"
        return 1
      fi
    fi
    
    case "$archive_name" in
      *.tar.gz|*.tgz)
        if [[ -n "$split_size" ]]; then
          # Create tar.gz with volume splitting using split command
          tar czf - "${files[@]}" | split -b "$split_size" - "${archive_name%.*}."
          echo "Created gzip compressed tar archive with volumes: ${archive_name%.*}.* (${split_size} each)"
        else
          tar czf "$archive_name" "${files[@]}"
          echo "Created gzip compressed tar archive: $archive_name"
        fi
        ;;
      *.tar.bz2|*.tbz2)
        if [[ -n "$split_size" ]]; then
          # Create tar.bz2 with volume splitting using split command
          tar cjf - "${files[@]}" | split -b "$split_size" - "${archive_name%.*}."
          echo "Created bzip2 compressed tar archive with volumes: ${archive_name%.*}.* (${split_size} each)"
        else
          tar cjf "$archive_name" "${files[@]}"
          echo "Created bzip2 compressed tar archive: $archive_name"
        fi
        ;;
      *.tar)
        if [[ -n "$split_size" ]]; then
          # Create tar with volume splitting using split command
          tar cf - "${files[@]}" | split -b "$split_size" - "${archive_name%.*}."
          echo "Created tar archive with volumes: ${archive_name%.*}.* (${split_size} each)"
        else
          tar cf "$archive_name" "${files[@]}"
          echo "Created tar archive: $archive_name"
        fi
        ;;
      *.zip)
        if command -v zip >/dev/null 2>&1; then
          if [[ -n "$split_size" ]]; then
            # Convert size format for zip (needs different format)
            local zip_size
            case "${split_size: -1}" in
              b) zip_size="${split_size%b}" ;;
              k) zip_size="${split_size%k}k" ;;
              m) zip_size="${split_size%m}m" ;;
              g) zip_size="${split_size%g}g" ;;
              *) zip_size="${split_size}b" ;;
            esac
            zip -r -s "$zip_size" "$archive_name" "${files[@]}"
            echo "Created ZIP archive with volumes: $archive_name and split files (${split_size} each)"
          else
            zip -r "$archive_name" "${files[@]}"
            echo "Created ZIP archive: $archive_name"
          fi
        else
          echo "Error: 'zip' command not found. Please install zip utility."
          return 1
        fi
        ;;
      *.7z)
        local sevenzip_cmd=""
        if command -v 7z >/dev/null 2>&1; then
          sevenzip_cmd="7z"
        elif command -v 7zz >/dev/null 2>&1; then
          sevenzip_cmd="7zz"
        elif command -v 7za >/dev/null 2>&1; then
          sevenzip_cmd="7za"
        else
          echo "Error: No 7-Zip command found. Please install 7-Zip (7z, 7zz, or 7za)."
          return 1
        fi
        
        if [[ -n "$split_size" ]]; then
          # Convert size format for 7z
          local szip_size
          case "${split_size: -1}" in
            b) szip_size="${split_size%b}b" ;;
            k) szip_size="${split_size%k}k" ;;
            m) szip_size="${split_size%m}m" ;;
            g) szip_size="${split_size%g}g" ;;
            *) szip_size="${split_size}b" ;;
          esac
          "$sevenzip_cmd" a -v"$szip_size" "$archive_name" "${files[@]}"
          echo "Created 7-Zip archive with volumes: ${archive_name%.7z}.7z.* (${split_size} each)"
        else
          "$sevenzip_cmd" a "$archive_name" "${files[@]}"
          echo "Created 7-Zip archive: $archive_name"
        fi
        ;;
      *.gz)
        if [[ -n "$split_size" ]]; then
          echo "Warning: Volume splitting not supported for .gz format"
        fi
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
        if [[ -n "$split_size" ]]; then
          echo "Warning: Volume splitting not supported for .bz2 format"
        fi
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
