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
- **File analysis**: `meta` for comprehensive file type detection and metadata extraction

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
- **Package management**: `brewi` for Homebrew package installation (macOS)
- **Package management**: `brewi` for Homebrew package installation, `brewu` for updating and upgrading packages (macOS)

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

### Service Management

#### Systemctl Operations (`sctlstart`, `sctlstop`, `sctlrestart`, `sctlstatus`)
Simplified systemd service management:

```bash
$ sctlstart nginx           # Start nginx service
$ sctlstop apache2          # Stop apache2 service
$ sctlrestart ssh           # Restart SSH service
$ sctlstatus postgresql     # Check PostgreSQL status
```

#### Service Logging (`sctllog`, `sctlwatch`)
Monitor systemd service logs:

```bash
$ sctllog nginx             # View nginx service logs
$ sctlwatch apache2         # Watch apache2 logs in real-time
```

#### Nginx Management (`nginxstart`, `nginxstop`, `nginxrestart`, `nginxstatus`, `nginxconf`, `nginxtest`, `nginxreload`)
Complete nginx service control:

```bash
$ nginxstart                # Start nginx service
$ nginxstop                 # Stop nginx service
$ nginxrestart              # Restart nginx service
$ nginxstatus               # Check nginx status
$ nginxconf                 # Edit nginx configuration
$ nginxtest                 # Test nginx configuration syntax
$ nginxreload               # Reload nginx configuration
```

### Archive Operations (`extract`, `compress`)

#### Universal Archive Extractor (`extract`)
Automatically detects and extracts any archive format:

```bash
$ extract archive.zip        # Extract ZIP file
$ extract data.tar.gz       # Extract gzipped tar
$ extract backup.rar        # Extract RAR file
$ extract package.7z        # Extract 7-Zip file
```

Supports: `.zip`, `.tar`, `.tar.gz`, `.tar.bz2`, `.tar.xz`, `.rar`, `.7z`, `.gz`, `.bz2`, `.xz`, and more.

#### Archive Creator (`compress`)
Create archives with optional volume splitting:

```bash
$ compress myfile.zip file1.txt file2.txt     # Create ZIP archive
$ compress backup.tar.gz folder/             # Create gzipped tar
$ compress data.7z -v100M file1 file2        # Create 7z with 100MB volumes
$ compress split.zip -v1G large_folder/      # Create ZIP with 1GB volumes
```

### File Operations

#### Find Files (`ff`)
Search for files by name pattern:

```bash
$ ff "*.py"           # Find all Python files
$ ff "config"         # Find files containing "config"
$ ff "test*.js"       # Find JavaScript test files
```

#### Search in Files (`search`)
Advanced text search with regex support:

```bash
$ search "pattern" file.txt                    # Basic search
$ search -i "case insensitive" *.txt          # Case insensitive
$ search -r "regex.*pattern" directory/       # Extended regex
$ search -g "compressed" archive.gz           # Search in gzipped files
```

#### Find and Replace (`replace`)
Replace text in strings, files, or stdin:

```bash
$ replace "old" "new" "old text here"         # Replace in string
$ replace "old" "new" file.txt               # Replace in file
$ echo "old text" | replace "old" "new" -   # Replace from stdin
```

#### File Backup (`backup`)
Create timestamped backups with optional compression:

```bash
$ backup file.txt                    # Create backup: file.txt.backup.20231201-143022
$ backup -c folder/                  # Create compressed backup: folder.backup.20231201-143022.tar.gz
$ backup -c -z file.txt             # Create gzipped backup
```

#### File Metadata Analysis (`meta`)
Display comprehensive file type information and extract metadata automatically based on file type:

```bash
$ meta photo.jpg                     # Show image EXIF data, dimensions, camera info
$ meta document.pdf                  # Show PDF properties, page count, author
$ meta video.mp4                     # Show video codec, resolution, duration
$ meta song.mp3                      # Show audio metadata, bitrate, artist, album
$ meta archive.zip                   # Show archive contents and compression info
$ meta script.py                     # Show text file encoding, line count, word count
$ meta program                       # Show executable architecture, libraries
```

