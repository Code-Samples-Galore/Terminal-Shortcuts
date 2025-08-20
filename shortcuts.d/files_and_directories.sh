#!/bin/bash
# File and Directory Operations Functions
#
# Description: Enhanced file and directory manipulation utilities including
# universal archive extraction, directory creation with navigation, file search,
# text search in files, directory monitoring, file/folder backup with timestamps and optional compression,
# and advanced file viewing with less.
#
# Functions:
#   extract    - Extract any type of archive file
#   compress   - Create any type of archive file
#   mkcd       - Create directory and navigate into it
#   ff         - Find files by name pattern
#   search     - Search for text in files with optional recursive directory search
#   backup     - Create timestamped backup of files or folders with optional compression
#   watchfile  - Monitor file changes in real-time
#   watchdir   - Monitor directory contents in real-time
#
# Usage Examples:
#   $ extract archive.tar.gz    # Extract any archive type
#   $ compress myfiles.tar.gz file1 file2 dir1  # Create tar.gz archive
#   $ compress backup.zip *.txt                 # Create zip archive
#   $ mkcd new_project          # Create and enter directory
#   $ ff "*.py"                 # Find Python files
#   $ search "TODO" file.txt    # Search for text in specific file
#   $ search -r "function" .    # Search recursively in current directory
#   $ backup important.txt      # Create simple copy backup
#   $ backup project/ --compress tar.gz  # Create compressed folder backup
#   $ backup config.ini --compress zip   # Create compressed file backup
#   $ watchfile /var/log/system.log  # Monitor log file
#   $ watchdir /home/user/downloads  # Monitor directory changes

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
cleanup_shortcut "backup"
cleanup_shortcut "watchfile"
cleanup_shortcut "watchlog"
cleanup_shortcut "search"
cleanup_shortcut "watchdir"
cleanup_shortcut "less"
cleanup_shortcut "le"
cleanup_shortcut "tle"
cleanup_shortcut "meta"

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
if ! should_exclude "rm" 2>/dev/null; then alias rm='rm -i'; fi
if ! should_exclude "grep" 2>/dev/null; then alias grep='grep --color=auto'; fi
if ! should_exclude "tree" 2>/dev/null; then alias tree='tree -C'; fi
if ! should_exclude "less" 2>/dev/null; then alias less='less -RMNi --mouse --use-color'; fi
if ! should_exclude "le" 2>/dev/null; then alias le='less'; fi
if ! should_exclude "tle" 2>/dev/null; then alias tle='less +G'; fi

# Extract any archive type
if ! should_exclude "extract" 2>/dev/null; then
  extract() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: extract <archive_file>"
      echo ""
      echo "Extract any type of archive file automatically based on file extension."
      echo "Supports all common archive formats and compression types."
      echo ""
      echo "Supported formats:"
      echo "  .tar.gz, .tgz     Gzip compressed tar archives"
      echo "  .tar.bz2, .tbz2   Bzip2 compressed tar archives"
      echo "  .tar              Uncompressed tar archives"
      echo "  .zip              ZIP archives"
      echo "  .7z               7-Zip archives"
      echo "  .rar              RAR archives (requires unrar)"
      echo "  .gz               Gzip compressed files"
      echo "  .bz2              Bzip2 compressed files"
      echo "  .Z                Compress format files"
      echo ""
      echo "Examples:"
      echo "  extract archive.tar.gz         # Extract gzip tar archive"
      echo "  extract project.zip            # Extract ZIP file"
      echo "  extract backup.7z              # Extract 7-Zip archive"
      echo "  extract data.tar.bz2           # Extract bzip2 tar archive"
      echo "  extract document.rar           # Extract RAR archive"
      echo "  extract file.gz                # Decompress gzip file"
      echo ""
      echo "Notes:"
      echo "  • Files are extracted to the current directory"
      echo "  • Original archive file is preserved"
      echo "  • SHA256 checksum is calculated for integrity verification"
      echo "  • For 7z files: requires 7z, 7zz, or 7za command"
      echo "  • For RAR files: requires unrar command"
      return 1
    fi
    
    if [[ ! -f "$1" ]]; then
      echo "Error: '$1' is not a valid file or does not exist"
      return 1
    fi
    
    echo "=== EXTRACTION INFORMATION ==="
    echo "Archive file: $1"
    
    # Calculate and display checksum of input archive
    if command -v hashit >/dev/null 2>&1; then
      echo -n "SHA256 checksum: "
      hashit sha256 "$1"
    else
      echo "SHA256 checksum: hashit function not available"
    fi
    
    echo ""
    echo "Extracting: $1"
    
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       
        if command -v unrar >/dev/null 2>&1; then
          unrar x "$1"
        else
          echo "Error: 'unrar' command not found. Please install unrar to extract RAR files."
          return 1
        fi
        ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       
        if command -v unzip >/dev/null 2>&1; then
          unzip "$1"
        else
          echo "Error: 'unzip' command not found. Please install unzip to extract ZIP files."
          return 1
        fi
        ;;
      *.Z)         
        if command -v uncompress >/dev/null 2>&1; then
          uncompress "$1"
        else
          echo "Error: 'uncompress' command not found. Please install compress utilities."
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
        "$sevenzip_cmd" x "$1"
        ;;
      *)           
        echo "Error: '$1' cannot be extracted - unsupported format"
        echo "Supported formats: .tar.gz, .tgz, .tar.bz2, .tbz2, .tar, .zip, .7z, .rar, .gz, .bz2, .Z"
        return 1
        ;;
    esac
    
    if [[ $? -eq 0 ]]; then
      echo "Successfully extracted: $1"
    else
      echo "Error: Failed to extract '$1'"
      return 1
    fi
  }
