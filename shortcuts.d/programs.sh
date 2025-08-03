#!/bin/bash
# Program Shortcuts
#
# Description: Quick access shortcuts for commonly used programs and editors.
# Simple aliases to reduce typing for frequently accessed tools.
#
# Aliases:
#   v          - Vim editor
#
# Usage Examples:
#   $ v file.txt                 # Open file in Vim

# Programs
if ! should_exclude "v" 2>/dev/null; then alias v='vim'; fi
