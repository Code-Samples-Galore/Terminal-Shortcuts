#!/bin/bash
# Python Virtual Environment Auto-Activation Function
#
# Description: Automatically finds and activates Python virtual environments
# by searching for 'activate' scripts in the current directory and subdirectories.
# Useful for quickly activating venvs without knowing the exact path.
#
# Usage: svenv
# Example: $ svenv  # Activates the first virtual environment found

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
