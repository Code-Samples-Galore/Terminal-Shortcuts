#!/bin/bash
# Node Version Manager Shortcuts
#
# Description: Convenient shortcuts for Node Version Manager (nvm) operations.
# Simplifies Node.js version management and switching between versions.
#
# Aliases:
#   nu         - Use Node version (nvm use)
#   nl         - List installed Node versions (nvm list)
#   ni         - Install Node version (nvm install)
#
# Usage Examples:
#   $ nl                         # List all installed Node versions
#   $ ni 18.17.0                 # Install Node.js version 18.17.0
#   $ nu 16.20.0                 # Switch to Node.js version 16.20.0
#   $ nu                         # Use Node version specified in .nvmrc

# Node Version Manager
if ! should_exclude "nu" 2>/dev/null; then alias nu="nvm use"; fi
if ! should_exclude "nl" 2>/dev/null; then alias nl="nvm list"; fi
if ! should_exclude "ni" 2>/dev/null; then alias ni="nvm install"; fi
