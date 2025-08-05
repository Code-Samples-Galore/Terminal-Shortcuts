cleanup_shortcut "cstmux"

if ! should_exclude "cstmux" 2>/dev/null; then
  cstmux() {
    echo "=== TMUX CHEATSHEET ==="
    echo
    
    echo "🚀 BASIC USAGE:"
    echo "  tmux                - Start new session"
    echo "  tmux new -s name    - Start new session with name"
    echo "  tmux ls             - List sessions"
    echo "  tmux attach         - Attach to last session"
    echo "  tmux attach -t name - Attach to named session"
    echo "  tmux kill-session -t name - Kill named session"
    echo
    
    echo "⌨️ PREFIX KEY:"
    echo "  Default prefix: Ctrl+b (shown as C-b)"
    echo "  All tmux commands start with the prefix key"
    echo
    
    echo "📱 SESSION MANAGEMENT:"
    echo "  C-b d           - Detach from session"
    echo "  C-b s           - List and switch sessions"
    echo "  C-b \$           - Rename current session"
    echo "  C-b (           - Switch to previous session"
    echo "  C-b )           - Switch to next session"
    echo
    
    echo "🪟 WINDOW MANAGEMENT:"
    echo "  C-b c           - Create new window"
    echo "  C-b n           - Next window"
    echo "  C-b p           - Previous window"
    echo "  C-b l           - Last window"
    echo "  C-b w           - List and select windows"
    echo "  C-b 0-9         - Select window by number"
    echo "  C-b ,           - Rename current window"
    echo "  C-b &           - Kill current window"
    echo "  C-b f           - Find window by name"
    echo
    
    echo "📦 PANE MANAGEMENT:"
    echo "  C-b %           - Split vertically (left/right)"
    echo "  C-b \"           - Split horizontally (top/bottom)"
    echo "  C-b o           - Switch to next pane"
    echo "  C-b ;           - Switch to last pane"
    echo "  C-b q           - Show pane numbers"
    echo "  C-b q 0-9       - Select pane by number"
    echo "  C-b {           - Move pane left"
    echo "  C-b }           - Move pane right"
    echo "  C-b x           - Kill current pane"
    echo "  C-b !           - Break pane into window"
    echo "  C-b z           - Toggle pane zoom"
    echo
    
    echo "🏃 PANE NAVIGATION:"
    echo "  C-b ←→↑↓        - Navigate between panes"
    echo "  C-b h           - Move to left pane (if configured)"
    echo "  C-b j           - Move to pane below (if configured)"
    echo "  C-b k           - Move to pane above (if configured)"
    echo "  C-b l           - Move to right pane (if configured)"
    echo
    
    echo "📏 PANE RESIZING:"
    echo "  C-b C-←→↑↓      - Resize pane by 1"
    echo "  C-b M-←→↑↓      - Resize pane by 5"
    echo "  C-b C-o         - Rotate panes"
    echo "  C-b M-1-5       - Select layout (even-horizontal, even-vertical, etc.)"
    echo
    
    echo "📋 COPY MODE:"
    echo "  C-b [           - Enter copy mode"
    echo "  Space           - Start selection (in copy mode)"
    echo "  Enter           - Copy selection (in copy mode)"
    echo "  C-b ]           - Paste"
    echo "  q               - Exit copy mode"
    echo "  /               - Search forward (in copy mode)"
    echo "  ?               - Search backward (in copy mode)"
    echo "  n               - Next search result (in copy mode)"
    echo "  N               - Previous search result (in copy mode)"
    echo
    
    echo "⚙️ CONFIGURATION:"
    echo "  C-b :           - Enter command mode"
    echo "  C-b ?           - List key bindings"
    echo "  C-b r           - Reload config (if configured)"
    echo "  C-b t           - Show clock"
    echo
    
    echo "🛠️ USEFUL COMMANDS (from command mode C-b :):"
    echo "  new-window -n name    - Create window with name"
    echo "  split-window -h       - Split horizontally"
    echo "  split-window -v       - Split vertically"
    echo "  resize-pane -D 5      - Resize pane down by 5"
    echo "  resize-pane -U 5      - Resize pane up by 5"
    echo "  resize-pane -L 5      - Resize pane left by 5"
    echo "  resize-pane -R 5      - Resize pane right by 5"
    echo "  setw synchronize-panes on/off - Sync input to all panes"
    echo
    
    echo "💡 TIPS & TRICKS:"
    echo "  • Hold Shift to select text with mouse"
    echo "  • Use 'tmux capture-pane -p' to get pane content"
    echo "  • Set mouse mode: 'set -g mouse on' in ~/.tmux.conf"
    echo "  • Use 'tmux source ~/.tmux.conf' to reload config"
    echo "  • Create custom key bindings in ~/.tmux.conf"
    echo "  • Use 'tmux display-message' to show variables"
    echo
    
    echo "🔄 SESSION WORKFLOW:"
    echo "  1. tmux new -s project    - Start named session"
    echo "  2. C-b c                  - Create windows for different tasks"
    echo "  3. C-b ,                  - Rename windows (editor, server, logs)"
    echo "  4. C-b % or \"             - Split panes as needed"
    echo "  5. C-b d                  - Detach when done"
    echo "  6. tmux attach -t project - Reattach later"
    echo

  }
fi
