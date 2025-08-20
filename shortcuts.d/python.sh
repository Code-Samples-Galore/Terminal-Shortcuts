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
cleanup_shortcut "cvenv"
cleanup_shortcut "pmem"
cleanup_shortcut "preq"
cleanup_shortcut "pytestcov"
cleanup_shortcut "pfmt"

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

# Create venv with conda's Python in target dir, activate, then upgrade pip
if ! should_exclude "cvenv" 2>/dev/null; then
  cvenv() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: cvenv [directory]"
      echo ""
      echo "Create a Python virtual environment at [directory]/.venv using the Python from conda,"
      echo "activate it (via svenv), and upgrade pip inside the environment."
      echo ""
      echo "Examples:"
      echo "  cvenv                 # Use current directory"
      echo "  cvenv my_project      # Create venv in my_project/.venv"
      echo "  cvenv ..              # Create venv in parent directory"
      return 0
    fi

    local target_dir="."
    if [[ -n "$1" ]]; then
      target_dir="$1"
    fi

    if [[ ! -d "$target_dir" ]]; then
      echo "Error: Directory '$target_dir' does not exist"
      return 1
    fi

    echo "Navigating to: $target_dir"
    cd "$target_dir" || return 1

    # Determine conda Python
    local py=""
    if command -v conda >/dev/null 2>&1; then
      if [[ -n "$CONDA_PREFIX" && -x "$CONDA_PREFIX/bin/python" ]]; then
        py="$CONDA_PREFIX/bin/python"
      else
        local conda_base
        conda_base="$(conda info --base 2>/dev/null)"
        if [[ -n "$conda_base" && -x "$conda_base/bin/python" ]]; then
          py="$conda_base/bin/python"
        fi
      fi
    fi
    if [[ -z "$py" ]]; then
      if command -v python3 >/dev/null 2>&1; then
        py="$(command -v python3)"
      elif command -v python >/dev/null 2>&1; then
        py="$(command -v python)"
      fi
      echo "Warning: conda Python not found. Falling back to: ${py:-<none>}"
    fi
    if [[ -z "$py" ]]; then
      echo "Error: No suitable Python interpreter found"
      return 1
    fi

    if [[ -d ".venv" ]]; then
      echo "Virtual environment '.venv' already exists. Skipping creation."
    else
      echo "Creating virtual environment with: $py -m venv .venv"
      "$py" -m venv .venv || return 1
    fi

    # Activate venv and upgrade pip inside it
    svenv || return 1
    pipu pip
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

# Python public members inspector - show public methods/attributes of built-in classes
if ! should_exclude "pmem" 2>/dev/null; then
  pmem() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pmem [options] <class_name>"
      echo ""
      echo "Display members (methods and attributes) of Python built-in classes."
      echo ""
      echo "Options:"
      echo "  -m, --magic     Show magic methods (names starting with __)"
      echo "  -a, --all       Show both public and magic methods"
      echo "  -d, --docs      Show docstrings for each member"
      echo "  (no options)    Show public methods only (default)"
      echo ""
      echo "Examples:"
      echo "  pmem str                         # Show public members of str class"
      echo "  pmem -m list                     # Show magic methods of list class"
      echo "  pmem --magic dict                # Show magic methods of dict class"
      echo "  pmem -a bytearray                # Show both public and magic methods"
      echo "  pmem --all int                   # Show both public and magic methods"
      echo "  pmem -d str                      # Show public members with docstrings"
      echo "  pmem -ad list                    # Show all members with docstrings"
      echo "  pmem xmlrpc.client.ServerProxy   # Show members of ServerProxy class"
      echo "  pmem -d urllib.request.Request   # Show Request class with docstrings"
      echo "  pmem pathlib.Path                # Show Path class members"
      echo ""
      echo "Class specification:"
      echo "  <class_name>     - Built-in class (str, int, list, dict, etc.)"
      echo "  <module.class>   - Module class (xmlrpc.client.ServerProxy)"
      echo ""
      echo "Common built-in classes to explore:"
      echo "  str, int, float, bool, list, tuple, dict, set, frozenset"
      echo "  bytes, bytearray, memoryview, range, slice, type, object"
      echo ""
      echo "Common module classes to explore:"
      echo "  xmlrpc.client.ServerProxy, urllib.request.Request, pathlib.Path"
      echo "  json.JSONEncoder, sqlite3.Connection, threading.Thread"
      return 1
    fi
    
    local show_magic=False
    local show_all=False
    local show_docs=False
    local class_name=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
      case $1 in
        -m|--magic)
          show_magic=True
          shift
          ;;
        -a|--all)
          show_all=True
          shift
          ;;
        -d|--docs)
          show_docs=True
          shift
          ;;
        -*)
          # Handle combined flags like -ad, -md, etc.
          if [[ "$1" =~ ^-[amd]+$ ]]; then
            [[ "$1" =~ a ]] && show_all=True
            [[ "$1" =~ m ]] && show_magic=True
            [[ "$1" =~ d ]] && show_docs=True
            shift
          else
            echo "Error: Unknown option '$1'"
            echo "Use 'pmem --help' for usage information"
            return 1
          fi
          ;;
        *)
          if [[ -z "$class_name" ]]; then
            class_name="$1"
          else
            echo "Error: Multiple class names provided"
            echo "Use 'pmem --help' for usage information"
            return 1
          fi
          shift
          ;;
      esac
    done
    
    if [[ -z "$class_name" ]]; then
      echo "Error: No class name provided"
      echo "Usage: pmem [options] <class_name>"
      echo "Use 'pmem --help' for more information"
      return 1
    fi
    
    python3 -c "
