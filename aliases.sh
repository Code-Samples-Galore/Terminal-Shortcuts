# Terminal Shortcuts - Useful Aliases
#
# Description: Collection of time-saving aliases for common terminal operations
# including file management, git operations, system utilities, and navigation.

# File and Directory Operations
if ! should_exclude "ll" 2>/dev/null; then alias ll='ls -lh'; fi
if ! should_exclude "la" 2>/dev/null; then alias la='ls -la'; fi
if ! should_exclude "l" 2>/dev/null; then alias l='ls -CF'; fi
if ! should_exclude ".." 2>/dev/null; then alias ..='cd ..'; fi
if ! should_exclude "..." 2>/dev/null; then alias ...='cd ../..'; fi
if ! should_exclude "...." 2>/dev/null; then alias ....='cd ../../..'; fi
if ! should_exclude "~" 2>/dev/null; then alias ~='cd ~'; fi
if ! should_exclude "mkdir" 2>/dev/null; then alias mkdir='mkdir -pv'; fi
if ! should_exclude "cp" 2>/dev/null; then alias cp='cp -iv'; fi
if ! should_exclude "mv" 2>/dev/null; then alias mv='mv -iv'; fi
if ! should_exclude "rm" 2>/dev/null; then alias rm='rm -iv'; fi
if ! should_exclude "grep" 2>/dev/null; then alias grep='grep --color=auto'; fi
if ! should_exclude "tree" 2>/dev/null; then alias tree='tree -C'; fi

# Node Version Manager
if ! should_exclude "nu" 2>/dev/null; then alias nu="nvm use"; fi
if ! should_exclude "nl" 2>/dev/null; then alias nl="nvm list"; fi
if ! should_exclude "ni" 2>/dev/null; then alias ni="nvm install"; fi

# Git Operations
if ! should_exclude "gs" 2>/dev/null; then alias gs='git status'; fi
if ! should_exclude "gc" 2>/dev/null; then alias gc='git commit -m'; fi
if ! should_exclude "gp" 2>/dev/null; then alias gp='git push'; fi
if ! should_exclude "gu" 2>/dev/null; then alias gu='git pull'; fi
if ! should_exclude "ga" 2>/dev/null; then alias ga='git add'; fi
if ! should_exclude "gaa" 2>/dev/null; then alias gaa='git add .'; fi
if ! should_exclude "gb" 2>/dev/null; then alias gb='git branch'; fi
if ! should_exclude "gco" 2>/dev/null; then alias gco='git checkout'; fi
if ! should_exclude "gcb" 2>/dev/null; then alias gcb='git checkout -b'; fi
if ! should_exclude "gl" 2>/dev/null; then alias gl='git log --oneline'; fi
if ! should_exclude "gd" 2>/dev/null; then alias gd='git diff'; fi
if ! should_exclude "gdc" 2>/dev/null; then alias gdc='git diff --cached'; fi

# System Utilities
if ! should_exclude "h" 2>/dev/null; then alias h='history'; fi
if ! should_exclude "j" 2>/dev/null; then alias j='jobs -l'; fi
if ! should_exclude "path" 2>/dev/null; then alias path='echo -e ${PATH//:/\\n}'; fi
if ! should_exclude "now" 2>/dev/null; then alias now='date +"%T"'; fi
if ! should_exclude "nowtime" 2>/dev/null; then alias nowtime=now; fi
if ! should_exclude "nowdate" 2>/dev/null; then alias nowdate='date +"%d-%m-%Y"'; fi

# Network and Process
if ! should_exclude "ports" 2>/dev/null; then alias ports='netstat -tulanp'; fi
if ! should_exclude "wget" 2>/dev/null; then alias wget='wget -c'; fi
if ! should_exclude "ping" 2>/dev/null; then alias ping='ping -c 5'; fi
if ! should_exclude "fastping" 2>/dev/null; then alias fastping='ping -c 100 -s.2'; fi

# Safety aliases
if ! should_exclude "chown" 2>/dev/null; then alias chown='chown --preserve-root'; fi
if ! should_exclude "chmod" 2>/dev/null; then alias chmod='chmod --preserve-root'; fi
if ! should_exclude "chgrp" 2>/dev/null; then alias chgrp='chgrp --preserve-root'; fi

# Quick edits
if ! should_exclude "bashrc" 2>/dev/null; then alias bashrc='vim ~/.bashrc'; fi
if ! should_exclude "zshrc" 2>/dev/null; then alias zshrc='vim ~/.zshrc'; fi
if ! should_exclude "vimrc" 2>/dev/null; then alias vimrc='vim ~/.vimrc'; fi

# Python
if ! should_exclude "p" 2>/dev/null; then alias p='python3'; fi
if ! should_exclude "pipi" 2>/dev/null; then alias pipi='python3 -m pip install'; fi
if ! should_exclude "pipu" 2>/dev/null; then alias pipu='python3 -m pip install -U'; fi
if ! should_exclude "pipr" 2>/dev/null; then alias pipr='python3 -m pip install -r'; fi

# Programs
if ! should_exclude "v" 2>/dev/null; then alias v='vim'; fi
