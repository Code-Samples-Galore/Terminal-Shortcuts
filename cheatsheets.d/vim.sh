cleanup_shortcut "csvim"

if ! should_exclude "csvim" 2>/dev/null; then
  csvim() {
    echo "=== VIM CHEATSHEET ==="
    echo
    
    echo "🚀 BASIC USAGE:"
    echo "  vim [file]      - Open file in vim"
    echo "  vim +[line]     - Open file at specific line"
    echo "  vim -o file1 file2  - Open files in horizontal splits"
    echo "  vim -O file1 file2  - Open files in vertical splits"
    echo
    
    echo "📝 MODES:"
    echo "  i               - Enter insert mode"
    echo "  a               - Append after cursor"
    echo "  A               - Append at end of line"
    echo "  o               - Open new line below"
    echo "  O               - Open new line above"
    echo "  v               - Visual mode"
    echo "  V               - Visual line mode"
    echo "  Ctrl+v          - Visual block mode"
    echo "  R               - Replace mode"
    echo "  Esc / jj        - Return to normal mode"
    echo
    
    echo "🏃 NAVIGATION:"
    echo "  h,j,k,l         - Left, down, up, right"
    echo "  w               - Next word"
    echo "  b               - Previous word"
    echo "  e               - End of word"
    echo "  0               - Beginning of line"
    echo "  ^               - First non-blank character"
    echo "  \$               - End of line"
    echo "  gg              - Go to first line"
    echo "  G               - Go to last line"
    echo "  [line]G         - Go to specific line"
    echo "  Ctrl+f          - Page down"
    echo "  Ctrl+b          - Page up"
    echo "  %               - Jump to matching bracket"
    echo
    
    echo "✂️ EDITING:"
    echo "  x               - Delete character"
    echo "  dd              - Delete line"
    echo "  D               - Delete to end of line"
    echo "  yy              - Copy line"
    echo "  Y               - Copy to end of line (custom mapping)"
    echo "  p               - Paste after cursor"
    echo "  P               - Paste before cursor"
    echo "  u               - Undo"
    echo "  Ctrl+r          - Redo"
    echo "  cc              - Change entire line"
    echo "  cw              - Change word"
    echo "  r[char]         - Replace character"
    echo "  s               - Substitute character"
    echo "  >>              - Indent line"
    echo "  <<              - Unindent line"
    echo

    echo "🧾 CUT & PASTE MULTIPLE LINES:"
    echo "  Press v for visual mode"
    echo "  Select everything you want to cut"
    echo "  Press d"
    echo "  Go to where you want to paste"
    echo "  Press p"
    echo
    
    echo "🔍 SEARCH & REPLACE:"
    echo "  /pattern        - Search forward"
    echo "  ?pattern        - Search backward"
    echo "  n               - Next search result"
    echo "  N               - Previous search result"
    echo "  Enter           - Clear search highlighting (custom)"
    echo "  *               - Search word under cursor"
    echo "  :%s/old/new/g   - Replace all occurrences"
    echo "  :%s/old/new/gc  - Replace with confirmation"
    echo
    
    echo "💾 FILE OPERATIONS:"
    echo "  :w              - Save file"
    echo "  :w filename     - Save as filename"
    echo "  :q              - Quit"
    echo "  :q!             - Quit without saving"
    echo "  :wq / :x        - Save and quit"
    echo "  :e filename     - Edit file"
    echo "  :r filename     - Read file into current buffer"
    echo
    
    echo "🔄 BUFFERS & TABS:"
    echo "  :tabnew         - New tab"
    echo "  :tabn           - Next tab"
    echo "  :tabp           - Previous tab"
    echo "  :bnext          - Next buffer"
    echo "  :bprev          - Previous buffer"
    echo "  :bdelete        - Delete buffer"
    echo
    
    echo "📱 WINDOWS & SPLITS:"
    echo "  :split / :sp    - Horizontal split"
    echo "  :vsplit / :vsp  - Vertical split"
    echo "  Ctrl+w h/j/k/l  - Navigate between splits"
    echo "  Ctrl+w +/-      - Resize splits vertically"
    echo "  Ctrl+w </>      - Resize splits horizontally"
    echo "  Ctrl+w =        - Equalize split sizes"
    echo "  Ctrl+w q        - Close current split"
    echo
    
    echo "📁 FOLDING:"
    echo "  za              - Toggle fold (custom: \\f)"
    echo "  zA              - Toggle all folds (custom: \\F)"
    echo "  zo              - Open fold"
    echo "  zc              - Close fold"
    echo "  zR              - Open all folds"
    echo "  zM              - Close all folds"
    echo
    
    echo "🎯 CUSTOM LEADER MAPPINGS (Leader = \\):"
    echo "  \\\\              - Jump to last cursor position"
    echo "  \\p              - Print file"
    echo "  \\w              - Quick save"
    echo "  \\q              - Quick quit"
    echo "  \\x              - Save and quit"
    echo "  \\n              - Toggle line numbers"
    echo "  \\r              - Toggle relative line numbers"
    echo "  \\pp             - Toggle paste mode"
    echo "  \\e              - Open file explorer"
    echo "  \\v              - Vertical split"
    echo "  \\s              - Horizontal split"
    echo "  \\bn             - Next buffer"
    echo "  \\bp             - Previous buffer"
    echo "  \\bd             - Delete buffer"
    echo "  \\bg             - Toggle background (dark/light)"
    echo
    
    echo "🔌 PLUGIN SHORTCUTS:"
    echo "  Ctrl+t          - Toggle NERDTree file explorer"
    echo "  F8              - Toggle Tagbar (code structure)"
    echo "  F5              - Run Python script"
    echo "  F6              - Run current file (based on filetype)"
    echo    
    echo "⚡ QUICK SHORTCUTS:"
    echo "  Space           - Enter command mode (:)"
    echo "  jj              - Exit insert mode (alternative to Esc)"
    echo "  j/k             - Move down/up on wrapped lines"
    echo    
    echo "🎨 AUTOCLOSE FEATURES:"
    echo "  Typing quotes/brackets automatically creates pairs:"
    echo "  '               - Creates '' with cursor inside"
    echo "  \"               - Creates \"\" with cursor inside"
    echo "  (               - Creates () with cursor inside"
    echo "  [               - Creates [] with cursor inside"
    echo "  {               - Creates {} with cursor inside"
    echo
    echo "  With semicolon (';):"
    echo "  ';              - Creates '';' with cursor inside"
    echo "  \";              - Creates \"\";' with cursor inside"
    echo
    echo "  With tab:"
    echo "  'Tab            - Creates '' with cursor after"
    echo "  \"Tab            - Creates \"\" with cursor after"
    echo
    echo "  With Enter:"
    echo "  'Enter          - Creates multi-line structure"
    echo "  {Enter          - Creates {\n\n} with cursor in middle"
    echo
    
    echo "💡 TIPS:"
    echo "  • Use . to repeat last command"
    echo "  • Use :help [topic] for detailed help"
    echo "  • Numbers before commands repeat them (e.g., 3dd deletes 3 lines)"
    echo "  • Use Ctrl+o in insert mode for one normal command"
    echo "  • Visual mode + commands work on selected text"
    echo "  • :set number! toggles line numbers"
    echo "  • :noh clears search highlighting"
    echo "  • Use marks: ma (set mark a), 'a (jump to mark a)"
    echo
  }
fi
