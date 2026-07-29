# 🚀 Terminal Shortcuts Collection

A comprehensive collection of shell aliases and functions designed to enhance terminal productivity and streamline common development tasks. Every shortcut works in both **Bash** (4.0+) and **Zsh** (5.0+).

## 🚀 Quick Start

### ⚡️ Installation

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

### 📝 Quick Reference

Use `sc` command to see all available shortcuts and their descriptions.

### 🚫 Excluding Shortcuts

Set `EXCLUDE_SHORTCUTS` to a space-separated list of names **before** sourcing
`shortcuts.sh`. Excluded names are never defined, and any alias or function you
already have under that name is left untouched:

```bash
export EXCLUDE_SHORTCUTS="p hashit sc"
source ~/terminal_shortcuts/shortcuts.sh
```

### 📦 Requirements

Core shortcuts rely on standard POSIX tools. Individual functions degrade
gracefully and tell you what is missing:

| Tool | Used by |
|------|---------|
| `bc` | `calc`, `log2`, `pow2`, `numconv`, `unitconv` |
| `openssl` | `randstr`, `hashit` (password hashes) |
| `xxd` | `strconv hex-decode` |
| `jq` or `python3` | `jsonpp` |
| `curl` | `apitest`, `isup`, `myip` |
| `python3` | all `p*` Python shortcuts |
| `zip`, `unzip`, `7z`, `unrar` | matching `compress` / `extract` formats |
| `exiftool`, `pdfinfo`, `mediainfo` | richer `meta` output |

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

- **Quick git operations**: `gs`, `gc`, `gp`, `ga`, `gaa`, etc.
- **AI-powered commits**: `gcm` with GitHub Copilot for intelligent commit messages
- **Auto-commit**: `gac` with intelligent commit messages
- **Recursive pull**: `gpullall` pulls every repo under a directory, skipping any that would fail or conflict
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
- **Package management**: `brewi` for Homebrew package installation, `brewu` for updating and upgrading packages (macOS)

### 🌐 Network Utilities

- **Website monitoring**: `isup` to check if websites are accessible
- **IP information**: `myip` for local and external IP addresses
- **Network monitoring**: `ports` for active connections
- **Enhanced ping**: Standard and fast ping options

### 🐍 Python Development

- **Virtual environment**: `svenv` for automatic venv activation, `cdsvenv` for navigate and activate
- **Create and bootstrap venv**: `cvenv` to create .venv with conda's Python, activate it, and upgrade pip
- **Quick Python access**: `p` alias for python3
- **Package management**: `pipi`, `pipu`, `pipl` for pip operations
- **Dependency analysis**: `preq` for analyzing project dependencies and environment
- **Testing with coverage**: `pytestcov` for running tests with coverage reports
- **Code formatting**: `pfmt` for formatting and linting with black, isort, and flake8
- **Module execution**: `pm` for running Python modules using file paths
- **Class inspection**: `pmem` for displaying members of classes

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

- **API testing**: `apitest` for quick HTTP API testing with curl
- **Asset optimization**: `optimizeassets` for minifying JavaScript and CSS files
- **Hash computation**: `hashit` for MD5, SHA1, SHA256, SHA512 hashing of strings, files, or stdin
- **Password generation**: `randstr` for secure random passwords
- **String/data conversion**: `strconv` for converting between hex, base64, and binary formats
- **Number base conversion**: `numconv` for converting numbers between different bases (2-36) with auto-detection
- **Unit conversion**: `unitconv` for converting between different units of measurement
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
- **Terminal shortcuts**: `csterminal` for comprehensive terminal keyboard shortcuts and command line editing

## 📖 Detailed Function Reference

### 🖥️ System Information (`sysinfo`)

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

### 🧩 Function Listing (`list_functions`)

Display all defined functions in the current shell session with optional filtering:

```bash
$ list_functions                   # List all functions
$ list_functions git               # List functions containing 'git'
$ list_functions '^c'              # List functions starting with 'c'
$ list_functions 'backup|restore'  # List functions with 'backup' or 'restore'
```

