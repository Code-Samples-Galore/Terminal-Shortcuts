# Copilot-generated commit shortcut: gcm (git commit with message from Copilot)
# Requires the Copilot CLI (copilot) in your PATH and that you're logged in/authenticated.
# Usage:
# 1) stage changes: git add <files>
# 2) run: gcm
# The function will generate a one-line Conventional-Commit-style message and run:
#   git commit -m "generated message"
#
# If your copilot CLI uses different subcommands/flags, adjust the `copilot chat --raw` line.
gcm() {
  # allow passing extra git commit flags, e.g. gcm --no-verify
  extra_args=("$@")

  if ! command -v copilot >/dev/null 2>&1; then
    echo "copilot CLI not found in PATH. Install and authenticate Copilot CLI first."
    return 1
  fi

  # ensure we have staged changes
  if git diff --cached --quiet; then
    echo "No staged changes to commit. Stage files first (git add ...)."
    return 1
  fi

  # get staged diff
  staged_diff=$(git diff --staged)

  # build prompt for Copilot - ask for a single-line Conventional Commit message
  prompt=$'Write a single-line Conventional Commit message (type(scope): short summary) for the staged git diff below. Output ONLY the one-line commit message with no extra text.\n\nDiff:\n'"$staged_diff"

  # call Copilot CLI - adjust subcommand/flags if your copilot CLI differs
  generated=$(printf "%s" "$prompt" | copilot chat --raw 2>/dev/null || true)

  # sanitize: pick first non-empty line and trim
  generated="$(printf "%s" "$generated" | awk 'NF{print; exit}' | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"

  # fallback if Copilot didn't return anything
  if [[ -z "$generated" ]]; then
    echo "Copilot did not return a message — using fallback message."
    generated="chore: update files"
  fi

  # Show message and confirm before committing (comment out confirm block to commit automatically)
  echo "Commit message from Copilot:"
  echo "  $generated"
  # Ask for confirmation
  read -r -p "Use this message and commit now? [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git commit -m "$generated" "${extra_args[@]}"
  else
    echo "Aborted. You can run 'git commit -m \"$generated\"' manually or edit the message."
    return 1
  fi
}
