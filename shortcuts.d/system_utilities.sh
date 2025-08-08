#!/bin/bash
# System Utilities Functions
# 
# Description: Comprehensive system information and process management utilities.
# Includes OS details display, process killing by command name, resource monitoring,
# and time/date utilities. Works cross-platform (macOS and Linux).
#
# Functions:
#   sysinfo    - Display comprehensive system information (OS, CPU, memory, GPU, disk)
#   killcmd    - Interactive process killer by command name
#   topcpu     - Show top 10 processes by CPU usage
#   topmem     - Show top 10 processes by memory usage
#
# Aliases:
#   h          - Command history
#   path       - Display PATH variable formatted
#   now        - Current time and date
#   nowtime    - Current time only
#   nowdate    - Current date only
#
# Usage Examples:
#   $ sysinfo                    # Show comprehensive system information
#   $ killcmd firefox            # Kill all Firefox processes interactively
#   $ topcpu                     # Show top CPU-consuming processes
#   $ topmem                     # Show top memory-consuming processes
#   $ h                          # Show command history
#   $ path                       # Display PATH variable formatted

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "so"
cleanup_shortcut "h"
cleanup_shortcut "path"
cleanup_shortcut "now"
cleanup_shortcut "nowtime"
cleanup_shortcut "nowdate"
cleanup_shortcut "sysinfo"
cleanup_shortcut "killcmd"
cleanup_shortcut "topcpu"
cleanup_shortcut "topmem"

# System Utilities
if ! should_exclude "so" 2>/dev/null; then alias so='source'; fi
if ! should_exclude "h" 2>/dev/null; then alias h='history'; fi
if ! should_exclude "path" 2>/dev/null; then alias path='echo -e ${PATH//:/\\n}'; fi
if ! should_exclude "now" 2>/dev/null; then alias now='date +"%T %Y-%m-%d"'; fi
if ! should_exclude "nowtime" 2>/dev/null; then alias nowtime='date +"%T"'; fi
if ! should_exclude "nowdate" 2>/dev/null; then alias nowdate='date +"%Y-%m-%d"'; fi

