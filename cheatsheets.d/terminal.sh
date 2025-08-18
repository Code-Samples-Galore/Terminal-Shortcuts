cleanup_shortcut "csterminal"

if ! should_exclude "csterminal" 2>/dev/null; then
  csterminal() {
    echo "=== TERMINAL CHEATSHEET (BASH/ZSH) ==="
    echo

    echo "📝 CURSOR MOVEMENT:"
    echo "  Ctrl+a          - Move to beginning of line"
    echo "  Ctrl+e          - Move to end of line"
    echo "  Ctrl+f / →      - Move forward one character"
    echo "  Ctrl+b / ←      - Move backward one character"
    echo "  Alt+f           - Move forward one word"
    echo "  Alt+b           - Move backward one word"
    echo "  Ctrl+xx         - Toggle between start of line and cursor"
    echo

    echo "✂️ CUTTING & DELETING:"
    echo "  Ctrl+k          - Cut from cursor to end of line"
    echo "  Ctrl+u          - Cut from cursor to beginning of line"
    echo "  Ctrl+w          - Cut word before cursor"
    echo "  Alt+d           - Cut word after cursor"
    echo "  Ctrl+d          - Delete character under cursor"
    echo "  Ctrl+h / ⌫      - Delete character before cursor (backspace)"
    echo "  Alt+⌫           - Delete word before cursor"
    echo

    echo "📋 PASTING & UNDOING:"
    echo "  Ctrl+y          - Paste (yank) last cut text"
    echo "  Alt+y           - Cycle through cut buffer (after Ctrl+y)"
    echo "  Ctrl+_          - Undo last edit"
    echo "  Alt+r           - Revert line (undo all changes)"
    echo

    echo "🔍 HISTORY & SEARCH:"
    echo "  Ctrl+r          - Reverse search history (incremental)"
    echo "  Ctrl+s          - Forward search history (incremental)"
    echo "  Ctrl+g          - Cancel search / escape"
    echo "  Ctrl+p / ↑      - Previous command in history"
    echo "  Ctrl+n / ↓      - Next command in history"
    echo "  Alt+<           - Move to beginning of history"
    echo "  Alt+>           - Move to end of history"
    echo "  !!              - Execute last command"
    echo "  !n              - Execute command line n"
    echo "  !string         - Execute most recent command starting with string"
    echo "  !?string        - Execute most recent command containing string"
    echo

    echo "🔄 COMPLETION & EXPANSION:"
    echo "  Tab             - Auto-complete command/filename"
    echo "  Tab Tab         - Show all completions"
    echo "  Alt+*           - Insert all possible completions"
    echo "  Alt+?           - List possible completions"
    echo "  Ctrl+i          - Same as Tab"
    echo "  Alt+!           - Complete command name"
    echo "  Alt+/           - Complete filename"
    echo "  Alt+~           - Complete username"
    echo "  Alt+\$           - Complete variable name"
    echo "  Alt+@           - Complete hostname"
    echo

    echo "🎛️ PROCESS CONTROL:"
    echo "  Ctrl+c          - Interrupt (SIGINT) - stop current command"
    echo "  Ctrl+z          - Suspend process (put in background)"
    echo "  Ctrl+d          - End of file (EOF) - exit shell if line empty"
    echo "  Ctrl+\\          - Quit (SIGQUIT) - force quit with core dump"
    echo "  Ctrl+s          - Stop output (suspend terminal)"
    echo "  Ctrl+q          - Resume output (resume terminal)"
    echo

    echo "📺 DISPLAY & TERMINAL:"
    echo "  Ctrl+l          - Clear screen (same as 'clear' command)"
    echo "  Ctrl+v          - Insert literal next character"
    echo "  Alt+l           - Lowercase word from cursor"
    echo "  Alt+u           - Uppercase word from cursor"
    echo "  Alt+c           - Capitalize word from cursor"
    echo "  Alt+t           - Transpose words"
    echo "  Ctrl+t          - Transpose characters"
    echo

    echo "🔗 COMMAND LINE EDITING:"
    echo "  Ctrl+a Ctrl+k   - Select all and cut (clear line)"
    echo "  Ctrl+x Ctrl+e   - Edit command in \$EDITOR (usually vim/nano)"
    echo "  Alt+#           - Comment out current line and execute"
    echo "  Ctrl+j          - Accept line (same as Enter)"
    echo "  Ctrl+m          - Accept line (same as Enter)"
    echo "  Ctrl+o          - Accept line and fetch next from history"
    echo

    echo "📊 ZSH-SPECIFIC (if using zsh):"
    echo "  Ctrl+x Ctrl+l   - List completions"
    echo "  Ctrl+x Ctrl+r   - Read from file into command line"
    echo "  Alt+s           - Insert 'sudo ' at beginning of line"
    echo "  Alt+.           - Insert last argument of previous command"
    echo "  Alt+_           - Insert last argument of previous command"
    echo "  Ctrl+x *        - Expand glob patterns"
    echo "  Ctrl+x g        - List glob matches"
    echo

    echo "🔢 ARGUMENT MANIPULATION:"
    echo "  Alt+.           - Insert last word of previous command"
    echo "  Alt+0 Alt+.     - Insert first word of previous command"
    echo "  Alt+1 Alt+.     - Insert second word of previous command"
    echo "  Alt+n Alt+.     - Insert nth word of previous command"
    echo "  Alt+-           - Negative argument (use with above)"
    echo

    echo "🎯 ADVANCED SHORTCUTS:"
    echo "  Alt+Space       - Set mark"
    echo "  Ctrl+x Ctrl+x   - Exchange point and mark"
    echo "  Ctrl+]          - Character search forward"
    echo "  Alt+Ctrl+]      - Character search backward"
    echo "  Alt+p           - Non-incremental reverse search"
    echo "  Alt+n           - Non-incremental forward search"
    echo

    echo "💡 TIPS:"
    echo "  • Use 'bind -p' to see all key bindings (bash)"
    echo "  • Use 'bindkey' to see all key bindings (zsh)"
    echo "  • Customize bindings in ~/.bashrc or ~/.zshrc"
    echo "  • Set 'set -o vi' for vi-mode editing"
    echo "  • Use 'fc' command to edit and re-execute commands"
    echo "  • Alt key might be Esc on some terminals"
    echo "  • Ctrl+Alt+t opens new terminal tab (many terminals)"
    echo "  • Use history expansion: ^old^new (replace old with new)"
    echo

    echo "🔄 WORKFLOW EXAMPLES:"
    echo "  1) Type command, Ctrl+a, type 'sudo ', Enter  - Add sudo to front"
    echo "  2) Ctrl+r, type search term, Enter            - Find and execute old command"
    echo "  3) Type 'rm file', Ctrl+w, type 'ls'          - Change rm to ls quickly"
    echo "  4) !! | grep error                            - Pipe last command to grep"
    echo "  5) Ctrl+u, type new command                   - Clear line and start over"
    echo
  }
fi
