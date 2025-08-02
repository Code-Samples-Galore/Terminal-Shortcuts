#!/bin/bash
# Development Tools Functions
#
# Description: Essential development utilities including HTTP server setup,
# JSON formatting, password generation, and mathematical calculations.
# Designed to streamline common development and administrative tasks.
#
# Functions:
#   jsonpp     - Pretty-print JSON files or stdin
#   genpass    - Generate secure random passwords
#   calc       - Perform mathematical calculations
#   pm         - Run Python modules using file path notation
#   log2       - Calculate base-2 logarithm of an integer
#   hexconv    - Encode/decode hex strings
#   genstr     - Generate random strings with special characters
#   hashit     - Compute hash of string or file (md5, sha1, sha256, sha512)
#   binconv    - Convert string or integer to binary representation
#   svenv      - Auto-activate Python virtual environment
#
# Usage Examples:
#   $ jsonpp data.json    # Pretty-print JSON file
#   $ genpass 20          # Generate 20-character password
#   $ calc "2 + 2 * 3"    # Calculate mathematical expression
#   $ pm src/main.py      # Run python -m src.main
#   $ log2 256            # Calculate log2(256) = 8
#   $ hexconv encode "hello"     # Hex encode string
#   $ hexconv decode "68656c6c6f" # Hex decode string
#   $ genstr 20           # Generate 20-char random string
#   $ hashit sha256 "text" # Hash string with SHA256
#   $ hashit md5 file.txt  # Hash file with MD5
#   $ binconv 255         # Convert integer to binary
#   $ binconv "A"         # Convert string to binary
#   $ svenv               # Activate Python virtual environment

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
if ! should_exclude "genpass" 2>/dev/null; then
  genpass() {
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

# Python module runner - converts file paths to module notation
if ! should_exclude "pm" 2>/dev/null; then
  pm() {
    if [[ -z "$1" ]]; then
      echo "Usage: pm <python_file_path>"
      return 1
    fi
    
    local module_path="$1"
    # Remove .py extension if present
    module_path="${module_path%.py}"
    # Replace / with .
    module_path="${module_path//\//.}"
    
    python3 -m "$module_path" "${@:2}"
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
      echo "Usage: hexconv <encode|decode> <string_or_file>"
      return 1
    fi
    
    local input_source
    if [[ -f "$2" ]]; then
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
      echo "Usage: base64conv <encode|decode> <string_or_file>"
      return 1
    fi
    
    local input_source
    if [[ -f "$2" ]]; then
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

# Generate random string with special characters
if ! should_exclude "randstr" 2>/dev/null; then
  randstr() {
    local length=${1:-16}
    local chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?'
    
    if command -v python3 >/dev/null 2>&1; then
      python3 -c "import secrets, string; chars='$chars'; print(''.join(secrets.choice(chars) for _ in range($length)))"
    else
      # Fallback using openssl for crypto-secure randomness
      openssl rand -base64 $((length * 2)) | tr -dc "$chars" | head -c "$length" && echo
    fi
  }
fi

# Hash function for strings and files
if ! should_exclude "hashit" 2>/dev/null; then
  hashit() {
    if [[ -z "$1" || -z "$2" ]]; then
      echo "Usage: hashit <hash_type> <string_or_file>"
      echo "Hash types: md5, sha1, sha256, sha512"
      return 1
    fi
    
    local hash_type="$1"
    local input="$2"
    
    # Check if input is a file
    if [[ -f "$input" ]]; then
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
      echo "Usage: binconv <string_or_integer>"
      echo "Examples:"
      echo "  binconv 255     # Convert integer to binary"
      echo "  binconv \"Hello\" # Convert string to binary"
      return 1
    fi
    
    local input="$1"
    
    # Check if input is a number
    if [[ "$input" =~ ^[0-9]+$ ]]; then
      # Convert integer to binary
      echo "obase=2; $input" | bc
    else
      # Convert string to binary (each character)
      echo -n "$input" | while IFS= read -r -n1 char; do
        if [[ -n "$char" ]]; then
          printf "%s " "$(printf '%d' "'$char" | xargs -I {} echo "obase=2; {}" | bc)"
        fi
      done
      echo
    fi
  }
fi

# Python Virtual Environment Auto-Activation Function
if ! should_exclude "svenv" 2>/dev/null; then
  svenv() {
    # Find activate script in current directory and subdirectories
    local activate_file=$(find . -name "activate" -path "*/bin/activate" -type f 2>/dev/null | head -1)
    
    if [[ -n "$activate_file" ]]; then
      echo "Activating virtual environment: $activate_file"
      source "$activate_file"
      return 0
    else
      echo "No virtual environment activate script found in current directory"
      return 1
    fi
  }
fi

