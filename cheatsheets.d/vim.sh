cleanup_shortcut "csvim"

if ! should_exclude "csvim" 2>/dev/null; then
  csvim() {
    echo "=== VIM CHEATSHEET ==="
    echo
    
    echo "🚀 BASIC USAGE (Terminal):"
    echo "  vim [file]      - Open file in vim"
    echo "  vim +[line]     - Open file at specific line"
    echo "  vim -o file1 file2  - Open files in horizontal splits"
    echo "  vim -O file1 file2  - Open files in vertical splits"
    echo
    
    echo "📝 MODES (press in Normal mode to change mode):"
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
    
    echo "🏃 NAVIGATION (Normal mode):"
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
    echo "  H/M/L           - Top/Middle/Bottom of screen [Normal]"
    echo "  zz/zt/zb        - Center/top/bottom current line [Normal]"
    echo "  Ctrl+u/Ctrl+d   - Half-page up/down [Normal]"
    echo "  Ctrl+e/Ctrl+y   - Scroll down/up one line [Normal]"
    echo "  gd/gD           - Go to local/global declaration [Normal]"
    echo "  gf              - Edit file under cursor [Normal]"
    echo "  gx              - Open URL/file under cursor with system [Normal]"
    echo
    echo "🏹 MOTIONS (targets you move over):"
    echo "  Motions move the cursor; operators act on a motion: d{motion}, c{motion}, y{motion}, gU/gu/g~{motion} [Normal]"
    echo "  Counts repeat motions/operators: 3w, d2e, 5j, 2gUw [Normal]"
    echo
    echo "  Word motions: w/b/e/ge (next/prev start/end), W/B/E for BIG words [Normal/Visual]"
    echo "  Line: 0/^/\$ (start/first-nonblank/end), gg/G, [count]G to line [count] [Normal/Visual]"
    echo "  Find in line: f{char}/F{char} to char; t{char}/T{char} till before; ;/, repeat [Normal/Visual]"
    echo "  Paragraph/sentence: { / } (prev/next paragraph), ( / ) (prev/next sentence) [Normal/Visual]"
    echo "  Search as motion: n/N move through matches; use dgn/cgn to act on next match [Normal/Visual]"
    echo "  Text objects: iw/aw (inner/a word), i\\\"/a\\\", i'/a', i)/a), i]/a], ip/ap (paragraph) [Normal/Visual]"
    echo "  Visual note: In Visual mode, motions extend the selection; operators then act on it [Visual]"
    echo

    echo "✂️ EDITING (Normal mode):"
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
    
    echo "🧱 FORMATTING & INDENTING:"
    echo "  ={motion}       - Re-indent selection (e.g., =ap) [Normal/Visual]"
    echo "  gg=G            - Re-indent whole file [Normal]"
    echo "  gq{motion}      - Format text (wrap) [Normal/Visual]"
    echo "  J / gJ          - Join with/without space [Normal]"
    echo

    echo "🎞 MACROS (record/replay):"
    echo "  qx ... q        - Record macro into register x; q to stop [Normal]"
    echo "  @x / @@         - Play macro x / repeat last macro [Normal]"
    echo "  :%normal! A;    - Run a Normal command on all lines (append ';') [Command-line]"
    echo

    echo "🧩 WORD/TEXT OBJECTS:"
    echo "  viw [Visual] / ciw/diw/yiw [Normal] - Select/change/delete/yank inner word"
    echo "  va\\\" [Visual] / ci]/di)/ya' [Normal] - Work with quotes/brackets"
    echo

    echo "🔤 CASE CHANGE OPERATORS (Normal/Visual):"
    echo "  gu{motion}      - Lowercase (e.g., guiw lowercase inner word) [Normal/Visual]"
    echo "  gU{motion}      - Uppercase (e.g., gUiw uppercase inner word) [Normal/Visual]"
    echo "  g~{motion}      - Toggle case [Normal/Visual]"
    echo

    echo "📐 VISUAL BLOCK (Column edit):"
    echo "  Ctrl+v + motion - Select a rectangle (block) [Normal→Visual-Block]"
    echo "  Itext Esc       - Insert text before each selected line [Visual-Block]"
    echo "  Atext Esc       - Append text to each selected line [Visual-Block]"
    echo "  rX              - Replace the block with character X [Visual-Block]"
    echo

    echo "🧾 CUT & PASTE MULTIPLE LINES (Visual mode):"
    echo "  • Select everything you want to cut"
    echo "  • Press d"
    echo "  • Go to where you want to paste"
    echo "  • Press p"
    echo

    echo "📋 REGISTERS & CLIPBOARD:"
    echo "  \\\"{reg}y/p       - Use register {reg} e.g., \\\"0, \\\"_, \\\"+, \\\"* [Normal/Visual]"
    echo "  \\\"+y / \\\"+p      - Yank/paste with system clipboard [Normal/Visual]"
    echo "  \\\"_d             - Delete to black hole register [Normal/Visual]"
    echo "  :reg            - Show registers [Command-line]"
    echo

    echo "🔍 SEARCH & REPLACE (Normal mode; ':' enters command-line):"
    echo "  /pattern        - Search forward"
    echo "  ?pattern        - Search backward"
    echo "  n               - Next search result"
    echo "  N               - Previous search result"
    echo "  Enter           - Clear search highlighting (custom)"
    echo "  *               - Search word under cursor"
    echo "  :%s/old/new/g   - Replace all occurrences"
    echo "  :%s/old/new/gc  - Replace with confirmation"
    echo
    
    echo "🧭 SEARCH TIPS (use / or ? from Normal mode):"
    echo "  \\v              - Very magic mode for simpler regex (e.g., /\\v(foo|bar)) [Normal search]"
    echo "  \\c / \\C        - Force case-insensitive / case-sensitive for one search [Normal search]"
    echo "  \\<word\\>       - Whole-word match boundaries in searches/substitutions [Normal search]"
    echo

    echo "🔁 SUBSTITUTE POWER-UPS:"
    echo "  :%s//new/g      - Reuse last searched pattern [Command-line]"
    echo "  :%s#old#new#g   - Use alternate delimiter (avoid escaping /) [Command-line]"
    echo "  :%s/\\(foo\\)bar/\\1BAZ/g - Backreference \\1 example [Command-line]"
    echo "  :%s/pat/\\u&/g   - Uppercase first letter of each match [Command-line]"
    echo "  :%s/pat/\\U&/g   - Uppercase the whole match [Command-line]"
    echo "  :%s/pat/\\L&/g   - Lowercase the match [Command-line]"
    echo "  Flags: g=global, c=confirm, i=ignorecase, I=case-sensitive"
    echo

    echo "🧠 MULTI-EDIT SAME WORDS (No plugins):"
    echo "  Put cursor on a word then press * to search it [Normal]"
    echo "  cgn             - Change next match; use . to repeat [Normal]"
    echo "  dgn / ygn       - Delete / Yank next match [Normal]"
    echo "  ggn             - Jump to first match of the last search [Normal]"
    echo "  :%s/old/new/gc  - Replace across file with confirmation [Command-line]"
    echo "  :'<,'>s/old/new/g - Replace only in current visual selection [Visual + Command-line]"
    echo "  :%s/\\<old\\>/new/g - Whole-word replace [Command-line]"
    echo

    echo "🧪 :global on matching lines:"
    echo "  :g/foo/s//bar/g - Substitute only on lines matching 'foo' [Command-line]"
    echo "  :v/foo/d        - Delete lines NOT matching 'foo' [Command-line]"
    echo "  :g/^\\s*$/d      - Delete blank lines [Command-line]"
    echo

    echo "📜 QUICKFIX & LOCATION LISTS:"
    echo "  :make | :copen  - Populate and open quickfix list [Command-line]"
    echo "  :cnext / :cprev - Next/prev quickfix item [Command-line]"
    echo "  :lopen          - Open location list for current window [Command-line]"
    echo
    echo "📱 WINDOWS & SPLITS (Normal: Ctrl+w; Command-line: :split/:vsplit):"
    echo "  :split / :sp    - Horizontal split"
    echo "  :vsplit / :vsp  - Vertical split"
    echo "  Ctrl+w h/j/k/l  - Navigate between splits"
    echo "  Ctrl+w +/-      - Resize splits vertically"
    echo "  Ctrl+w </>      - Resize splits horizontally"
    echo "  Ctrl+w =        - Equalize split sizes"
    echo "  Ctrl+w q        - Close current split"
    echo
    
    echo "🔄 BUFFERS & TABS (Command-line via ':'):"
    echo "  :tabnew         - New tab"
    echo "  :tabn           - Next tab"
    echo "  :tabp           - Previous tab"
    echo "  :bnext          - Next buffer"
    echo "  :bprev          - Previous buffer"
    echo "  :bdelete        - Delete buffer"
    echo
    
    echo "📚 ARG LIST:"
    echo "  :args           - Show argument list [Command-line]"
    echo "  :next / :prev   - Move to next/prev file in arg list [Command-line]"
    echo
    echo "📁 FOLDING (Normal mode):"
    echo "  za              - Toggle fold (custom: \\f)"
    echo "  zA              - Toggle all folds (custom: \\F)"
    echo "  zo              - Open fold"
    echo "  zc              - Close fold"
    echo "  zR              - Open all folds"
    echo "  zM              - Close all folds"
    echo
    
    echo "💾 FILE OPERATIONS (Command-line via ':'):"
    echo "  :w              - Save file"
    echo "  :w filename     - Save as filename"
    echo "  :q              - Quit"
    echo "  :q!             - Quit without saving"
    echo "  :wq / :x        - Save and quit"
    echo "  :e filename     - Edit file"
    echo "  :r filename     - Read file into current buffer"
    echo
    
    echo "🎯 CUSTOM LEADER MAPPINGS (Normal mode, Leader = ,):"
    echo "  ,,              - Jump to last cursor position"
    echo "  ,p              - Print file"
    echo "  ,w              - Quick save"
    echo "  ,q              - Quick quit"
    echo "  ,x              - Save and quit"
    echo "  ,n              - Toggle line numbers"
    echo "  ,r              - Toggle relative line numbers"
    echo "  ,pp             - Toggle paste mode"
    echo "  ,e              - Open file explorer"
    echo "  ,v              - Vertical split"
    echo "  ,s              - Horizontal split"
    echo "  ,bn             - Next buffer"
    echo "  ,bp             - Previous buffer"
    echo "  ,bd             - Delete buffer"
    echo "  ,bg             - Toggle background (dark/light)"
    echo
    
    echo "🔌 PLUGIN SHORTCUTS (Normal mode):"
    echo "  Ctrl+t          - Toggle NERDTree file explorer"
    echo "  F8              - Toggle Tagbar (code structure)"
    echo "  F5              - Run Python script"
    echo "  F6              - Run current file (based on filetype)"
    echo "  gcc / gc{motion} - Toggle comments (vim-commentary) [Normal/Visual]"
    echo "  ysiw) / ds) / cs') - Add/delete/change surroundings (vim-surround) [Normal]"
    echo    
    echo "⚡ QUICK SHORTCUTS:"
    echo "  Space           - Enter command mode (:) [Normal]"
    echo "  jj              - Exit insert mode (alternative to Esc) [Insert]"
    echo "  j/k             - Move down/up on wrapped lines [Normal]"
    echo    
    echo "🎨 AUTOCLOSE FEATURES (Insert mode):"
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
    printf "  {Enter          - Creates {%s%s} with cursor in middle\n" '\n' '\n'
    echo
    
    echo "📝 SPELL & DIFF:"
    echo "  :set spell / :set spell! - Enable/toggle spell check [Command-line]"
    echo "  ]s / [s          - Next/prev misspelling [Normal]"
    echo "  z=               - Suggestions for word under cursor [Normal]"
    echo "  :diffthis        - Start diff mode in current window [Command-line]"
    echo "  do / dp          - Obtain/Put changes from other diff window [Normal]"
    echo "  :diffoff!        - Turn off diff in all windows [Command-line]"
    echo

    echo "💡 TIPS (mode indicated per tip):"
    echo "  • [Normal] Use . to repeat last command"
    echo "  • [Command-line] Use :help [topic] for detailed help"
    echo "  • [Normal] Numbers before commands repeat them (e.g., 3dd deletes 3 lines)"
    echo "  • [Insert] Use Ctrl+o in insert mode for one normal command"
    echo "  • [Visual] Visual mode + commands work on selected text"
    echo "  • [Command-line] :set number! toggles line numbers"
    echo "  • [Command-line] :noh clears search highlighting"
    echo "  • [Normal] Use marks: ma (set mark a), 'a (jump to mark a)"
    echo
  }
fi
