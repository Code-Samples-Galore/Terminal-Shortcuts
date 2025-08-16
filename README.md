# Terminal Shortcuts Collection

A comprehensive collection of bash aliases and functions designed to enhance terminal productivity and streamline common development tasks.

## 🚀 Quick Start

### Installation

1. Clone or download this repository:

```bash
git clone <repository-url> ~/terminal_shortcuts
# or download and extract to ~/terminal_shortcuts
```

2. Add to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# Add this line to source all terminal shortcuts
source ~/terminal_shortcuts/shortcuts.sh
```

3. Reload your shell or run:

```bash
source ~/.bashrc  # or ~/.zshrc
```

### Quick Reference

Use `sc` command to see all available shortcuts and their descriptions.

## 📋 Features Overview

### 📁 File and Directory Operations

- **Enhanced file listing**: `ll`, `la`, `l` with colors and details
- **Smart navigation**: `..`, `...`, `....` for quick directory traversal
- **Archive operations**: Universal `extract` and `compress` functions for any archive type with volume splitting support
- **File operations**: Find files (`ff`), find-and-replace (`replace`), timestamped backups (`backup`)
- **Directory creation**: `mkcd` to create and enter directories
- **Monitoring**: `watchfile` for real-time file monitoring and `watchdir` for directory content monitoring
- **File viewing**: `less` (enhanced), `le` (less), `tle` (less +G)

### 🔀 Git Enhancements

- **Quick git operations**: `gs`, `gc`, `gp`, `ga`, etc.
- **Auto-commit**: `gac` with intelligent commit messages
- **Repository info**: `gitinfo` for comprehensive repo status
- **Branch management**: Simplified checkout and branch creation

### 🖥️ System Information & Monitoring

- **System overview**: `sysinfo` for comprehensive system details (OS, CPU, memory, GPU, disk)
- **Process management**: `killcmd` with interactive confirmation for killing processes by name
- **Resource monitoring**: `topcpu`, `topmem` for CPU and memory usage
- **Time utilities**: `now`, `nowtime`, `nowdate` for current time/date
- **History access**: `h` for command history, `path` for formatted PATH display
- **Service management**: `sctlstart`, `sctlstop`, `sctlrestart`, `sctlstatus` for systemctl operations
- **Log monitoring**: `sctllog` for service logs, `sctlwatch` for real-time log monitoring
- **Nginx management**: `nginxstart`, `nginxstop`, `nginxrestart`, `nginxstatus` for nginx service control
- **Nginx configuration**: `nginxconf` for config editing, `nginxtest` for syntax validation, `nginxreload` for config reload

### 🌐 Network Utilities

- **Website monitoring**: `isup` to check if websites are accessible
- **IP information**: `myip` for local and external IP addresses
- **Network monitoring**: `ports` for active connections
- **Enhanced ping**: Standard and fast ping options

### 🐍 Python Development

- **Virtual environment**: `svenv` for automatic venv activation, `cdsvenv` for navigate and activate
- **Create and bootstrap venv**: `cvenv` to create .venv with conda’s Python, activate it, and upgrade pip
- **Quick Python access**: `p` alias for python3
- **Package management**: `pipi`, `pupu`, `pipl` for pip operations
- **Module execution**: `pm` for running Python modules using file paths

### 📦 Node.js Development

- **Version management**: `nu`, `nl`, `ni` for nvm operations
- **Quick switching**: Easy Node.js version switching

### ✏️ Quick Configuration Access

- **Config editing**: `bashrc`, `zshrc`, `vimrc` for instant config file access
- **Config reloading**: `sobashrc`, `sozshrc` for quick shell configuration reload

### 🚀 Program Shortcuts

- **Editor access**: `v` for Vim
- **Source config**: `so` for source (reload shell config)

### 🛠️ Development Tools

- **Hash computation**: `hashit` for MD5, SHA1, SHA256, SHA512 hashing of strings, files, or stdin
- **Password generation**: `randstr` for secure random passwords
- **String/data conversion**: `strconv` for converting between hex, base64, and binary formats
- **Number base conversion**: `numconv` for converting numbers between different bases (2-36) with auto-detection
- **Entropy analysis**: `entropy` for calculating Shannon entropy of strings, files, or stdin
- **Mathematical calculations**: `calc`, `log2`, and `pow2` functions
- **JSON formatting**: `jsonpp` for pretty-printing JSON

### 📝 Wordlist Processing

- **Advanced filtering**: Filter by length, character types, entropy, regex patterns
- **Data processing**: Sort, remove duplicates, randomize word order
- **Output options**: Split by size (MB/GB) or percentage distribution
- **Memory efficiency**: Streaming processing for large files
- **Pattern matching**: Case-sensitive/insensitive regex support

### 📚 Cheatsheets

- **Vim reference**: `csvim` for comprehensive Vim usage guide including custom configurations
- **tmux reference**: `cstmux` for terminal multiplexer usage with sessions, windows, and panes
- **less reference**: `csless` for file viewer navigation, search, and advanced features
- **Terminator reference**: `csterminator` for advanced terminal emulator with splits and layouts

## 📖 Detailed Function Reference

### System Information (`sysinfo`)

Displays comprehensive system information including:

- OS details and kernel version
- CPU specifications and core count
- Memory usage and availability
- GPU information (NVIDIA, macOS, Linux)
- Disk usage statistics

```bash
$ sysinfo
=== SYSTEM INFORMATION ===
OS Information:
Hostname: my-computer
OS: Darwin
Kernel: 21.6.0
...
```

### Process Management (`killcmd`)

Interactive process termination by command name:

```bash
$ killcmd firefox
=== KILL COMMAND ===
Searching for processes containing: 'firefox'
Found 3 matching process(es):
PID: 1234 - /Applications/Firefox.app/Contents/MacOS/firefox
Kill all these processes? (y/N):
```

### Network Monitoring (`isup`, `myip`)

Check website availability:

```bash
$ isup google.com
google.com is UP