def public_members(cls):
    return {name for name in dir(cls) if not name.startswith('_')}

def magic_members(cls):
    return {name for name in dir(cls) if name.startswith('__')}

def get_member_info(cls, name):
    try:
        member = getattr(cls, name)
        doc = getattr(member, '__doc__', None)
        if doc:
            # Clean up docstring - remove extra whitespace and newlines
            doc = ' '.join(doc.strip().split())
        return doc
    except:
        return None

def get_class_from_string(class_string):
    '''Get class object from string, supporting both built-ins and module.class notation'''
    try:
        # First try as built-in or already imported class
        return eval(class_string)
    except NameError:
        # If it contains dots, try importing the module
        if '.' in class_string:
            parts = class_string.split('.')
            if len(parts) >= 2:
                # Try different module/class combinations
                for i in range(1, len(parts)):
                    module_name = '.'.join(parts[:i])
                    class_path = parts[i:]
                    
                    try:
                        # Import the module
                        module = __import__(module_name, fromlist=[parts[i]])
                        
                        # Navigate to the class
                        cls = module
                        for part in class_path:
                            cls = getattr(cls, part)
                        
                        return cls
                    except (ImportError, AttributeError):
                        continue
        
        # If all else fails, raise the original error
        raise NameError(f'Class \'{class_string}\' not found')

def display_members_with_docs(members, cls, title):
    print(f'=== {title} ===')
    print(f'Total: {len(members)} members')
    print()
    
    if not members:
        print('No members found')
        return
    
    # Find members with and without docs
    with_docs = []
    without_docs = []
    
    for name in members:
        doc = get_member_info(cls, name)
        if doc:
            with_docs.append((name, doc))
        else:
            without_docs.append(name)
    
    # Display members with documentation first
    if with_docs:
        print('MEMBERS WITH DOCUMENTATION:')
        for name, doc in with_docs:
            print(f'  {name}')
            print(f'    {doc}')
            print()
    
    # Display members without documentation
    if without_docs:
        print('MEMBERS WITHOUT DOCUMENTATION:')
        import textwrap
        wrapped = textwrap.fill(', '.join(without_docs), width=80, initial_indent='  ', subsequent_indent='  ')
        print(wrapped)

def display_members_simple(members, title):
    print(f'=== {title} ===')
    print(f'Total: {len(members)} members')
    print()
    
    if members:
        import textwrap
        wrapped = textwrap.fill(', '.join(members), width=80)
        print(wrapped)
    else:
        print('No members found')

class_name = '$class_name'
show_magic = $show_magic
show_all = $show_all
show_docs = $show_docs

