#!/bin/bash
# Shortcuts List Display Function
#
# Description: Displays all defined shortcuts with descriptions organized by category.
# Provides a quick reference for available shortcuts and their purposes.
#
# Usage: sc
# Example: $ sc  # Shows all shortcuts with descriptions

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "sc"

if ! should_exclude "sc" 2>/dev/null; then
  sc() {
    echo "=== AVAILABLE SHORTCUTS ==="
    echo
    
    echo "📚 Cheatsheets:"
    echo "  csvim       - Display comprehensive Vim cheatsheet with custom configs"
    echo "  cstmux      - Display comprehensive tmux cheatsheet with sessions, windows, and panes"
    echo "  csless      - Display comprehensive less cheatsheet with navigation and search"
    echo "  csterminator - Display comprehensive Terminator cheatsheet with splits and layouts"
    echo

    echo "🛠️ Development Tools:"
    echo "  base64conv  - Encode/decode base64 strings, files, or stdin"
    echo "  binconv     - Convert string, integer, or stdin to binary representation"
    echo "  calc        - Perform mathematical calculations with expressions"
    echo "  entropy     - Calculate Shannon entropy of strings, files, or stdin"
    echo "  hashit      - Compute hash of strings, files, or stdin (md5/sha1/sha256/sha512)"
    echo "  hexconv     - Encode/decode hex strings, files, or stdin"
    echo "  jsonpp      - Pretty-print JSON files or stdin"
    echo "  log2        - Calculate base-2 logarithm of positive integers"
    echo "  randstr     - Generate secure random passwords with custom length"
    echo "  replace     - Find and replace text in strings, files, or stdin"
    echo "  wordlist    - Advanced wordlist filtering, processing and manipulation"
    echo "                • Comprehensive filtering by length, character types, entropy, regex"
    echo "                • Sort, remove duplicates, randomize word order"
    echo "                • Split output by size (MB/GB) or percentage distribution"
    echo "                • Memory-efficient streaming for large files"
    echo "                • Case-sensitive/insensitive regex matching"
    echo "                • Extensive usage examples and help system"
    echo

    echo "📁 Files and Directories:"
    echo "  ..          - Go up one directory"
    echo "  ...         - Go up two directories"
    echo "  ....        - Go up three directories"
    echo "  ~           - Go to home directory"
    echo "  backup      - Create timestamped backup of files/folders with optional compression"
    echo "  chgrp       - chgrp with preserve-root safety"
    echo "  chmod       - chmod with preserve-root safety" 
    echo "  chown       - chown with preserve-root safety"
    echo "  compress    - Create any type of archive file (with volume splitting support)"
    echo "  cp          - Copy with interactive"
    echo "  extract     - Extract any type of archive file"
    echo "  ff          - Find files by name pattern"
    echo "  grep        - Grep with color highlighting"
    echo "  l           - List files in columns (ls -CF)"
    echo "  la          - List all files including hidden (ls -la)"
    echo "  ll          - List files with details (ls -lh)"
    echo "  le          - View file with less"
    echo "  less        - Enhanced less (less -Ni --mouse --use-color)"
    echo "  mkdir       - Create directories with verbose output"
    echo "  mkcd        - Create directory and navigate into it"
    echo "  mv          - Move with interactive"
    echo "  rm          - Remove with interactive"
    echo "  search      - Search for text in files with basic/extended regex, case sensitivity, and optional .gz file support"
    echo "  tree        - Tree view with colors"
    echo "  tle         - View file with less, start at end (+G)"
    echo "  watchdir    - Monitor directory contents in real-time"
    echo "  watchfile   - Monitor file changes in real-time"
    echo 
    
    echo "🔀 Git:"
    echo "  ga          - Git add"
    echo "  gaa         - Git add all files"
    echo "  gac         - Git add all and commit with auto message"
    echo "  gb          - Git branch"
    echo "  gc          - Git commit with message"
    echo "  gcb         - Git checkout new branch"
    echo "  gco         - Git checkout"
    echo "  gd          - Git diff"
    echo "  gdc         - Git diff cached"
    echo "  gitinfo     - Display Git repository information"
    echo "  gl          - Git log one line"
    echo "  gp          - Git push"
    echo "  gr          - Git remove from cache"
    echo "  gs          - Git status"
    echo "  gu          - Git pull"
    echo   
  
    echo "📚 Help:"
    echo "  sc          - Show this complete function reference"
    echo

    echo "🌐 Network:"
    echo "  fastping    - Fast ping test (100 packets)"
    echo "  isup        - Check if website is accessible"
    echo "  myip        - Display local and external IP addresses"
    echo "  ping        - Ping 5 times"
    echo "  ports       - Show network ports and connections"
    echo "  wget        - Wget with continue option"
    echo    

    echo "📦 Node.js:"
    echo "  ni          - Install Node version (nvm install)"
    echo "  nl          - List Node versions (nvm list)"
    echo "  nu          - Use Node version (nvm use)"
    echo

    echo "🚀 Programs:"
    echo "  so          - Source a file (reload shell config)"
    echo "  ta          - Tmux attach to session (tmux attach -t)"
    echo "  v           - Vim editor"
    echo

    echo "🐍 Python:"
    echo "  p           - Python3"
    echo "  pipi        - Install Python package(s) or from requirements file"
    echo "  pipl        - List installed packages (pip list)"
    echo "  pipu        - Upgrade Python package(s), all packages, or from requirements.txt"
    echo "  pm          - Run Python modules using file path notation"
    echo "  svenv       - Auto-activate Python virtual environment"
    echo "  cdsvenv     - Navigate to project directory and activate virtual environment"
    echo    

    echo "✏️ Quick Edits:"
    echo "  bashrc      - Edit ~/.bashrc"
    echo "  vimrc       - Edit ~/.vimrc"
    echo "  zshrc       - Edit ~/.zshrc"
    echo
    
    echo "⚙️ System Utilities:"
    echo "  h           - Show command history"
    echo "  killcmd     - Kill processes by command name"
    echo "  now         - Show current time and date"
    echo "  nowdate     - Show current date"
    echo "  nowtime     - Show current time"
    echo "  path        - Display PATH variable (formatted)"
    echo "  sctllog     - View systemd service logs (journalctl -ru)"
    echo "  sctlrestart - Restart systemd service (systemctl restart)"
    echo "  sctlstart   - Start systemd service (systemctl start)"
    echo "  sctlstatus  - Check systemd service status (systemctl status)"
    echo "  sctlstop    - Stop systemd service (systemctl stop)"
    echo "  sctlwatch   - Watch systemd service logs in real-time (journalctl -fu)"
    echo "  sysinfo     - Display comprehensive system information (OS, CPU, memory, disk)"
    echo "  topcpu      - Show top processes by CPU usage"
    echo "  topmem      - Show top processes by memory usage"
    echo

    echo "🚫 Exclusion Feature:"
    echo "Use EXCLUDE_SHORTCUTS environment variable to exclude specific aliases/functions:"
    echo "  export EXCLUDE_SHORTCUTS=\"p hashit sc\""
    echo "  source shortcuts.sh"
    echo
  }
fi
