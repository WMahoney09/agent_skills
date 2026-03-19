---
name: revise
description: |
  Address a discrete revision — a bug fix, refactor, or piece of feedback — with a lightweight alignment check, holistic implementation, and a user-gated commit. Works from triage output, review findings, or a direct user statement.
  TRIGGER when: triage output exists in the conversation and the user asks to start fixing items ("fix these", "address the feedback", "let's work through the revisions", "start with the critical ones"), or the user asks to fix a specific piece of feedback ("fix the null check issue", "address that review comment"). Do NOT auto-invoke without triage or explicit user direction.
---

# Revise: Focused Revision with User-Gated Commits

This skill addresses one revision at a time: align on the issue, implement the fix holistically, confirm with the user, then commit. The commit gate is always owned by the user — no change is committed until explicitly confirmed as resolved.

## Invocation

- **`/revise`** — Address the next unresolved revision from the current triage output
- **`/revise C1`** — Address a specific revision by ID (from `/triage` output)
- **`/revise "description"`** — Address a revision stated directly by the user

## What a Revision Is

A revision is a discrete, bounded piece of work: a bug fix, a refactor, an accessibility improvement, a pattern correction. It is not a full feature. By definition, revisions are smaller in scope than implementation work — they are corrections and improvements to existing work.

A revision may touch multiple files if the issue appears as a pattern across the codebase. The fix should be holistic: if the pattern is wrong in five places, all five are addressed in one revision.

## The Revision Loop

Every revision follows the same four-stage loop:

```
Align → Implement → Confirm → Commit
         ↑__________________|
         (if not confirmed, loop back)
```

### Stage 1: Align

Before touching any code, state your understanding of the issue clearly and concisely:

- What is the problem?
- Where does it occur? (specific files, patterns, or areas of the codebase)
- What does a correct fix look like?
- Are there related instances elsewhere that should be addressed together?

Then ask: **"Is that the right understanding? Anything to add before I start?"**

Wait for confirmation. If the user corrects or expands the understanding, update and re-state before proceeding. Do not begin implementation until alignment is confirmed.

This is a lightweight check — not the full discovery process of `/understanding`. The goal is to confirm you're solving the right thing before writing a single line of code.

### Stage 2: Implement

Once aligned, implement the fix:

- Address the issue **holistically** across all affected files — if a pattern is wrong in multiple places, fix all instances in this revision
- Make only the changes needed to resolve this specific revision — do not fix unrelated issues encountered along the way (note them separately if they're worth flagging)
- Use the codebase's existing patterns and conventions unless the revision specifically calls for changing them

### Stage 3: Confirm

After implementing, present a clear summary of what was done:

**"Here's what I changed:**
- [File]: [what changed and why]
- [File]: [what changed and why]

**Does this resolve the issue?"**

The user will either:
- **Confirm** — "Yes, that's it" → proceed to commit
- **Give more guidance** — "Almost, but also..." or "Not quite, the issue is..." → loop back to Stage 2 with the new information

Do not commit until you receive explicit confirmation that the issue is resolved. Do not interpret silence or a vague response as confirmation.

### Stage 4: Commit

Once confirmed, commit the changes following the `/commit` skill convention with one addition: the commit message must include the revision ID and any PR comment IDs addressed by this revision.

**Commit message format for revise:**

```
[code] Brief description of what was fixed

- Bullet describing the change
- Bullet describing the change

Revision: C1
Addresses: #123, #124
```

- **`Revision:`** — the triage revision ID (e.g., `C1`, `M1`, `m1`). Omit if the revision came from a direct user statement with no triage ID.
- **`Addresses:`** — comma-separated list of PR comment IDs that this revision resolves. Omit if the revision did not come from PR comments.

These trailers are used by `/reply` to map commits back to PR comments.

## Input Sources

### From Triage Output

When `/triage` has been run, its output is the source of truth for revision IDs and PR comment linkage. Work through revisions in priority order: Critical first, then Major, then Minor.

Reference the triage report for:
- The revision ID (used in the commit trailer)
- The PR comment IDs grouped under this revision (used in the `Addresses:` trailer)
- The plain-language description of what needs to change

### From Review Output

When working from `/review` findings without a triage step, treat each finding as a revision. There are no triage IDs — omit the `Revision:` trailer. If the review was run against a PR, include comment references if available.

### From a Direct User Statement

When the user states the revision directly (e.g., "The null check in the auth middleware is missing"), take that as the revision description. There is no triage ID or comment ID — omit both trailers.

## Key Behaviors

**The commit gate is yours, not the agent's.**
The agent implements and presents. You confirm. Only then does a commit happen.

**Holistic, not surgical.**
If the issue is a pattern, all instances of that pattern are fixed in the revision. A fix that addresses one occurrence but leaves five others is incomplete.

**One revision at a time.**
Do not attempt to address multiple revisions in a single pass. Each revision gets its own alignment, implementation, confirmation, and commit. This keeps the git history clean and the feedback loop tight.

**Stay in scope.**
If the agent notices unrelated issues while implementing, it should note them — but not fix them. They belong in a separate revision.

**No speculative changes.**
Do not refactor surrounding code, improve naming, or make other improvements unless they are explicitly part of the revision. The goal is precision, not polish.

## Completion

A revision is complete when:

- [ ] Alignment was confirmed before implementation began
- [ ] All affected instances of the issue were addressed holistically
- [ ] The user has explicitly confirmed the issue is resolved
- [ ] A commit has been made with the correct type prefix, revision ID, and comment IDs (where applicable)

After committing, report the commit hash and message, then stop. The user will invoke `/revise` again for the next revision.

## Notes

- Revise is not produce — it does not run autonomously to completion. Each revision is a discrete, user-gated unit.
- The alignment stage is intentionally lightweight. If a revision turns out to be larger or more complex than expected during alignment, flag that before implementing — it may need to be broken into smaller revisions or escalated.
- If a revision cannot be completed (e.g., it depends on an architectural decision not yet made), say so clearly rather than implementing a partial fix.