$ isup badsite.xyz
badsite.xyz is DOWN
```

Show IP address information:

```bash
$ myip
=== IP ADDRESS INFORMATION ===

Local IP Address:
  192.168.1.100

External IP Address:
  203.0.113.45
```

### Development Tools

#### Hash Calculator (`hashit`)
Compute various hash functions for strings, files, or stdin:

```bash
$ hashit sha256 "hello world"     # Hash a string
$ hashit md5 myfile.txt          # Hash a file
$ echo "data" | hashit sha1 -    # Hash stdin
$ hashit sha512 "secret data"    # SHA512 hash
```

#### Entropy Calculator (`entropy`)
Calculate Shannon entropy for strings, files, or stdin to measure randomness/complexity:

```bash
$ entropy "hello world"          # Calculate entropy of string
$ entropy passwords.txt          # Calculate entropy of file contents
$ echo "random data" | entropy - # Calculate entropy of stdin
```

Entropy values range from 0 (completely predictable) to ~8 (maximum randomness for byte data).

#### String/Data Converter (`strconv`)
Convert between different data encodings and representations:

```bash
$ strconv hex "hello"              # Encode to hex: 68656c6c6f
$ strconv hex-decode "68656c6c6f"  # Decode hex: hello
$ strconv base64 "hello world"     # Encode to Base64: aGVsbG8gd29ybGQ=
$ strconv b64-d "aGVsbG8gd29ybGQ="  # Decode Base64: hello world
$ strconv bin 255                  # Integer to binary: 11111111
$ strconv bin "A"                  # String to binary: 01000001
$ echo "data" | strconv hex -      # Encode stdin to hex
$ cat file.txt | strconv base64 -  # Encode file to Base64
```

Supports:
- **Hexadecimal**: `hex` (encode), `hex-decode`/`hex-d` (decode)
- **Base64**: `base64`/`b64` (encode), `base64-decode`/`b64-d` (decode)
- **Binary**: `bin`/`binary` (integers to binary numbers, strings to ASCII binary)

### Cheatsheets (`csvim`, `cstmux`, `csless`, `csterminator`)

#### Vim Cheatsheet (`csvim`)
Comprehensive Vim cheatsheet covering:

- Basic usage and modes (normal, insert, visual)
- Navigation commands and movement
- Editing operations (cut, copy, paste, undo/redo)
- Search and replace functionality
- File operations and buffer management
- Window splits and tab management
- Folding operations
- Custom leader key mappings (Leader = \)
- Plugin shortcuts (NERDTree, Tagbar, ALE)
- Autoclose features for quotes and brackets
- Advanced tips and configuration features

```bash
$ csvim
=== VIM CHEATSHEET ===

