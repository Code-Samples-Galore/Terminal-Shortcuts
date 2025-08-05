#!/bin/bash
# Program Shortcuts
#
# Description: Quick access aliases and functions for common programs and tools.
# Provides shortcuts for editors, terminal multiplexers, and other utilities.
#
# Aliases:
#   v          - Vim editor
#   so         - Source a file (reload shell config)
#   ta         - Tmux attach
#
# Usage Examples:
#   $ v file.txt                 # Open file in Vim
#   $ so ~/.bashrc               # Source bashrc
#   $ ta session_name             # Attach to a tmux session

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "ta"
cleanup_shortcut "v"
cleanup_shortcut "so"

# Programs
if ! should_exclude "ta" 2>/dev/null; then alias ta='tmux attach -t'; fi
if ! should_exclude "v" 2>/dev/null; then alias v='vim'; fi
if ! should_exclude "so" 2>/dev/null; then alias so='source'; fi