**Features:**
- Alphabetically sorted output for easy browsing
- Optional grep pattern filtering for targeted searches
- Includes both built-in shell functions and user-defined functions
- Shows total count of functions found
- Supports regular expressions for advanced filtering

**Common Use Cases:**
- Explore available functions in your shell environment
- Find functions related to specific tasks (e.g., git, file operations)
- Debug shell configurations by listing loaded functions
- Discover functions from loaded modules and scripts

### 🗑️ Process Management (`killcmd`)

Interactive process termination by command name:

```bash
$ killcmd firefox
=== KILL COMMAND ===
Searching for processes containing: 'firefox'
Found 3 matching process(es):
PID: 1234 - /Applications/Firefox.app/Contents/MacOS/firefox
Kill all these processes? (y/N):
```

### 🛎️ Service Management

#### 🛠️ Systemctl Operations (`sctlstart`, `sctlstop`, `sctlrestart`, `sctlstatus`)
Simplified systemd service management:

```bash
$ sctlstart nginx           # Start nginx service
$ sctlstop apache2          # Stop apache2 service
$ sctlrestart ssh           # Restart SSH service
$ sctlstatus postgresql     # Check PostgreSQL status
```

#### 📜 Service Logging (`sctllog`, `sctlwatch`)
Monitor systemd service logs:

```bash
$ sctllog nginx             # View nginx service logs
$ sctlwatch apache2         # Watch apache2 logs in real-time
```

#### 🕸️ Nginx Management (`nginxstart`, `nginxstop`, `nginxrestart`, `nginxstatus`, `nginxconf`, `nginxtest`, `nginxreload`)
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

### 📦 Archive Operations (`extract`, `compress`)

#### 📤 Universal Archive Extractor (`extract`)
Automatically detects and extracts any archive format:

```bash
$ extract archive.zip        # Extract ZIP file
$ extract data.tar.gz       # Extract gzipped tar
$ extract backup.rar        # Extract RAR file
$ extract package.7z        # Extract 7-Zip file
```

Supports: `.zip`, `.tar`, `.tar.gz`, `.tgz`, `.tar.bz2`, `.tbz2`, `.rar`, `.7z`, `.gz`, `.bz2`, `.Z`.

#### 📦 Archive Creator (`compress`)
Create archives with optional volume splitting (`--split` / `-s`, sizes in `b`, `k`, `m`, `g`):

```bash
$ compress myfile.zip file1.txt file2.txt        # Create ZIP archive
$ compress backup.tar.gz folder/                 # Create gzipped tar
$ compress --split 100m data.7z file1 file2      # Create 7z with 100MB volumes
$ compress -s 1g split.zip large_folder/         # Create ZIP with 1GB volumes
```

Supports: `.tar.gz`, `.tgz`, `.tar.bz2`, `.tbz2`, `.tar`, `.zip`, `.7z`, `.gz`, `.bz2`.
Volume splitting is available for every format except `.gz` and `.bz2`.

### 📁 File Operations

#### 🔍 Find Files (`ff`)
Search for files by name pattern:

```bash
$ ff "*.py"           # Find all Python files
$ ff "config"         # Find files containing "config"
$ ff "test*.js"       # Find JavaScript test files
```

#### 🔎 Search in Files (`search`)
Advanced text search with regex support. Flags: `-r` recursive, `-i` ignore case,
`-E` extended regex, `-z` include `.gz` files. Short flags can be bundled (`-riE`):

```bash
$ search "pattern" file.txt                    # Basic search (BRE)
$ search -i "case insensitive" notes.txt       # Case insensitive
$ search -r "pattern" directory/               # Recursive
$ search -E "^(GET|POST)" access.log           # Extended regex
$ search -z "compressed" archive.gz            # Search in gzipped files
$ search -rz "exception" logs/                 # Recursive, including .gz files
```

#### 📝 Find and Replace (`replace`)
Replace text in strings, files, or stdin. The argument order is
`replace <input> <search> <replacement>`, and matching is literal, not regex:

```bash
$ replace "old text here" "old" "new"         # Replace in string
$ replace file.txt "old" "new"                # Replace in file (in place)
$ replace file.txt "old" "new" --backup       # Replace in file, keeping a backup
$ echo "old text" | replace - "old" "new"     # Replace from stdin
```

