# Terminal Shortcuts - main entry point
#
# Source this file from ~/.bashrc or ~/.zshrc:
#   source /path/to/Terminal-Shortcuts/shortcuts.sh
#
# Set EXCLUDE_SHORTCUTS to a space-separated list of names to skip:
#   export EXCLUDE_SHORTCUTS="p hashit sc"

# Resolve the directory holding this script.
# $0 is NOT the sourced file in bash (it is the name of the running shell), so
# ${BASH_SOURCE[0]} is required there; zsh needs the %x prompt expansion.
if [ -n "$BASH_VERSION" ]; then
  SHORTCUTS_SOURCE="${BASH_SOURCE[0]}"
elif [ -n "$ZSH_VERSION" ]; then
  SHORTCUTS_SOURCE="${(%):-%x}"
else
  SHORTCUTS_SOURCE="$0"
fi
SHORTCUTS_DIR="$(cd "$(dirname "$SHORTCUTS_SOURCE")" 2>/dev/null && pwd)"

if [ -z "$SHORTCUTS_DIR" ] || [ ! -d "$SHORTCUTS_DIR" ]; then
  echo "shortcuts.sh: unable to determine install directory; nothing loaded" >&2
  unset SHORTCUTS_SOURCE SHORTCUTS_DIR
  return 1 2>/dev/null || exit 1
fi

# Split EXCLUDE_SHORTCUTS into a list once, at load time.
# zsh does not word-split unquoted parameters, so the split must be explicit.
if [ -n "$ZSH_VERSION" ]; then
  SHORTCUTS_EXCLUDED=(${=EXCLUDE_SHORTCUTS})
else
  # shellcheck disable=SC2206
  SHORTCUTS_EXCLUDED=($EXCLUDE_SHORTCUTS)
fi

# Return 0 (true) when a shortcut name should be skipped.
should_exclude() {
  case " ${SHORTCUTS_EXCLUDED[*]} " in
    *" $1 "*) return 0 ;;
  esac
  return 1
}

# Drop any alias or function of this name so the definition below wins.
# Names the user asked to exclude are left untouched.
cleanup_shortcut() {
  if ! should_exclude "$1"; then
    unalias "$1" 2>/dev/null || true
    unset -f "$1" 2>/dev/null || true
  fi
}

# Source every *.sh file in a directory.
# Wrapped in a function so `no_nomatch` can be set locally: zsh aborts on a
# glob that matches nothing, bash does not.
shortcuts_load_dir() {
  [ -d "$1" ] || return 0
  if [ -n "$ZSH_VERSION" ]; then
    setopt local_options no_nomatch
  fi
  for _shortcuts_file in "$1"/*.sh; do
    [ -f "$_shortcuts_file" ] || continue
    # shellcheck disable=SC1090
    . "$_shortcuts_file"
  done
  unset _shortcuts_file
}

shortcuts_load_dir "$SHORTCUTS_DIR/shortcuts.d"
shortcuts_load_dir "$SHORTCUTS_DIR/cheatsheets.d"

# Clean up the loader's own helpers.
unset -f should_exclude
unset -f cleanup_shortcut
unset -f shortcuts_load_dir
unset SHORTCUTS_SOURCE SHORTCUTS_EXCLUDED