fi

# Compress files/directories into any archive type
if ! should_exclude "compress" 2>/dev/null; then
  compress() {
    if [[ $# -lt 2 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: compress [--split <size>] <archive_name> <files_or_directories...>"
      echo ""
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
          # Calculate checksum for first volume
          if command -v hashit >/dev/null 2>&1 && [[ -f "${archive_name%.*}.aa" ]]; then
            echo -n "SHA256 checksum (first volume): "
            hashit sha256 "${archive_name%.*}.aa"
          fi
        else
          tar czf "$archive_name" "${files[@]}"
          echo "Created gzip compressed tar archive: $archive_name"
          # Calculate and display checksum
          if command -v hashit >/dev/null 2>&1; then
            echo -n "SHA256 checksum: "
            hashit sha256 "$archive_name"
          fi
        fi
        ;;
      *.tar.bz2|*.tbz2)
        if [[ -n "$split_size" ]]; then
          # Create tar.bz2 with volume splitting using split command
          tar cjf - "${files[@]}" | split -b "$split_size" - "${archive_name%.*}."
          echo "Created bzip2 compressed tar archive with volumes: ${archive_name%.*}.* (${split_size} each)"
          # Calculate checksum for first volume
          if command -v hashit >/dev/null 2>&1 && [[ -f "${archive_name%.*}.aa" ]]; then
            echo -n "SHA256 checksum (first volume): "
            hashit sha256 "${archive_name%.*}.aa"
          fi
        else
          tar cjf "$archive_name" "${files[@]}"
          echo "Created bzip2 compressed tar archive: $archive_name"
          # Calculate and display checksum
          if command -v hashit >/dev/null 2>&1; then
            echo -n "SHA256 checksum: "
            hashit sha256 "$archive_name"
          fi
        fi
        ;;
      *.tar)
        if [[ -n "$split_size" ]]; then
          # Create tar with volume splitting using split command
          tar cf - "${files[@]}" | split -b "$split_size" - "${archive_name%.*}."
          echo "Created tar archive with volumes: ${archive_name%.*}.* (${split_size} each)"
          # Calculate checksum for first volume
          if command -v hashit >/dev/null 2>&1 && [[ -f "${archive_name%.*}.aa" ]]; then
            echo -n "SHA256 checksum (first volume): "
            hashit sha256 "${archive_name%.*}.aa"
          fi
        else
          tar cf "$archive_name" "${files[@]}"
          echo "Created tar archive: $archive_name"
          # Calculate and display checksum
          if command -v hashit >/dev/null 2>&1; then
            echo -n "SHA256 checksum: "
            hashit sha256 "$archive_name"
          fi
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
            # Calculate checksum for main zip file
            if command -v hashit >/dev/null 2>&1 && [[ -f "$archive_name" ]]; then
              echo -n "SHA256 checksum (main file): "
              hashit sha256 "$archive_name"
            fi
          else
            zip -r "$archive_name" "${files[@]}"
            echo "Created ZIP archive: $archive_name"
            # Calculate and display checksum
            if command -v hashit >/dev/null 2>&1; then
              echo -n "SHA256 checksum: "
              hashit sha256 "$archive_name"
            fi
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
          # Calculate checksum for first volume
          if command -v hashit >/dev/null 2>&1 && [[ -f "${archive_name%.7z}.7z.001" ]]; then
            echo -n "SHA256 checksum (first volume): "
            hashit sha256 "${archive_name%.7z}.7z.001"
          fi
        else
          "$sevenzip_cmd" a "$archive_name" "${files[@]}"
          echo "Created 7-Zip archive: $archive_name"
          # Calculate and display checksum
          if command -v hashit >/dev/null 2>&1; then
            echo -n "SHA256 checksum: "
            hashit sha256 "$archive_name"
          fi
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
          # Calculate and display checksum
          if command -v hashit >/dev/null 2>&1; then
            echo -n "SHA256 checksum: "
            hashit sha256 "$archive_name"
          fi
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
          # Calculate and display checksum
          if command -v hashit >/dev/null 2>&1; then
            echo -n "SHA256 checksum: "
            hashit sha256 "$archive_name"
          fi
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
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: mkcd <directory_name>"
      echo ""
      echo "Create a directory and navigate into it in one command."
      echo ""
      echo "Examples:"
      echo "  mkcd new_project           # Create and enter 'new_project' directory"
      echo "  mkcd path/to/deep/dir      # Create nested directories and enter"
      echo "  mkcd \"My Project\"          # Create directory with spaces in name"
      return 1
    fi
    mkdir -p "$1" && cd "$1"
  }
