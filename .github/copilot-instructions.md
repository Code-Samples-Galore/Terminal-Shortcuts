# Copilot Coding Agent Instructions

## Repository Overview

**Terminal-Shortcuts** is a collection of bash aliases and shell functions designed to enhance terminal productivity. The project provides shortcuts for file operations, Git, Python development, Node.js, network utilities, system management, and more.

- **Type**: Shell script library (sourced into user's shell)
- **Language**: Shell, required to run in **both** Bash 4.0+ and Zsh 5.0+
- **Size**: ~6,700 lines across 17 shell script files, defining ~114 shortcuts
- **No build process**: Scripts are sourced directly, no compilation required
- **No CI/CD pipelines**: No GitHub Actions or automated tests exist

See `CLAUDE.md` in the repository root for the full portability rulebook.

## Repository Structure

```
Terminal-Shortcuts/
├── shortcuts.sh           # Main entry point - sources all other files (76 lines)
├── shortcuts.d/           # Shortcut function/alias definitions
│   ├── development_tools.sh    # hashit, calc, strconv, jsonpp, etc. (1778 lines)
│   ├── files_and_directories.sh # extract, compress, ff, backup, etc. (1126 lines)
│   ├── git.sh                   # gs, gc, gp, gitinfo, etc. (105 lines)
│   ├── list_shortcuts.sh        # sc function - lists all shortcuts (177 lines)
│   ├── network.sh               # isup, myip, ports, ping (241 lines)
│   ├── node_js.sh               # nvm shortcuts: nu, nl, ni (26 lines)
│   ├── programs.sh              # Editor aliases (17 lines)
│   ├── python.sh                # pipi, svenv, pytestcov, etc. (1072 lines)
│   ├── quick_edits.sh           # bashrc, vimrc, zshrc shortcuts (37 lines)
│   ├── system_utilities.sh      # sysinfo, killcmd, topcpu, etc. (409 lines)
│   └── wordlist_processing.sh   # wordlist filtering function (853 lines)
├── cheatsheets.d/         # Reference cheatsheet functions
│   ├── vim.sh                   # csvim - Vim cheatsheet (288 lines)
│   ├── tmux.sh                  # cstmux - tmux cheatsheet (107 lines)
│   ├── less.sh                  # csless - less cheatsheet (98 lines)
│   ├── terminal.sh              # csterminal - terminal shortcuts (153 lines)
│   └── terminator.sh            # csterminator - Terminator cheatsheet (162 lines)
├── CLAUDE.md              # Portability rules and contribution guide
├── README.md              # Comprehensive documentation
├── LICENSE                # MIT License
└── .gitignore             # Ignores .vscode/ directory
```

## Validation Commands

### Syntax Checking

**Always validate syntax in BOTH shells before committing:**

```bash
# Check all shortcut files in bash and zsh
for f in shortcuts.sh shortcuts.d/*.sh cheatsheets.d/*.sh; do
  bash -n "$f" && zsh -n "$f" && echo "OK: $f" || echo "FAIL: $f"
done
```

### Testing Shortcuts

```bash
# Source from an unrelated directory - this catches path-resolution bugs
(cd /tmp && bash -c 'source /path/to/Terminal-Shortcuts/shortcuts.sh && sc | head -20')
(cd /tmp && zsh  -c 'source /path/to/Terminal-Shortcuts/shortcuts.sh && sc | head -20')

# Exercise the function you changed in BOTH shells
for s in bash zsh; do
  $s -c 'source /path/to/Terminal-Shortcuts/shortcuts.sh; <function> <args>'
done
```

Testing only in bash is the most common way a broken change gets merged: zsh
differs on word splitting, array indexing, `${var^^}`, `PIPESTATUS`, unmatched
globs, and alias expansion during sourcing.

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

1. **Always call `cleanup_shortcut`** before defining any alias or function to prevent conflicts.
   The `cleanup_shortcut` list and the set of names actually defined in a file must match: a
   cleanup call for a name the repo no longer defines deletes the *user's own* alias.
2. **Always wrap definitions** in `if ! should_exclude "name" 2>/dev/null; then ... fi`
3. **Functions should have `--help` / `-h` support** that displays usage information
4. **Use cross-platform checks** for macOS vs Linux: `[[ "$OSTYPE" == "darwin"* ]]`
5. **Prefer `command -v`** over `which` to check command availability
6. **Use `echo` for output**, with emoji prefixes for visual organization (📁, 🔀, 🐍, etc.)
7. **Call aliased commands through `command`** inside function bodies. Aliases are expanded
   when a function body is parsed, so a bare `rm` becomes `rm -i`, `cp` becomes `cp -iv`, and
   `ping -c "$n"` becomes `ping -c 5 -c "$n"`. Use `command rm`, `command cp`, etc.
8. **Write bash/zsh-portable shell.** The full rule table lives in `CLAUDE.md`; the short
   version is: no `${var^^}`, no `${arr[0]}`, no `PIPESTATUS`, no `for x in $scalar`, no
   unquoted `$cmd` as a command, no bare globs in a `for` loop, and use
   `local x; x=$(cmd)` rather than `local x=$(cmd)` when you need the exit status.

### Adding to list_shortcuts.sh

When adding a new shortcut, update `shortcuts.d/list_shortcuts.sh` to include it in the `sc` output under the appropriate category.

### File Naming

- Shortcut files go in `shortcuts.d/` with `.sh` extension
- Cheatsheet files go in `cheatsheets.d/` with `.sh` extension
- Use underscores in filenames (e.g., `file_operations.sh`)

## Common Errors and Workarounds

### Sourcing Issues

`shortcuts.sh` resolves its own location from `${BASH_SOURCE[0]}` (bash) or
`${(%):-%x}` (zsh) and exports the result as `SHORTCUTS_DIR`. Do not replace
this with `dirname "$0"`: when a file is *sourced*, `$0` in bash is the name of
the running shell, so the loader silently found nothing unless the user
happened to be sitting in the repository directory.

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
2. **Run syntax checks**: `bash -n <file>.sh && zsh -n <file>.sh`
3. **Test by sourcing in both shells**: `source shortcuts.sh && <function_name> --help`
4. **Update `list_shortcuts.sh`** if adding or renaming shortcuts
5. **Update `README.md`** and the function's own `--help` text so they describe what
   the code actually does — both have drifted from reality before

## No Build/Test Infrastructure

This repository has no:
- Automated tests
- CI/CD pipelines
- Build steps
- Package managers

Validation is manual via `bash -n` / `zsh -n` syntax checking and interactive
testing in both shells.

## Trust These Instructions

These instructions are validated and accurate. Only search for additional information if:
- Instructions appear incomplete for a specific task
- You encounter an error not documented here
- The repository structure has changed from what is documented