try:
    # Get the class object (supports both built-ins and module.class)
    cls = get_class_from_string(class_name)
    
    if show_all:
        public = sorted(public_members(cls))
        magic = sorted(magic_members(cls))
        
        if show_docs:
            display_members_with_docs(public, cls, f'PUBLIC MEMBERS OF {cls.__name__}')
            print()
            display_members_with_docs(magic, cls, f'MAGIC METHODS OF {cls.__name__}')
        else:
            print(f'=== ALL MEMBERS OF {cls.__name__} ===')
            print(f'Public: {len(public)} members | Magic: {len(magic)} members')
            print()
            
            if public:
                print('PUBLIC MEMBERS:')
                import textwrap
                wrapped = textwrap.fill(', '.join(public), width=80)
                print(wrapped)
                print()
            
            if magic:
                print('MAGIC METHODS:')
                import textwrap
                wrapped = textwrap.fill(', '.join(magic), width=80)
                print(wrapped)
        
    elif show_magic:
        members = sorted(magic_members(cls))
        
        if show_docs:
            display_members_with_docs(members, cls, f'MAGIC METHODS OF {cls.__name__}')
        else:
            display_members_simple(members, f'MAGIC METHODS OF {cls.__name__}')
    
    else:
        members = sorted(public_members(cls))
        
        if show_docs:
            display_members_with_docs(members, cls, f'PUBLIC MEMBERS OF {cls.__name__}')
        else:
            display_members_simple(members, f'PUBLIC MEMBERS OF {cls.__name__}')
        
except NameError as e:
    if '.' in class_name:
        print(f'Error: Could not import or find class \'{class_name}\'')
        parts = class_name.split('.')
        if len(parts) >= 2:
            module_name = '.'.join(parts[:-1])
            class_part = parts[-1]
            print(f'Make sure module \'{module_name}\' exists and contains class \'{class_part}\'')
        print('Examples: xmlrpc.client.ServerProxy, urllib.request.Request, pathlib.Path')
    else:
        print(f'Error: \'{class_name}\' is not a recognized built-in class')
        print('Try: str, int, float, list, dict, set, bytes, bytearray, etc.')
        print('Or use module.class notation: xmlrpc.client.ServerProxy')
except ImportError as e:
    print(f'Error: Could not import module for \'{class_name}\'')
    print(f'Import error: {e}')
except AttributeError as e:
    print(f'Error: Class \'{class_name}\' not found in module')
    print(f'Attribute error: {e}')
except Exception as e:
    print(f'Error: {e}')
"