fi

# Find files by name
if ! should_exclude "ff" 2>/dev/null; then
  ff() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: ff <pattern>"
      echo ""
      echo "Find files by name pattern in current directory and subdirectories."
      echo ""
      echo "Examples:"
      echo "  ff \"*.py\"                  # Find all Python files"
      echo "  ff \"test\"                  # Find files containing 'test' in name"
      echo "  ff \"*.log\"                 # Find all log files"
      echo "  ff \"config\"                # Find files with 'config' in name"
      echo "  ff \"*.txt\"                 # Find all text files"
      return 1
    fi
    find . -type f -name "*$1*" 2>/dev/null
  }
fi

# Search for text in files with optional recursive directory search
if ! should_exclude "search" 2>/dev/null; then
  search() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: search [-r|--recursive] [-i|--ignore-case] [-E|--extended-regexp] [-z|--gzip] <pattern> [file_or_directory]"
      echo ""
      echo "Options:"
      echo "  -r, --recursive       Search recursively in directories"
      echo "  -i, --ignore-case     Case insensitive search"
      echo "  -E, --extended-regexp Use extended regular expressions (ERE)"
      echo "  -z, --gzip           Include gzip compressed files (.gz) in search"
      echo ""
      echo "Supported file types:"
      echo "  • Regular text files (always searched)"
      echo "  • Gzip compressed files (.gz) - only with -z/--gzip option"
      echo ""
      echo "Regex Support:"
      echo "  By default, supports basic regular expressions (BRE):"
      echo "    [a-z]         - Character class"
      echo "    [0-9]\\{4\\}    - Exactly 4 digits (escaped braces)"
      echo "    ^pattern      - Start of line"
      echo "    pattern\$      - End of line"
      echo "    .             - Any character"
      echo "    *             - Zero or more of preceding"
      echo ""
      echo "  With -E flag, supports extended regular expressions (ERE):"
      echo "    [a-z]+        - One or more lowercase letters"
      echo "    [0-9]{4}      - Exactly 4 digits (unescaped braces)"
      echo "    (pattern1|pattern2) - Alternation"
      echo "    pattern?      - Zero or one occurrence"
      echo ""
      echo "Examples:"
      echo "  search \"TODO\" file.txt                     # Literal text search"
      echo "  search \"[a-z][0-9]\" *.txt                 # Basic regex: letter followed by digit"
      echo "  search \"^function\" *.py                   # Lines starting with 'function'"
      echo "  search \"error\$\" logs/                     # Lines ending with 'error'"
      echo "  search \"pattern\" .                        # Search in current directory"
      echo "  search -r \"pattern\" .                     # Search recursively in current directory"
      echo "  search -z \"error\" logfile.gz              # Search in gzip compressed file"
      echo "  search -rz \"exception\" logs/              # Recursive search including .gz files"
      echo "  search -E \"[a-z]+@[a-z]+\\.[a-z]{2,4}\" .  # Extended regex: email pattern"
      echo "  search -ri \"[Ee]ror\" /var/log            # Case insensitive, recursive"
      echo "  search -E \"^(GET|POST)\" access.log        # Extended regex with alternation"
      return 1
    fi
    
    local recursive=false
    local ignore_case=false
    local extended_regex=false
    local include_gzip=false
    local pattern=""
    local target=""
    
    # Parse options
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -r|--recursive)
          recursive=true
          shift
          ;;
        -i|--ignore-case)
          ignore_case=true
          shift
          ;;
        -E|--extended-regexp)
          extended_regex=true
          shift
          ;;
        -z|--gzip)
          include_gzip=true
          shift
          ;;
        -ri|-ir)
          recursive=true
          ignore_case=true
          shift
          ;;
        -rE|-Er)
          recursive=true
          extended_regex=true
          shift
          ;;
        -rz|-zr)
          recursive=true
          include_gzip=true
          shift
          ;;
        -iE|-Ei)
          ignore_case=true
          extended_regex=true
          shift
          ;;
        -iz|-zi)
          ignore_case=true
          include_gzip=true
          shift
          ;;
        -Ez|-zE)
          extended_regex=true
          include_gzip=true
          shift
          ;;
        -riE|-rEi|-irE|-iEr|-Eri|-Eir)
          recursive=true
          ignore_case=true
          extended_regex=true
          shift
          ;;
        -riz|-rzi|-irz|-izr|-zri|-zir)
          recursive=true
          ignore_case=true
          include_gzip=true
          shift
          ;;
        -rEz|-rZe|-Erz|-Ezr|-zrE|-zEr)
          recursive=true
          extended_regex=true
          include_gzip=true
          shift
          ;;
        -iEz|-iZe|-Eiz|-Ezi|-ziE|-zEi)
          ignore_case=true
          extended_regex=true
          include_gzip=true
          shift
          ;;
        -riEz|-riZe|-rEiz|-rEzi|-irEz|-irZe|-iErz|-iEzr|-Eriz|-Erzi|-Eirz|-Eizr|-zriE|-zrEi|-zirE|-ziEr|-zEri|-zEir)
          recursive=true
          ignore_case=true
          extended_regex=true
          include_gzip=true
          shift
          ;;
        *)
          if [[ -z "$pattern" ]]; then
            pattern="$1"
          elif [[ -z "$target" ]]; then
            target="$1"
          else
            echo "Error: Too many arguments"
            return 1
          fi
          shift
          ;;
      esac
    done
    
    if [[ -z "$pattern" ]]; then
      echo "Error: Search pattern is required"
      return 1
    fi
    
    # Default to current directory if no target specified
    if [[ -z "$target" ]]; then
      target="."
    fi
    
    # Check if target exists
    if [[ ! -e "$target" ]]; then
      echo "Error: '$target' does not exist"
      return 1
    fi
    
    # Build grep options
    local grep_options="-n"
    local color_option=""
    
    # Check if grep supports --color and we have a TTY
    if [[ -t 1 ]] && grep --color=auto --version >/dev/null 2>&1; then
      color_option="--color=always"
    fi
    
    if [[ "$ignore_case" == true ]]; then
      grep_options+="i"
    fi
    if [[ "$extended_regex" == true ]]; then
      grep_options+="E"
    fi
    if [[ "$recursive" == true ]]; then
      grep_options+="r"
    fi
    
    echo "=== SEARCH RESULTS ==="
    echo "Pattern: '$pattern'"
    if [[ "$target" == "." ]]; then
      echo "Target: current directory"
    else
      echo "Target: '$target'"
    fi
    echo "Recursive: $recursive"
    echo "Case insensitive: $ignore_case"
    echo "Include gzip files: $include_gzip"
    if [[ "$extended_regex" == true ]]; then
      echo "Regex mode: Extended (ERE)"
    else
      echo "Regex mode: Basic (BRE) - supports [a-z], ^, \$, ., *, \\{\\}"
    fi
    echo ""
    
    # Helper function to search in a single file (regular or gzipped)
    search_file() {
      local file="$1"
      local pattern="$2"
      local grep_opts="$3"
      local color_opt="$4"
      local allow_gz="$5"
      
      if [[ "$file" == *.gz && "$allow_gz" == true ]]; then
        # Use zgrep for gzip files only if gzip option is enabled
        if command -v zgrep >/dev/null 2>&1; then
          zgrep $grep_opts $color_opt "$pattern" "$file" 2>/dev/null
        else
          # Fallback: decompress and pipe to grep
          zcat "$file" 2>/dev/null | grep $grep_opts $color_opt "$pattern" | sed "s|^|${file}:|"
        fi
      elif [[ "$file" != *.gz ]]; then
        # Use regular grep for normal files
        grep $grep_opts $color_opt "$pattern" "$file" 2>/dev/null
      fi
      # Skip gz files if gzip option is not enabled
    }
    
    local results_found=false
    local result_count=0
    
    if [[ -f "$target" ]]; then
      # Search in a specific file (regular or gzipped)
      local temp_results=$(search_file "$target" "$pattern" "$grep_options" "$color_option" "$include_gzip")
      if [[ -n "$temp_results" ]]; then
        echo "$temp_results"
        result_count=$(echo "$temp_results" | wc -l)
        results_found=true
      fi
    elif [[ -d "$target" ]]; then
      # Search in directory
      if [[ "$recursive" == true ]]; then
        # Recursive search in directory - handle both regular and gz files
        local temp_results=""
        
        # Search regular files
        local regular_results=$(grep $grep_options $color_option "$pattern" "$target" 2>/dev/null)
        if [[ -n "$regular_results" ]]; then
          temp_results+="$regular_results"$'\n'
        fi
        
        # Search gz files recursively only if gzip option is enabled
        if [[ "$include_gzip" == true ]]; then
          if command -v zgrep >/dev/null 2>&1; then
            local gz_results=$(find "$target" -name "*.gz" -type f -exec zgrep $grep_options $color_option "$pattern" {} \; 2>/dev/null)
            if [[ -n "$gz_results" ]]; then
              temp_results+="$gz_results"$'\n'
            fi
          else
            # Fallback for systems without zgrep
            local gz_results=$(find "$target" -name "*.gz" -type f -exec sh -c 'zcat "$1" 2>/dev/null | grep '"$grep_options"' '"$color_option"' "'"$pattern"'" | sed "s|^|$1:|"' _ {} \; 2>/dev/null)
            if [[ -n "$gz_results" ]]; then
              temp_results+="$gz_results"$'\n'
            fi
          fi
        fi
        
        if [[ -n "$temp_results" ]]; then
          echo "$temp_results"
          result_count=$(echo "$temp_results" | wc -l)
          results_found=true
        fi
      else
        # Non-recursive search (only files in the specified directory)
        local temp_results=""
        
        # Search regular files
        local regular_files=$(find "$target" -maxdepth 1 -type f ! -name "*.gz" -exec grep -l $grep_options "$pattern" {} \; 2>/dev/null)
        for file in $regular_files; do
          local file_results=$(grep $grep_options $color_option "$pattern" "$file" 2>/dev/null | sed "s|^|${file}:|")
          if [[ -n "$file_results" ]]; then
            temp_results+="$file_results"$'\n'
          fi
        done
        
        # Search gz files only if gzip option is enabled
        if [[ "$include_gzip" == true ]]; then
          local gz_files=$(find "$target" -maxdepth 1 -name "*.gz" -type f 2>/dev/null)
          for file in $gz_files; do
            local file_results=$(search_file "$file" "$pattern" "$grep_options" "$color_option" "$include_gzip" | sed "s|^|${file}:|")
            if [[ -n "$file_results" ]]; then
              temp_results+="$file_results"$'\n'
            fi
          done
        fi
        
        if [[ -n "$temp_results" ]]; then
          echo "$temp_results"
          result_count=$(echo "$temp_results" | wc -l)
          results_found=true
        fi
      fi
    else
      # Handle wildcards and multiple files
      local temp_results=""
      for file in $target; do
        if [[ -f "$file" ]]; then
          local file_results=$(search_file "$file" "$pattern" "$grep_options" "$color_option" "$include_gzip" | sed "s|^|${file}:|")
          if [[ -n "$file_results" ]]; then
            temp_results+="$file_results"$'\n'
          fi
        fi
      done
      if [[ -n "$temp_results" ]]; then
        echo "$temp_results"
        result_count=$(echo "$temp_results" | wc -l)
        results_found=true
      fi
    fi
    
    if [[ "$results_found" == false ]]; then
      echo "No matches found for pattern '$pattern'"
      return 1
    else
      echo ""
      echo "Found $result_count match(es)"
    fi
  }
