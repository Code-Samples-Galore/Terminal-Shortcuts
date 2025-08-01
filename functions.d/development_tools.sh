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
#
# Usage Examples:
#   $ jsonpp data.json    # Pretty-print JSON file
#   $ genpass 20          # Generate 20-character password
#   $ calc "2 + 2 * 3"    # Calculate mathematical expression

# JSON prettify
jsonpp() {
  if [[ -n "$1" ]]; then
    cat "$1" | python3 -m json.tool
  else
    python3 -m json.tool
  fi
}

# Generate random password
genpass() {
  local length=${1:-16}
  openssl rand -base64 32 | head -c "$length" && echo
}

# Calculator function
calc() {
  echo "scale=3; $*" | bc -l
}