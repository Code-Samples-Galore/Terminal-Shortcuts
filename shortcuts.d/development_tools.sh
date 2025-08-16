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
#   pow2       - Calculate powers of 2 (2^X)
#   strconv    - Convert strings/data between different encodings (hex, base64, binary)
#   entropy    - Calculate Shannon entropy of strings or files
#   jsonpp     - Pretty-print JSON files or stdin
#   replace    - Find and replace text in strings, files, or stdin
#   numconv    - Convert numbers between different bases (binary, octal, decimal, hex, custom)
#
# Usage Examples:
#   $ hashit sha256 "text"        # Hash string with SHA256
#   $ hashit md5 file.txt         # Hash file with MD5
#   $ echo "data" | hashit sha1 - # Hash stdin with SHA1
#   $ randstr 20                  # Generate 20-character password
#   $ calc "2 + 2 * 3"           # Calculate mathematical expression
#   $ log2 256                   # Calculate log2(256) = 8
#   $ pow2 8                     # Calculate 2^8 = 256
#   $ strconv hex "hello"        # Encode string to hex
#   $ strconv hex-decode "68656c6c6f" # Decode hex to string
#   $ strconv base64 "data"      # Encode string to base64
#   $ strconv base64-decode "ZGF0YQ==" # Decode base64 to string
#   $ strconv bin 255            # Convert integer to binary
#   $ strconv bin "A"            # Convert string to binary (ASCII)
#   $ echo "hello" | strconv hex - # Encode stdin to hex
#   $ echo "data" | strconv base64 - # Base64 encode from stdin
#   $ entropy "hello world"      # Calculate entropy of string
#   $ entropy myfile.txt         # Calculate entropy of file
#   $ echo "data" | entropy -    # Calculate entropy of stdin
#   $ replace "hello world" "world" "universe" # Replace in string
#   $ replace myfile.txt "old" "new" --backup # Replace in file with backup
#   $ echo "text" | replace - "old" "new" # Replace from stdin
#   $ numconv hex 255            # Convert 255 to hex: FF
#   $ numconv bin 255            # Convert 255 to binary: 11111111
#   $ numconv dec 0xFF           # Convert hex FF to decimal: 255
#   $ numconv oct 255            # Convert 255 to octal: 377
#   $ numconv 16 255             # Convert 255 to base 16: FF
#   $ numconv 2 255              # Convert 255 to base 2: 11111111
#   $ numconv dec 0b11111111     # Convert binary to decimal: 255
#   $ numconv hex 377 8          # Convert octal 377 to hex: FF
#   $ numconv 36 1000            # Convert 1000 to base 36: RS
#   $ numconv 255                # Convert 255 to decimal (default): 255

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "jsonpp"
cleanup_shortcut "randstr"
cleanup_shortcut "calc"
cleanup_shortcut "log2"
cleanup_shortcut "pow2"
cleanup_shortcut "strconv"
cleanup_shortcut "hashit"
cleanup_shortcut "entropy"
cleanup_shortcut "numconv"
cleanup_shortcut "replace"