#### 🗄️ File Backup (`backup`)
Create timestamped backups with optional compression
(`--compress <tar.gz|tar.bz2|zip|7z|tar>`):

```bash
$ backup file.txt                          # Copy backup: file.txt.backup.20231201_143022
$ backup project/                          # Copy backup of a directory
$ backup project/ --compress tar.gz        # Compressed backup: project.backup.20231201_143022.tar.gz
$ backup config.ini --compress zip         # Compressed single-file backup
```

#### 🏷️ File Metadata Analysis (`meta`)
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

### 👀 File Monitoring

#### 👁️‍🗨️ Watch Files (`watchfile`)
Monitor file changes in real-time (`tail -f`):

```bash
$ watchfile /var/log/nginx/access.log   # Monitor nginx access log
$ watchfile app.log                     # Monitor application log
```

#### 🗂️ Watch Directory (`watchdir`)
Monitor directory contents for changes:

```bash
$ watchdir /home/user/downloads/        # Watch downloads folder
$ watchdir .                           # Watch current directory
```

### 🐍 Python Development Tools

#### 📦 Package Management (`pipi`, `pipu`, `pipl`)
Simplified pip operations:

```bash
$ pipi requests flask       # Install packages
$ pipi requirements.txt     # Install from requirements file
$ pipu requests            # Upgrade specific package
$ pipu                     # Upgrade all packages (asks for confirmation)
$ pipu requirements.txt    # Upgrade packages from requirements
$ pipl                     # List installed packages
```

#### 🧪 Virtual Environment Auto-Activation (`svenv`)
Automatically detect and activate Python virtual environments:

```bash
$ svenv
Activating virtual environment: .venv/bin/activate
```

Checks `.venv/`, `venv/`, `env/` and `.virtualenv/` first, then falls back to a
depth-limited search for any `*/bin/activate` script.

#### 📂 Navigate and Activate (`cdsvenv`)
Navigate to project directory and activate virtual environment. The directory
argument is required:

```bash
$ cdsvenv ~/myproject        # Navigate and activate venv
$ cdsvenv ../other_project   # Relative paths work too
```

#### 🏗️ Create Virtual Environment (`cvenv`)
Create `.venv` using conda's Python, activate it, and upgrade pip:

```bash
$ cvenv                     # Create venv in current directory
$ cvenv myproject           # Create venv in myproject/ directory
```

#### 🏃 Python Module Runner (`pm`)
Run Python modules using file paths:

```bash
$ pm script.py              # Run script.py as module
$ pm path/to/module.py      # Run module with full path
```

#### 🕵️ Python Class Inspector (`pmem`)
Display public members (methods and attributes) of Python built-in classes:

```bash
$ pmem str                       # Show public members of str class
$ pmem -m list                   # Show magic methods of list class
$ pmem --magic dict              # Show magic methods of dict class
$ pmem -a bytearray              # Show both public and magic methods
$ pmem --all int                 # Show both public and magic methods
$ pmem -d str                    # Show public members with docstrings
$ pmem -ad list                  # Show all members with docstrings
$ pmem -md dict                  # Show magic methods with docstrings
$ pmem xmlrpc.client.ServerProxy # Show ServerProxy class members
$ pmem -d urllib.request.Request # Show Request class with docstrings
$ pmem pathlib.Path              # Show Path class members
```

**Class Specification:**
- **Built-in classes**: Use simple names like `str`, `int`, `list`, `dict`
- **Module classes**: Use dot notation like `xmlrpc.client.ServerProxy`, `urllib.request.Request`