🚀 BASIC USAGE:
  vim [file]      - Open file in vim
  vim +[line]     - Open file at specific line
  ...
```

#### tmux Cheatsheet (`cstmux`)
Comprehensive tmux cheatsheet covering:

- Session management (create, attach, detach, list)
- Window operations (create, switch, rename, close)
- Pane management (split, navigate, resize, zoom)
- Copy mode and text selection
- Key bindings and prefix commands
- Configuration tips and common settings
- Workflow examples and best practices

```bash
$ cstmux
=== TMUX CHEATSHEET ===

🚀 BASIC USAGE:
  tmux                - Start new session
  tmux new -s name    - Start new session with name
  tmux attach -t name - Attach to named session
  ...
```

#### less Cheatsheet (`csless`)
Comprehensive less cheatsheet covering:

- Basic file viewing and navigation
- Forward and backward movement (screens, lines, half-screens)
- Search functionality (forward, backward, filtering)
- Marks and position management
- File operations and multiple file handling
- Display options and customization
- Color and highlighting features
- Horizontal scrolling for long lines
- Command-line options and environment variables
- Advanced search with regular expressions
- Common workflows and pro tips

```bash
$ csless
=== LESS CHEATSHEET ===

🚀 BASIC USAGE:
  less file.txt       - Open file with less
  cat file | less     - Pipe output to less
  less +G file.txt    - Open file at end
  ...
```

#### Terminator Cheatsheet (`csterminator`)
Comprehensive Terminator cheatsheet covering:

- Window and terminal management
- Terminal splitting (horizontal and vertical)
- Tab management and navigation
- Terminal resizing and arrangement
- Search and find functionality
- Copy, paste, and text selection
- Display options and zoom controls
- Profiles and layout management
- Broadcasting and terminal grouping
- Configuration file examples
- Command-line options and startup
- Plugin system and customization
- Common workflows and tips

```bash
$ csterminator
=== TERMINATOR CHEATSHEET ===

🚀 BASIC USAGE:
  terminator              - Start Terminator
  terminator -l layout    - Start with specific layout
  terminator -x command   - Execute command in new window
  ...