fi

# Backup file or folder with timestamp and optional compression
if ! should_exclude "backup" 2>/dev/null; then
  backup() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: backup <file_or_folder> [--compress <format>]"
      echo ""
      echo "Create timestamped backup copies of files or directories with optional compression."
      echo ""
      echo "Compression formats: tar.gz, tar.bz2, zip, 7z, tar"
      echo "Examples:"
      echo "  backup important.txt                   # Simple copy backup"
      echo "  backup project/                        # Simple folder backup"
      echo "  backup config.ini --compress zip       # Compressed file backup"
      echo "  backup project/ --compress tar.gz      # Compressed folder backup"
      echo "  backup data/ --compress 7z             # 7z compressed backup"
      return 1
    fi
    
    local source_path="$1"
    local compress_format=""
    local use_compression=false
    
    # Parse compression option
    if [[ "$2" == "--compress" && -n "$3" ]]; then
      compress_format="$3"
      use_compression=true
    fi
    
    # Check if source exists
    if [[ ! -e "$source_path" ]]; then
      echo "Error: '$source_path' does not exist"
      return 1
    fi
    
    # Generate timestamp
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local basename=$(basename "$source_path")
    
    # Remove trailing slash for consistency
    source_path="${source_path%/}"
    basename="${basename%/}"
    
    if [[ "$use_compression" == true ]]; then
      # Validate compression format
      case "$compress_format" in
        tar.gz|tar.bz2|zip|7z|tar)
          ;;
        *)
          echo "Error: Unsupported compression format '$compress_format'"
          echo "Supported formats: tar.gz, tar.bz2, zip, 7z, tar"
          return 1
          ;;
      esac
      
      # Create compressed backup
      local backup_name="${basename}.backup.${timestamp}.${compress_format}"
      
      echo "Creating compressed backup: $backup_name"
      if compress "$backup_name" "$source_path"; then
        echo "Compressed backup created successfully: $backup_name"
      else
        echo "Error: Failed to create compressed backup"
        return 1
      fi
    else
      # Create simple copy backup
      if [[ -f "$source_path" ]]; then
        # File backup
        local backup_name="${source_path}.backup.${timestamp}"
        cp "$source_path" "$backup_name"
        echo "File backup created: $backup_name"
      elif [[ -d "$source_path" ]]; then
        # Directory backup
        local backup_name="${basename}.backup.${timestamp}"
        cp -r "$source_path" "$backup_name"
        echo "Folder backup created: $backup_name"
      else
        echo "Error: '$source_path' is neither a file nor a directory"
        return 1
      fi
    fi
  }