# JSON prettify
if ! should_exclude "jsonpp" 2>/dev/null; then
  jsonpp() {
    if [[  $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: jsonpp [options] [file|-]"
      echo ""
      echo "Pretty-print JSON data with proper indentation and formatting."
      echo "If no file specified, reads from stdin."
      echo ""
      echo "Options:"
      echo "  -c, --color      Enable colored output (default if terminal supports it)"
      echo "  --no-color       Disable colored output"
      echo "  -r, --raw        Raw output without colors (same as --no-color)"
      echo ""
      echo "Examples:"
      echo "  jsonpp data.json             # Format JSON file with auto-color"
      echo "  jsonpp --color data.json     # Force colored output"
      echo "  jsonpp --no-color data.json  # Force plain output"
      echo "  jsonpp -                     # Read from stdin explicitly"
      echo "  echo '{\"key\":\"value\"}' | jsonpp    # Format JSON from stdin"
      echo "  curl -s api.example.com | jsonpp     # Format API response"
      echo "  cat response.json | jsonpp   # Format via pipe"
      echo ""
      echo "Color support:"
      echo "  • Uses jq if available (best colors)"
      echo "  • Falls back to Python with pygments"
      echo "  • Falls back to plain Python json.tool"
      echo ""
      echo "Note: Use '-' as input to read from stdin explicitly"
      return 0
    fi
    
    local use_color="auto"
    local input_file=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
      case $1 in
        -c|--color)
          use_color="yes"
          shift
          ;;
        --no-color|-r|--raw)
          use_color="no"
          shift
          ;;
        -)
          # Explicit stdin
          input_file="-"
          shift
          ;;
        -*)
          echo "Error: Unknown option $1"
          return 1
          ;;
        *)
          if [[ -z "$input_file" ]]; then
            input_file="$1"
          else
            echo "Error: Multiple input files specified"
            return 1
          fi
          shift
          ;;
      esac
    done
    
    # Auto-detect color support
    if [[ "$use_color" == "auto" ]]; then
      if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
        use_color="yes"
      else
        use_color="no"
      fi
    fi
    
    # Function to get input data
    local get_input_cmd
    if [[ -n "$input_file" && "$input_file" != "-" ]]; then
      get_input_cmd="cat \"$input_file\""
    else
      get_input_cmd="cat"
    fi
    
    # Try different tools for JSON formatting with color support
    if [[ "$use_color" == "yes" ]]; then
      # First try: jq (best option for colored JSON)
      if command -v jq >/dev/null 2>&1; then
        eval "$get_input_cmd" | jq '.'
        return $?
      fi
      
      # Second try: Python with pygments (good colors)
      if command -v python3 >/dev/null 2>&1; then
        local python_color_result
        python_color_result=$(eval "$get_input_cmd" | python3 -c "
import json
import sys
try:
    from pygments import highlight
    from pygments.lexers import JsonLexer
    from pygments.formatters import TerminalFormatter
    
    data = json.loads(sys.stdin.read())
    formatted = json.dumps(data, indent=2, ensure_ascii=False, sort_keys=True)
    colored = highlight(formatted, JsonLexer(), TerminalFormatter())
    print(colored, end='')
except ImportError:
    # Fallback to basic formatting if pygments not available
    data = json.loads(sys.stdin.read())
    print(json.dumps(data, indent=2, ensure_ascii=False, sort_keys=True))
except json.JSONDecodeError as e:
    print(f'Error: Invalid JSON - {e}', file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null)
        
        if [[ $? -eq 0 && -n "$python_color_result" ]]; then
          echo "$python_color_result"
          return 0
        fi
      fi
      
      # If colored options failed, fall through to plain formatting
      echo "Note: Colored output not available, using plain formatting" >&2
    fi
    
    # Fallback: Plain Python json.tool
    if [[ -n "$input_file" && "$input_file" != "-" ]]; then
      python3 -m json.tool "$input_file"
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

# Power of 2 function
if ! should_exclude "pow2" 2>/dev/null; then
  pow2() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pow2 <integer>"
      echo ""
      echo "Calculate powers of 2 (2^X) for a given integer exponent."
      echo "Useful for computing bit values, memory sizes, etc."
      echo ""
      echo "Examples:"
      echo "  pow2 8                       # Result: 256 (2^8 = 256)"
      echo "  pow2 10                      # Result: 1024 (2^10 = 1024)"
      echo "  pow2 0                       # Result: 1 (2^0 = 1)"
      echo "  pow2 16                      # Result: 65536 (2^16 = 65536)"
      echo "  pow2 20                      # Result: 1048576 (2^20 = 1MB)"
      return 1
    fi
    
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
      echo "Error: Input must be a non-negative integer"
      return 1
    fi
    
    echo "scale=0; 2^$1" | bc
  }
fi

