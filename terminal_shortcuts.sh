# Get the directory where this script is located
SCRIPT_DIR="$(dirname "$0")"

source "$SCRIPT_DIR/aliases.sh"

# Source all files in functions.d directory
if [[ -d "$SCRIPT_DIR/functions.d" ]]; then
  for file in "$SCRIPT_DIR/functions.d"/*; do
    if [[ -f "$file" ]]; then
      source "$file"
    fi
  done
fi