```

## 🎯 Complete Aliases and Functions Reference

### 📚 Cheatsheets
- `csvim` - Display comprehensive Vim cheatsheet with custom configurations
- `cstmux` - Display comprehensive tmux cheatsheet with sessions, windows, and panes
- `csless` - Display comprehensive less cheatsheet with navigation and search
- `csterminator` - Display comprehensive Terminator cheatsheet with splits and layouts

### 📁 File and Directory Operations
- `ll` - List files with details (ls -lh)
- `la` - List all files including hidden (ls -la)
- `l` - List files in columns (ls -CF)
- `..` - Go up one directory
- `...` - Go up two directories
- `....` - Go up three directories
- `~` - Go to home directory
- `mkdir` - Create directories with verbose output
- `mkcd` - Create directory and navigate into it
- `cp` - Copy with interactive and verbose flags
- `mv` - Move with interactive and verbose flags
- `rm` - Remove with interactive and verbose flags
- `grep` - Grep with color highlighting
- `tree` - Tree view with colors
- `extract` - Extract any type of archive file
- `compress` - Create any type of archive file with volume splitting support
- `ff` - Find files by name pattern
- `search` - Search for text in files with basic/extended regex, case sensitivity, and optional .gz file support
- `replace` - Find and replace text in strings, files, or stdin
- `backup` - Create timestamped backup of files/folders with optional compression
- `watchlog` - Monitor log file changes in real-time
- `watchdir` - Monitor directory contents in real-time
- `chown` - chown with preserve-root safety
- `chmod` - chmod with preserve-root safety
- `chgrp` - chgrp with preserve-root safety
- `less` - Enhanced less (less -Ni --mouse --use-color)
- `le` - View file with less
- `tle` - View file with less, start at end (+G)

### 📦 Node Version Manager
- `nu` - Use Node version (nvm use)
- `nl` - List Node versions (nvm list)
- `ni` - Install Node version (nvm install)

### 🔀 Git Operations
- `gs` - Git status
- `gc` - Git commit with message
- `gp` - Git push
- `gu` - Git pull
- `ga` - Git add
- `gaa` - Git add all files
- `gac` - Git add all and commit with auto message
- `gb` - Git branch
- `gco` - Git checkout
- `gcb` - Git checkout new branch
- `gl` - Git log one line
- `gd` - Git diff
- `gdc` - Git diff cached
- `gr` - Git remove from cache
- `gitinfo` - Display Git repository information

### ⚙️ System Utilities
- `h` - Show command history
- `path` - Display PATH variable (formatted)
- `now` - Show current time and date
- `nowtime` - Show current time
- `nowdate` - Show current date
- `nginxreload` - Reload nginx configuration (nginx -s reload)
- `nginxrestart` - Restart nginx service (systemctl restart nginx)
- `nginxstart` - Start nginx service (systemctl start nginx)
- `nginxstatus` - Check nginx service status (systemctl status nginx)
- `nginxstop` - Stop nginx service (systemctl stop nginx)
- `nginxtest` - Test nginx configuration syntax (nginx -t)
- `sctlstart` - Start systemd service (systemctl start)
- `sctlstop` - Stop systemd service (systemctl stop)  
- `sctlrestart` - Restart systemd service (systemctl restart)
- `sctlstatus` - Check systemd service status (systemctl status)
- `sctllog` - View systemd service logs (journalctl -ru)
- `sctlwatch` - Watch systemd service logs in real-time (journalctl -fu)
- `so` - Source a file (reload shell config)
- `sysinfo` - Display comprehensive system information
- `killcmd` - Kill processes by command name
- `ta` - Tmux attach to session (tmux attach -t)
- `topcpu` - Show top processes by CPU usage
- `topmem` - Show top processes by memory usage

### 🌐 Network
- `ports` - Show network ports and connections
- `wget` - Wget with continue option
- `ping` - Ping 5 times
- `fastping` - Fast ping test (100 packets)
- `isup` - Check if website is accessible
- `myip` - Display local and external IP addresses

### ✏️ Quick Edits
- `bashrc` - Edit ~/.bashrc
- `nginxconf` - Edit nginx main configuration file (/etc/nginx/nginx.conf)
- `sobashrc` - Source ~/.bashrc (reload Bash configuration)
- `sozshrc` - Source ~/.zshrc (reload Zsh configuration)
- `vimrc` - Edit ~/.vimrc
- `zshrc` - Edit ~/.zshrc

### 🚀 Programs
- `v` - Vim editor

### 🐍 Python
- `p` - Python3
- `pm` - Run Python modules using file path
- `pipi` - Install Python package(s) or from requirements file
- `pupu` - Upgrade Python package(s), all packages, or from requirements.txt
- `pipl` - List installed packages (pip list)
- `svenv` - Auto-activate Python virtual environment
- `cdsvenv` - Navigate to project directory and activate virtual environment
- `cvenv` - Create .venv with conda's Python, activate, and upgrade pip

### 🛠️ Development Tools
- `calc` - Perform mathematical calculations with expressions
- `entropy` - Calculate Shannon entropy of strings, files, or stdin
- `hashit` - Compute hash of strings, files, or stdin (md5/sha1/sha256/sha512)
- `jsonpp` - Pretty-print JSON files or stdin
- `log2` - Calculate base-2 logarithm of positive integers
- `numconv` - Convert numbers between different bases (binary, octal, decimal, hex, custom 2-36)
- `pow2` - Calculate powers of 2 (2^X) for given integer exponents
- `randstr` - Generate secure random passwords with custom length
- `replace` - Find and replace text in strings, files, or stdin
- `strconv` - Convert strings/data between encodings (hex, base64, binary)
- `wordlist` - Advanced wordlist filtering, processing and manipulation

## 📄 License

MIT License
- `gitinfo` - Display Git repository information

### ⚙️ System Utilities
- `h` - Show command history
- `path` - Display PATH variable (formatted)
- `now` - Show current time and date
- `nowtime` - Show current time
- `nowdate` - Show current date
- `nginxreload` - Reload nginx configuration (nginx -s reload)
- `nginxrestart` - Restart nginx service (systemctl restart nginx)
- `nginxstart` - Start nginx service (systemctl start nginx)
- `nginxstatus` - Check nginx service status (systemctl status nginx)
- `nginxstop` - Stop nginx service (systemctl stop nginx)
- `nginxtest` - Test nginx configuration syntax (nginx -t)
- `sctlstart` - Start systemd service (systemctl start)
- `sctlstop` - Stop systemd service (systemctl stop)  
- `sctlrestart` - Restart systemd service (systemctl restart)
- `sctlstatus` - Check systemd service status (systemctl status)
- `sctllog` - View systemd service logs (journalctl -ru)
- `sctlwatch` - Watch systemd service logs in real-time (journalctl -fu)
- `so` - Source a file (reload shell config)
- `sysinfo` - Display comprehensive system information
- `killcmd` - Kill processes by command name
- `ta` - Tmux attach to session (tmux attach -t)
- `topcpu` - Show top processes by CPU usage
- `topmem` - Show top processes by memory usage

### 🌐 Network
- `ports` - Show network ports and connections
- `wget` - Wget with continue option
- `ping` - Ping 5 times
- `fastping` - Fast ping test (100 packets)
- `isup` - Check if website is accessible
- `myip` - Display local and external IP addresses

### ✏️ Quick Edits
- `bashrc` - Edit ~/.bashrc
- `nginxconf` - Edit nginx main configuration file (/etc/nginx/nginx.conf)
- `sobashrc` - Source ~/.bashrc (reload Bash configuration)
- `sozshrc` - Source ~/.zshrc (reload Zsh configuration)
- `vimrc` - Edit ~/.vimrc
- `zshrc` - Edit ~/.zshrc

### 🚀 Programs
- `v` - Vim editor

### 🐍 Python
- `p` - Python3
- `pm` - Run Python modules using file path
- `pipi` - Install Python package(s) or from requirements file
- `pupu` - Upgrade Python package(s), all packages, or from requirements.txt
- `pipl` - List installed packages (pip list)
- `svenv` - Auto-activate Python virtual environment
- `cdsvenv` - Navigate to project directory and activate virtual environment
- `cvenv` - Create .venv with conda's Python, activate, and upgrade pip

### 🛠️ Development Tools
- `base64conv` - Encode/decode base64 strings, files, or stdin
- `binconv` - Convert string, integer, or stdin to binary representation
- `calc` - Perform mathematical calculations with expressions
- `entropy` - Calculate Shannon entropy of strings, files, or stdin
- `hashit` - Compute hash of strings, files, or stdin (md5/sha1/sha256/sha512)
- `hexconv` - Encode/decode hex strings, files, or stdin
- `jsonpp` - Pretty-print JSON files or stdin
- `log2` - Calculate base-2 logarithm of positive integers
- `numconv` - Convert numbers between different bases (binary, octal, decimal, hex, custom 2-36)
- `pow2` - Calculate powers of 2 (2^X) for given integer exponents
- `randstr` - Generate secure random passwords with custom length
- `replace` - Find and replace text in strings, files, or stdin
- `wordlist` - Advanced wordlist filtering, processing and manipulation

## 📄 License

MIT License