**Supported File Types:**
- **Images**: JPEG, PNG, GIF, TIFF, BMP, WebP - Shows EXIF data, dimensions, camera settings, GPS coordinates
- **Documents**: PDF, DOC, DOCX - Shows document properties, page count, author, creation date
- **Videos**: MP4, AVI, MOV, MKV, WebM - Shows duration, resolution, codec info, frame rate, GPS data
- **Audio**: MP3, WAV, FLAC, OGG, M4A - Shows duration, bitrate, artist, album, genre metadata
- **Archives**: ZIP, TAR, RAR, 7z - Shows contents list and compression information
- **Text files**: Shows encoding, line count, word count, character count
- **Executables**: Shows architecture, linked libraries, file format details

**Required Tools** (auto-detected):
- `exiftool` - Most comprehensive metadata extraction for images, videos, audio
- `pdfinfo` - PDF document information (from poppler-utils)
- `mediainfo` - Video and audio file analysis
- `identify` - ImageMagick image information
- Standard tools: `file`, `stat`, `wc`, `readelf`, `ldd`

### File Monitoring

#### Watch Log Files (`watchlog`)
Monitor log file changes in real-time:

```bash
$ watchlog /var/log/nginx/access.log    # Monitor nginx access log
$ watchlog app.log                      # Monitor application log
```

#### Watch Directory (`watchdir`)
Monitor directory contents for changes:

```bash
$ watchdir /home/user/downloads/        # Watch downloads folder
$ watchdir .                           # Watch current directory
```

### Python Development Tools

#### Package Management (`pipi`, `pupu`, `pipl`)
Simplified pip operations:

```bash
$ pipi requests flask       # Install packages
$ pipi requirements.txt     # Install from requirements file
$ pupu requests            # Upgrade specific package
$ pupu                     # Upgrade all packages
$ pupu requirements.txt    # Upgrade packages from requirements
$ pipl                     # List installed packages
```

#### Virtual Environment Auto-Activation (`svenv`)
Automatically detect and activate Python virtual environments:

```bash
$ svenv
Activated virtual environment: /home/user/project/.venv
```

Searches for virtual environments in: `.venv/`, `venv/`, `.virtualenv/`

#### Navigate and Activate (`cdsvenv`)
Navigate to project directory and activate virtual environment:

```bash
$ cdsvenv ~/myproject        # Navigate and activate venv
$ cdsvenv                   # Use current directory
```

#### Create Virtual Environment (`cvenv`)
Create `.venv` using conda's Python, activate it, and upgrade pip:

```bash
$ cvenv                     # Create venv in current directory
$ cvenv myproject           # Create venv in myproject/ directory
```

#### Python Module Runner (`pm`)
Run Python modules using file paths:

```bash
$ pm script.py              # Run script.py as module
$ pm path/to/module.py      # Run module with full path
```

### Node.js Development Tools

#### Node Version Management (`nu`, `nl`, `ni`)
Simplified nvm operations for Node.js version management:

```bash
$ nu 18.17.0               # Use Node.js version 18.17.0
$ nu lts                   # Use latest LTS version
$ nl                       # List installed Node.js versions
$ ni 20.5.0                # Install Node.js version 20.5.0
$ ni --lts                 # Install latest LTS version
```

### Time and Date Utilities (`now`, `nowtime`, `nowdate`)

Get current time and date information:

```bash
$ now                      # Current date and time: 2023-12-01 14:30:22
$ nowtime                  # Current time only: 14:30:22
$ nowdate                  # Current date only: 2023-12-01
```

### Resource Monitoring (`topcpu`, `topmem`)

Monitor system resource usage:

```bash
$ topcpu                   # Show top processes by CPU usage
$ topmem                   # Show top processes by memory usage
```

Output shows processes sorted by resource consumption with PID, user, and command details.

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

### Network Utilities (`ports`)

Show active network connections and listening ports:

```bash
$ ports                    # Display all network connections and listening ports
```

Shows local/remote addresses, connection states, and associated processes.

### Git Repository Information (`gitinfo`)

Display comprehensive Git repository status:

```bash
$ gitinfo
=== GIT REPOSITORY INFORMATION ===

Repository Path: /home/user/myproject
Branch: main
Status: Clean working directory

Remote Origin:
  https://github.com/user/myproject.git

Recent Commits:
  a1b2c3d - Fix bug in authentication (2 hours ago)
  d4e5f6g - Add new feature (1 day ago)
```

