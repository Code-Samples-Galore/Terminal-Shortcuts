#!/bin/bash
# Git Enhancement Functions
#
# Description: Enhanced Git utilities that extend basic Git functionality
# with automated commit messages, repository information display, and
# streamlined workflow shortcuts for faster development cycles.
#
# Functions:
#   gac        - Git add all and commit with auto-generated message
#   gitinfo    - Display comprehensive Git repository information
#   gpullall   - Recursively git pull every repo under a directory,
#                skipping any where the working tree is dirty, no upstream
#                is set, or the merge would introduce a conflict
#
# Aliases:
#   gs         - Git status
#   gc         - Git commit with message
#   gp         - Git push
#   gu         - Git pull
#   ga         - Git add
#   gaa        - Git add all files
#   gb         - Git branch
#   gco        - Git checkout
#   gcb        - Git checkout new branch
#   gl         - Git log one line
#   gd         - Git diff
#   gdc        - Git diff cached
#   gr         - Git remove from cache
#
# Usage Examples:
#   $ gs                         # Show git status
#   $ gc "commit message"        # Commit with message
#   $ gaa                        # Add all files
#   $ gac                        # Add all files and commit with auto message
#   $ gitinfo                    # Show current repo status and info
#   $ gcb feature-branch         # Create and checkout new branch
#   $ gr file.txt                # Remove file from git cache
#   $ gpullall ~/Projects        # Pull every repo under ~/Projects
#                                # (skips dirty repos and repos where the
#                                #  merge would conflict)

# Unset any existing conflicting aliases/functions before defining new ones
cleanup_shortcut "gs"
cleanup_shortcut "gc"
cleanup_shortcut "gp"
cleanup_shortcut "gu"
cleanup_shortcut "ga"
cleanup_shortcut "gaa"
cleanup_shortcut "gb"
cleanup_shortcut "gco"
cleanup_shortcut "gcb"
cleanup_shortcut "gl"
cleanup_shortcut "gd"
cleanup_shortcut "gdc"
cleanup_shortcut "gr"
cleanup_shortcut "gac"
cleanup_shortcut "gitinfo"
cleanup_shortcut "gpullall"

# Git Operations
if ! should_exclude "gs" 2>/dev/null; then alias gs='git status'; fi
if ! should_exclude "gc" 2>/dev/null; then alias gc='git commit -m'; fi
if ! should_exclude "gp" 2>/dev/null; then alias gp='git push'; fi
if ! should_exclude "gu" 2>/dev/null; then alias gu='git pull'; fi
if ! should_exclude "ga" 2>/dev/null; then alias ga='git add'; fi
if ! should_exclude "gaa" 2>/dev/null; then alias gaa='git add -A'; fi
if ! should_exclude "gb" 2>/dev/null; then alias gb='git branch'; fi
if ! should_exclude "gco" 2>/dev/null; then alias gco='git checkout'; fi
if ! should_exclude "gcb" 2>/dev/null; then alias gcb='git checkout -b'; fi
if ! should_exclude "gl" 2>/dev/null; then alias gl='git log --oneline'; fi
if ! should_exclude "gd" 2>/dev/null; then alias gd='git diff'; fi
if ! should_exclude "gdc" 2>/dev/null; then alias gdc='git diff --cached'; fi
if ! should_exclude "gr" 2>/dev/null; then alias gr='git rm --cached'; fi