# String/data converter function
if ! should_exclude "strconv" 2>/dev/null; then
  strconv() {
    if [[ -z "$1" || -z "$2" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: strconv <format> <string_or_file|->"
      echo ""
      echo "Convert strings and data between different encodings and representations."
      echo "Can process strings, files, or stdin input."
      echo ""
      echo "Formats:"
      echo "  hex, hex-encode      Convert data to hexadecimal"
      echo "  hex-decode, hex-d    Convert hexadecimal back to original data"
      echo "  base64, b64          Convert data to Base64"
      echo "  base64-decode, b64-d Convert Base64 back to original data"
      echo "  bin, binary          Convert to binary representation"
      echo "                       • Integers: binary number representation"
      echo "                       • Strings: ASCII/UTF-8 binary for each character"
      echo ""
      echo "Examples:"
      echo "  strconv hex \"hello\"              # Encode string to hex: 68656c6c6f"
      echo "  strconv hex-decode \"68656c6c6f\"   # Decode hex to string: hello"
      echo "  strconv base64 \"hello world\"     # Encode to Base64: aGVsbG8gd29ybGQ="
      echo "  strconv b64-d \"aGVsbG8gd29ybGQ=\"  # Decode Base64: hello world"
      echo "  strconv bin 255                  # Integer to binary: 11111111"
      echo "  strconv bin \"A\"                 # String to binary: 01000001"
      echo "  strconv hex myfile.txt           # Encode file contents to hex"
      echo "  echo \"data\" | strconv base64 -   # Encode stdin to Base64"
      echo "  cat encoded.txt | strconv hex-d - # Decode hex from stdin"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
      return 1
    fi
    
    local format="$1"
    local input_source
    
    if [[ "$2" == "-" ]]; then
      input_source="cat"
    elif [[ -f "$2" ]]; then
      input_source="cat \"$2\""
    else
      input_source="echo -n \"$2\""
    fi
    
    case "$format" in
      hex|hex-encode)
        eval "$input_source" | xxd -p | tr -d '\n'
        echo
        ;;
      hex-decode|hex-d)
        eval "$input_source" | xxd -r -p
        echo
        ;;
      base64|b64)
        eval "$input_source" | base64
        ;;
      base64-decode|b64-d)
        eval "$input_source" | base64 -d
        echo
        ;;
      bin|binary)
        local input_data
        if [[ "$2" == "-" ]]; then
          input_data=$(cat)
        elif [[ -f "$2" ]]; then
          input_data=$(cat "$2")
        else
          input_data="$2"
        fi
        
        # Check if input is a number
        if [[ "$input_data" =~ ^[0-9]+$ ]]; then
          # Convert integer to binary
          echo "obase=2; $input_data" | bc
        else
          # Convert string to binary (each character) using od for reliable character processing
          echo -n "$input_data" | od -An -tu1 | tr -s ' ' '\n' | while read -r byte; do
            if [[ -n "$byte" && "$byte" != "0" ]]; then
              echo "obase=2; $byte" | bc
            fi
          done | tr '\n' ' '
          echo
        fi
        ;;
      *)
        echo "Error: Unsupported format '$format'"
        echo "Supported formats: hex, hex-decode, base64, base64-decode, bin"
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
      echo "Simple Hash types:"
      echo "  md5      128-bit hash (legacy, not secure)"
      echo "  sha1     160-bit hash (legacy, not secure)"
      echo "  sha224   224-bit hash (SHA-2 family)"
      echo "  sha256   256-bit hash (secure, recommended)"
      echo "  sha384   384-bit hash (SHA-2 family)"
      echo "  sha512   512-bit hash (secure, high security)"
      echo "  blake2   BLAKE2 hash (modern, fast)"
      echo "  crc32    CRC32 checksum (integrity, not security)"
      echo ""
      echo "Password Hash types (with salt):"
      echo "  bcrypt   Bcrypt password hash (adaptive, secure)"
      echo "  argon2   Argon2id password hash (modern, recommended)"
      echo "  sha256crypt  SHA-256 crypt (Unix-style password hash)"
      echo "  sha512crypt  SHA-512 crypt (Unix-style password hash)"
      echo ""
      echo "Platform-specific:"
      echo "  sha3     SHA-3 (if available)"
      echo ""
      echo "Examples:"
      echo "  hashit sha256 \"hello world\"       # Hash string with SHA256"
      echo "  hashit blake2 document.pdf         # Hash file with BLAKE2"
      echo "  hashit bcrypt \"password123\"       # Generate bcrypt password hash"
      echo "  hashit argon2 \"password123\"       # Generate Argon2 password hash"
      echo "  hashit sha256crypt \"password\"     # Generate SHA-256 crypt hash"
      echo "  echo \"password\" | hashit bcrypt -  # Hash stdin with bcrypt"
      echo ""
      echo "Note: Use '-' as input to read from stdin"
      echo "      Password hashes include random salt and are different each time"
      return 1
    fi
    
    local hash_type="$1"
    local input="$2"
    
    # Function to get input data
    _get_input_data() {
      if [[ "$input" == "-" ]]; then
        cat
      elif [[ -f "$input" ]]; then
        cat "$input"
      else
        echo -n "$input"
      fi
    }
    
    # Function to handle simple hash algorithms
    _hash_input() {
      local hash_cmd="$1"
      if [[ "$input" == "-" ]]; then
        eval "$hash_cmd" | cut -d' ' -f1
      elif [[ -f "$input" ]]; then
        eval "$hash_cmd \"$input\"" | cut -d' ' -f1
      else
        echo -n "$input" | eval "$hash_cmd" | cut -d' ' -f1
      fi
    }
    
    case "$hash_type" in
      md5)
        _hash_input "md5sum"
        ;;
      sha1)
        _hash_input "sha1sum"
        ;;
      sha224)
        if command -v sha224sum >/dev/null 2>&1; then
          _hash_input "sha224sum"
        elif command -v shasum >/dev/null 2>&1; then
          # macOS fallback
          if [[ "$input" == "-" ]]; then
            shasum -a 224 | cut -d' ' -f1
          elif [[ -f "$input" ]]; then
            shasum -a 224 "$input" | cut -d' ' -f1
          else
            echo -n "$input" | shasum -a 224 | cut -d' ' -f1
          fi
        else
          echo "Error: SHA224 not available on this system"
          return 1
        fi
        ;;
      sha256)
        _hash_input "sha256sum"
        ;;
      sha384)
        if command -v sha384sum >/dev/null 2>&1; then
          _hash_input "sha384sum"
        elif command -v shasum >/dev/null 2>&1; then
          # macOS fallback
          if [[ "$input" == "-" ]]; then
            shasum -a 384 | cut -d' ' -f1
          elif [[ -f "$input" ]]; then
            shasum -a 384 "$input" | cut -d' ' -f1
          else
            echo -n "$input" | shasum -a 384 | cut -d' ' -f1
          fi
        else
          echo "Error: SHA384 not available on this system"
          return 1
        fi
        ;;
      sha512)
        _hash_input "sha512sum"
        ;;
      blake2)
        if command -v b2sum >/dev/null 2>&1; then
          _hash_input "b2sum"
        else
          echo "Error: BLAKE2 (b2sum) not available. Install coreutils or blake2 package."
          return 1
        fi
        ;;
      sha3)
        if command -v sha3sum >/dev/null 2>&1; then
          _hash_input "sha3sum"
        else
          echo "Error: SHA-3 not available. Install sha3sum package if available."
          return 1
        fi
        ;;
      crc32)
        if command -v cksum >/dev/null 2>&1; then
          if [[ "$input" == "-" ]]; then
            cksum | cut -d' ' -f1
          elif [[ -f "$input" ]]; then
            cksum "$input" | cut -d' ' -f1
          else
            echo -n "$input" | cksum | cut -d' ' -f1
          fi
        else
          echo "Error: CRC32 (cksum) not available on this system"
          return 1
        fi
        ;;
      bcrypt)
        local password_data
        password_data=$(_get_input_data)
        
        if command -v htpasswd >/dev/null 2>&1; then
          # Use Apache htpasswd (most common)
          echo "$password_data" | htpasswd -niB dummy | cut -d: -f2
        elif command -v python3 >/dev/null 2>&1; then
          # Python fallback with bcrypt library
          python3 -c "
