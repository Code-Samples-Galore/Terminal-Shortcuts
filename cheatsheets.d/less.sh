cleanup_shortcut "csless"

if ! should_exclude "csless" 2>/dev/null; then
  csless() {
    echo "=== LESS CHEATSHEET ==="
    echo

    echo "🚀 BASIC USAGE"
    echo "  less file.txt       - Open file"
    echo "  cat file | less     - Pipe output"
    echo "  less +n file.txt    - Open at line n (e.g., +42)"
    echo "  less +/pattern file - Open at first match"
    echo "  less +G file.txt    - Open at end"
    echo "  less -N/-S file.txt - Show line numbers / chop long lines"
    echo

    echo "🏃 NAVIGATION"
    echo "  Space / f / Ctrl+f  - Forward one screen"
    echo "  b / Ctrl+b          - Backward one screen"
    echo "  Enter / j / ↓       - Forward one line"
    echo "  k / ↑               - Backward one line"
    echo "  d / Ctrl+d          - Forward half screen"
    echo "  u / Ctrl+u          - Backward half screen"
    echo "  g / G               - First / last line"
    echo "  [n]g / [n]%         - Go to line n / n percent"
    echo "  = or Ctrl+g         - Show current position info"
    echo "  h                   - Help"
    echo "  q                   - Quit"
    echo

    echo "🔍 SEARCH & FILTERING"
    echo "  /pattern            - Search forward"
    echo "  ?pattern            - Search backward"
    echo "  n / N               - Next / previous match"
    echo "  &pattern            - Show only matching lines; '&' clears filter"
    echo "  Toggle case: -i     - Ignore case (smart)"
    echo "  Always ignore: -I   - Ignore case (always)"
    echo "  Highlight: -g/-G    - Last-match only / disable highlight"
    echo

    echo "🔍 ADVANCED SEARCH:"
    echo "  Regular expressions are supported:"
    echo "    /^Error              - Lines starting with 'Error'"
    echo "    /[0-9]+             - Lines containing numbers"
    echo "    /\\.(txt|log)\$       - Lines ending with .txt or .log"
    echo
    echo "  Case sensitivity:"
    echo "    -i flag or ESC u     - Toggle case sensitivity"
    echo "    /Pattern vs /pattern - Different with case sensitivity"
    echo

    echo "📌 JUMPS, MARKS & POSITIONS"
    echo "  mX                  - Mark current position as 'X'"
    echo "  'X                  - Jump to mark 'X'"
    echo "  ''                  - Jump to previous position"
    echo

    echo "📁 FILES & FOLLOWING"
    echo "  :e filename         - Examine (open) a new file"
    echo "  :n / :p             - Next / previous file"
    echo "  F                   - Follow (like tail -f); Ctrl+c to stop"
    echo "  R                   - Reload file (useful after F)"
    echo "  v                   - Edit current file with \$EDITOR"
    echo

    echo "📏 HORIZONTAL SCROLLING"
    echo "  -S                  - Chop long lines (enables sideways scroll)"
    echo "  → / ←               - Scroll right / left"
    echo "  ESC → / ESC ←       - Scroll right / left half screen"
    echo "  ESC ( / ESC )       - Jump to leftmost / rightmost"
    echo

    echo "🔧 OUTPUT & SHELL"
    echo "  s filename          - Save input to file (when input is a pipe)"
    echo "  | command           - Pipe to shell command"
    echo

    echo "🛠️ OPTIONS"
    echo "  -N / -n             - Show / hide line numbers"
    echo "  -S                  - Chop long lines (no wrapping). Usefull for large files."
    echo "  -s                  - Squeeze multiple blank lines"
    echo "  -R                  - Display ANSI color escape sequences"
    echo "  -F                  - Quit if content fits one screen"
    echo "  -X                  - Do not clear screen on exit"
    echo "  -M / -m             - Long / short prompt"
    echo "  -x[n]               - Set tab stops to n spaces"
    echo "  -E                  - Quit at end of file"
    echo "  -J                  - Show status column (marks/searches)"
    echo "  Tip: Inside less, press '-' then option letters to toggle (e.g., -S -N -i)"
    echo

    echo "⚡ QUICK TIPS"
    echo "  • F to follow; Ctrl+c to stop; R to reload; q to quit"
    echo "  • = or Ctrl+g shows file/position info"
    echo "  • Use '!' to execute shell commands"
    echo
  }
fi
