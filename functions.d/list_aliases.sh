#!/bin/bash
# Alias List Display Function
#
# Description: Displays all defined aliases with descriptions organized by category.
# Provides a quick reference for available shortcuts and their purposes.
#
# Usage: aliaslist
# Example: $ aliaslist  # Shows all aliases with descriptions

aliaslist() {
  echo "=== AVAILABLE ALIASES ==="
  echo
  
  echo "📁 File and Directory Operations:"
  echo "  ll          - List files with details (ls -lha)"
  echo "  la          - List all files including hidden (ls -la)"
  echo "  l           - List files in columns (ls -CF)"
  echo "  ..          - Go up one directory"
  echo "  ...         - Go up two directories"
  echo "  ....        - Go up three directories"
  echo "  ~           - Go to home directory"
  echo "  mkdir       - Create directories with verbose output"
  echo "  cp          - Copy with interactive and verbose flags"
  echo "  mv          - Move with interactive and verbose flags"
  echo "  rm          - Remove with interactive and verbose flags"
  echo "  grep        - Grep with color highlighting"
  echo "  tree        - Tree view with colors"
  echo
  
  echo "📦 Node Version Manager:"
  echo "  nu          - Use Node version (nvm use)"
  echo "  nl          - List Node versions (nvm list)"
  echo "  ni          - Install Node version (nvm install)"
  echo
  
  echo "🔀 Git Operations:"
  echo "  gs          - Git status"
  echo "  gc          - Git commit with message"
  echo "  gp          - Git push"
  echo "  gu          - Git pull"
  echo "  ga          - Git add"
  echo "  gaa         - Git add all files"
  echo "  gb          - Git branch"
  echo "  gco         - Git checkout"
  echo "  gcb         - Git checkout new branch"
  echo "  gl          - Git log one line"
  echo "  gd          - Git diff"
  echo "  gdc         - Git diff cached"
  echo
  
  echo "⚙️  System Utilities:"
  echo "  h           - Show command history"
  echo "  j           - Show jobs list"
  echo "  path        - Display PATH variable (formatted)"
  echo "  now         - Show current time"
  echo "  nowtime     - Show current time (alias for now)"
  echo "  nowdate     - Show current date"
  echo
  
  echo "🌐 Network and Process:"
  echo "  ports       - Show network ports and connections"
  echo "  wget        - Wget with continue option"
  echo "  ping        - Ping 5 times"
  echo "  fastping    - Fast ping test (100 packets)"
  echo
  
  echo "🛡️  Safety Aliases:"
  echo "  chown       - chown with preserve-root safety"
  echo "  chmod       - chmod with preserve-root safety" 
  echo "  chgrp       - chgrp with preserve-root safety"
  echo
  
  echo "✏️  Quick Edits:"
  echo "  bashrc      - Edit ~/.bashrc"
  echo "  zshrc       - Edit ~/.zshrc"
  echo "  vimrc       - Edit ~/.vimrc"
  echo
  
  echo "🚀 Programs:"
  echo "  v           - Vim editor"
  echo "  n           - Nano editor"
  echo "  e           - Emacs editor"
  echo "  p           - Python3"
  echo
  
  echo "📋 Custom Functions:"
  echo "  🖥️  System Information & Utilities:"
  echo "    sysinfo     - Display comprehensive system information"
  echo
  echo "  🐍 Python Development:"
  echo "    svenv       - Auto-activate Python virtual environment"
  echo
  echo "  ⚙️  Process Management:"
  echo "    killcmd     - Kill processes by command name"
  echo "    topcpu      - Show top processes by CPU usage"
  echo "    topmem      - Show top processes by memory usage"
  echo
  echo "  🌐 Network Monitoring:"
  echo "    isup        - Check if website is accessible"
  echo "    watchlog    - Monitor log file changes in real-time"
  echo "    weather     - Get weather information for a city"
  echo
  echo "  🔀 Git Enhancements:"
  echo "    gac         - Git add all and commit with auto message"
  echo "    gitinfo     - Display Git repository information"
  echo
  echo "  📁 File Operations:"
  echo "    extract     - Extract any type of archive file"
  echo "    mkcd        - Create directory and navigate into it"
  echo "    ff          - Find files by name pattern"
  echo "    replace     - Find and replace text in files"
  echo "    backup      - Create timestamped backup of file"
  echo
  echo "  🛠️  Development Tools:"
  echo "    jsonpp      - Pretty-print JSON files"
  echo "    genpass     - Generate secure random passwords"
  echo "    calc        - Perform mathematical calculations"
  echo
  echo "  📚 Help:"
  echo "    aliaslist   - Show this complete function reference"
  echo
}
