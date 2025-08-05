cleanup_shortcut "csless"

if ! should_exclude "csless" 2>/dev/null; then
  csless() {
    echo "=== LESS CHEATSHEET ==="
    echo
    
    echo "🚀 BASIC USAGE:"
    echo "  less file.txt       - Open file with less"
    echo "  cat file | less     - Pipe output to less"
    echo "  less +G file.txt    - Open file at end"
    echo "  less +/pattern file - Open file at first match of pattern"
    echo "  less -N file.txt    - Show line numbers"
    echo "  less -S file.txt    - Disable line wrapping (chop long lines)"
    echo
    
    echo "🏃 NAVIGATION:"
    echo "  Space / f / Ctrl+f  - Forward one screen"
    echo "  b / Ctrl+b          - Backward one screen"
    echo "  Enter / j / ↓       - Forward one line"
    echo "  k / ↑               - Backward one line"
    echo "  d / Ctrl+d          - Forward half screen"
    echo "  u / Ctrl+u          - Backward half screen"
    echo "  g                   - Go to first line"
    echo "  G                   - Go to last line"
    echo "  [number]g           - Go to specific line number"
    echo "  h                   - Display help"
    echo "  q                   - Quit less"
    echo
    
    echo "🔍 SEARCH:"
    echo "  /pattern            - Search forward for pattern"
    echo "  ?pattern            - Search backward for pattern"
    echo "  n                   - Next search match"
    echo "  N                   - Previous search match"
    echo "  &pattern            - Display only lines containing pattern"
    echo "  Ctrl+r              - Toggle regex interpretation"
    echo "  ESC u               - Undo search filtering (show all lines)"
    echo
    
    echo "📊 MARKS & POSITIONS:"
    echo "  m[letter]           - Mark current position with letter"
    echo "  '[letter]           - Go to marked position"
    echo "  ''                  - Go to previous position"
    echo
    
    echo "🔄 FILE OPERATIONS:"
    echo "  :e filename         - Examine (open) new file"
    echo "  :n                  - Next file (when multiple files)"
    echo "  :p                  - Previous file"
    echo "  v                   - Edit current file with \$EDITOR"
    echo "  s filename          - Save input to file"
    echo "  | command           - Pipe to shell command"
    echo
    
    echo "⚙️ DISPLAY OPTIONS:"
    echo "  -number             - Toggle line numbers"
    echo "  -S                  - Toggle line wrapping/chopping"
    echo "  -i                  - Toggle case-insensitive search"
    echo "  -I                  - Toggle case-insensitive search (always)"
    echo "  -F                  - Quit if file fits on one screen"
    echo "  -X                  - Disable screen clearing on exit"
    echo "  -R                  - Display ANSI color escape sequences"
    echo "  +                   - Toggle display option"
    echo
    
    echo "🎨 COLOR & HIGHLIGHTING:"
    echo "  -R                  - Enable color interpretation"
    echo "  --use-color         - Use color for search highlighting"
    echo "  ESC ]               - Toggle search highlighting"
    echo
    
    echo "📏 HORIZONTAL SCROLLING:"
    echo "  →                   - Scroll right (when -S is used)"
    echo "  ←                   - Scroll left"
    echo "  ESC →               - Scroll right half screen"
    echo "  ESC ←               - Scroll left half screen"
    echo "  ESC (               - Scroll to leftmost position"
    echo "  ESC )               - Scroll to rightmost position"
    echo
    
    echo "🔢 REPEAT COMMANDS:"
    echo "  [number]command     - Repeat command number times"
    echo "  Examples:"
    echo "    5j                - Move down 5 lines"
    echo "    10f               - Forward 10 screens"
    echo "    100g              - Go to line 100"
    echo
    
    echo "🛠️ USEFUL COMMAND-LINE OPTIONS:"
    echo "  -n                  - Suppress line numbers"
    echo "  -N                  - Show line numbers"
    echo "  -S                  - Chop long lines (no wrapping)"
    echo "  -s                  - Squeeze multiple blank lines"
    echo "  -i                  - Case-insensitive searches"
    echo "  -I                  - Case-insensitive always"
    echo "  -F                  - Quit if one screen"
    echo "  -X                  - No screen clearing"
    echo "  -R                  - Raw control chars (colors)"
    echo "  -E                  - Quit at end of file"
    echo "  -M                  - Long prompt with percentages"
    echo "  -x[n]               - Set tab stops to n spaces"
    echo
    
    echo "📱 MULTIPLE FILES:"
    echo "  less file1 file2    - Open multiple files"
    echo "  :n                  - Next file"
    echo "  :p                  - Previous file"
    echo "  :e file3            - Examine new file"
    echo "  :x                  - Close current file"
    echo "  T                   - Go to next tag"
    echo
    
    echo "🔧 ENVIRONMENT VARIABLES:"
    echo "  LESS                - Default options"
    echo "  LESSOPEN            - Input preprocessor"
    echo "  LESSCLOSE           - Input postprocessor"
    echo "  EDITOR              - Editor for 'v' command"
    echo "  PAGER               - Used when less is the pager"
    echo
    echo "  Example LESS settings:"
    echo "    export LESS='-R -M -i -j10'"
    echo "    # -R: colors, -M: long prompt, -i: case insensitive, -j10: target line"
    echo
    
    echo "⚡ QUICK TIPS:"
    echo "  • Use 'F' to follow file like 'tail -f'"
    echo "  • Press 'r' to refresh/reload current file"
    echo "  • Use '=' to show current position info"
    echo "  • Press 'Ctrl+c' to stop following (after F)"
    echo "  • Use '-p pattern' to start at first match"
    echo "  • Combine options: less -RMiS file.txt"
    echo "  • Use '!' to execute shell commands"
    echo
    
    echo "🎯 COMMON WORKFLOWS:"
    echo "  Log monitoring:"
    echo "    less +F /var/log/syslog  # Follow log file"
    echo "    Ctrl+c, then q           # Stop and quit"
    echo
    echo "  Code review:"
    echo "    less -N code.py          # Show line numbers"
    echo "    /function, n, N          # Search for functions"
    echo
    echo "  Large file analysis:"
    echo "    less -S large.csv        # No line wrapping"
    echo "    →←                       # Horizontal scroll"
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
    
    echo "💡 PRO TIPS:"
    echo "  • Create alias: alias l='less -R -M -i'"
    echo "  • Use less as default pager: export PAGER=less"
    echo "  • For colorized output: ls --color | less -R"
    echo "  • Follow multiple files: less +F file1 file2"
    echo "  • Use with find: find . -name '*.log' | less"
    echo "  • Pipe long commands: ps aux | less"
    echo
  }
fi
