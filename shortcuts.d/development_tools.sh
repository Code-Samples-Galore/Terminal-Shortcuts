#!/bin/bash
# Development Tools Functions
#
# Description: Essential development utilities including hash computation, password generation,
# mathematical calculations, encoding/decoding operations, entropy analysis, text replacement,
# and JSON formatting. Designed to streamline common development and administrative tasks.
#
# Functions:
#   hashit     - Compute hash of strings or files (md5/sha1/sha256/sha512)
#   randstr    - Generate secure random passwords
#   calc       - Perform mathematical calculations
#   log2       - Calculate base-2 logarithm of integers
#   hexconv    - Encode/decode hex strings or files
#   base64conv - Encode/decode base64 strings or files
#   binconv    - Convert string or integer to binary representation
#   entropy    - Calculate Shannon entropy of strings or files
#   jsonpp     - Pretty-print JSON files or stdin
#   replace    - Find and replace text in strings, files, or stdin
#
# Usage Examples:
#   $ hashit sha256 "text"        # Hash string with SHA256
#   $ hashit md5 file.txt         # Hash file with MD5
#   $ echo "data" | hashit sha1 - # Hash stdin with SHA1
#   $ randstr 20                  # Generate 20-character password
#   $ calc "2 + 2 * 3"           # Calculate mathematical expression
#   $ log2 256                   # Calculate log2(256) = 8
#   $ hexconv encode "hello"     # Hex encode string
#   $ hexconv decode "68656c6c6f" # Hex decode string
#   $ echo "hello" | hexconv encode - # Hex encode from stdin
#   $ base64conv encode "data"   # Base64 encode string
#   $ echo "data" | base64conv encode - # Base64 encode from stdin
#   $ binconv 255                # Convert integer to binary
#   $ binconv "A"                # Convert string to binary
#   $ echo "text" | binconv -    # Convert stdin to binary
#   $ entropy "hello world"      # Calculate entropy of string
#   $ entropy myfile.txt         # Calculate entropy of file
#   $ echo "data" | entropy -    # Calculate entropy of stdin
#   $ replace "hello world" "world" "universe" # Replace in string
#   $ replace myfile.txt "old" "new" --backup # Replace in file with backup
#   $ echo "text" | replace - "old" "new" # Replace from stdin

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "jsonpp"
cleanup_shortcut "randstr"
cleanup_shortcut "calc"
cleanup_shortcut "log2"
cleanup_shortcut "hexconv"
cleanup_shortcut "base64conv"
cleanup_shortcut "hashit"
cleanup_shortcut "binconv"
cleanup_shortcut "entropy"
cleanup_shortcut "replace"

# JSON prettify
if ! should_exclude "jsonpp" 2>/dev/null; then
  jsonpp() {
    if [[ -n "$1" ]]; then
      cat "$1" | python3 -m json.tool
    else
      python3 -m json.tool
    fi
  }
fi

# Generate random password
if ! should_exclude "randstr" 2>/dev/null; then
  randstr() {
    local length=${1:-16}
    openssl rand -base64 32 | head -c "$length" && echo
  }
fi

# Calculator function
if ! should_exclude "calc" 2>/dev/null; then
  calc() {
    echo "scale=3; $*" | bc -l
  }
fi

# Base-2 logarithm function
if ! should_exclude "log2" 2>/dev/null; then
  log2() {
    if [[ -z "$1" ]]; then
      echo "Usage: log2 <integer>"
      return 1
    fi
    echo "scale=6; l($1)/l(2)" | bc -l
  }
fi

# Hex encode/decode function
if ! should_exclude "hexconv" 2>/dev/null; then
  hexconv() {
    if [[ -z "$1" || -z "$2" ]]; then
      echo "Usage: hexconv <encode|decode> <string_or_file|->"
      echo "Use '-' to read from stdin"
      return 1
    fi
    
    local input_source
    if [[ "$2" == "-" ]]; then
      input_source="cat"
    elif [[ -f "$2" ]]; then
      input_source="cat \"$2\""
    else
      input_source="echo -n \"$2\""
    fi
    
    case "$1" in
      encode|e)
        eval "$input_source" | xxd -p | tr -d '\n'
        echo
        ;;
      decode|d)
        eval "$input_source" | xxd -r -p
        echo
        ;;
      *)
        echo "Error: Use 'encode' or 'decode'"
        return 1
        ;;
    esac
  }
fi

# Base64 encode/decode function
if ! should_exclude "base64conv" 2>/dev/null; then
  base64conv() {
    if [[ -z "$1" || -z "$2" ]]; then
      echo "Usage: base64conv <encode|decode> <string_or_file|->"
      echo "Use '-' to read from stdin"
      return 1
    fi
    
    local input_source
    if [[ "$2" == "-" ]]; then
      input_source="cat"
    elif [[ -f "$2" ]]; then
      input_source="cat \"$2\""
    else
      input_source="echo -n \"$2\""
    fi
    
    case "$1" in
      encode|e)
        eval "$input_source" | base64
        ;;
      decode|d)
        eval "$input_source" | base64 -d
        echo
        ;;
      *)
        echo "Error: Use 'encode' or 'decode'"
        return 1
        ;;
    esac
  }
fi

