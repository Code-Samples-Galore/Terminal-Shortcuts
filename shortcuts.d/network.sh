#!/bin/bash
# Network Utilities Functions
#
# Description: Collection of utilities for network monitoring, connectivity testing,
# and IP address information. Includes website availability checking and network
# port monitoring with cross-platform compatibility.
#
# Functions:
#   isup       - Check if a website is accessible
#   myip       - Display local and external IP addresses
#
# Aliases:
#   ports      - Show network ports and connections (netstat -tulan)
#   wget       - Wget with continue option (-c)
#   ping       - Ping 5 times (-c 5)
#   fastping   - Fast ping test (100 packets, 0.2s interval)
#
# Usage Examples:
#   $ isup google.com            # Check if Google is accessible
#   $ myip                       # Show local and external IP addresses
#   $ ports                      # Show all network connections
#   $ ping google.com            # Ping Google 5 times
#   $ fastping 8.8.8.8          # Fast ping test to Google DNS

# Network and Process
if ! should_exclude "ports" 2>/dev/null; then alias ports='netstat -tulan'; fi
if ! should_exclude "wget" 2>/dev/null; then alias wget='wget -c'; fi
if ! should_exclude "ping" 2>/dev/null; then alias ping='ping -c 5'; fi
if ! should_exclude "fastping" 2>/dev/null; then alias fastping='ping -c 100 -s.2'; fi

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

# Display IP addresses
if ! should_exclude "myip" 2>/dev/null; then
  myip() {
    echo "=== IP ADDRESS INFORMATION ==="
    echo
    
    # Local IP address
    echo "Local IP Address:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print "  " $2}'
    else
      # Linux
      hostname -I | awk '{for(i=1;i<=NF;i++) print "  " $i}'
    fi
    echo
    
    # External IP address
    echo "External IP Address:"
    if command -v curl >/dev/null 2>&1; then
      local external_ip=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || curl -s icanhazip.com 2>/dev/null)
      if [[ -n "$external_ip" ]]; then
        echo "  $external_ip"
      else
        echo "  Unable to retrieve external IP"
      fi
    else
      echo "  curl not available - cannot retrieve external IP"
    fi
    echo
  }
fi