import sys
try:
    import bcrypt
    password = sys.stdin.read().strip()
    hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
    print(hashed.decode('utf-8'))
except ImportError:
    print('Error: bcrypt library not available. Install with: pip3 install bcrypt', file=sys.stderr)
    sys.exit(1)
" <<< "$password_data"
        else
          echo "Error: bcrypt not available. Install htpasswd (apache2-utils) or Python bcrypt library."
          return 1
        fi
        ;;
      argon2)
        local password_data
        password_data=$(_get_input_data)
        
        if command -v argon2 >/dev/null 2>&1; then
          # Use standalone argon2 tool
          echo -n "$password_data" | argon2 "$(openssl rand -base64 16)" -id -t 3 -m 12 -p 1
        elif command -v python3 >/dev/null 2>&1; then
          # Python fallback with argon2-cffi library
          python3 -c "
import sys
try:
    from argon2 import PasswordHasher
    password = sys.stdin.read().strip()
    ph = PasswordHasher()
    hashed = ph.hash(password)
    print(hashed)
except ImportError:
    print('Error: argon2-cffi library not available. Install with: pip3 install argon2-cffi', file=sys.stderr)
    sys.exit(1)
" <<< "$password_data"
        else
          echo "Error: Argon2 not available. Install argon2 tool or Python argon2-cffi library."
          return 1
        fi
        ;;
      sha256crypt)
        local password_data
        password_data=$(_get_input_data)
        
        if command -v openssl >/dev/null 2>&1; then
          # Generate random salt
          local salt=$(openssl rand -base64 12 | tr -d '+/=' | cut -c1-16)
          # Use OpenSSL for SHA-256 crypt
          openssl passwd -5 -salt "$salt" "$password_data"
        elif command -v python3 >/dev/null 2>&1; then
          # Python fallback using crypt module
          python3 -c "
