# Terminal Shortcuts - Useful Aliases
#
# Description: Collection of time-saving aliases for common terminal operations
# including file management, git operations, system utilities, and navigation.

# File and Directory Operations
alias ll='ls -lha'
alias la='ls -la'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep='grep --color=auto'
alias tree='tree -C'

# Node Version Manager
alias nu="nvm use"
alias nl="nvm list"
alias ni="nvm install"

# Git Operations
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias gu='git pull'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gl='git log --oneline'
alias gd='git diff'
alias gdc='git diff --cached'

# System Utilities
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Network and Process
alias ports='netstat -tulanp'
alias wget='wget -c'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'

# Safety aliases
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Quick edits
alias bashrc='${EDITOR:-nano} ~/.bashrc'
alias zshrc='${EDITOR:-nano} ~/.zshrc'
alias vimrc='${EDITOR:-nano} ~/.vimrc'

# Programs
alias v='vim'
alias n='nano'
alias e='emacs'
alias p='python3'
