# Copilot Coding Agent Instructions

## Repository Overview

**Terminal-Shortcuts** is a collection of bash aliases and shell functions designed to enhance terminal productivity. The project provides shortcuts for file operations, Git, Python development, Node.js, network utilities, system management, and more.

- **Type**: Shell script library (sourced into user's shell)
- **Language**: Bash (compatible with zsh)
- **Size**: ~6,600 lines across 16 shell script files
- **No build process**: Scripts are sourced directly, no compilation required
- **No CI/CD pipelines**: No GitHub Actions or automated tests exist

## Repository Structure

```
Terminal-Shortcuts/
├── shortcuts.sh           # Main entry point - sources all other files
├── shortcuts.d/           # Shortcut function/alias definitions
│   ├── development_tools.sh    # hashit, calc, strconv, jsonpp, etc. (1679 lines)
│   ├── files_and_directories.sh # extract, compress, ff, backup, etc. (1218 lines)
│   ├── git.sh                   # gs, gc, gp, gitinfo, etc. (99 lines)
│   ├── list_shortcuts.sh        # sc function - lists all shortcuts (177 lines)
│   ├── network.sh               # isup, myip, ports, ping (235 lines)
│   ├── node_js.sh               # nvm shortcuts: nu, nl, ni (26 lines)
│   ├── programs.sh              # Editor aliases (17 lines)
│   ├── python.sh                # pipi, svenv, pytestcov, etc. (1036 lines)
│   ├── quick_edits.sh           # bashrc, vimrc, zshrc shortcuts (37 lines)
│   ├── system_utilities.sh      # sysinfo, killcmd, topcpu, etc. (386 lines)
│   └── wordlist_processing.sh   # wordlist filtering function (839 lines)
├── cheatsheets.d/         # Reference cheatsheet functions
│   ├── vim.sh                   # csvim - Vim cheatsheet (288 lines)
│   ├── tmux.sh                  # cstmux - tmux cheatsheet (107 lines)
│   ├── less.sh                  # csless - less cheatsheet (98 lines)
│   ├── terminal.sh              # csterminal - terminal shortcuts (153 lines)
│   └── terminator.sh            # csterminator - Terminator cheatsheet (162 lines)
├── README.md              # Comprehensive documentation
├── LICENSE                # MIT License
└── .gitignore             # Ignores .vscode/ directory
```

## Validation Commands

### Syntax Checking

**Always validate shell script syntax before committing:**

```bash
# Check a single file
bash -n <filename>.sh

# Check all shortcut files
for f in shortcuts.d/*.sh cheatsheets.d/*.sh shortcuts.sh; do
  bash -n "$f" && echo "OK: $f" || echo "FAIL: $f"
done
```

### Testing Shortcuts

```bash
# Source shortcuts and verify they load
cd /path/to/Terminal-Shortcuts
source shortcuts.sh

# Test the sc function lists all shortcuts
sc | head -20

# Test a specific function
type <function_name>
```

## Code Patterns and Conventions

### Adding New Shortcuts

Each shortcut file follows this pattern:

```bash
#!/bin/bash
# Function Name
#
# Description: What the function does
#
# Functions:
#   func1    - Description
#   func2    - Description
#
# Aliases:
#   alias1   - Description
#
# Usage Examples:
#   $ func1 arg1 arg2

# Cleanup existing definitions
cleanup_shortcut "func_name"

# Define with exclusion check
if ! should_exclude "func_name" 2>/dev/null; then
  func_name() {
    # Implementation
  }
fi
```

### Key Conventions

1. **Always call `cleanup_shortcut`** before defining any alias or function to prevent conflicts
2. **Always wrap definitions** in `if ! should_exclude "name" 2>/dev/null; then ... fi`
3. **Functions should have `--help` / `-h` support** that displays usage information
4. **Use cross-platform checks** for macOS vs Linux: `[[ "$OSTYPE" == "darwin"* ]]`
5. **Prefer `command -v`** over `which` to check command availability
6. **Use `echo` for output**, with emoji prefixes for visual organization (📁, 🔀, 🐍, etc.)

### Adding to list_shortcuts.sh

When adding a new shortcut, update `shortcuts.d/list_shortcuts.sh` to include it in the `sc` output under the appropriate category.

### File Naming

- Shortcut files go in `shortcuts.d/` with `.sh` extension
- Cheatsheet files go in `cheatsheets.d/` with `.sh` extension
- Use underscores in filenames (e.g., `file_operations.sh`)

## Common Errors and Workarounds

### Sourcing Issues

If functions don't load, ensure `SCRIPT_DIR` is correctly resolved in `shortcuts.sh`. The script uses `dirname "$0"` which may fail in some edge cases.

### Exclusion Feature

The `EXCLUDE_SHORTCUTS` environment variable allows users to exclude specific shortcuts:
```bash
export EXCLUDE_SHORTCUTS="p hashit sc"
source shortcuts.sh
```

### Cross-Platform Commands

Many functions have OS-specific implementations. Check for:
- `ifconfig` vs `ip addr` (network)
- `netstat` vs `ss` (ports)
- `stat` differences between macOS and Linux

## Making Changes

1. **Edit the appropriate file** in `shortcuts.d/` or `cheatsheets.d/`
2. **Run syntax check**: `bash -n <file>.sh`
3. **Test by sourcing**: `source shortcuts.sh && <function_name> --help`
4. **Update `list_shortcuts.sh`** if adding new shortcuts
5. **Update `README.md`** if adding significant features

## No Build/Test Infrastructure

This repository has no:
- Automated tests
- CI/CD pipelines
- Build steps
- Package managers

Validation is manual via `bash -n` syntax checking and interactive testing.

## Trust These Instructions

These instructions are validated and accurate. Only search for additional information if:
- Instructions appear incomplete for a specific task
- You encounter an error not documented here
- The repository structure has changed from what is documented