# Python package dependencies analyzer
if ! should_exclude "preq" 2>/dev/null; then
  preq() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: preq"
      echo ""
      echo "Analyze Python project dependencies and environment information."
      echo "Automatically detects requirements.txt and Pipfile configurations."
      echo ""
      echo "Features:"
      echo "  • Check installed packages against requirements.txt"
      echo "  • List outdated packages in current environment"
      echo "  • Display dependency graph for Pipenv projects"
      echo "  • Show virtual environment size"
      echo "  • Detect dependency management tool (pip/pipenv)"
      echo ""
      echo "Examples:"
      echo "  preq                         # Analyze current project dependencies"
      echo ""
      echo "Output includes:"
      echo "  • Installed packages matching requirements.txt"
      echo "  • List of outdated packages with current/latest versions"
      echo "  • Dependency graph (for Pipenv projects)"
      echo "  • Virtual environment disk usage"
      echo ""
      echo "Supported dependency files:"
      echo "  • requirements.txt (pip-based projects)"
      echo "  • Pipfile (pipenv-based projects)"
      echo ""
      echo "Note: This command takes no arguments and analyzes the current directory"
      return 0
    fi
    
    if [[ $# -gt 0 ]]; then
      echo "Error: preq takes no arguments"
      echo "Usage: preq"
      echo "Use 'preq --help' for more information"
      return 1
    fi
    
    echo "📦 Analyzing Python dependencies..."
    echo
    
    local found_config=false
    
    # Check for requirements.txt
    if [[ -f "requirements.txt" ]]; then
      found_config=true
      echo "✅ Requirements.txt found"
      echo "📋 Installed packages matching requirements:"
      
      # Extract package names from requirements.txt (handle various formats)
      local req_packages=$(grep -v '^#' requirements.txt | grep -v '^$' | sed 's/[>=<!=].*//' | sed 's/\[.*\]//')
      
      if [[ -n "$req_packages" ]]; then
        echo "$req_packages" | while read -r package; do
          if [[ -n "$package" ]]; then
            pip show "$package" >/dev/null 2>&1 && echo "  ✅ $package" || echo "  ❌ $package (not installed)"
          fi
        done
      else
        echo "  No packages found in requirements.txt"
      fi
      echo
    fi
    
    # Check for Pipfile
    if [[ -f "Pipfile" ]]; then
      found_config=true
      echo "✅ Pipfile found - pipenv project detected"
      
      if command -v pipenv >/dev/null 2>&1; then
        echo "📊 Dependency graph:"
        pipenv graph 2>/dev/null || echo "  Run 'pipenv install' to install dependencies first"
      else
        echo "  ⚠️  pipenv not installed. Install with: pip install pipenv"
      fi
      echo
    fi
    
    # Check for pyproject.toml
    if [[ -f "pyproject.toml" ]]; then
      found_config=true
      echo "✅ pyproject.toml found"
      if grep -q "poetry" pyproject.toml; then
        echo "  Poetry project detected"
        if command -v poetry >/dev/null 2>&1; then
          echo "📊 Poetry dependencies:"
          poetry show 2>/dev/null || echo "  Run 'poetry install' to install dependencies first"
        else
          echo "  ⚠️  Poetry not installed. Install with: pip install poetry"
        fi
      fi
      echo
    fi
    
    if [[ "$found_config" == false ]]; then
      echo "ℹ️  No dependency configuration files found"
      echo "   Expected files: requirements.txt, Pipfile, pyproject.toml"
      echo
    fi
    
    # Check for outdated packages
    echo "🔍 Checking for outdated packages..."
    local outdated_output
    outdated_output=$(pip list --outdated 2>/dev/null)
    
    if [[ -n "$outdated_output" ]]; then
      echo "$outdated_output"
    else
      echo "  ✅ All packages are up to date"
    fi
    echo
    
    # Check virtual environment size
    echo "💾 Virtual environment information:"
    local venv_found=false
    
    for venv_dir in venv .venv env .virtualenv; do
      if [[ -d "$venv_dir" ]]; then
        venv_found=true
        local size=$(du -sh "$venv_dir" 2>/dev/null | cut -f1)
        echo "  📂 $venv_dir/: $size"
      fi
    done
    
    if [[ "$venv_found" == false ]]; then
      echo "  ℹ️  No virtual environment found in current directory"
      echo "     (Checked: venv/, .venv/, env/, .virtualenv/)"
    fi
    
    # Show active environment info
    if [[ -n "$VIRTUAL_ENV" ]]; then
      echo "  🔴 Active virtual environment: $VIRTUAL_ENV"
      local active_size=$(du -sh "$VIRTUAL_ENV" 2>/dev/null | cut -f1)
      echo "     Size: $active_size"
    else
      echo "  ℹ️  No virtual environment currently activated"
    fi
  }
fi

# Python test runner with coverage
if ! should_exclude "pytestcov" 2>/dev/null; then
  pytestcov() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pytestcov [test_path] [pytest_options]"
      echo ""
      echo "Run Python tests with coverage analysis using pytest."
      echo "Automatically installs pytest and pytest-cov if not present."
      echo ""
      echo "Parameters:"
      echo "  test_path        Directory or file to test (default: current directory)"
      echo "  pytest_options   Additional pytest options (passed through)"
      echo ""
      echo "Features:"
      echo "  • Automatic tool installation (pytest, pytest-cov)"
      echo "  • Coverage report in terminal and HTML format"
      echo "  • Missing lines highlighted in coverage report"
      echo "  • HTML coverage report with detailed file-by-file analysis"
      echo "  • Comprehensive test execution statistics"
      echo ""
      echo "Examples:"
      echo "  pytestcov                    # Test current directory with coverage"
      echo "  pytestcov tests/             # Test specific directory"
      echo "  pytestcov test_module.py     # Test specific file"
      echo "  pytestcov tests/ -v          # Verbose output"
      echo "  pytestcov . --tb=short       # Short traceback format"
      echo "  pytestcov tests/ -k \"unit\"   # Run only tests matching 'unit'"
      echo ""
      echo "Output:"
      echo "  • Terminal coverage report with missing lines"
      echo "  • HTML coverage report at htmlcov/index.html"
      echo "  • Test execution summary and statistics"
      echo ""
      echo "Generated files:"
      echo "  • htmlcov/         - HTML coverage report directory"
      echo "  • .coverage        - Coverage data file"
      echo ""
      echo "Note: Requires Python testing environment with write permissions"
      return 0
    fi
    
    local test_path="${1:-.}"
    
    # Validate test path exists
    if [[ ! -e "$test_path" ]]; then
      echo "Error: Test path '$test_path' does not exist"
      return 1
    fi
    
    echo "🧪 Running Python tests with coverage analysis..."
    echo "📍 Test path: $test_path"
    echo
    
    # Check and install required packages
    echo "📦 Checking required packages..."
    local packages_to_install=()
    
    if ! pip show pytest >/dev/null 2>&1; then
      packages_to_install+=("pytest")
    fi
    
    if ! pip show pytest-cov >/dev/null 2>&1; then
      packages_to_install+=("pytest-cov")
    fi
    
    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
      echo "Installing required packages: ${packages_to_install[*]}"
      pip install "${packages_to_install[@]}" || {
        echo "Error: Failed to install required packages"
        return 1
      }
      echo
    else
      echo "✅ All required packages are installed"
      echo
    fi
    
    # Run tests with coverage
    echo "🔬 Running tests with coverage..."
    echo "Command: pytest \"$test_path\" --cov=. --cov-report=html --cov-report=term-missing ${*:2}"
    echo
    
    # Execute pytest with coverage
    pytest "$test_path" --cov=. --cov-report=html --cov-report=term-missing "${@:2}"
    local exit_code=$?
    
    echo
    echo "📊 Test Results Summary:"
    
    if [[ $exit_code -eq 0 ]]; then
      echo "✅ All tests passed successfully"
    else
      echo "❌ Some tests failed (exit code: $exit_code)"
    fi
    
    # Check for HTML coverage report
    if [[ -d "htmlcov" ]]; then
      echo "📈 Coverage report generated successfully"
      echo "   HTML report: htmlcov/index.html"
      echo "   Open with: open htmlcov/index.html"
      
      # Show file count in HTML report
      local html_files=$(find htmlcov -name "*.html" | wc -l)
      echo "   Report contains $html_files HTML files"
    else
      echo "⚠️  HTML coverage report not generated"
    fi
    
    # Check for .coverage file
    if [[ -f ".coverage" ]]; then
      echo "📁 Coverage data saved to .coverage file"
    fi
    
    return $exit_code
  }