### Configuration Management

#### Quick Configuration Access (`bashrc`, `zshrc`, `vimrc`, `nginxconf`)
Instantly open configuration files for editing:

```bash
$ bashrc                   # Edit ~/.bashrc
$ zshrc                    # Edit ~/.zshrc  
$ vimrc                    # Edit ~/.vimrc
$ nginxconf                # Edit /etc/nginx/nginx.conf
```

#### Configuration Reloading (`sobashrc`, `sozshrc`)
Quickly reload shell configurations:

```bash
$ sobashrc                 # Reload ~/.bashrc
$ sozshrc                  # Reload ~/.zshrc
```

### Directory Navigation Enhancements

#### Smart Navigation (`..`, `...`, `....`, `~`)
Quick directory traversal shortcuts:

```bash
$ ..                       # Go up one directory (cd ..)
$ ...                      # Go up two directories (cd ../..)
$ ....                     # Go up three directories (cd ../../..)
$ ~                        # Go to home directory (cd ~)
```

#### Create and Navigate (`mkcd`)
Create directory and navigate into it in one command:

```bash
$ mkcd new_project         # Create and enter new_project directory
$ mkcd path/to/deep/dir    # Create nested directories and navigate
```

### Enhanced File Listing

#### File Listing Variants (`ll`, `la`, `l`)
Enhanced directory listing with different detail levels:

```bash
$ ll                       # Detailed list with human-readable sizes (ls -lh)
$ la                       # List all files including hidden (ls -la)
$ l                        # Compact column format (ls -CF)
```

### File Viewing Enhancements

#### Enhanced Less (`less`, `le`, `tle`)
Improved file viewing with enhanced less functionality:

```bash
$ less file.txt            # Enhanced less with colors and mouse support
$ le file.txt              # Alias for less
$ tle file.txt             # Open file with less, start at end (+G)
```

Features include syntax highlighting, mouse support, and improved navigation.

### System Path and History

#### Path Display (`path`)
Format and display the system PATH variable:

```bash
$ path                     # Display PATH with each directory on separate line
```

#### Command History (`h`)
Quick access to command history:

```bash
$ h                        # Display command history
$ h pattern                # Search history for pattern
```

### tmux Session Management (`ta`)

Quick tmux session attachment:

```bash
$ ta session_name          # Attach to named tmux session
$ ta                       # Attach to most recent session
```

### Development Tools

#### Hash Calculator (`hashit`)
Compute various hash functions for strings, files, or stdin. Supports both simple cryptographic hashes and secure password hashes:

**Simple Hash Functions:**
```bash
$ hashit sha256 "hello world"     # Hash a string: a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e
$ hashit md5 myfile.txt          # Hash a file: 5d41402abc4b2a76b9719d911017c592
$ echo "data" | hashit sha1 -    # Hash stdin: a17c9aaa61e80a1bf71d0d850af4e5baa9800bbd
$ hashit blake2 "secret data"    # BLAKE2 hash (modern, fast algorithm)
$ hashit crc32 "integrity check" # CRC32 checksum: 3632233996
```

**Password Hash Functions (with salt):**
```bash
$ hashit bcrypt "password123"       # Bcrypt hash: $2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBXFhAsC/HjBKS
$ hashit argon2 "password123"       # Argon2id hash: $argon2id$v=19$m=4096,t=3,p=1$salt$hash
$ hashit sha256crypt "password"     # SHA-256 crypt: $5$saltvalue$hashvalue
$ hashit sha512crypt "password"     # SHA-512 crypt: $6$saltvalue$hashvalue
$ echo "mypassword" | hashit bcrypt - # Hash password from stdin
```

**Supported Hash Types:**
- **Simple hashes**: `md5`, `sha1`, `sha224`, `sha256`, `sha384`, `sha512`, `blake2`, `sha3`, `crc32`
- **Password hashes**: `bcrypt`, `argon2`, `sha256crypt`, `sha512crypt`

Password hashes automatically include random salt and produce different outputs each time for security.

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

