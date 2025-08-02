#!/bin/bash
# System Information Display Function
# 
# Description: Provides comprehensive system information including OS details,
# CPU specifications, memory usage, GPU information, and disk usage.
# Works cross-platform (macOS and Linux) with appropriate fallbacks.
#
# Usage: sysinfo
# Example: $ sysinfo

if ! should_exclude "sysinfo" 2>/dev/null; then
  sysinfo() {
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
