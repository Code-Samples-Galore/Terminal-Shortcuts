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
- **Archive operations**: Universal `extract` and `compress` functions for any archive type
- **File operations**: Find files (`ff`), find-and-replace (`replace`), timestamped backups (`backup`)
- **Directory creation**: `mkcd` to create and enter directories
- **Log monitoring**: `watchlog` for real-time log file monitoring

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

### 🌐 Network Utilities

- **Website monitoring**: `isup` to check if websites are accessible
- **IP information**: `myip` for local and external IP addresses
- **Network monitoring**: `ports` for active connections
- **Enhanced ping**: Standard and fast ping options

### 🐍 Python Development

- **Virtual environment**: `svenv` for automatic venv activation
- **Quick Python access**: `p` alias for python3
- **Package management**: `pipi`, `pipu`, `pipr`, `pipl` for pip operations
- **Module execution**: `pm` for running Python modules using file paths

### 📦 Node.js Development

- **Version management**: `nu`, `nl`, `ni` for nvm operations
- **Quick switching**: Easy Node.js version switching

### ✏️ Quick Configuration Access

- **Config editing**: `bashrc`, `zshrc`, `vimrc` for instant config file access

### 🚀 Program Shortcuts

- **Editor access**: `v` for Vim

### 🛠️ Development Tools

- **Hash computation**: `hashit` for MD5, SHA1, SHA256, SHA512 hashing of strings, files, or stdin
- **Password generation**: `randstr` for secure random passwords
- **Encoding/decoding**: `hexconv` and `base64conv` for data conversion from strings, files, or stdin
- **Binary conversion**: `binconv` for converting strings, integers, or stdin to binary
- **Entropy analysis**: `entropy` for calculating Shannon entropy of strings, files, or stdin
- **Mathematical calculations**: `calc` and `log2` functions
- **JSON formatting**: `jsonpp` for pretty-printing JSON

### 📝 Wordlist Processing

- **Advanced filtering**: Filter by length, character types, entropy, regex patterns
- **Data processing**: Sort, remove duplicates, randomize word order
- **Output options**: Split by size (MB/GB) or percentage distribution
- **Memory efficiency**: Streaming processing for large files
- **Pattern matching**: Case-sensitive/insensitive regex support

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

#### Encoding/Decoding Tools
Convert between different data formats from strings, files, or stdin:

```bash
$ hexconv encode "hello"         # Returns: 68656c6c6f
$ hexconv decode "68656c6c6f"    # Returns: hello
$ echo "hello" | hexconv encode - # Hex encode from stdin
$ base64conv encode "data"       # Base64 encode
$ echo "data" | base64conv encode - # Base64 encode from stdin
$ binconv 255                    # Convert to binary: 11111111
$ echo "text" | binconv -        # Convert stdin to binary
```

### Python Development (`svenv`, `pm`)

#### Virtual Environment (`svenv`)
Automatically finds and activates Python virtual environments:

```bash
$ svenv
Activating virtual environment: ./venv/bin/activate
```

#### Module Runner (`pm`)
Run Python modules using file path notation:

```bash
$ pm src/main.py          # Runs: python3 -m src.main
$ pm utils/helper.py arg1 # Runs: python3 -m utils.helper arg1
```

#### Package Management
Enhanced pip operations:

```bash
$ pipi requests           # Install requests package
$ pipu numpy             # Upgrade numpy package
$ pipu                   # Upgrade all outdated packages
$ pipu requirements.txt  # Upgrade packages from requirements file
$ pipr requirements.txt  # Install from requirements file
$ pipl                   # List all installed packages
```

### Wordlist Processing (`wordlist`)

Comprehensive wordlist filtering and manipulation:

```bash
$ wordlist -min 8 -max 16 passwords.txt     # Filter by length
$ wordlist -minentropy 3.0 passwords.txt    # Filter by entropy
$ wordlist -regex "^admin" passwords.txt     # Regex filtering
$ wordlist -su -o output.txt passwords.txt   # Sort, unique, save to file
$ wordlist -split 100MB -o parts.txt large.txt  # Split into 100MB files
```

### File Operations (`extract`, `compress`, `mkcd`, `ff`, `replace`, `backup`)

#### Universal Archive Operations
```bash
# Extract archives
extract archive.tar.gz    # Extracts tar.gz files
extract package.zip       # Extracts zip files
extract data.7z          # Extracts 7z files

# Create archives
compress backup.tar.gz file1.txt file2.txt dir1/  # Create gzip tar archive
compress project.zip src/ docs/ README.md         # Create zip archive
compress data.7z *.csv *.json                     # Create 7z archive
compress single.gz important.txt                  # Compress single file
```

#### Find and Replace (`replace`)
```bash
$ replace "hello world" "world" "universe"     # Returns: hello universe
$ replace myfile.txt "old_text" "new_text"     # Replace in file
$ replace config.ini "localhost" "127.0.0.1" --backup  # Replace with backup
$ echo "hello world" | replace - "world" "universe"    # Replace from stdin
```

# ...existing code...

## 🎯 Complete Aliases and Functions Reference

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
- `compress` - Create any type of archive file
- `ff` - Find files by name pattern
- `replace` - Find and replace text in strings, files, or stdin
- `backup` - Create timestamped backup of file
- `watchlog` - Monitor log file changes in real-time
- `chown` - chown with preserve-root safety
- `chmod` - chmod with preserve-root safety
- `chgrp` - chgrp with preserve-root safety

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
- `sysinfo` - Display comprehensive system information
- `killcmd` - Kill processes by command name
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
- `zshrc` - Edit ~/.zshrc
- `vimrc` - Edit ~/.vimrc

### 🚀 Programs
- `v` - Vim editor

### 🐍 Python
- `p` - Python3
- `pm` - Run Python modules using file path
- `pipi` - Install Python package (pip install)
- `pipu` - Upgrade Python package(s), all packages, or from requirements.txt
- `pipr` - Install from requirements file (pip install -r)
- `pipl` - List installed packages (pip list)
- `svenv` - Auto-activate Python virtual environment

## 📄 License

MIT License
- `pm` - Run Python modules using file path
- `pipi` - Install Python package (pip install)
- `pipu` - Upgrade Python package(s), all packages, or from requirements.txt
- `pipr` - Install from requirements file (pip install -r)
- `pipl` - List installed packages (pip list)
- `svenv` - Auto-activate Python virtual environment

## 📄 License

MIT License

