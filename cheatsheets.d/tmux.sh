cleanup_shortcut "cstmux"

if ! should_exclude "cstmux" 2>/dev/null; then
  cstmux() {
    echo "=== TMUX CHEATSHEET ==="
    echo

    echo "⌨️ PREFIX & HELP:"
    echo "  Prefix: Ctrl+b (shown as C-b)"
    echo "  Help:   C-b ? (list key bindings), C-b : (command prompt)"
    echo

    echo "🚀 QUICK START (SESSIONS):"
    echo "  tmux                     - Start new session"
    echo "  tmux new -s name         - Start named session"
    echo "  tmux ls                  - List sessions"
    echo "  tmux attach -t name      - Attach to named session"
    echo "  tmux attach -d -t name   - Attach and detach others"
    echo "  tmux kill-session -t name - Kill named session"
    echo "  tmux kill-server         - Kill all sessions (server)"
    echo

    echo "📱 SESSION MANAGEMENT (IN TMUX):"
    echo "  C-b d           - Detach"
    echo "  C-b s           - Choose session (tree)"
    echo "  C-b \$           - Rename session"
    echo "  C-b ( / )       - Prev / next session"
    echo

    echo "🪟 WINDOW MANAGEMENT:"
    echo "  C-b c           - New window"
    echo "  C-b n / p       - Next / previous window"
    echo "  C-b l           - Last window"
    echo "  C-b w           - Choose window (list)"
    echo "  C-b 0-9         - Select window by number"
    echo "  C-b ,           - Rename window"
    echo "  C-b .           - Move window to index (prompt)"
    echo "  C-b &           - Kill window"
    echo "  C-b f           - Find window by name"
    echo

    echo "📦 PANES (SPLIT & MANAGE):"
    echo "  C-b %           - Split vertically (left/right)"
    echo "  C-b \"           - Split horizontally (top/bottom)"
    echo "  C-b o / ;       - Next / last pane"
    echo "  C-b q           - Show pane numbers (then 0-9 to select)"
    echo "  C-b { / }       - Move pane left / right"
    echo "  C-b x           - Kill pane"
    echo "  C-b !           - Break pane into a new window"
    echo "  C-b z           - Toggle pane zoom"
    echo

    echo "🏃 PANE NAVIGATION:"
    echo "  C-b ←→↑↓        - Move between panes"
    echo "  C-b h/j/k/l     - Move using vim-keys (if configured)"
    echo

    echo "📏 RESIZE & LAYOUT:"
    echo "  C-b C-←→↑↓      - Resize by 1"
    echo "  C-b M-←→↑↓      - Resize by 5"
    echo "  C-b Space       - Cycle layouts"
    echo "  C-b C-o         - Rotate panes"
    echo

    echo "📋 COPY & PASTE:"
    echo "  C-b [           - Enter copy mode"
    echo "  Space           - Start selection (copy mode)"
    echo "  Enter           - Copy selection (copy mode)"
    echo "  C-b ]           - Paste"
    echo "  q               - Exit copy mode"
    echo "  / or ?          - Search forward / backward (copy mode)"
    echo "  n / N           - Next / previous match (copy mode)"
    echo

    echo "⚙️ COMMANDS (C-b :):"
    echo "  new-window -n name        - Create window with name"
    echo "  split-window -h | -v      - Split left/right | top/bottom"
    echo "  join-pane  -s src -t dst  - Move pane between windows"
    echo "  swap-pane  -U | -D        - Swap panes up/down"
    echo "  move-window -t idx        - Move window to index"
    echo "  select-layout tiled | even-horizontal | even-vertical | main-horizontal | main-vertical"
    echo "  resize-pane -D/-U/-L/-R 5 - Resize pane by 5"
    echo "  setw synchronize-panes on/off - Sync input to all panes"
    echo

    echo "💡 TIPS:"
    echo "  • Hold Shift to select text with mouse"
    echo "  • Use 'tmux capture-pane -p' to get pane content"
    echo "  • Set mouse mode: 'set -g mouse on' in ~/.tmux.conf"
    echo "  • Use 'tmux source ~/.tmux.conf' to reload config"
    echo "  • Create custom key bindings in ~/.tmux.conf"
    echo "  • Use 'tmux display-message' to show variables"
    echo "  • Hold Shift to select text with mouse when mouse mode is off"
    echo

    echo "🔄 WORKFLOW:"
    echo "  1) tmux new -s project         - Start named session"
    echo "  2) C-b c                       - Create windows (editor, server, logs)"
    echo "  3) C-b ,                       - Rename windows"
    echo "  4) C-b % / \"                  - Split panes as needed"
    echo "  5) C-b Space                   - Pick a layout"
    echo "  6) C-b d                       - Detach"
    echo "  7) tmux attach -t project      - Reattach later"
    echo

  }
fi