fi

# Monitor file
if ! should_exclude "watchfile" 2>/dev/null; then
  watchfile() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: watchfile <file_path>"
      echo ""
      echo "Monitor a file for changes in real-time (like tail -f)."
      echo ""
      echo "Examples:"
      echo "  watchfile /var/log/system.log    # Monitor system log"
      echo "  watchfile app.log                # Monitor application log"
      echo "  watchfile access.log             # Monitor web server access log"
      echo ""
      echo "Note: Press Ctrl+C to stop monitoring"
      return 1
    fi
    
    if [[ -f "$1" ]]; then
      tail -f "$1"
    else
      echo "File not found: $1"
    fi
  }
fi

# Monitor directory contents
if ! should_exclude "watchdir" 2>/dev/null; then
  watchdir() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: watchdir [directory_path]"
      echo ""
      echo "Monitor directory contents for changes in real-time."
      echo "If no directory specified, monitors current directory."
      echo ""
      echo "Examples:"
      echo "  watchdir                         # Monitor current directory"
      echo "  watchdir /home/user/downloads    # Monitor downloads folder"
      echo "  watchdir /var/www                # Monitor web directory"
      echo "  watchdir logs/                   # Monitor logs directory"
      echo ""
      echo "Note: Press Ctrl+C to stop monitoring"
      return 1
    fi
    
    local target_dir="${1:-.}"
    
    if [[ ! -d "$target_dir" ]]; then
      echo "Error: '$target_dir' is not a directory or does not exist"
      return 1
    fi
    
    if ! command -v watch >/dev/null 2>&1; then
      echo "Error: 'watch' command not found. Please install it to use this function."
      return 1
    fi
    
    echo "Monitoring directory: $target_dir"
    echo "Press Ctrl+C to stop monitoring"
    echo ""
    
    watch -n 2 "ls -lh '$target_dir'"
  }
