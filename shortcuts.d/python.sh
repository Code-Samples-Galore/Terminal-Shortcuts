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
#   $ cdsvenv my_project         # Navigate to my_project and activate venv

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "p"
cleanup_shortcut "pipl"
cleanup_shortcut "pipi"
cleanup_shortcut "pipu"
cleanup_shortcut "svenv"
cleanup_shortcut "pm"
cleanup_shortcut "cdsvenv"

# Python
if ! should_exclude "p" 2>/dev/null; then alias p='python3'; fi
if ! should_exclude "pipl" 2>/dev/null; then alias pipl='python3 -m pip list'; fi

# Python package install function - install specific package(s) or from requirements file
if ! should_exclude "pipi" 2>/dev/null; then
  pipi() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pipi <package_name> [package_name2 ...] | pipi <requirements_file>"
      echo ""
      echo "Install Python packages using pip."
      echo "Can install individual packages or from a requirements file."
      echo ""
      echo "Examples:"
      echo "  pipi requests                    # Install requests package"
      echo "  pipi numpy pandas matplotlib     # Install multiple packages"
      echo "  pipi requirements.txt            # Install from requirements file"
      echo "  pipi dev-requirements.txt        # Install from custom requirements file"
      echo "  pipi flask==2.0.1               # Install specific version"
      echo "  pipi 'requests>=2.25.0'         # Install with version constraint"
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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pipu [package_name] [package_name2 ...] | pipu <requirements_file> | pipu"
      echo ""
      echo "Upgrade Python packages using pip."
      echo "If no arguments provided, upgrades all outdated packages."
      echo ""
      echo "Examples:"
      echo "  pipu                             # Upgrade all outdated packages"
      echo "  pipu requests                    # Upgrade requests package"
      echo "  pipu numpy pandas                # Upgrade multiple packages"
      echo "  pipu requirements.txt            # Upgrade packages from requirements file"
      echo "  pipu dev-requirements.txt        # Upgrade from custom requirements file"
      echo ""
      echo "Note: Use with caution when upgrading all packages as it may break compatibility"
      return 0
    fi
    
    if [[ $# -eq 0 ]]; then
      # No arguments provided, upgrade all packages
      echo "Upgrading all outdated packages..."
      echo "Note: This may take a while and could potentially break compatibility"
      echo -n "Continue? (y/N): "
      read -r confirm
      if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled"
        return 1
      fi
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
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: svenv"
      echo ""
      echo "Auto-activate Python virtual environment in current directory."
      echo "Searches for 'activate' script in current directory and subdirectories."
      echo ""
      echo "Examples:"
      echo "  svenv                            # Activate virtual environment"
      echo "  cdsvenv my_project               # Navigate to project and activate venv"
      echo ""
      echo "Virtual environment structure expected:"
      echo "  ./venv/bin/activate              # Standard venv location"
      echo "  ./env/bin/activate               # Alternative venv location"
      echo "  ./.venv/bin/activate             # Hidden venv location"
      echo ""
      echo "Note: This command takes no arguments and searches automatically"
      return 0
    fi
    
    if [[ $# -gt 0 ]]; then
      echo "Error: svenv takes no arguments"
      echo "Usage: svenv"
      echo "Use 'svenv --help' for more information"
      return 1
    fi
    
    # Find activate script in current directory and subdirectories
    local activate_file=$(find . -name "activate" -path "*/bin/activate" -type f 2>/dev/null | head -1)
    
    if [[ -n "$activate_file" ]]; then
      echo "Activating virtual environment: $activate_file"
      source "$activate_file"
      return 0
    else
      echo "No virtual environment activate script found in current directory"
      echo "Expected locations:"
      echo "  ./venv/bin/activate"
      echo "  ./env/bin/activate" 
      echo "  ./.venv/bin/activate"
      echo ""
      echo "To create a virtual environment, run:"
      echo "  python3 -m venv venv"
      return 1
    fi
  }
fi

# Navigate to project directory and activate virtual environment
if ! should_exclude "cdsvenv" 2>/dev/null; then
  cdsvenv() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: cdsvenv <directory>"
      echo ""
      echo "Navigate to a project directory and auto-activate Python virtual environment."
      echo "Combines 'cd' and 'svenv' functionality in one command."
      echo ""
      echo "Examples:"
      echo "  cdsvenv my_project               # cd my_project && svenv"
      echo "  cdsvenv ../other_project         # cd ../other_project && svenv"
      echo "  cdsvenv /path/to/project         # cd /path/to/project && svenv"
      echo ""
      echo "Virtual environment structure expected in target directory:"
      echo "  ./venv/bin/activate              # Standard venv location"
      echo "  ./env/bin/activate               # Alternative venv location"
      echo "  ./.venv/bin/activate             # Hidden venv location"
      return 1
    fi
    
    # Check if directory exists
    if [[ ! -d "$1" ]]; then
      echo "Error: Directory '$1' does not exist"
      return 1
    fi
    
    # Navigate to directory
    echo "Navigating to: $1"
    cd "$1" || return 1
    
    # Activate virtual environment
    svenv
  }
fi

# Python module runner - converts file paths to module notation
if ! should_exclude "pm" 2>/dev/null; then
  pm() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pm <python_file_path> [arguments...]"
      echo ""
      echo "Run Python modules using file path notation."
      echo "Converts file paths to Python module notation and executes with python -m."
      echo ""
      echo "Path conversion:"
      echo "  src/main.py        →  python -m src.main"
      echo "  utils/helper.py    →  python -m utils.helper"
      echo "  package/sub/mod.py →  python -m package.sub.mod"
      echo ""
      echo "Examples:"
      echo "  pm src/main.py                   # Run python -m src.main"
      echo "  pm utils/helper.py arg1 arg2     # Run python -m utils.helper arg1 arg2"
      echo "  pm tests/test_unit.py            # Run python -m tests.test_unit"
      echo "  pm package/cli.py --verbose      # Run python -m package.cli --verbose"
      echo ""
      echo "Note: The .py extension is automatically removed"
      return 1
    fi
    
    local module_path="$1"
    
    # Check if file exists
    if [[ ! -f "$module_path" && ! -f "${module_path}.py" ]]; then
      echo "Error: File '$module_path' not found"
      echo "Make sure the Python file exists before running"
      return 1
    fi
    
    # Remove .py extension if present
    module_path="${module_path%.py}"
    # Replace / with .
    module_path="${module_path//\//.}"
    
    echo "Running: python3 -m $module_path ${*:2}"
    python3 -m "$module_path" "${@:2}"
  }
fi

