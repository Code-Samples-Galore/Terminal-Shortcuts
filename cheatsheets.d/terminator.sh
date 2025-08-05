cleanup_shortcut "csterminator"

if ! should_exclude "csterminator" 2>/dev/null; then
  csterminator() {
    echo "=== TERMINATOR CHEATSHEET ==="
    echo
    
    echo "🚀 BASIC USAGE:"
    echo "  terminator              - Start Terminator"
    echo "  terminator -l layout    - Start with specific layout"
    echo "  terminator -x command   - Execute command in new window"
    echo "  terminator -e command   - Execute command and keep window open"
    echo "  terminator --help       - Show help and options"
    echo
    
    echo "🪟 WINDOW MANAGEMENT:"
    echo "  Ctrl+Shift+o        - Split horizontally (above/below)"
    echo "  Ctrl+Shift+e        - Split vertically (left/right)"
    echo "  Ctrl+Shift+t        - Open new tab"
    echo "  Ctrl+Shift+w        - Close current terminal"
    echo "  Ctrl+Shift+q        - Quit Terminator"
    echo "  Ctrl+Shift+i        - Open new window"
    echo "  F11                 - Toggle fullscreen"
    echo "  Ctrl+Shift+x        - Toggle maximize current terminal"
    echo
    
    echo "🏃 TERMINAL NAVIGATION:"
    echo "  Alt+↑               - Move to terminal above"
    echo "  Alt+↓               - Move to terminal below"
    echo "  Alt+←               - Move to terminal left"
    echo "  Alt+→               - Move to terminal right"
    echo "  Ctrl+Shift+n        - Move to next terminal"
    echo "  Ctrl+Shift+p        - Move to previous terminal"
    echo "  Ctrl+Tab            - Cycle through terminals"
    echo "  Ctrl+Shift+Tab      - Reverse cycle through terminals"
    echo
    
    echo "📋 TAB MANAGEMENT:"
    echo "  Ctrl+Shift+t        - New tab"
    echo "  Ctrl+PageDown       - Next tab"
    echo "  Ctrl+PageUp         - Previous tab"
    echo "  Ctrl+Shift+w        - Close tab"
    echo "  Ctrl+Shift+PageDown - Move tab right"
    echo "  Ctrl+Shift+PageUp   - Move tab left"
    echo "  Alt+[1-9]           - Switch to tab number"
    echo
    
    echo "📏 TERMINAL RESIZING:"
    echo "  Ctrl+Shift+↑        - Resize terminal up"
    echo "  Ctrl+Shift+↓        - Resize terminal down"
    echo "  Ctrl+Shift+←        - Resize terminal left"
    echo "  Ctrl+Shift+→        - Resize terminal right"
    echo "  Ctrl+Shift+r        - Reset terminal size"
    echo
    
    echo "🔍 SEARCH & FIND:"
    echo "  Ctrl+Shift+f        - Search in terminal"
    echo "  Ctrl+Shift+g        - Find next"
    echo "  Ctrl+Shift+h        - Find previous"
    echo "  Ctrl+Shift+j        - Clear search highlighting"
    echo
    
    echo "📋 COPY & PASTE:"
    echo "  Ctrl+Shift+c        - Copy selected text"
    echo "  Ctrl+Shift+v        - Paste"
    echo "  Ctrl+Shift+s        - Save terminal contents to file"
    echo "  Middle mouse        - Paste selection"
    echo "  Shift+Insert        - Paste"
    echo
    
    echo "🎨 DISPLAY & ZOOM:"
    echo "  Ctrl+Plus           - Zoom in (increase font)"
    echo "  Ctrl+Minus          - Zoom out (decrease font)"
    echo "  Ctrl+0              - Reset zoom to default"
    echo "  F1                  - Hide/show window borders"
    echo "  Ctrl+Shift+h        - Hide/show scrollbar"
    echo
    
    echo "⚙️ PREFERENCES & CONFIG:"
    echo "  Ctrl+Shift+p        - Open preferences"
    echo "  Right-click         - Context menu"
    echo "  Ctrl+Shift+g        - Group terminals"
    echo "  Ctrl+Shift+u        - Ungroup terminals"
    echo "  Ctrl+Shift+Alt+g    - Group all terminals"
    echo
    
    echo "🔄 PROFILES & LAYOUTS:"
    echo "  Profile switching:"
    echo "    Right-click → Profiles → [profile name]"
    echo "  Layout management:"
    echo "    terminator -l [layout]   - Load layout"
    echo "    Save layout via preferences"
    echo
    
    echo "📱 BROADCAST & GROUPING:"
    echo "  Ctrl+Alt+g          - Group terminals together"
    echo "  Ctrl+Shift+Alt+g    - Group all terminals"
    echo "  Ctrl+Alt+t          - Toggle broadcast to group"
    echo "  Ctrl+Alt+o          - Broadcast off"
    echo "  Ctrl+Alt+a          - Broadcast to all terminals"
    echo
    
    echo "🛠️ COMMAND LINE OPTIONS:"
    echo "  -b, --borderless    - Start without window borders"
    echo "  -f, --fullscreen    - Start in fullscreen mode"
    echo "  -m, --maximise      - Start maximized"
    echo "  -H, --hidden        - Start hidden"
    echo "  -T, --title=TITLE   - Set window title"
    echo "  --geometry=GEOM     - Set window geometry (WIDTHxHEIGHT+X+Y)"
    echo "  -l, --layout=LAYOUT - Load saved layout"
    echo "  -e, --command=CMD   - Execute command"
    echo "  -x, --execute       - Execute command and close"
    echo
    
    echo "🎯 USEFUL SHORTCUTS:"
    echo "  Ctrl+Shift+r        - Reset terminal"
    echo "  Ctrl+Shift+g        - Reset and clear terminal"
    echo "  Ctrl+A              - Select all text"
    echo "  Ctrl+C              - Send SIGINT (interrupt)"
    echo "  Ctrl+D              - Send EOF"
    echo "  Ctrl+Z              - Send SIGTSTP (suspend)"
    echo
    
    echo "💡 TIPS & TRICKS:"
    echo "  • Use layouts to save terminal arrangements"
    echo "  • Group terminals to broadcast commands to all"
    echo "  • Create custom profiles for different environments"
    echo "  • Use keyboard shortcuts for faster navigation"
    echo "  • Right-click for context menu with many options"
    echo "  • Drag terminals to rearrange splits"
    echo "  • Use plugins for extended functionality"
    echo
    
    echo "📐 LAYOUT CREATION:"
    echo "  1. Arrange terminals as desired"
    echo "  2. Right-click → Preferences"
    echo "  3. Go to Layouts tab"
    echo "  4. Click 'Add' to save current layout"
    echo "  5. Launch with: terminator -l [layout_name]"
    echo
    
    echo "⚡ COMMON WORKFLOWS:"
    echo "  Development setup:"
    echo "    Ctrl+Shift+o        # Split horizontal (editor/terminal)"
    echo "    Ctrl+Shift+e        # Split vertical (logs/monitoring)"
    echo "    Ctrl+Alt+g          # Group for broadcast commands"
    echo
    echo "  Server monitoring:"
    echo "    Ctrl+Shift+t        # New tabs for different servers"
    echo "    Alt+[1-9]           # Quick tab switching"
    echo "    Ctrl+Shift+f        # Search logs"
    echo
    
    echo "🔄 PLUGIN SYSTEM:"
    echo "  • TerminalShot - Screenshot terminals"
    echo "  • Logger - Log terminal sessions"
    echo "  • ActivityWatch - Monitor terminal activity"
    echo "  • URLPlugin - Click URLs to open in browser"
    echo "  • Enable in Preferences → Plugins"
    echo
  }
fi