#### Number Base Converter (`numconv`)
Convert numbers between different bases (2-36) with auto-detection:

```bash
$ numconv 255                    # Auto-detect: 255 (decimal) = 0xff (hex) = 0o377 (octal) = 0b11111111 (binary)
$ numconv 0xff                   # Hex to all: 0xff = 255 (decimal) = 0o377 (octal) = 0b11111111 (binary)
$ numconv 0b1010                 # Binary to all: 0b1010 = 10 (decimal) = 0xa (hex) = 0o12 (octal)
$ numconv 777 8                  # Convert 777 from base 8: 777₈ = 511 (decimal)
$ numconv 255 16                 # Convert 255 to base 16: 255 = ff₁₆
$ numconv abc 16 2               # Convert abc from base 16 to base 2: abc₁₆ = 101010111100₂
```

**Range conversion** (convert multiple consecutive numbers):
```bash
$ numconv 100-110 hex            # Convert 100-110 to hex: 64, 65, 66, ..., 6E
$ numconv 0x10-0x1F dec          # Convert hex 10-1F to decimal: 16, 17, ..., 31
$ numconv 8-12 bin               # Convert 8-12 to binary: 1000, 1001, ..., 1100
$ numconv 250-255 hex            # Convert 250-255 to hex: FA, FB, FC, FD, FE, FF
```

Range format supports the same base auto-detection and supports up to 1000 numbers per range.

#### Random Password Generator (`randstr`)
Generate secure random passwords:

```bash
$ randstr              # Generate 12-character password: aB3$xY9!mN2@
$ randstr 16           # Generate 16-character password
$ randstr 8            # Generate 8-character password
```

#### Mathematical Calculators (`calc`, `log2`, `pow2`)

**Calculator (`calc`):**
```bash
$ calc "2 + 3 * 4"          # Result: 14
$ calc "sqrt(16)"           # Result: 4
$ calc "sin(pi/2)"          # Result: 1
$ calc "log(100)"           # Result: 2 (base 10)
```

**Base-2 Logarithm (`log2`):**
```bash
$ log2 8                    # Result: 3 (since 2³ = 8)
$ log2 1024                 # Result: 10 (since 2¹⁰ = 1024)
```

**Powers of 2 (`pow2`):**
```bash
$ pow2 3                    # Result: 8 (2³)
$ pow2 10                   # Result: 1024 (2¹⁰)
```

#### JSON Pretty Printer (`jsonpp`)
Format and pretty-print JSON data:

```bash
$ jsonpp data.json          # Pretty-print JSON file
$ echo '{"a":1,"b":2}' | jsonpp -    # Pretty-print JSON from stdin
```

#### Wordlist Processor (`wordlist`)
Advanced wordlist filtering and processing:

```bash
$ wordlist -l 8-12 passwords.txt          # Filter by length 8-12 characters
$ wordlist -a words.txt                   # Filter alphabetic only
$ wordlist -n data.txt                    # Filter numeric only
$ wordlist -e 4.0- entropy.txt           # Filter by minimum entropy 4.0
$ wordlist -r "^[a-z]+$" words.txt        # Filter by regex pattern
$ wordlist -s size output.txt input.txt   # Sort and remove duplicates
$ wordlist -x 10 random.txt              # Randomize and take 10 entries
$ wordlist --split-mb 100 large.txt      # Split into 100MB files
```

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

#### Terminal Cheatsheet (`csterminal`)
Comprehensive terminal keyboard shortcuts cheatsheet covering:

- Cursor movement and navigation within command line
- Text cutting, deleting, and pasting operations
- Command history search and navigation
- Tab completion and text expansion
- Process control signals (Ctrl+c, Ctrl+z, etc.)
- Display and terminal control commands
- Advanced command line editing features
- ZSH-specific shortcuts and enhancements
- Argument manipulation and word operations
- Advanced shortcuts for power users
- Workflow examples and practical tips
- Key binding customization guidance

```bash
$ csterminal
=== TERMINAL CHEATSHEET (BASH/ZSH) ===

📝 CURSOR MOVEMENT:
  Ctrl+a          - Move to beginning of line
  Ctrl+e          - Move to end of line
  Alt+f           - Move forward one word
  ...
```