import crypt
import sys
import secrets
import string

password = sys.stdin.read().strip()
# Generate random salt for SHA-256 crypt (\$5\$)
salt_chars = string.ascii_letters + string.digits + './'
salt = ''.join(secrets.choice(salt_chars) for _ in range(16))
hashed = crypt.crypt(password, '\$5\$' + salt + '\$')
print(hashed)
" <<< "$password_data"
        else
          echo "Error: SHA-256 crypt not available. OpenSSL or Python required."
          return 1
        fi
        ;;
      sha512crypt)
        local password_data
        password_data=$(_get_input_data)
        
        if command -v openssl >/dev/null 2>&1; then
          # Generate random salt
          local salt=$(openssl rand -base64 12 | tr -d '+/=' | cut -c1-16)
          # Use OpenSSL for SHA-512 crypt
          openssl passwd -6 -salt "$salt" "$password_data"
        elif command -v python3 >/dev/null 2>&1; then
          # Python fallback using crypt module
          python3 -c "
import crypt
import sys
import secrets
import string

password = sys.stdin.read().strip()
# Generate random salt for SHA-512 crypt (\$6\$)
salt_chars = string.ascii_letters + string.digits + './'
salt = ''.join(secrets.choice(salt_chars) for _ in range(16))
hashed = crypt.crypt(password, '\$6\$' + salt + '\$')
print(hashed)
" <<< "$password_data"
        else
          echo "Error: SHA-512 crypt not available. OpenSSL or Python required."
          return 1
        fi
        ;;
      *)
        echo "Error: Unsupported hash type '$hash_type'"
        echo "Simple hashes: md5, sha1, sha224, sha256, sha384, sha512, blake2, sha3, crc32"
        echo "Password hashes: bcrypt, argon2, sha256crypt, sha512crypt"
        return 1
        ;;
    esac
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