if ! should_exclude "sysinfo" 2>/dev/null; then
  sysinfo() {
    if [[ $# -gt 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: sysinfo"
      echo ""
      echo "Display comprehensive system information including:"
      echo "  • Operating system details and kernel version"
      echo "  • System uptime and load information"
      echo "  • CPU model, cores, and architecture"
      echo "  • Memory usage and available RAM"
      echo "  • GPU information (if available)"
      echo "  • Disk space usage for mounted filesystems"
      echo ""
      echo "Examples:"
      echo "  sysinfo                    # Show all system information"
      echo ""
      echo "Note: This command takes no arguments"
      return 1
    fi
    
    echo "=== SYSTEM INFORMATION ==="
    echo
    
    echo "OS Information:"
    echo "Hostname: $(hostname)"
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"

    if command -v lsb_release &> /dev/null; then
      lsb_release -a 2>/dev/null
    elif [[ -f /etc/os-release ]]; then
      cat /etc/os-release | head -2
    fi
    echo
    
    echo "Uptime:"
    uptime
    echo
    
    echo "CPU Information:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      sysctl -n machdep.cpu.brand_string
      echo "Cores: $(sysctl -n hw.ncpu)"
    elif command -v lscpu &> /dev/null; then
      # Linux with lscpu
      lscpu | grep -E "Model name|CPU\(s\)|Thread|Core"
    elif [[ -f /proc/cpuinfo ]]; then
      # Linux fallback
      grep -E "model name|cpu cores|processor" /proc/cpuinfo | head -3
    fi
    echo
    
    echo "Memory Information:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      echo "Total: $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB"
      vm_stat | grep -E "Pages free|Pages active|Pages inactive" | awk '{print $1 " " $2 " " $3}'
    elif command -v free &> /dev/null; then
      # Linux
      free -h
    fi
    echo
    
    echo "GPU Information:"
    if command -v nvidia-smi &> /dev/null; then
      nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      system_profiler SPDisplaysDataType | grep -E "Chipset Model|VRAM" | sed 's/^[[:space:]]*//'
    elif command -v lspci &> /dev/null; then
      lspci | grep -i vga
    else
      echo "GPU information not available"
    fi
    echo
    
    echo "Disk Usage:"
    df -h | grep -E "Filesystem|/dev/"
    echo
  }
fi

# Process Killer by Command Name Function
if ! should_exclude "killcmd" 2>/dev/null; then
  killcmd() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: killcmd <command_string>"
      echo ""
      echo "Interactively kill processes by command name or pattern."
      echo "Searches for running processes matching the given string and prompts for confirmation."
      echo ""
      echo "Features:"
      echo "  • Case-insensitive search"
      echo "  • Interactive confirmation before killing"
      echo "  • Shows process details before termination"
      echo "  • Uses SIGKILL (-9) for reliable termination"
      echo ""
      echo "Examples:"
      echo "  killcmd firefox              # Kill all Firefox processes"
      echo "  killcmd chrome               # Kill all Chrome processes"
      echo "  killcmd python               # Kill all Python processes"
      echo "  killcmd \"node server\"        # Kill processes containing 'node server'"
      echo "  killcmd vim                  # Kill all Vim instances"
      echo "  killcmd ssh                  # Kill all SSH connections"
      echo ""
      echo "Note: This command requires superuser privileges for system processes"
      return 1
    fi
    
    local search_term="$1"
    echo "=== KILL COMMAND ==="
    echo "Searching for processes containing: '$search_term'"
    echo
    
    # Find matching processes and create temporary file
    local temp_file=$(mktemp)
    ps aux | grep -i "$search_term" | grep -v grep | grep -v "killcmd $search_term" > "$temp_file"
    
    if [[ ! -s "$temp_file" ]]; then
      echo "No processes found matching '$search_term'"
      echo ""
      echo "Tips:"
      echo "  • Check if the process name is correct"
      echo "  • Try a partial name (e.g., 'fire' instead of 'firefox')"
      echo "  • Use 'ps aux | grep <name>' to see all matching processes"
      rm "$temp_file"
      return 1
    fi
    
    local count=$(wc -l < "$temp_file")
    echo "Found $count matching process(es):"
    echo
    
    while IFS= read -r line; do
      local pid=$(echo "$line" | awk '{print $2}')
      local cpu=$(echo "$line" | awk '{print $3}')
      local mem=$(echo "$line" | awk '{print $4}')
      local cmd=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
      echo "PID: $pid (CPU: ${cpu}%, MEM: ${mem}%) - $cmd"
    done < "$temp_file"
    echo
    
    echo -n "Kill all these processes? (y/N): "
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      echo "Terminating processes..."
      while IFS= read -r line; do
        local pid=$(echo "$line" | awk '{print $2}')
        echo "Killing PID: $pid"
        kill -9 "$pid" 2>/dev/null
        if [[ $? -eq 0 ]]; then
          echo "✅ Successfully killed PID: $pid"
        else
          echo "❌ Failed to kill PID: $pid (may already be dead or permission denied)"
        fi
      done < "$temp_file"
    else
      echo "Operation cancelled"
    fi
    
    rm "$temp_file"
  }
fi

# Show top processes by CPU/Memory
if ! should_exclude "topcpu" 2>/dev/null; then
  topcpu() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: topcpu [count]"
      echo ""
      echo "Show top processes by CPU usage in descending order."
      echo "Displays process ID, CPU percentage, memory usage, and command."
      echo ""
      echo "Options:"
      echo "  count    Number of processes to show (default: 10)"
      echo ""
      echo "Examples:"
      echo "  topcpu                       # Show top 10 CPU-consuming processes"
      echo "  topcpu 5                     # Show top 5 CPU-consuming processes"
      echo "  topcpu 20                    # Show top 20 CPU-consuming processes"
      echo ""
      echo "Output columns:"
      echo "  USER     Process owner"
      echo "  PID      Process ID"
      echo "  %CPU     CPU usage percentage"
      echo "  %MEM     Memory usage percentage"
      echo "  COMMAND  Process command and arguments"
      echo ""
      echo "Note: This command takes no arguments and shows current CPU usage"
      return 0
    fi
    
    local count="${1:-10}"
    
    if [[ -n "$1" && ! "$1" =~ ^[0-9]+$ ]]; then
      echo "Error: Count must be a positive integer"
      echo "Usage: topcpu [count]"
      return 1
    fi
    
    echo "=== TOP $count PROCESSES BY CPU USAGE ==="
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS - use BSD-style ps
      ps aux | head -1  # Header
      ps aux | tail -n +2 | sort -k3 -nr | head -"$count"
    else
      # Linux - use GNU-style ps
      ps aux --sort=-%cpu | head -$((count + 1))
    fi
  }
fi

if ! should_exclude "topmem" 2>/dev/null; then
  topmem() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: topmem [count]"
      echo ""
      echo "Show top processes by memory usage in descending order."
      echo "Displays process ID, memory percentage, CPU usage, and command."
      echo ""
      echo "Options:"
      echo "  count    Number of processes to show (default: 10)"
      echo ""
      echo "Examples:"
      echo "  topmem                       # Show top 10 memory-consuming processes"
      echo "  topmem 5                     # Show top 5 memory-consuming processes"
      echo "  topmem 15                    # Show top 15 memory-consuming processes"
      echo ""
      echo "Output columns:"
      echo "  USER     Process owner"
      echo "  PID      Process ID"
      echo "  %CPU     CPU usage percentage"
      echo "  %MEM     Memory usage percentage"
      echo "  COMMAND  Process command and arguments"
      return 0
    fi
    
    local count="${1:-10}"
    
    if [[ -n "$1" && ! "$1" =~ ^[0-9]+$ ]]; then
      echo "Error: Count must be a positive integer"
      echo "Usage: topmem [count]"
      return 1
    fi
    
    echo "=== TOP $count PROCESSES BY MEMORY USAGE ==="
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS - use BSD-style ps
      ps aux | head -1  # Header
      ps aux | tail -n +2 | sort -k4 -nr | head -"$count"
    else
      # Linux - use GNU-style ps
      ps aux --sort=-%mem | head -$((count + 1))
    fi
  }
fi
