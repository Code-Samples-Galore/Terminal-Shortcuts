#!/bin/bash
# Program Shortcuts
#
# Description: Quick access aliases and functions for common programs and tools.
# Provides shortcuts for editors, terminal multiplexers, and other utilities.
#
# Aliases:
#   v          - Vim editor
#
# Usage Examples:
#   $ v file.txt                 # Open file in Vim

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "v"

# Programs
if ! should_exclude "v" 2>/dev/null; then alias v='vim'; fi
