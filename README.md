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
source ~/terminal_shortcuts/terminal_shortcuts.sh
```

3. Reload your shell or run:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### Quick Reference
Use `aliaslist` command to see all available shortcuts and their descriptions.

## 📋 Features Overview

### 📁 File and Directory Operations
- **Enhanced file listing**: `ll`, `la`, `l` with colors and details
- **Smart navigation**: `..`, `...`, `....` for quick directory traversal
- **Archive extraction**: Universal `extract` function for any archive type
- **File operations**: Find files (`ff`), find-and-replace (`replace`), timestamped backups (`backup`)
- **Directory creation**: `mkcd` to create and enter directories

### 🔀 Git Enhancements
- **Quick git operations**: `gs`, `gc`, `gp`, `ga`, etc.
- **Auto-commit**: `gac` with intelligent commit messages
- **Repository info**: `gitinfo` for comprehensive repo status
- **Branch management**: Simplified checkout and branch creation

### 🖥️ System Information & Monitoring
- **System overview**: `sysinfo` for comprehensive system details
- **Process monitoring**: `topcpu`, `topmem` for resource usage
- **Network monitoring**: `isup` for website availability, `weather` info
- **Log monitoring**: `watchlog` for real-time log file monitoring

### 🐍 Python Development
- **Virtual environment**: `svenv` for automatic venv activation
- **Quick Python access**: `p` alias for python3

### ⚙️ Process Management
- **Smart process killing**: `killcmd` with interactive confirmation
- **Resource monitoring**: CPU and memory usage tracking

### 🛠️ Development Tools
- **JSON formatting**: `jsonpp` for pretty-printing JSON
- **Password generation**: `genpass` for secure passwords
- **Mathematical calculations**: `calc` function
- **HTTP servers**: Quick development server setup

### 🌐 Network Utilities
- **Website monitoring**: Check if services are up
- **Port monitoring**: View active network connections
- **Weather information**: Terminal-based weather lookup

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

### Python Virtual Environment (`svenv`)
Automatically finds and activates Python virtual environments:
```bash
$ svenv
Activating virtual environment: ./venv/bin/activate
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

### Network Monitoring (`isup`)
Check website availability:
```bash
$ isup google.com
google.com is UP

$ isup badsite.xyz
badsite.xyz is DOWN
```

### File Operations (`extract`)
Universal archive extraction:
```bash
$ extract archive.tar.gz    # Extracts tar.gz files
$ extract package.zip       # Extracts zip files
$ extract data.7z          # Extracts 7z files
```

### Git Enhancements (`gac`)
Auto-commit with intelligent messages:
```bash
$ gac
[main 1a2b3c4] Auto commit: 5 files changed
```

### Development Tools (`jsonpp`)
Pretty-print JSON files:
```bash
$ jsonpp data.json          # Format JSON file
$ curl api.example.com | jsonpp  # Format API response
```

### Password Generation (`genpass`)
Generate secure passwords:
```bash
$ genpass           # 16-character password (default)
$ genpass 32        # 32-character password
```

## 🎯 Aliases Quick Reference

### File Operations
- `ll` - Detailed file listing with sizes and permissions
- `la` - List all files including hidden ones
- `..` / `...` / `....` - Navigate up 1/2/3 directories
- `mkcd dirname` - Create and enter directory

### Git Shortcuts
- `gs` - Git status
- `ga` - Git add
- `gc "message"` - Git commit with message
- `gp` - Git push
- `gb` - Git branch

### System Utilities
- `h` - Command history
- `path` - Display PATH variable formatted
- `ports` - Show network connections
- `now` - Current time
- `weather city` - Weather information

### Safety Features
- Interactive confirmations for destructive operations
- Preserve-root protection for system commands
- Process confirmation before killing multiple processes

## 🔧 Customization

### Adding Custom Functions
1. Create a new file in `functions.d/` directory
2. Follow the existing naming convention and documentation format
3. Functions will be automatically loaded

### Modifying Aliases
Edit `alias.sh` to add or modify aliases according to your needs.

### Platform Compatibility
- **macOS**: Full compatibility with macOS-specific commands
- **Linux**: Comprehensive Linux support with appropriate fallbacks
- **Cross-platform**: Automatic detection and adaptation

## 🐛 Troubleshooting

### Common Issues
1. **Functions not loading**: Ensure the path in your shell config is correct
2. **Command not found**: Check if required dependencies are installed
3. **Permission denied**: Ensure scripts have execute permissions

### Dependencies
Some functions require additional tools:
- `curl` - For weather and network functions
- `jq` or `python3` - For JSON processing
- `bc` - For calculations
- `tree` - For directory tree display


---

**Quick Help**: Run `aliaslist` in your terminal for a complete reference of all available commands and functions.
