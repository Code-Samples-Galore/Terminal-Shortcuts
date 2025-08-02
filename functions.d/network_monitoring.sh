#!/bin/bash
# Network and System Monitoring Functions
#
# Description: Collection of utilities for network monitoring, process analysis,
# and system observation. Includes website availability checking, process monitoring,
# log file watching, and weather information retrieval.
#
# Functions:
#   isup       - Check if a website is accessible
#   topcpu     - Show top 10 processes by CPU usage
#   topmem     - Show top 10 processes by memory usage
#   watchlog   - Monitor log file changes in real-time
#   weather    - Get weather information for a city
#
# Usage Examples:
#   $ isup google.com     # Check if Google is up
#   $ topcpu              # Show CPU-intensive processes
#   $ topmem              # Show memory-intensive processes
#   $ watchlog /var/log/system.log  # Monitor system log
#   $ weather London      # Get London weather

# Check if website is up
if ! should_exclude "isup" 2>/dev/null; then
  isup() {
    local website=$1
    if curl -sSf "$website" > /dev/null; then
      echo "$website is UP"
    else
      echo "$website is DOWN"
    fi
  }
fi

# Show top processes by CPU/Memory
if ! should_exclude "topcpu" 2>/dev/null; then
  topcpu() {
    ps aux --sort=-%cpu | head -10
  }
fi

if ! should_exclude "topmem" 2>/dev/null; then
  topmem() {
    ps aux --sort=-%mem | head -10
  }
fi

# Monitor log file
if ! should_exclude "watchlog" 2>/dev/null; then
  watchlog() {
    if [[ -f "$1" ]]; then
      tail -f "$1"
    else
      echo "File not found: $1"
    fi
  }
fi

# Weather info (requires curl)
if ! should_exclude "weather" 2>/dev/null; then
  weather() {
    local city=${1:-""}
    curl -s "wttr.in/$city?format=3"
  }
fi