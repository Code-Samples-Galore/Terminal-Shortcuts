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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: jsonpp [file]"
      echo ""
      echo "Pretty-print JSON data with proper indentation and formatting."
      echo "If no file specified, reads from stdin."
      echo ""
      echo "Examples:"
      echo "  jsonpp data.json             # Format JSON file"
      echo "  echo '{\"key\":\"value\"}' | jsonpp    # Format JSON from stdin"
      echo "  curl -s api.example.com | jsonpp     # Format API response"
      echo "  cat response.json | jsonpp   # Format via pipe"
      return 0
    fi
    
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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: randstr [length]"
      echo ""
      echo "Generate a secure random password using base64 encoding."
      echo "Default length is 16 characters if not specified."
      echo ""
      echo "Examples:"
      echo "  randstr                      # Generate 16-character password"
      echo "  randstr 32                   # Generate 32-character password"
      echo "  randstr 8                    # Generate 8-character password"
      echo "  randstr 64                   # Generate 64-character password"
      return 0
    fi
    
    local length=${1:-16}
    if ! [[ "$length" =~ ^[0-9]+$ ]]; then
      echo "Error: Length must be a positive integer"
      echo "Usage: randstr [length]"
      return 1
    fi
    openssl rand -base64 32 | head -c "$length" && echo
  }
fi

# Calculator function
if ! should_exclude "calc" 2>/dev/null; then
  calc() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: calc <mathematical_expression>"
      echo ""
      echo "Perform mathematical calculations with floating point precision."
      echo "Supports standard arithmetic operations and functions."
      echo ""
      echo "Operators: +, -, *, /, ^, %, sqrt(), sin(), cos(), log(), etc."
      echo ""
      echo "Examples:"
      echo "  calc \"2 + 2\"                # Basic addition: 4"
      echo "  calc \"3.14 * 2^2\"          # Pi times radius squared"
      echo "  calc \"sqrt(16)\"             # Square root: 4"
      echo "  calc \"10 / 3\"               # Division with decimals"
      echo "  calc \"2^10\"                 # Powers: 1024"
      echo "  calc \"sin(3.14159/2)\"       # Trigonometry"
      return 1
    fi
    echo "scale=3; $*" | bc -l
  }
fi

# Base-2 logarithm function
if ! should_exclude "log2" 2>/dev/null; then
  log2() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: log2 <integer>"
      echo ""
      echo "Calculate the base-2 logarithm of a positive integer."
      echo "Useful for determining bit lengths, tree depths, etc."
      echo ""
      echo "Examples:"
      echo "  log2 256                     # Result: 8 (2^8 = 256)"
      echo "  log2 1024                    # Result: 10 (2^10 = 1024)"
      echo "  log2 7                       # Result: 2.807 (between 2^2 and 2^3)"
      echo "  log2 1                       # Result: 0 (2^0 = 1)"
      echo "  log2 65536                   # Result: 16 (2^16 = 65536)"
      return 1
    fi
    
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
      echo "Error: Input must be a positive integer"
      return 1
    fi
    
    echo "scale=6; l($1)/l(2)" | bc -l
  }
fi

