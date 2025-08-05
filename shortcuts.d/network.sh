#!/bin/bash
# Network Utilities Functions
#
# Description: Network diagnostic and utility functions for testing connectivity,
# checking website availability, displaying IP addresses, and monitoring network connections.
# Includes both basic and advanced network troubleshooting tools.
#
# Functions:
#   isup       - Check if website is accessible
#   myip       - Display local and external IP addresses
#   ports      - Show network ports and connections
#   fastping   - Fast ping test (100 packets)
#
# Aliases:
#   ping       - Ping 5 times (instead of unlimited)
#   wget       - Wget with continue option
#
# Usage Examples:
#   $ isup google.com            # Check if Google is accessible
#   $ myip                       # Show local and external IP addresses
#   $ ports                      # Show all network connections
#   $ fastping 8.8.8.8          # Fast ping test with 100 packets
#   $ ping google.com            # Ping 5 times
#   $ wget -c file.zip           # Download with resume capability

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "ping"
cleanup_shortcut "wget"
cleanup_shortcut "isup"
cleanup_shortcut "myip"
cleanup_shortcut "ports"
cleanup_shortcut "fastping"

# Network
if ! should_exclude "ping" 2>/dev/null; then alias ping='ping -c 5'; fi
if ! should_exclude "wget" 2>/dev/null; then alias wget='wget -c'; fi

# Check if website is up
if ! should_exclude "isup" 2>/dev/null; then
  isup() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: isup <website_or_ip>"
      echo ""
      echo "Check if a website or IP address is accessible."
      echo "Tests HTTP connectivity and reports response status."
      echo ""
      echo "Examples:"
      echo "  isup google.com              # Check if Google is accessible"
      echo "  isup https://example.com     # Check specific URL"
      echo "  isup 8.8.8.8                # Check IP address"
      echo "  isup github.com              # Check GitHub accessibility"
      echo "  isup localhost:3000          # Check local service"
      echo ""
      echo "Response codes:"
      echo "  200-299: Success (website is up)"
      echo "  300-399: Redirection (usually OK)"
      echo "  400-499: Client error (check URL)"
      echo "  500-599: Server error (website issues)"
      return 1
    fi
    
    local url="$1"
    
    # Add http:// if no protocol specified
    if [[ ! "$url" =~ ^https?:// ]]; then
      url="http://$url"
    fi
    
    echo "Checking: $url"
    
    if command -v curl >/dev/null 2>&1; then
      local response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")
      local exit_code=$?
      
      if [[ $exit_code -eq 0 ]]; then
        case "$response" in
          200) echo "✅ Website is UP (HTTP $response - OK)" ;;
          3*) echo "⚠️  Website is UP (HTTP $response - Redirected)" ;;
          4*) echo "❌ Website error (HTTP $response - Client Error)" ;;
          5*) echo "❌ Website error (HTTP $response - Server Error)" ;;
          *) echo "⚠️  Unexpected response (HTTP $response)" ;;
        esac
      else
        echo "❌ Website is DOWN (Connection failed)"
      fi
    else
      echo "Error: curl not found. Please install curl to use this function."
      return 1
    fi
  }
fi

# Show IP addresses
if ! should_exclude "myip" 2>/dev/null; then
  myip() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: myip"
      echo ""
      echo "Display local and external IP addresses."
      echo "Shows network interface information and public IP."
      echo ""
      echo "Information displayed:"
      echo "  • Local IP addresses for all interfaces"
      echo "  • External/Public IP address"
      echo "  • Network interface details"
      echo ""
      echo "Examples:"
      echo "  myip                         # Show all IP information"
      echo ""
      echo "Note: This command takes no arguments"
      return 0
    fi
    
    if [[ $# -gt 0 ]]; then
      echo "Error: myip takes no arguments"
      echo "Usage: myip"
      echo "Use 'myip --help' for more information"
      return 1
    fi
    
    echo "=== IP ADDRESS INFORMATION ==="
    echo
    
    echo "Local IP Addresses:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      ifconfig | grep -E "inet [0-9]" | grep -v 127.0.0.1 | awk '{print "  " $2}' | head -5
    else
      # Linux
      ip addr show | grep -E "inet [0-9]" | grep -v 127.0.0.1 | awk '{print "  " $2}' | cut -d'/' -f1 | head -5
    fi
    
    echo
    echo "External IP Address:"
    if command -v curl >/dev/null 2>&1; then
      local ext_ip=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || curl -s --max-time 5 ipinfo.io/ip 2>/dev/null || echo "Unable to determine")
      echo "  $ext_ip"
    else
      echo "  Unable to determine (curl not available)"
    fi
    
    echo
    echo "Network Interfaces:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      ifconfig | grep -E "^[a-z]" | awk '{print "  " $1}' | head -10
    else
      # Linux
      ip link show | grep -E "^[0-9]" | awk '{print "  " $2}' | sed 's/:$//' | head -10
    fi
  }
fi

# Show network connections and ports
if ! should_exclude "ports" 2>/dev/null; then
  ports() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: ports"
      echo ""
      echo "Show network ports and active connections."
      echo "Displays listening ports and established connections."
      echo ""
      echo "Information shown:"
      echo "  • Listening ports (servers)"
      echo "  • Established connections"
      echo "  • Process names and PIDs"
      echo "  • Local and remote addresses"
      echo ""
      echo "Examples:"
      echo "  ports                        # Show all network connections"
      echo ""
      echo "Note: This command takes no arguments"
      return 0
    fi
    
    if [[ $# -gt 0 ]]; then
      echo "Error: ports takes no arguments"
      echo "Usage: ports"
      echo "Use 'ports --help' for more information"
      return 1
    fi
    
    echo "=== NETWORK CONNECTIONS ==="
    echo
    
    if command -v netstat >/dev/null 2>&1; then
      echo "Listening Ports:"
      netstat -tuln | grep LISTEN | head -10
      echo
      echo "Established Connections:"
      netstat -tupn | grep ESTABLISHED | head -10
    elif command -v ss >/dev/null 2>&1; then
      echo "Listening Ports:"
      ss -tuln | head -10
      echo
      echo "Established Connections:"
      ss -tupn | grep ESTAB | head -10
    else
      echo "Error: Neither netstat nor ss found. Please install net-tools or iproute2."
      return 1
    fi
  }
fi

# Fast ping function
if ! should_exclude "fastping" 2>/dev/null; then
  fastping() {
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: fastping <host_or_ip> [count]"
      echo ""
      echo "Perform a fast ping test with specified number of packets."
      echo "Default is 100 packets for comprehensive connectivity testing."
      echo ""
      echo "Examples:"
      echo "  fastping google.com          # Ping Google 100 times"
      echo "  fastping 8.8.8.8             # Ping Google DNS 100 times"
      echo "  fastping github.com 50       # Ping GitHub 50 times"
      echo "  fastping 192.168.1.1 200     # Ping router 200 times"
      return 1
    fi
    
    local host="$1"
    local count="${2:-100}"
    
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
      echo "Error: Count must be a positive integer"
      return 1
    fi
    
    echo "Fast ping test: $host ($count packets)"
    echo "Press Ctrl+C to stop early"
    echo
    
    ping -c "$count" "$host"
  }
fi