# Git commit with auto-generated message based on changes
if ! should_exclude "gac" 2>/dev/null; then
  gac() {
    # gac stages and commits everything, so it must recognise --help rather
    # than treating it as a signal to go ahead and commit.
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: gac"
      echo ""
      echo "Stage every change in the working tree and commit it with an"
      echo "auto-generated message naming the number of files changed."
      echo ""
      echo "Examples:"
      echo "  gac                          # git add . && git commit -m 'Auto commit: N files changed'"
      echo ""
      echo "Note: This command takes no arguments and commits ALL changes."
      echo "      Use 'gaa' then 'gc \"message\"' to write your own message."
      return 0
    fi

    if [[ $# -gt 0 ]]; then
      echo "Error: gac takes no arguments"
      echo "Use 'gac --help' for more information"
      return 1
    fi

    git add . || return 1
    local files_changed
    # tr strips the padding that BSD wc adds, which otherwise lands in the
    # commit message.
    files_changed=$(git diff --cached --name-only | wc -l | tr -d '[:space:]')
    if [[ "$files_changed" -eq 0 ]]; then
      echo "Nothing staged to commit"
      return 1
    fi
    git commit -m "Auto commit: $files_changed files changed"
  }
fi

# Show git branch info in a nice format
if ! should_exclude "gitinfo" 2>/dev/null; then
  gitinfo() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: gitinfo"
      echo ""
      echo "Display current branch, repository name, last commit and status"
      echo "for the Git repository in the current directory."
      echo ""
      echo "Examples:"
      echo "  gitinfo                      # Show repository information"
      echo ""
      echo "Note: This command takes no arguments"
      return 0
    fi

    # Check if we're in a git repository first
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
      echo "Not a git repository"
      return 1
    fi
    
    echo "=== GIT REPOSITORY INFO ==="
    echo "Current branch: $(git branch --show-current)"
    echo "Repository: $(basename "$(git rev-parse --show-toplevel)")"
    echo "Last commit: $(git log -1 --format='%h - %s (%cr)' 2>/dev/null || echo 'No commits yet')"
    echo "Status:"
    local status_output=$(git status -s)
    if [ -z "$status_output" ]; then
      echo "  Working tree clean - no changes to commit"
    else
      echo "$status_output"
    fi
  }
fi

# Recursively pull every git repo under a directory, but skip repos where
# the pull would fail or introduce a merge conflict.
if ! should_exclude "gpullall" 2>/dev/null; then
  gpullall() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: gpullall [directory]"
      echo ""
      echo "Recursively find every Git repository under [directory] (default: current"
      echo "directory) and run 'git pull' in each one. A repo is skipped when:"
      echo "  - the working tree has uncommitted changes"
      echo "  - the current branch has no upstream configured"
      echo "  - merging the fetched upstream would produce a conflict"
      echo ""
      echo "Examples:"
      echo "  gpullall                     # Pull every repo under \$PWD"
      echo "  gpullall ~/Projects          # Pull every repo under ~/Projects"
      echo ""
      echo "Exit status: 0 if every repo was pulled cleanly or skipped safely,"
      echo "1 if any repo failed (fetch or pull error)."
      return 0
    fi

    if [[ $# -gt 1 ]]; then
      echo "Error: gpullall takes at most one directory argument"
      echo "Use 'gpullall --help' for more information"
      return 1
    fi

    if ! command -v git >/dev/null 2>&1; then
      echo "Error: git is not installed"
      return 1
    fi

    local root="${1:-.}"
    if [[ ! -d "$root" ]]; then
      echo "Error: '$root' is not a directory"
      return 1
    fi

    local repo="" dir="" label=""
    local pulled=0 skipped=0 failed=0

    while IFS= read -r -d '' repo; do
      dir=$(dirname "$repo")
      # Show a relative path when possible; otherwise the full path.
      label=${dir#"$root"/}
      [[ "$label" == "$dir" ]] && label="$dir"
      [[ "$dir" == "$root" ]] && label="$root"

      echo "=== $label ==="

      (
        cd "$dir" 2>/dev/null || { echo "  fail: cannot enter directory"; exit 3; }

        # Confirm this really is a git working tree.
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "  skip: not a git working tree"
          exit 2
        fi

        # 1. Working tree must be clean (this also catches unresolved merges).
        if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
          echo "  skip: uncommitted local changes"
          exit 2
        fi

        # 2. Current branch must have an upstream to pull from.
        upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
        if [[ -z "$upstream" ]]; then
          echo "  skip: no upstream configured"
          exit 2
        fi

        # 3. Fetch so the merge-tree check has the latest upstream tip.
        if ! git fetch --quiet 2>/dev/null; then
          echo "  fail: git fetch failed"
          exit 3
        fi

        # 4. Predict whether merging upstream into HEAD would conflict.
        # Prefer 'git merge-tree --write-tree' (git 2.38+): exit 0 = clean,
        # exit 1 = conflict. Fall back to the 3-arg form on older git and
        # look for conflict markers in its diff output ('+<<<<<<< ' because
        # merge-tree emits its conflict hunks as diff-format additions).
        git merge-tree --write-tree HEAD "$upstream" >/dev/null 2>&1
        mt_rc=$?
        if [[ $mt_rc -eq 1 ]]; then
          echo "  skip: pulling would cause a merge conflict"
          exit 2
        elif [[ $mt_rc -gt 1 ]]; then
          base=$(git merge-base HEAD "$upstream" 2>/dev/null)
          if [[ -z "$base" ]]; then
            echo "  skip: no common ancestor with $upstream"
            exit 2
          fi
          if git merge-tree "$base" HEAD "$upstream" 2>/dev/null \
               | command grep -q '^+<<<<<<< '; then
            echo "  skip: pulling would cause a merge conflict"
            exit 2
          fi
        fi

        # 5. Actually pull. Force merge mode so the pull's outcome matches
        # what merge-tree predicted above — a user-configured pull.rebase=true
        # would otherwise attempt a rebase whose conflict behavior differs.
        if git pull --quiet --no-rebase --no-edit; then
          echo "  ok: pulled from $upstream"
          exit 0
        fi
        echo "  fail: git pull failed"
        exit 3
      )
      case $? in
        0) pulled=$((pulled + 1)) ;;
        2) skipped=$((skipped + 1)) ;;
        *) failed=$((failed + 1)) ;;
      esac
    done < <(command find "$root" -name .git -prune -print0 2>/dev/null)

    echo
    echo "Summary: $pulled pulled, $skipped skipped, $failed failed"
    [[ $failed -eq 0 ]]
  }
fi