# Hex encode/decode function
if ! should_exclude "hexconv" 2>/dev/null; then
  hexconv() {
    if [[ -z "$1" || -z "$2" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: hexconv <encode|decode> <string_or_file|->"
      echo ""
      echo "Encode or decode data to/from hexadecimal representation."
      echo "Can process strings, files, or stdin input."
      echo ""
      echo "Commands:"
      echo "  encode, e    Convert data to hexadecimal"
      echo "  decode, d    Convert hexadecimal back to original data"
      echo ""
      echo "Examples:"
      echo "  hexconv encode \"hello\"           # Encode string to hex"
      echo "  hexconv decode \"68656c6c6f\"      # Decode hex to string"
      echo "  hexconv e myfile.txt             # Encode file contents"
      echo "  hexconv d hexfile.txt            # Decode hex file"
      echo "  echo \"hello\" | hexconv encode -  # Encode from stdin"
      echo "  echo \"68656c6c6f\" | hexconv decode -  # Decode from stdin"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
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
    if [[ -z "$1" || -z "$2" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: base64conv <encode|decode> <string_or_file|->"
      echo ""
      echo "Encode or decode data to/from Base64 representation."
      echo "Can process strings, files, or stdin input."
      echo ""
      echo "Commands:"
      echo "  encode, e    Convert data to Base64"
      echo "  decode, d    Convert Base64 back to original data"
      echo ""
      echo "Examples:"
      echo "  base64conv encode \"hello world\"   # Encode string to Base64"
      echo "  base64conv decode \"aGVsbG8gd29ybGQ=\"  # Decode Base64 to string"
      echo "  base64conv e document.pdf          # Encode file contents"
      echo "  base64conv d encoded.txt           # Decode Base64 file"
      echo "  echo \"data\" | base64conv encode -  # Encode from stdin"
      echo "  cat encoded.txt | base64conv decode -  # Decode from stdin"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
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
    if [[ -z "$1" || -z "$2" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: hashit <hash_type> <string_or_file|->"
      echo ""
      echo "Compute cryptographic hash of strings, files, or stdin input."
      echo "Supports multiple hash algorithms for different security needs."
      echo ""
      echo "Hash types:"
      echo "  md5      128-bit hash (legacy, not secure)"
      echo "  sha1     160-bit hash (legacy, not secure)"
      echo "  sha256   256-bit hash (secure, recommended)"
      echo "  sha512   512-bit hash (secure, high security)"
      echo ""
      echo "Examples:"
      echo "  hashit sha256 \"hello world\"       # Hash string with SHA256"
      echo "  hashit md5 document.pdf           # Hash file with MD5"
      echo "  hashit sha512 /etc/passwd         # Hash system file"
      echo "  echo \"password\" | hashit sha256 -  # Hash stdin input"
      echo "  cat largefile.zip | hashit sha1 -  # Hash large file via pipe"
      echo ""
      echo "Security recommendations:"
      echo "  • Use SHA256 or SHA512 for new applications"
      echo "  • Avoid MD5 and SHA1 for security-critical uses"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
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
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: binconv <string_or_integer|->"
      echo ""
      echo "Convert strings or integers to binary representation."
      echo "Handles both numeric and text input automatically."
      echo ""
      echo "Input types:"
      echo "  Integer    Converts to binary number representation"
      echo "  String     Converts each character to binary (ASCII/UTF-8)"
      echo "  Stdin      Processes piped input"
      echo ""
      echo "Examples:"
      echo "  binconv 255                    # Integer: 11111111"
      echo "  binconv 1024                   # Integer: 10000000000"
      echo "  binconv \"A\"                   # String: 01000001"
      echo "  binconv \"Hello\"               # String: multiple binary values"
      echo "  echo \"World\" | binconv -       # Stdin: binary for each character"
      echo "  binconv 0                      # Integer: 0"
      echo ""
      echo "Use cases:"
      echo "  • Learning binary representation"
      echo "  • Debugging character encoding"
      echo "  • Understanding data storage"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
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
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: entropy <string_or_file|->"
      echo ""
      echo "Calculate Shannon entropy to measure randomness and information content."
      echo "Higher entropy indicates more randomness and unpredictability."
      echo ""
      echo "Entropy scale:"
      echo "  0.0 - 1.0    Very low (repetitive, predictable)"
      echo "  1.0 - 2.0    Low (simple patterns)"
      echo "  2.0 - 4.0    Moderate (typical text)"
      echo "  4.0 - 6.0    High (complex text, mixed data)"
      echo "  6.0 - 8.0    Very high (random, encrypted data)"
      echo ""
      echo "Examples:"
      echo "  entropy \"hello world\"          # Analyze text entropy"
      echo "  entropy \"aaaaaaaaaa\"           # Low entropy (repetitive)"
      echo "  entropy document.txt           # Analyze file entropy"
      echo "  entropy /dev/random            # Very high entropy"
      echo "  echo \"password123\" | entropy -  # Analyze via stdin"
      echo "  entropy encrypted.bin          # Check encryption quality"
      echo ""
      echo "Use cases:"
      echo "  • Password strength analysis"
      echo "  • Data compression potential"
      echo "  • Encryption quality verification"
      echo "  • Random number generator testing"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
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
    if [[ $# -lt 3 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: replace <string_or_file|-> <search_pattern> <replacement> [--backup]"
      echo ""
      echo "Find and replace text in strings, files, or stdin input."
      echo "Supports literal text replacement with optional backup creation."
      echo ""
      echo "Options:"
      echo "  --backup     Create timestamped backup before modifying files"
      echo ""
      echo "Input types:"
      echo "  String       Direct text manipulation"
      echo "  File         In-place file modification"
      echo "  Stdin (-)    Process piped input"
      echo ""
      echo "Examples:"
      echo "  replace \"hello world\" \"world\" \"universe\"    # String replacement"
      echo "  replace config.txt \"old_value\" \"new_value\"   # File replacement"
      echo "  replace data.txt \"pattern\" \"replacement\" --backup  # With backup"
      echo "  echo \"test data\" | replace - \"test\" \"demo\"   # Stdin replacement"
      echo "  replace script.sh \"#!/bin/bash\" \"#!/bin/zsh\"  # Shebang replacement"
      echo ""
      echo "Backup format:"
      echo "  original_file.bak.YYYYMMDD_HHMMSS"
      echo ""
      echo "Note:"
      echo "  • Use '-' as first argument to read from stdin"
      echo "  • File modifications are permanent unless --backup is used"
      echo "  • Pattern matching is literal (not regex)"
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