# Hash function for strings and files
if ! should_exclude "hashit" 2>/dev/null; then
  hashit() {
    if [[ -z "$1" || -z "$2" ]]; then
      echo "Usage: hashit <hash_type> <string_or_file|->"
      echo "Hash types: md5, sha1, sha256, sha512"
      echo "Use '-' to read from stdin"
      return 1
    fi
    
    local hash_type="$1"
    local input="$2"
    
    # Check if input is stdin
    if [[ "$input" == "-" ]]; then
      case "$hash_type" in
        md5)     md5sum | cut -d' ' -f1 ;;
        sha1)    sha1sum | cut -d' ' -f1 ;;
        sha256)  sha256sum | cut -d' ' -f1 ;;
        sha512)  sha512sum | cut -d' ' -f1 ;;
        *)       echo "Error: Unsupported hash type. Use: md5, sha1, sha256, sha512" && return 1 ;;
      esac
    # Check if input is a file
    elif [[ -f "$input" ]]; then
      case "$hash_type" in
        md5)     md5sum "$input" | cut -d' ' -f1 ;;
        sha1)    sha1sum "$input" | cut -d' ' -f1 ;;
        sha256)  sha256sum "$input" | cut -d' ' -f1 ;;
        sha512)  sha512sum "$input" | cut -d' ' -f1 ;;
        *)       echo "Error: Unsupported hash type. Use: md5, sha1, sha256, sha512" && return 1 ;;
      esac
    else
      # Treat as string
      case "$hash_type" in
        md5)     echo -n "$input" | md5sum | cut -d' ' -f1 ;;
        sha1)    echo -n "$input" | sha1sum | cut -d' ' -f1 ;;
        sha256)  echo -n "$input" | sha256sum | cut -d' ' -f1 ;;
        sha512)  echo -n "$input" | sha512sum | cut -d' ' -f1 ;;
        *)       echo "Error: Unsupported hash type. Use: md5, sha1, sha256, sha512" && return 1 ;;
      esac
    fi
  }
fi

# Binary converter function
if ! should_exclude "binconv" 2>/dev/null; then
  binconv() {
    if [[ -z "$1" ]]; then
      echo "Usage: binconv <string_or_integer|->"
      echo "Examples:"
      echo "  binconv 255     # Convert integer to binary"
      echo "  binconv \"Hello\" # Convert string to binary"
      echo "  echo \"data\" | binconv -  # Convert stdin to binary"
      return 1
    fi
    
    local input="$1"
    
    # Check if input is stdin
    if [[ "$input" == "-" ]]; then
      input=$(cat)
    fi
    
    # Check if input is a number
    if [[ "$input" =~ ^[0-9]+$ ]]; then
      # Convert integer to binary
      echo "obase=2; $input" | bc
    else
      # Convert string to binary (each character) using od for reliable character processing
      echo -n "$input" | od -An -tu1 | tr -s ' ' '\n' | while read -r byte; do
        if [[ -n "$byte" && "$byte" != "0" ]]; then
          echo "obase=2; $byte" | bc
        fi
      done | tr '\n' ' '
      echo
    fi
  }
fi

# Entropy calculation function
if ! should_exclude "entropy" 2>/dev/null; then
  entropy() {
    if [[ -z "$1" ]]; then
      echo "Usage: entropy <string_or_file|->"
      echo "Examples:"
      echo "  entropy \"hello world\"    # Calculate entropy of string"
      echo "  entropy myfile.txt        # Calculate entropy of file"
      echo "  echo \"data\" | entropy -  # Calculate entropy of stdin"
      return 1
    fi
    
    local input="$1"
    local data
    
    # Check if input is stdin
    if [[ "$input" == "-" ]]; then
      data=$(cat)
    # Check if input is a file
    elif [[ -f "$input" ]]; then
      data=$(cat "$input")
    else
      data="$input"
    fi
    
    # Print entropy context information
    echo "=== ENTROPY INFORMATION ==="
    echo "Entropy Range: 0.0 (completely predictable) to 8.0 (maximum randomness)"
    echo "Normal Text:   1.0 - 4.5 (typical range for human-readable text)"
    echo "Random Data:   6.0 - 8.0 (cryptographic quality randomness)"
    echo ""
    
    # Calculate Shannon entropy using awk with proper locale handling
    local entropy_value=$(echo -n "$data" | LC_NUMERIC=C awk '
    BEGIN { 
      for (i = 0; i < 256; i++) freq[i] = 0 
    }
    {
      for (i = 1; i <= length($0); i++) {
        char = substr($0, i, 1)
        freq[sprintf("%c", char)]++
        total++
      }
    }
    END {
      entropy = 0
      for (char in freq) {
        if (freq[char] > 0) {
          p = freq[char] / total
          entropy -= p * log(p) / log(2)
        }
      }
      printf "%.6f", entropy
    }')
    
    echo "Calculated Entropy: $entropy_value"
    
    # Provide interpretation using awk for floating point comparison (bc-independent)
    local interpretation=$(echo "$entropy_value" | awk '
    {
      if ($1 < 1.0) print "Very low entropy - highly predictable data"
      else if ($1 < 2.0) print "Low entropy - simple or repetitive text"
      else if ($1 < 4.0) print "Moderate entropy - typical human-readable text"
      else if ($1 < 6.0) print "High entropy - complex text or mixed data"
      else print "Very high entropy - random or encrypted data"
    }')
    
    echo "Interpretation: $interpretation"
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



