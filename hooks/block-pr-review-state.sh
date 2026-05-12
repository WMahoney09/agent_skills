#!/usr/bin/env bash
# PreToolUse hook for Bash — blocks `gh pr review` invocations that change
# the review state. Per global CLAUDE.md, reviews via Will's account are
# comment-mode only; severity belongs in the body, not the review state.
#
# Stdin: JSON with { tool_name, tool_input: { command, ... }, ... }
# Exit 2 + stderr message → Claude Code blocks the tool call and surfaces
# the message to the agent.

set -euo pipefail

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Match `gh pr review` (with any whitespace) followed somewhere by a
# state-changing flag. The flags are checked separately so order doesn't
# matter and other args between them don't break the match.
if printf '%s' "$command" | grep -qE 'gh[[:space:]]+pr[[:space:]]+review\b' \
  && printf '%s' "$command" | grep -qE -- '(--approve|--request-changes)\b'; then
  cat >&2 <<'MSG'
Blocked: `gh pr review` with a state-changing flag (--approve / --request-changes).

Per global CLAUDE.md ("GitHub Reviews: Comment-Mode Only"), reviews posted
through Will's account must be comment-mode only. Severity belongs in the
body text, not the review state.

Re-run as:
  gh pr review <N> --comment --body-file /tmp/review.md

If you genuinely need to approve or request changes, ask Will to do it himself.
MSG
  exit 2
fi

# Also catch the lower-level `gh api .../pulls/N/reviews` path with
# event=APPROVE or event=REQUEST_CHANGES.
if printf '%s' "$command" | grep -qE 'gh[[:space:]]+api\b.*pulls/.*/reviews' \
  && printf '%s' "$command" | grep -qiE 'event[ =]+(APPROVE|REQUEST_CHANGES)'; then
  cat >&2 <<'MSG'
Blocked: `gh api .../reviews` with event=APPROVE or REQUEST_CHANGES.

Per global CLAUDE.md ("GitHub Reviews: Comment-Mode Only"), reviews posted
through Will's account must be comment-mode only. Use event=COMMENT instead,
or just `gh pr review <N> --comment --body-file ...`.
MSG
  exit 2
fi

exit 0