**Options:**
- Default: Shows public members (methods and attributes that don't start with underscore)
- `-m, --magic`: Shows magic methods (names starting with `__`)
- `-a, --all`: Shows both public and magic methods in separate sections
- `-d, --docs`: Shows docstrings for each member (when available)

The function automatically imports required modules when using dot notation, making it easy to explore any Python class without manual imports.

**Common Examples:**
- `pmem xmlrpc.client.ServerProxy` - XML-RPC client methods
- `pmem urllib.request.Request` - HTTP request class
- `pmem pathlib.Path` - Modern path handling
- `pmem json.JSONEncoder` - JSON encoding methods
- `pmem sqlite3.Connection` - Database connection methods

#### 📊 Python Dependency Analysis (`preq`)
Analyze Python project dependencies and environment information:

```bash
$ preq                             # Analyze current project dependencies
```

**Features:**
- Detects and analyzes requirements.txt files
- Shows installed packages matching requirements
- Lists outdated packages with current/latest versions
- Supports Pipenv projects with dependency graphs
- Displays virtual environment disk usage
- Detects Poetry projects in pyproject.toml files
- Shows active virtual environment information

**Supported Configuration Files:**
- `requirements.txt` - Standard pip requirements
- `Pipfile` - Pipenv project dependencies
- `pyproject.toml` - Poetry and other modern Python projects

**Output Information:**
- Installed vs required packages comparison
- Outdated packages that need updates
- Virtual environment size and location
- Dependency graphs for Pipenv projects
- Active environment status

#### 🧪 Python Testing with Coverage (`pytestcov`)
Run Python tests with comprehensive coverage analysis:

```bash
$ pytestcov                        # Test current directory with coverage
$ pytestcov tests/                 # Test specific directory
$ pytestcov test_module.py         # Test specific file
$ pytestcov tests/ -v              # Verbose output
$ pytestcov . --tb=short           # Short traceback format
$ pytestcov tests/ -k "unit"       # Run only tests matching 'unit'
```

**Features:**
- Automatic installation of pytest and pytest-cov if missing
- Terminal coverage report with missing lines highlighted
- HTML coverage report with detailed file-by-file analysis
- Test execution statistics and comprehensive reporting
- Supports all standard pytest options and filters
- Generates interactive HTML coverage reports

**Generated Output:**
- Terminal coverage report with line-by-line analysis
- `htmlcov/index.html` - Interactive HTML coverage report
- `.coverage` - Coverage data file for further analysis
- Test execution summary with pass/fail statistics

**Requirements:**
- Python testing environment with write permissions
- Automatic tool installation via pip

#### 🎨 Python Code Formatting (`pfmt`)
Format and lint Python code using industry-standard tools:

```bash
$ pfmt                             # Format current directory
$ pfmt src/                        # Format specific directory
$ pfmt module.py                   # Format specific file
$ pfmt --check                     # Check formatting without changes
$ pfmt --diff src/                 # Show formatting differences
$ pfmt --line-length 100 .         # Use custom line length
```

**Tools Integration:**
- **black** - PEP 8 compliant code formatter
- **isort** - Import statement organizer with black compatibility
- **flake8** - Code style checker and linter

**Features:**
- Automatic tool installation if missing
- Consistent code formatting across entire projects
- Import organization compatible with black formatting
- Configurable line length (default: 88 characters)
- Check and diff modes for CI/CD integration
- Compatible with popular development workflows

**Configuration:**
- Line length: 88 characters (black default, configurable)
- flake8 ignores: E203 (whitespace before ':'), W503 (line break before operator)
- isort profile: black (ensures compatibility)
- In-place formatting with version control recommended

**Options:**
- `--check` - Verify formatting without making changes
- `--diff` - Show what would be changed without applying
- `--line-length N` - Set custom maximum line length

#### 📦 Node.js Development Tools

#### 🔢 Node Version Management (`nu`, `nl`, `ni`)
Simplified nvm operations for Node.js version management:

```bash
$ nu 18.17.0               # Use Node.js version 18.17.0
$ nu lts                   # Use latest LTS version
$ nl                       # List installed Node.js versions
$ ni 20.5.0                # Install Node.js version 20.5.0
$ ni --lts                 # Install latest LTS version
```

### 🕰️ Time and Date Utilities (`now`, `nowtime`, `nowdate`)

Get current time and date information:

```bash
$ now                      # Current time and date: 14:30:22 2023-12-01
$ nowtime                  # Current time only: 14:30:22
$ nowdate                  # Current date only: 2023-12-01
```

### 📈 Resource Monitoring (`topcpu`, `topmem`)

Monitor system resource usage:

```bash
$ topcpu                   # Show top processes by CPU usage
$ topmem                   # Show top processes by memory usage
```

Output shows processes sorted by resource consumption with PID, user, and command details.

### 🌍 Network Monitoring (`isup`, `myip`)

Check website availability:

```bash
$ isup google.com
Checking: http://google.com
✅ Website is UP (HTTP 200 - OK)

$ isup badsite.xyz
Checking: http://badsite.xyz
❌ Website is DOWN (connection failed, curl exit code: 6)
```

Show IP address information:

```bash
$ myip
=== IP ADDRESS INFORMATION ===

Local IP Addresses:
  192.168.1.100

External IP Address:
  203.0.113.45

Network Interfaces:
  lo
  eth0
```

### 🌐 Network Utilities (`ports`)

Show active network connections and listening ports:

```bash
$ ports                    # Display all network connections and listening ports
```

Shows local/remote addresses, connection states, and associated processes.

### � Git Shortcuts

Quick Git operations for common workflows:

#### 🤖 AI-Powered Commits (`gcm`)

Automatically stage all changes and generate intelligent commit messages using GitHub Copilot:

```bash
$ gcm                      # Stage all changes and commit with AI-generated message
```

**Features:**
- Runs `git add -A` to stage all changes
- Uses GitHub Copilot CLI to analyze changes and generate meaningful commit messages
- Interactive workflow with Copilot for best commit message quality

**Requirements:**
- GitHub Copilot CLI installed: `npm install -g @githubnext/github-copilot-cli`
- Authenticated with GitHub Copilot

#### 📝 Basic Git Operations

Common Git shortcuts for faster workflows:

```bash
$ gs                       # Git status
$ ga file.txt              # Git add specific file
$ gaa                      # Git add all files (git add -A)
$ gc "commit message"      # Git commit with message
$ gp                       # Git push
$ gu                       # Git pull
$ gb                       # Git branch
$ gco branch-name          # Git checkout branch
$ gcb new-branch           # Git checkout new branch
$ gl                       # Git log one line
$ gd                       # Git diff
$ gdc                      # Git diff cached
$ gr file.txt              # Git remove from cache
```

#### 🚀 Auto-Commit (`gac`)

Quick commit with auto-generated message:

```bash
$ gac                      # Add all files and commit with auto message
```

Automatically generates commit message based on number of files changed.

#### 🔁 Recursive Pull (`gpullall`)

Recursively find every Git repository under a directory and run `git pull`,
but only where it is safe to do so:

```bash
$ gpullall                 # Pull every repo under the current directory
$ gpullall ~/Projects      # Pull every repo under ~/Projects
```

A repository is skipped (not failed) when:

- the working tree has uncommitted changes (including unresolved merges),
- the current branch has no upstream configured, or
- merging the fetched upstream into `HEAD` would produce a conflict
  (detected up-front with `git merge-tree`, before the pull runs).

Output is one block per repo followed by a summary of how many were pulled,
skipped, and failed. Exits non-zero only if any `fetch`/`pull` actually
errored — a skipped repo is not a failure.

### �🔎 Git Repository Information (`gitinfo`)

Display comprehensive Git repository status:

```bash
$ gitinfo
=== GIT REPOSITORY INFO ===
Current branch: main
Repository: myproject
Last commit: a1b2c3d - Fix bug in authentication (2 hours ago)
Status:
  Working tree clean - no changes to commit
```

### ⚙️ Configuration Management

#### ⚡️ Quick Configuration Access (`bashrc`, `zshrc`, `vimrc`, `nginxconf`)
Instantly open configuration files for editing:

```bash
$ bashrc                   # Edit ~/.bashrc
$ zshrc                    # Edit ~/.zshrc  
$ vimrc                    # Edit ~/.vimrc
$ nginxconf                # Edit /etc/nginx/nginx.conf
```

#### 🔄 Configuration Reloading (`sobashrc`, `sozshrc`)
Quickly reload shell configurations:

```bash
$ sobashrc                 # Reload ~/.bashrc
$ sozshrc                  # Reload ~/.zshrc
```

### 📂 Directory Navigation Enhancements

#### 🚶‍♂️ Smart Navigation (`..`, `...`, `....`, `~`)
Quick directory traversal shortcuts:

```bash
$ ..                       # Go up one directory (cd ..)
$ ...                      # Go up two directories (cd ../..)
$ ....                     # Go up three directories (cd ../../..)
$ ~                        # Go to home directory (cd ~)
```

#### 🏗️ Create and Navigate (`mkcd`)
Create directory and navigate into it in one command:

```bash
$ mkcd new_project         # Create and enter new_project directory
$ mkcd path/to/deep/dir    # Create nested directories and navigate
```

### 📃 Enhanced File Listing

#### 📄 File Listing Variants (`ll`, `la`, `l`)
Enhanced directory listing with different detail levels:

```bash
$ ll                       # Detailed list with human-readable sizes (ls -lh)
$ la                       # List all files including hidden (ls -la)
$ l                        # Compact column format (ls -CF)
```

### 👁️ File Viewing Enhancements

#### 🔎 Enhanced Less (`less`, `le`, `tle`)
Improved file viewing with enhanced less functionality:

```bash
$ less file.txt            # Enhanced less (less -RMNi --use-color)
$ le file.txt              # Alias for less
$ tle file.txt             # Open file with less, start at end (+G)
```

Flags used: `-R` raw colour escapes, `-M` verbose prompt, `-N` line numbers,
`-i` case-insensitive search, `--use-color` colourised output (requires less 580+).

### 🛤️ System Path and History

#### 🛣️ Path Display (`path`)
Format and display the system PATH variable:

```bash
$ path                     # Display PATH with each directory on separate line
```

#### 🕰️ Command History (`h`)
Quick access to command history:

```bash
$ h                        # Display command history
$ h | grep pattern         # Search history for a pattern
```

### 🖥️ tmux Session Management (`ta`)

Quick tmux session attachment:

```bash
$ ta session_name          # Attach to named tmux session
```

### 🛠️ Development Tools

#### 🧪 API Testing (`apitest`)
Quick HTTP API testing tool using curl with automatic formatting and timing:

```bash
$ apitest localhost:3000/api/users                    # GET request
$ apitest api.example.com/data GET                    # Explicit GET
$ apitest localhost/api/users POST '{"name":"John"}'  # POST with data
$ apitest api.site.com/users/1 PUT '{"age":25}'       # PUT request
$ apitest localhost:8080/api/users/1 DELETE           # DELETE request
$ apitest https://api.github.com/users/octocat         # External API
```

**Features:**
- Automatic Content-Type and Accept headers for JSON
- Response time measurement and HTTP status code display
- Support for GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS methods
- Automatic protocol detection (adds http:// if missing)
- Pretty formatted output with response information
- Error handling with helpful troubleshooting tips

**Response Information:**
- HTTP status code
- Response time in seconds
- Response size in bytes
- Complete response body

#### 🗜️ Asset Optimization (`optimizeassets`)
Optimize web assets by minifying JavaScript and CSS files:

```bash
$ optimizeassets                   # Optimize current directory
$ optimizeassets ./src/assets      # Optimize specific directory
$ optimizeassets /path/to/project  # Optimize project directory
$ optimizeassets ../public         # Optimize relative path
```

**Features:**
- Automatic minification of JavaScript files using UglifyJS
- Automatic minification of CSS files using clean-css
- Preserves original files while creating .min.js and .min.css versions
- Skips already minified files and node_modules directories
- Automatic tool installation via npm if not present
- File size reduction reporting with percentage savings
- Smart file timestamp checking to avoid unnecessary reprocessing

**Requirements:**
- Node.js and npm installed
- Write permissions in target directory
- npm global install permissions (for tool installation)

**Output Information:**
- Progress reporting for each processed file
- File size reduction percentages
- Summary of processed files and any errors
- Skips files that are already up to date

**Supported File Types:**
- JavaScript: `.js` files (creates `.min.js`)
- CSS: `.css` files (creates `.min.css`)
- Automatically excludes already minified files (`.min.js`, `.min.css`)

#### 🔑 Hash Calculator (`hashit`)
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

#### 🎲 Entropy Calculator (`entropy`)
Calculate Shannon entropy for strings, files, or stdin to measure randomness/complexity:

```bash
$ entropy "hello world"          # Calculate entropy of string
$ entropy passwords.txt          # Calculate entropy of file contents
$ echo "random data" | entropy - # Calculate entropy of stdin
```

Entropy values range from 0 (completely predictable) to ~8 (maximum randomness for byte data).

#### 🔄 String/Data Converter (`strconv`)
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

#### 🔢 Number Base Converter (`numconv`)
Convert numbers between different bases (2-36). The signature is
`numconv <number|range> [target_base] [source_base]`; the source base is
auto-detected from a `0x`, `0b` or leading-`0` prefix when omitted, and the
target base defaults to decimal:

```bash
$ numconv 255                    # Decimal in, decimal out: 255
$ numconv 0xff                   # Hex in, decimal out: 255
$ numconv 0b1010                 # Binary in, decimal out: 10
$ numconv 255 hex                # Decimal to hex: FF
$ numconv 255 bin                # Decimal to binary: 11111111
$ numconv 255 16                 # Same, using the numeric base: FF
$ numconv 377 hex 8              # Octal 377 to hex: FF
$ numconv 1000 36                # Decimal to base 36: RS
```

**Range conversion** (convert multiple consecutive numbers):
```bash
$ numconv 100-110 hex            # Convert 100-110 to hex: 64, 65, 66, ..., 6E
$ numconv 0x10-0x1F dec          # Convert hex 10-1F to decimal: 16, 17, ..., 31
$ numconv 8-12 bin               # Convert 8-12 to binary: 1000, 1001, ..., 1100
$ numconv 250-255 hex            # Convert 250-255 to hex: FA, FB, FC, FD, FE, FF
```

Range format supports the same base auto-detection and supports up to 1000 numbers per range.

#### 📏 Unit Converter (`unitconv`)
Convert between different units of measurement across multiple categories:

```bash
$ unitconv 100 cm m              # Convert 100 cm to meters: 1
$ unitconv 32 f c                # Convert 32°F to Celsius: 0
$ unitconv 1 km mi               # Convert 1 km to miles: 0.621371
$ unitconv 1000 g kg             # Convert 1000g to kg: 1
$ unitconv 1 gb mb               # Convert 1 GB to MB: 1000
$ unitconv 24 h min              # Convert 24 hours to minutes: 1440
$ unitconv 1 m2 ft2              # Convert 1 m² to ft²: 10.7639
$ unitconv 1 l ml                # Convert 1 liter to ml: 1000
```

**Supported Categories:**

**Length Units:**
- Metric: `mm`, `cm`, `m`, `km`, `nm`, `um`
- Imperial: `in`, `ft`, `yd`, `mi`, `mil`

**Weight/Mass Units:**
- Metric: `mg`, `g`, `kg`, `t`
- Imperial: `oz`, `lb`, `st`, `ton`

**Temperature Units:**
- `c` (Celsius), `f` (Fahrenheit), `k` (Kelvin)

**Volume Units:**
- Metric: `ml`, `l`
- Imperial: `gal`, `qt`, `pt`, `cup`, `fl_oz`, `tsp`, `tbsp`

**Area Units:**
- Metric: `mm2`, `cm2`, `m2`, `km2`, `ha`
- Imperial: `in2`, `ft2`, `yd2`, `mi2`, `acre`

**Time Units:**
- `ms`, `s`, `min`, `h`, `d`, `w`, `mo`, `y`

**Data/Storage Units:**
- Decimal: `b`, `kb`, `mb`, `gb`, `tb`, `pb`
- Binary: `kib`, `mib`, `gib`, `tib`, `pib`

**Features:**
- Case-insensitive unit names
- High precision calculations using bc
- Automatic decimal cleanup for clean output
- Cross-category conversion prevention
- Comprehensive error handling and validation

#### 🔐 Random Password Generator (`randstr`)
Generate secure random strings from `openssl rand` (Base64 alphabet: `A-Z a-z 0-9 + /`).
The default length is 16 characters:

```bash
$ randstr              # Generate 16-character string: kR3xPq7Za1MvBn8W
$ randstr 32           # Generate 32-character string
$ randstr 64           # Generate 64-character string
```

#### 🧮 Mathematical Calculators (`calc`, `log2`, `pow2`)

**Calculator (`calc`):** results are printed with 3 decimal places. Available
functions: `sqrt`, `sin`, `cos`, `tan`, `atan`, `ln`, `log` (base 10), `exp`;
constants `pi` and `e`.

```bash
$ calc "2 + 3 * 4"          # Result: 14
$ calc "sqrt(16)"           # Result: 4.000
$ calc "sin(pi/2)"          # Result: 1.000
$ calc "log(100)"           # Result: 2.000 (base 10)
```

**Base-2 Logarithm (`log2`):** results are printed with 6 decimal places.
```bash
$ log2 8                    # Result: 3.000000 (since 2³ = 8)
$ log2 1024                 # Result: 10.000000 (since 2¹⁰ = 1024)
```

**Powers of 2 (`pow2`):**
```bash
$ pow2 3                    # Result: 8 (2³)
$ pow2 10                   # Result: 1024 (2¹⁰)
```

#### 🧾 JSON Pretty Printer (`jsonpp`)
Format and pretty-print JSON data:

```bash
$ jsonpp data.json          # Pretty-print JSON file
$ echo '{"a":1,"b":2}' | jsonpp -    # Pretty-print JSON from stdin
```

#### 📝 Wordlist Processor (`wordlist`)
Advanced wordlist filtering and processing. Run `wordlist --help` for the full
option list:

```bash
$ wordlist -min 8 -max 12 passwords.txt              # Filter by length 8-12 characters
$ wordlist -regex "^[a-z]+$" words.txt               # Keep only lowercase words
$ wordlist -notregex "[0-9]" words.txt               # Exclude words containing digits
$ wordlist -i -regex "PASS" words.txt                # Case-insensitive regex
$ wordlist -minentropy 4.0 entropy.txt               # Filter by minimum entropy
$ wordlist -minnum 2 -minspecial 1 passwords.txt     # Filter by character classes
$ wordlist -su words.txt                             # Sort and remove duplicates
$ wordlist -r -o random.txt words.txt                # Randomize word order
$ wordlist -split 100MB -o parts.txt large.txt       # Split into 100MB files
$ wordlist -splitpct "30 30 40" -o parts.txt in.txt  # Split by percentage
$ cat passwords.txt | wordlist -su -                 # Read from stdin
```

**Options:**

| Option | Effect |
|--------|--------|
| `-s` / `-u` / `-su` | Sort / deduplicate / both |
| `-r` | Randomize word order |
| `-i` / `-I` | Case-insensitive / case-sensitive regex (default `-I`) |
| `-min N` / `-max N` | Word length bounds |
| `-minentropy E` / `-maxentropy E` | Shannon entropy bounds |
| `-minnum` / `-maxnum` | Count of digits |
| `-minlower` / `-maxlower` | Count of lowercase letters |
| `-minupper` / `-maxupper` | Count of uppercase letters |
| `-minspecial` / `-maxspecial` | Count of special characters |
| `-regex P` / `-notregex P` | Keep / exclude words matching a pattern |
| `-keepws` / `-removews` | Keep only / drop words containing whitespace |
| `-o FILE` | Write to a file instead of stdout |
| `-split SIZE` | Split output into `SIZE` chunks (requires `-o`) |
| `-splitpct "X Y Z"` | Split output by percentage, must sum to 100 (requires `-o`) |

### 📚 Cheatsheets (`csvim`, `cstmux`, `csless`, `csterminator`, `csterminal`)

#### 📝 Vim Cheatsheet (`csvim`)
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

#### 🖥️ tmux Cheatsheet (`cstmux`)
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

#### 📖 less Cheatsheet (`csless`)
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

#### 🖥️ Terminator Cheatsheet (`csterminator`)
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

#### ⌨️ Terminal Cheatsheet (`csterminal`)
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
- Background process management (jobs, fg, bg)
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

## 📄 License

MIT License.
