#!/bin/bash
# Quick Configuration File Edits
#
# Description: Instant access shortcuts for editing common configuration files.
# Opens frequently modified dotfiles in Vim for quick configuration changes.
#
# Aliases:
#   bashrc     - Edit ~/.bashrc in Vim
#   zshrc      - Edit ~/.zshrc in Vim
#   vimrc      - Edit ~/.vimrc in Vim
#
# Usage Examples:
#   $ bashrc                     # Edit Bash configuration
#   $ zshrc                      # Edit Zsh configuration
#   $ vimrc                      # Edit Vim configuration

# Quick edits
if ! should_exclude "bashrc" 2>/dev/null; then alias bashrc='vim ~/.bashrc'; fi
if ! should_exclude "zshrc" 2>/dev/null; then alias zshrc='vim ~/.zshrc'; fi
if ! should_exclude "vimrc" 2>/dev/null; then alias vimrc='vim ~/.vimrc'; fi
