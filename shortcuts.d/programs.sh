#!/bin/bash
# Program Shortcuts
#
# Description: Quick access shortcuts for commonly used programs and editors.
# Simple aliases to reduce typing for frequently accessed tools.
#
# Aliases:
#   v          - Vim editor
#   so         - Source a file (reload shell config)
#
# Usage Examples:
#   $ v file.txt                 # Open file in Vim
#   $ so ~/.bashrc               # Source bashrc

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "v"
cleanup_shortcut "so"

# Programs
if ! should_exclude "v" 2>/dev/null; then alias v='vim'; fi
if ! should_exclude "so" 2>/dev/null; then alias so='source'; fi
