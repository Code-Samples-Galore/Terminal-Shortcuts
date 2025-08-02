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

Use `shortcuts` command to see all available shortcuts and their descriptions.

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
- **Process killing**: `killcmd` with interactive confirmation for killing processes by name
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
- **String generation**: `randstr` for crypto-secure random strings with special characters
- **Mathematical calculations**: `calc` and `log2` functions
- **Python module runner**: `pm` for executing Python modules using file paths
- **Python virtual environment**: `svenv` for automatic venv activation
- **Hex encoding/decoding**: `hexconv` for hex string conversion (supports files)
- **Base64 encoding/decoding**: `base64conv` for base64 conversion (supports files)
- **Binary conversion**: `binconv` for converting strings or integers to binary
- **Hash computation**: `hashit` for MD5, SHA1, SHA256, SHA512 hashing
- **HTTP servers**: Quick development server setup

### 🌐 Network Utilities

- **Website monitoring**: Check if services are up
- **Port monitoring**: View active network connections
- **Weather information**: Terminal-based weather lookup
- **IP address display**: Show local and external IP addresses

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

Show IP address information:

```bash
$ myip
=== IP ADDRESS INFORMATION ===

Local IP Address:
  192.168.1.100

External IP Address:
  203.0.113.45
```

### File Operations (`extract`)

Universal archive extraction:

```bash
extract archive.tar.gz    # Extracts tar.gz files
extract package.zip       # Extracts zip files
extract data.7z          # Extracts 7z files
```

### Git Enhancements (`gac`)

Auto-commit with intelligent messages:

```bash
$ gac
[main 1a2b3c4] Auto commit: 5 files changed
```

### Development Tools (`pm`, `log2`, `hexconv`, `base64conv`, `randstr`, `hashit`, `binconv`)

#### Binary Converter (`binconv`)
Convert strings or integers to binary representation:

```bash
$ binconv 255            # Returns: 11111111
$ binconv "A"            # Returns: 1000001
$ binconv "Hello"        # Returns: 1001000 1100101 1101100 1101100 1101111
```

#### Python Virtual Environment (`svenv`)
Automatically finds and activates Python virtual environments:

```bash
$ svenv
Activating virtual environment: ./venv/bin/activate
```

#### Python Module Runner (`pm`)
Run Python modules using file path notation:

```bash
$ pm src/main.py          # Runs: python3 -m src.main
$ pm utils/helper.py arg1 # Runs: python3 -m utils.helper arg1
```

#### Logarithm Calculator (`log2`)
Calculate base-2 logarithms:

```bash
$ log2 256               # Returns: 8.000000
$ log2 1024              # Returns: 10.000000
```

#### Hex Converter (`hexconv`)
Encode and decode hex strings or files:

```bash
$ hexconv encode "hello"      # Returns: 68656c6c6f
$ hexconv decode "68656c6c6f" # Returns: hello
$ hexconv encode myfile.txt   # Hex encode file contents
$ hexconv decode hexfile.txt  # Hex decode file contents
```

#### Base64 Converter (`base64conv`)
Encode and decode base64 strings or files:

```bash
$ base64conv encode "hello"        # Returns: aGVsbG8=
$ base64conv decode "aGVsbG8="     # Returns: hello
$ base64conv encode myfile.txt     # Base64 encode file contents
$ base64conv decode b64file.txt    # Base64 decode file contents
```

#### Hash Calculator (`hashit`)
Compute various hash functions for strings or files:

```bash
$ hashit sha256 "hello world"     # Hash a string
$ hashit md5 myfile.txt          # Hash a file
$ hashit sha512 "secret data"    # SHA512 hash
```

### Development Tools (`jsonpp`, `genpass`, `calc`)

Pretty-print JSON files:

```bash
jsonpp data.json          # Format JSON file
curl api.example.com | jsonpp  # Format API response
```

Generate secure passwords:

```bash
genpass           # 16-character password (default)
genpass 32        # 32-character password
```

Calculate mathematical expressions:

```bash
calc '2 + 2'      # Returns: 4
calc 'sin(30)'    # Returns: 0.49999999999999994
```

### Network Monitoring (`myip`)

Display IP address information:

```bash
$ myip
=== IP ADDRESS INFORMATION ===

Local IP Address:
  192.168.1.100

External IP Address:
  203.0.113.45
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

### Excluding Specific Shortcuts

You can exclude specific aliases and functions by setting the `EXCLUDE_SHORTCUTS` environment variable before sourcing the shortcuts:

```bash
# Exclude specific shortcuts
export EXCLUDE_SHORTCUTS="p hashit shortcuts gs gc"
source ~/terminal_shortcuts/shortcuts.sh
```

This will prevent the following from being loaded:
- `p` alias (Python3)
- `hashit` function
- `shortcuts` function  
- `gs` alias (Git status)
- `gc` alias (Git commit)

**Note**: Set the exclusion variable before sourcing the shortcuts file in your shell configuration.

#### How the Exclusion System Works

The exclusion system uses a helper function `should_exclude()` that checks if a given alias or function name is listed in the `EXCLUDE_SHORTCUTS` environment variable. Here's how it works:

1. **Environment Variable**: `EXCLUDE_SHORTCUTS` is a space-separated list of alias/function names to exclude
2. **Check Function**: Each alias and function is wrapped with a check: `if ! should_exclude "name" 2>/dev/null; then`
3. **Silent Failures**: The `2>/dev/null` ensures no errors if the check function isn't available
4. **Dynamic Loading**: Only shortcuts not in the exclusion list are loaded

#### Examples

**Basic exclusion** - exclude Python alias and hash function:
```bash
export EXCLUDE_SHORTCUTS="p hashit"
source ~/terminal_shortcuts/shortcuts.sh
```

**Exclude Git shortcuts** - if you prefer your own Git aliases:
```bash
export EXCLUDE_SHORTCUTS="gs gc gp ga gb gco gcb gl gd gdc gaa gu gac gitinfo"
source ~/terminal_shortcuts/shortcuts.sh
```

**Exclude system utilities** - if you have conflicting commands:
```bash
export EXCLUDE_SHORTCUTS="ll la l h j path now ping ports"
source ~/terminal_shortcuts/shortcuts.sh
```

**Complete exclusion** - exclude everything (useful for testing):
```bash
export EXCLUDE_SHORTCUTS="ll la l .. ... .... ~ mkdir cp mv rm grep tree nu nl ni gs gc gp gu ga gaa gb gco gcb gl gd gdc h j path now nowtime nowdate ports wget ping fastping chown chmod chgrp bashrc zshrc vimrc v n e p sysinfo svenv killcmd topcpu topmem isup watchlog weather myip gac gitinfo extract mkcd ff replace backup jsonpp genpass calc pm log2 hexconv randstr hashit binconv shortcuts"
source ~/terminal_shortcuts/shortcuts.sh
```

#### Adding Exclusion to Custom Functions

If you create custom functions, you can add exclusion support:

```bash
# Custom function with exclusion support
if ! should_exclude "myfunction" 2>/dev/null; then
  myfunction() {
    echo "My custom function"
  }
fi
```

#### Permanent Configuration

Add the exclusion to your shell configuration file for permanent effect:

```bash
# In ~/.bashrc or ~/.zshrc
export EXCLUDE_SHORTCUTS="p hashit shortcuts"
source ~/terminal_shortcuts/shortcuts.sh
```

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

## 📄 License

MIT License

---

**Quick Help**: Run `shortcuts` in your terminal for a complete reference of all available commands and functions.
