# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## What this is

A library of ~114 shell aliases and functions that a user sources from their
`~/.bashrc` or `~/.zshrc`. There is no build step, no package manager, and no
test framework — the code *is* the deliverable, and it runs inside the user's
interactive shell.

**Every shortcut must work in both Bash (4.0+) and Zsh (5.0+).** This is the
single most important constraint in the repo and the source of most historical
bugs. See "Bash/Zsh portability" below.

## Layout

```
shortcuts.sh          Entry point: resolves its own directory, defines the
                      should_exclude/cleanup_shortcut helpers, sources
                      shortcuts.d/*.sh then cheatsheets.d/*.sh, then unsets
                      its helpers.
shortcuts.d/*.sh      Shortcut definitions, grouped by topic.
cheatsheets.d/*.sh    cs* functions that print reference cards.
```

Files are sourced in glob (alphabetical) order within each directory. That
order matters — see "Aliases leak into function bodies".

## Adding or changing a shortcut

Every definition follows this shape:

```bash
# Drop any pre-existing alias/function of this name
cleanup_shortcut "name"

# Define it, unless the user excluded it
if ! should_exclude "name" 2>/dev/null; then
  name() {
    if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
      echo "Usage: name <args>"
      ...
      return 1
    fi
    ...
  }
fi
```

Rules:

1. **`cleanup_shortcut` and the `should_exclude` guard are mandatory** — and the
   two lists must match exactly. A `cleanup_shortcut` call for a name this repo
   no longer defines silently destroys the *user's own* alias of that name.
2. **Functions need `--help` / `-h`.** Keep the help text truthful; it is the
   primary documentation for most shortcuts.
3. **Update three places when adding a shortcut:** the file's header comment
   block, `shortcuts.d/list_shortcuts.sh` (the `sc` listing), and `README.md`.
4. **Prefer `command -v tool` checks** with an actionable error over failing
   obscurely when a tool is missing.
5. **Cross-platform**: gate macOS-specific paths on `[[ "$OSTYPE" == "darwin"* ]]`
   and offer a fallback (`sha256sum` vs `shasum -a 256`, `netstat` vs `ss`,
   `ip addr` vs `ifconfig`).

## Bash/Zsh portability

These are the rules that actually bite. Each one corresponds to a bug that has
already shipped in this repo at least once.

| Don't | Do | Why |
|-------|----|-----|
| `$0` to find the script | `${BASH_SOURCE[0]}` / `${(%):-%x}` | When *sourced*, `$0` in bash is the shell's name, not the file. |
| `for x in $scalar` | `while IFS= read -r x` | Zsh does not word-split unquoted parameters. (It *does* split command substitutions.) |
| `cmd="ls -l"; $cmd` | build an array: `cmd=(ls -l); "${cmd[@]}"` | Same reason — zsh runs `$cmd` as one command name. |
| `${arr[0]}` | `${arr[@]:0:1}` | Zsh arrays are 1-indexed; `${arr[0]}` is empty there. |
| `${var^^}` / `${var,,}` | `tr '[:lower:]' '[:upper:]'` | Bash-only expansion; a fatal "bad substitution" in zsh. |
| `${PIPESTATUS[0]}` | write `$?` to a temp file inside the pipeline | Zsh spells it `pipestatus` and indexes from 1. |
| `for f in dir/*` | enumerate with `find` | An unmatched glob aborts the command in zsh. |
| `local a b` inside a loop | `local a="" b=""` before the loop | Re-declaring already-set names makes zsh *print* them. |
| `[[ " $list " =~ " $x " ]]` | `case " $list " in *" $x "*)` | Bash treats a quoted RHS as literal, zsh always as a regex. |
| `local x=$(cmd); [[ $? ...]]` | `local x; x=$(cmd); rc=$?` | `local` returns its own status, masking the command's. |
| splitting a scalar into an array | `if [ -n "$ZSH_VERSION" ]; then a=(${=s}); else a=($s); fi` | The one place an explicit branch is needed. |

Also portable in both, and used throughout: `local -a arr`, `arr+=(x)`,
`${#arr[@]}`, `"${arr[@]}"`, `${@:2}`, `${var:offset:length}`, `read -r -d ''`,
process substitution `< <(...)`, and C-style `for (( ))` loops.

### Aliases leak into function bodies

Aliases are expanded when a function body is *parsed*. Since each file defines
its aliases before its functions, and files are sourced alphabetically, a
function that calls `rm`, `cp`, `mv`, `mkdir`, `grep`, `ping`, `less` or `tree`
picks up this repo's alias for it — turning `cp` into an interactive `cp -iv`,
`rm` into a prompting `rm -i`, and `ping -c "$n"` into `ping -c 5 -c "$n"`.

**Inside a function, always call these through `command`:** `command rm -f ...`,
`command cp ...`, `command mkdir -p ...`, `command grep ...`.

Zsh expands aliases while sourcing even non-interactively; bash only does so
when interactive. A bug of this kind will therefore reproduce under
`zsh -c 'source shortcuts.sh; ...'` but *not* under `bash -c`. Use `bash -ic`
to reproduce it in bash.

### Namespace hygiene

The shell being polluted here is the user's own. Keep it clean:

- Helper functions defined inside a function are **global** in both shells.
  `unset -f` them on every exit path (see `_search_one`, `_hash_input`,
  `_numconv_render`).
- Don't create bare global variables at file scope. `wordlist` needs a
  persistent usage string, so it uses the namespaced `WORDLIST_USAGE`.
- `shortcuts.sh` deliberately leaves exactly one variable behind:
  `SHORTCUTS_DIR`.

## Verifying changes

There is no test suite. At minimum, before committing:

```bash
# 1. Both shells must parse every file
for f in shortcuts.sh shortcuts.d/*.sh cheatsheets.d/*.sh; do
  bash -n "$f" && zsh -n "$f" || echo "FAIL: $f"
done

# 2. Both shells must load cleanly from an unrelated directory
(cd /tmp && bash -c 'source ~/terminal_shortcuts/shortcuts.sh && sc >/dev/null && echo bash ok')
(cd /tmp && zsh  -c 'source ~/terminal_shortcuts/shortcuts.sh && sc >/dev/null && echo zsh ok')

# 3. Exercise the changed function in BOTH shells, not just your own
for s in bash zsh; do $s -c 'source ~/terminal_shortcuts/shortcuts.sh; <your function> <args>'; done

# 4. Exclusion still works in both
for s in bash zsh; do
  EXCLUDE_SHORTCUTS="sc" $s -c 'source ~/terminal_shortcuts/shortcuts.sh; type sc'
done
```

Step 3 is not optional. Testing in bash alone has repeatedly let zsh-fatal
bugs through.

## Documentation must match behavior

`README.md`, the `sc` listing, and each function's `--help` are all
hand-maintained and have drifted badly in the past — documenting flags that
never existed (`backup -c`, `search -g`, `wordlist -l`), commands that were
never defined (`watchlog`, `pupu`), and output formats that no function
produces. When you touch a function, re-read its help text and its README
section and make them true. When in doubt, run the command and copy the real
output.