fi

# Display file metadata and type information
if ! should_exclude "meta" 2>/dev/null; then
  meta() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: meta <file_path>"
      echo ""
      echo "Display comprehensive file type information and metadata."
      echo "Automatically detects file type and extracts relevant metadata."
      echo ""
      echo "Supported file types:"
      echo "  • Images (JPEG, PNG, GIF, TIFF, etc.) - EXIF data, dimensions, color info"
      echo "  • Documents (PDF, DOC, DOCX, etc.) - document properties, page count"
      echo "  • Videos (MP4, AVI, MOV, etc.) - duration, resolution, codec info"
      echo "  • Audio (MP3, WAV, FLAC, etc.) - duration, bitrate, artist, album"
      echo "  • Archives (ZIP, TAR, etc.) - contents, compression info"
      echo "  • Text files - encoding, line count, word count"
      echo "  • Executables - architecture, symbols, libraries"
      echo ""
      echo "Required tools (installed automatically where possible):"
      echo "  • exiftool - Image/video/audio metadata (images, videos, audio)"
      echo "  • pdfinfo - PDF document information"
      echo "  • mediainfo - Video/audio file information"
      echo "  • identify - ImageMagick image information"
      echo "  • file - File type detection (built-in)"
      echo ""
      echo "Examples:"
      echo "  meta photo.jpg                  # Show image metadata and EXIF data"
      echo "  meta document.pdf               # Show PDF properties and page count"
      echo "  meta video.mp4                  # Show video codec, resolution, duration"
      echo "  meta song.mp3                   # Show audio metadata, bitrate, artist"
      echo "  meta archive.zip                # Show archive contents and compression"
      echo "  meta script.py                  # Show text file encoding and stats"
      echo "  meta program                    # Show executable information"
      return 1
    fi
    
    local file_path="$1"
    
    # Check if file exists
    if [[ ! -e "$file_path" ]]; then
      echo "Error: '$file_path' does not exist"
      return 1
    fi
    
    # Get basic file information
    local file_type=$(file -b "$file_path" 2>/dev/null)
    local file_size=$(ls -lh "$file_path" 2>/dev/null | awk '{print $5}')
    local file_perms=$(ls -l "$file_path" 2>/dev/null | awk '{print $1}')
    local file_owner=$(ls -l "$file_path" 2>/dev/null | awk '{print $3":"$4}')
    local file_modified=$(stat -c "%y" "$file_path" 2>/dev/null || stat -f "%Sm" "$file_path" 2>/dev/null)
    
    echo "=== FILE METADATA ANALYSIS ==="
    echo "File: $(basename "$file_path")"
    echo "Path: $file_path"
    echo "Type: $file_type"
    echo "Size: $file_size"
    echo "Permissions: $file_perms"
    echo "Owner: $file_owner"
    echo "Modified: $file_modified"
    
    # Calculate and display file hash if hashit is available
    if command -v hashit >/dev/null 2>&1; then
      echo -n "SHA256: "
      hashit sha256 "$file_path"
    fi
    
    echo ""
    echo "=== DETAILED METADATA ==="
    
    # Determine file category and extract specific metadata
    local file_lower=$(echo "$file_type" | tr '[:upper:]' '[:lower:]')
    
    case "$file_lower" in
      *image*|*jpeg*|*jpg*|*png*|*gif*|*tiff*|*bmp*|*webp*)
        echo "📷 IMAGE FILE DETECTED"
        echo ""
        
        # Try exiftool first (most comprehensive)
        if command -v exiftool >/dev/null 2>&1; then
          echo "--- EXIF Data (exiftool) ---"
          exiftool -S -f "$file_path" 2>/dev/null | grep --color=never -E "^(GPSAltitude|GPSDateTime|GPSLatitude|GPSLongitude|ImageWidth|ImageHeight|Make|Model|LensModel|DateTimeOriginal|Megapixels):"
        # Fallback to identify (ImageMagick)
        elif command -v identify >/dev/null 2>&1; then
          echo "--- Image Information (ImageMagick) ---"
          identify -verbose "$file_path" 2>/dev/null | grep --color=never -E "^(Format|Geometry|Resolution|Compression):"
        else
          echo "Install 'exiftool' or 'imagemagick' for detailed image metadata"
        fi
        ;;
        
      *pdf*)
        echo "📄 PDF DOCUMENT DETECTED"
        echo ""
        
        if command -v pdfinfo >/dev/null 2>&1; then
          echo "--- PDF Information ---"
          pdfinfo "$file_path" 2>/dev/null | grep --color=never -E "^(Title|Author|Subject|Pages|Creator|Producer|CreationDate|ModDate|Encrypted|PDF version):"
        elif command -v exiftool >/dev/null 2>&1; then
          echo "--- PDF Metadata (exiftool) ---"
          exiftool -S -f "$file_path" 2>/dev/null | grep --color=never -E "^(Title|Author|Subject|PageCount|Creator|Producer|CreateDate|ModifyDate|PDFVersion):"
        else
          echo "Install 'poppler-utils' (for pdfinfo) for detailed PDF metadata"
        fi
        ;;
        
      *video*|*mp4*|*avi*|*mov*|*mkv*|*webm*|*flv*)
        echo "🎬 VIDEO FILE DETECTED"
        echo ""
        
        if command -v exiftool >/dev/null 2>&1; then
          echo "--- Video Metadata (exiftool) ---"
          exiftool -S -f "$file_path" 2>/dev/null | grep --color=never -E "^(GPSAltitude|GPSLatitude|GPSLongitude|Duration|ImageWidth|ImageHeight|FrameRate|VideoCodec|AudioCodec|Bitrate|CreateDate|FileType|MajorBrand):"
        elif command -v mediainfo >/dev/null 2>&1; then
          echo "--- Video Information (mediainfo) ---"
          mediainfo "$file_path" 2>/dev/null | grep --color=never -E "^(Duration|Width|Height|Frame rate|Bit rate|Format|File size)[ ]*:"
        elif command -v ffprobe >/dev/null 2>&1; then
          echo "--- Video Information (ffprobe) ---"
          ffprobe -v quiet -print_format json -show_format -show_streams "$file_path" 2>/dev/null | grep --color=never -E "(duration|width|height|codec_name|bit_rate)"
        else
          echo "Install 'mediainfo', 'exiftool', or 'ffmpeg' for detailed video metadata"
        fi
        ;;
        
      *audio*|*mp3*|*wav*|*flac*|*ogg*|*m4a*|*aac*)
        echo "🎵 AUDIO FILE DETECTED"
        echo ""
        
        if command -v mediainfo >/dev/null 2>&1; then
          echo "--- Audio Information (mediainfo) ---"
          mediainfo "$file_path" 2>/dev/null | grep --color=never -E "^(Performer|Composer|Duration|Bit rate|Format|Format profile|Album|Artist|Title|Genre|Track|Date)[ ]*:"
        elif command -v exiftool >/dev/null 2>&1; then
          echo "--- Audio Metadata (exiftool) ---"
          exiftool -S -f "$file_path" 2>/dev/null | grep --color=never -E "^(MajorBrand|FileType|Duration|Bitrate|Artist|Album|Title|Genre|Track|Year|Composer|ContentCreateDate|HandlerVendorID):"
        else
          echo "Install 'mediainfo' or 'exiftool' for detailed audio metadata"
        fi
        ;;
        
      *archive*|*zip*|*tar*|*gzip*|*compressed*|*rar*|*7-zip*)
        echo "📦 ARCHIVE FILE DETECTED"
        echo ""
        
        case "$file_lower" in
          *zip*)
            if command -v unzip >/dev/null 2>&1; then
              echo "--- ZIP Archive Contents ---"
              unzip -l "$file_path" 2>/dev/null | head -20
            fi
            ;;
          *tar*|*gzip*)
            echo "--- TAR Archive Contents ---"
            tar -tvf "$file_path" 2>/dev/null | head -20
            ;;
          *rar*)
            if command -v unrar >/dev/null 2>&1; then
              echo "--- RAR Archive Contents ---"
              unrar l "$file_path" 2>/dev/null | head -20
            fi
            ;;
          *7-zip*|*7z*)
            local sevenzip_cmd=""
            if command -v 7z >/dev/null 2>&1; then
              sevenzip_cmd="7z"
            elif command -v 7zz >/dev/null 2>&1; then
              sevenzip_cmd="7zz"
            elif command -v 7za >/dev/null 2>&1; then
              sevenzip_cmd="7za"
            fi
            if [[ -n "$sevenzip_cmd" ]]; then
              echo "--- 7-Zip Archive Contents ---"
              "$sevenzip_cmd" l "$file_path" 2>/dev/null | head -20
            fi
            ;;
        esac
        ;;
        
      *text*|*ascii*|*utf-8*|*script*)
        echo "📝 TEXT FILE DETECTED"
        echo ""
        
        echo "--- Text File Statistics ---"
        local line_count=$(wc -l < "$file_path" 2>/dev/null)
        local word_count=$(wc -w < "$file_path" 2>/dev/null)
        local char_count=$(wc -c < "$file_path" 2>/dev/null)
        local encoding=""
        
        if command -v file >/dev/null 2>&1; then
          encoding=$(file -bi "$file_path" 2>/dev/null | grep --color=never -o 'charset=[^;]*' | cut -d= -f2)
        fi
        
        echo "Lines: $line_count"
        echo "Words: $word_count"
        echo "Characters: $char_count"
        [[ -n "$encoding" ]] && echo "Encoding: $encoding"
        
        # Show first few lines if it's a script
        if [[ "$file_lower" == *script* ]] || [[ "$file_path" == *.sh ]] || [[ "$file_path" == *.py ]] || [[ "$file_path" == *.pl ]]; then
          echo ""
          echo "--- Script Preview (first 10 lines) ---"
          head -10 "$file_path" 2>/dev/null
        fi
        ;;
        
      *executable*|*elf*|*mach-o*|*pe32*)
        echo "⚙️  EXECUTABLE FILE DETECTED"
        echo ""
        
        echo "--- Executable Information ---"
        if command -v file >/dev/null 2>&1; then
          file "$file_path" 2>/dev/null
        fi
        
        # Additional info for ELF files on Linux
        if [[ "$file_lower" == *elf* ]] && command -v readelf >/dev/null 2>&1; then
          echo ""
          echo "--- ELF Header Information ---"
          readelf -h "$file_path" 2>/dev/null | grep --color=never -E "(Class|Data|Machine|Entry point)"
        fi
        
        # Show linked libraries if available
        if command -v ldd >/dev/null 2>&1 && [[ "$file_lower" == *elf* ]]; then
          echo ""
          echo "--- Linked Libraries (first 10) ---"
          ldd "$file_path" 2>/dev/null | head -10
        fi
        ;;
        
      *)
        echo "🔍 GENERAL FILE ANALYSIS"
        echo ""
        
        # Try exiftool as last resort for any file
        if command -v exiftool >/dev/null 2>&1; then
          echo "--- General Metadata (exiftool) ---"
          exiftool -S "$file_path" 2>/dev/null
        else
          echo "--- File Command Output ---"
          file -i "$file_path" 2>/dev/null
          echo ""
          echo "For more detailed metadata, install 'exiftool'"
        fi
        ;;
    esac
    
    echo ""
    echo "=== ANALYSIS COMPLETE ==="
  }
fi

