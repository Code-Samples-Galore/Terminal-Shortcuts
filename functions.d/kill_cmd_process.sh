#!/bin/bash
# Process Killer by Command Name Function
#
# Description: Searches for and kills processes by command name or partial match.
# Provides interactive confirmation before killing processes and shows detailed
# information about matched processes including PID and command line.
#
# Usage: killcmd <command_string>
# Example: $ killcmd firefox    # Finds and kills all Firefox processes
#          $ killcmd python     # Finds and kills all Python processes

if ! should_exclude "killcmd" 2>/dev/null; then
  killcmd() {
    if [[ -z "$1" ]]; then
      echo "Usage: killcmd <command_string>"
      echo "Example: killcmd firefox"
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
      rm "$temp_file"
      return 1
    fi
    
    local count=$(wc -l < "$temp_file")
    echo "Found $count matching process(es):"
    
    while IFS= read -r line; do
      local pid=$(echo "$line" | awk '{print $2}')
      local cmd=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
      echo "PID: $pid - $cmd"
    done < "$temp_file"
    echo
    
    echo -n "Kill all these processes? (y/N): "
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      while IFS= read -r line; do
        local pid=$(echo "$line" | awk '{print $2}')
        echo "Killing PID: $pid"
        kill -9 "$pid" 2>/dev/null
        if [[ $? -eq 0 ]]; then
          echo "Successfully killed PID: $pid"
        else
          echo "Failed to kill PID: $pid (may already be dead or permission denied)"
        fi
      done < "$temp_file"
    else
      echo "Operation cancelled"
    fi
    
    rm "$temp_file"
  }
fi
