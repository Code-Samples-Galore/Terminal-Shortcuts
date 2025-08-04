#!/bin/bash
# Python Development Functions
#
# Description: Python development utilities including package management shortcuts,
# virtual environment auto-activation, and module execution helpers.
# Streamlines Python workflow and environment management.
#
# Functions:
#   svenv      - Auto-activate Python virtual environment in current directory
#   pm         - Run Python modules using file path notation
#   pipu       - Upgrade Python package(s) or from requirements file
#   pipi       - Install Python package(s) or from requirements file
#
# Aliases:
#   p          - Python3 interpreter
#   pipl       - List installed packages (pip list)
#
# Usage Examples:
#   $ p                          # Start Python3 interpreter
#   $ pipi requests              # Install requests package
#   $ pipi requirements.txt      # Install from requirements file
#   $ pipu numpy                 # Upgrade numpy package
#   $ pipu                       # Upgrade all packages
#   $ pipu requirements.txt      # Upgrade packages from requirements file
#   $ pipl                       # List installed packages
#   $ svenv                      # Activate virtual environment
#   $ pm src/main.py             # Run python -m src.main
#   $ pm utils/helper.py arg1    # Run python -m utils.helper arg1

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "p"
cleanup_shortcut "pipl"
cleanup_shortcut "pipi"
cleanup_shortcut "pipu"
cleanup_shortcut "svenv"
cleanup_shortcut "pm"

# Python
if ! should_exclude "p" 2>/dev/null; then alias p='python3'; fi
if ! should_exclude "pipl" 2>/dev/null; then alias pipl='python3 -m pip list'; fi

# Python package install function - install specific package(s) or from requirements file
if ! should_exclude "pipi" 2>/dev/null; then
  pipi() {
    if [[ $# -eq 0 ]]; then
      echo "Usage: pipi <package_name> or pipi <requirements_file>"
      return 1
    elif [[ "$1" == "requirements.txt" || "$1" == *.txt ]]; then
      # Install packages from requirements file
      python3 -m pip install -r "$@"
    else
      # Install specific package(s)
      python3 -m pip install "$@"
    fi
  }
fi

# Python package upgrade function - upgrade specific package, all packages, or from requirements file
if ! should_exclude "pipu" 2>/dev/null; then
  pipu() {
    if [[ $# -eq 0 ]]; then
      # No arguments provided, upgrade all packages
      echo "Upgrading all packages..."
      python3 -m pip list --outdated | grep -v '^\-e' | awk '{print $1}' | tail -n +3 | xargs -n1 python3 -m pip install -U
    elif [[ "$1" == "requirements.txt" || "$1" == *.txt ]]; then
      # Upgrade packages from requirements file
      python3 -m pip install -U -r "$@"
    else
      # Upgrade specific package(s)
      python3 -m pip install -U "$@"
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

