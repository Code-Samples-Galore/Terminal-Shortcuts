# Get the directory where this script is located
SCRIPT_DIR="$(dirname "$0")"

# Function to check if an item should be excluded
should_exclude() {
  local item="$1"
  if [[ -n "$EXCLUDE_SHORTCUTS" ]]; then
    for excluded in $EXCLUDE_SHORTCUTS; do
      if [[ "$excluded" == "$item" ]]; then
        return 0  # Should exclude
      fi
    done
  fi
  return 1  # Should not exclude
}

# Source all files in shortcuts.d directory
if [[ -d "$SCRIPT_DIR/shortcuts.d" ]]; then
  for file in "$SCRIPT_DIR/shortcuts.d"/*; do
    if [[ -f "$file" ]]; then
      source "$file"
    fi
  done
fi

# Clean up the function after all files are sourced
unset -f should_exclude