fi

# Python code formatter and linter
if ! should_exclude "pfmt" 2>/dev/null; then
  pfmt() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: pfmt [target] [options]"
      echo ""
      echo "Format and lint Python code using black, isort, and flake8."
      echo "Automatically installs required tools if not present."
      echo ""
      echo "Parameters:"
      echo "  target           File or directory to format (default: current directory)"
      echo ""
      echo "Options:"
      echo "  --check          Check if formatting is needed without making changes"
      echo "  --diff           Show formatting differences without applying them"
      echo "  --line-length N  Set maximum line length (default: 88)"
      echo ""
      echo "Tools used:"
      echo "  • black    - Code formatter (PEP 8 compliant)"
      echo "  • isort    - Import statement organizer"  
      echo "  • flake8   - Code style checker and linter"
      echo ""
      echo "Features:"
      echo "  • Automatic tool installation if missing"
      echo "  • Import organization with isort"
      echo "  • Code formatting with black (88 char line length)"
      echo "  • Style checking with flake8"
      echo "  • Consistent formatting across entire project"
      echo "  • Compatible with popular CI/CD pipelines"
      echo ""
      echo "Examples:"
      echo "  pfmt                         # Format current directory"
      echo "  pfmt src/                    # Format specific directory"
      echo "  pfmt module.py               # Format specific file"
      echo "  pfmt --check                 # Check formatting without changes"
      echo "  pfmt --diff src/             # Show formatting differences"
      echo "  pfmt --line-length 100 .     # Use custom line length"
      echo ""
      echo "Configuration:"
      echo "  • Line length: 88 characters (black default)"
      echo "  • flake8 ignores: E203 (whitespace before :), W503 (line break before operator)"
      echo "  • isort profile: black (compatible with black formatting)"
      echo ""
      echo "Generated files:"
      echo "  Code is formatted in-place. Consider using version control."
      return 0
    fi
    
    local target="${1:-.}"
    local check_only=false
    local show_diff=false
    local line_length=88
    
    # Parse options
    while [[ $# -gt 0 ]]; do
      case $1 in
        --check)
          check_only=true
          shift
          ;;
        --diff)
          show_diff=true
          shift
          ;;
        --line-length)
          line_length="$2"
          shift 2
          ;;
        --line-length=*)
          line_length="${1#*=}"
          shift
          ;;
        -*)
          echo "Error: Unknown option '$1'"
          echo "Use 'pfmt --help' for usage information"
          return 1
          ;;
        *)
          target="$1"
          shift
          ;;
      esac
    done
    
    # Validate target exists
    if [[ ! -e "$target" ]]; then
      echo "Error: Target '$target' does not exist"
      return 1
    fi
    
    # Validate line length
    if ! [[ "$line_length" =~ ^[0-9]+$ ]] || [[ "$line_length" -lt 40 ]]; then
      echo "Error: Line length must be a number >= 40"
      return 1
    fi
    
    echo "🎨 Python code formatting and linting"
    echo "📍 Target: $target"
    echo "📏 Line length: $line_length"
    if [[ "$check_only" == true ]]; then
      echo "🔍 Check mode: will not modify files"
    elif [[ "$show_diff" == true ]]; then
      echo "📄 Diff mode: showing changes without applying"
    fi
    echo
    
    # Check and install required tools
    echo "📦 Checking required tools..."
    local tools_to_install=()
    
    if ! pip show black >/dev/null 2>&1; then
      tools_to_install+=("black")
    fi
    
    if ! pip show isort >/dev/null 2>&1; then
      tools_to_install+=("isort")
    fi
    
    if ! pip show flake8 >/dev/null 2>&1; then
      tools_to_install+=("flake8")
    fi
    
    if [[ ${#tools_to_install[@]} -gt 0 ]]; then
      echo "Installing required tools: ${tools_to_install[*]}"
      pip install "${tools_to_install[@]}" || {
        echo "Error: Failed to install required tools"
        return 1
      }
      echo
    else
      echo "✅ All required tools are installed"
      echo
    fi
    
    local overall_success=true
    
    # Run isort
    echo "🔄 Organizing imports with isort..."
    local isort_cmd="isort"
    if [[ "$check_only" == true ]]; then
      isort_cmd="$isort_cmd --check-only"
    elif [[ "$show_diff" == true ]]; then
      isort_cmd="$isort_cmd --diff"
    fi
    
    $isort_cmd --profile black "$target"
    if [[ $? -ne 0 ]]; then
      overall_success=false
      echo "⚠️  isort found issues"
    else
      echo "✅ Import organization complete"
    fi
    echo
    
    # Run black
    echo "🖤 Formatting code with black..."
    local black_cmd="black --line-length $line_length"
    if [[ "$check_only" == true ]]; then
      black_cmd="$black_cmd --check"
    elif [[ "$show_diff" == true ]]; then
      black_cmd="$black_cmd --diff"
    fi
    
    $black_cmd "$target"
    if [[ $? -ne 0 ]]; then
      overall_success=false
      echo "⚠️  black found formatting issues"
    else
      echo "✅ Code formatting complete"
    fi
    echo
    
    # Run flake8
    echo "🔍 Checking code style with flake8..."
    flake8 "$target" --max-line-length="$line_length" --extend-ignore=E203,W503
    if [[ $? -ne 0 ]]; then
      overall_success=false
      echo "⚠️  flake8 found style issues"
    else
      echo "✅ Code style check passed"
    fi
    echo
    
    # Final summary
    if [[ "$overall_success" == true ]]; then
      echo "🎉 Code formatting and linting complete!"
      if [[ "$check_only" == false && "$show_diff" == false ]]; then
        echo "   All files have been formatted and pass style checks"
      fi
    else
      echo "⚠️  Some issues were found during formatting/linting"
      if [[ "$check_only" == true ]]; then
        echo "   Run 'pfmt $target' to apply formatting fixes"
      fi
      return 1
    fi
  }
fi