# Number base converter function
if ! should_exclude "numconv" 2>/dev/null; then
  numconv() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: numconv <number> [target_base] [source_base]"
      echo ""
      echo "Convert numbers between different number bases."
      echo "Supports binary, octal, decimal, hexadecimal, and custom bases (2-36)."
      echo ""
      echo "Target bases (default: dec):"
      echo "  bin, binary, 2     Binary (base 2)"
      echo "  oct, octal, 8      Octal (base 8)"
      echo "  dec, decimal, 10   Decimal (base 10) - default"
      echo "  hex, hexadecimal, 16  Hexadecimal (base 16)"
      echo "  3-36               Custom base (3-36)"
      echo ""
      echo "Source base (optional):"
      echo "  If not specified, auto-detects from number format:"
      echo "  • 0x prefix = hexadecimal"
      echo "  • 0b prefix = binary"
      echo "  • 0 prefix = octal"
      echo "  • default = decimal"
      echo ""
      echo "Examples:"
      echo "  numconv 255 hex               # Convert 255 to hex: FF"
      echo "  numconv 255 bin               # Convert 255 to binary: 11111111"
      echo "  numconv 0xFF dec              # Convert hex FF to decimal: 255"
      echo "  numconv 255 oct               # Convert 255 to octal: 377"
      echo "  numconv 255 16                # Convert 255 to base 16: FF"
      echo "  numconv 255 2                 # Convert 255 to base 2: 11111111"
      echo "  numconv 0b11111111 dec        # Convert binary to decimal: 255"
      echo "  numconv 377 hex 8             # Convert octal 377 to hex: FF"
      echo "  numconv 1000 36               # Convert 1000 to base 36: RS"
      echo "  numconv 0xFF                  # Convert hex FF to decimal (default): 255"
      return 1
    fi
    
    local number="$1"
    local target_base="${2:-dec}"
    local source_base="${3:-auto}"
    local decimal_value
    local target_base_num
    
    # Normalize target base
    case "$target_base" in
      bin|binary|2)     target_base_num=2 ;;
      oct|octal|8)      target_base_num=8 ;;
      dec|decimal|10)   target_base_num=10 ;;
      hex|hexadecimal|16) target_base_num=16 ;;
      [3-9]|[12][0-9]|3[0-6]) target_base_num="$target_base" ;;
      *)
        echo "Error: Invalid target base '$target_base'. Use 2-36 or bin/oct/dec/hex"
        return 1
        ;;
    esac
    
    # Auto-detect source base if not specified
    if [[ "$source_base" == "auto" ]]; then
      if [[ "$number" =~ ^0[xX][0-9a-fA-F]+$ ]]; then
        source_base=16
        number="${number#0x}"  # Remove 0x prefix
        number=$(echo "$number" | tr '[:lower:]' '[:upper:]')  # Convert to uppercase for bc
      elif [[ "$number" =~ ^0b[01]+$ ]]; then
        source_base=2
        number="${number#0b}"  # Remove 0b prefix
      elif [[ "$number" =~ ^0[0-7]+$ ]]; then
        source_base=8
        number="${number#0}"   # Remove leading 0
      elif [[ "$number" =~ ^[0-9]+$ ]]; then
        source_base=10
      else
        echo "Error: Cannot auto-detect base for '$1'. Please specify source base."
        return 1
      fi
    fi
    
    # Validate source base
    if ! [[ "$source_base" =~ ^([2-9]|[12][0-9]|3[0-6])$ ]]; then
      echo "Error: Invalid source base '$source_base'. Use 2-36"
      return 1
    fi
    
    # Convert to decimal first (if not already decimal)
    if [[ "$source_base" == "10" ]]; then
      decimal_value="$number"
    else
      # Use bc for base conversion to decimal
      decimal_value=$(echo "ibase=$source_base; $number" | bc 2>/dev/null)
      if [[ -z "$decimal_value" ]]; then
        echo "Error: Invalid number '$number' for base $source_base"
        return 1
      fi
    fi
    
    # Validate decimal value is non-negative integer
    if ! [[ "$decimal_value" =~ ^[0-9]+$ ]]; then
      echo "Error: Result must be a non-negative integer"
      return 1
    fi
    
    # Convert from decimal to target base
    if [[ "$target_base_num" == "10" ]]; then
      echo "$decimal_value"
    else
      local result=$(echo "obase=$target_base_num; $decimal_value" | bc)
      if [[ "$target_base_num" == "16" ]]; then
        echo "$result" | tr 'a-f' 'A-F'  # Uppercase hex
      else
        echo "$result"
      fi
    fi
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
