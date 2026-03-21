# Reply Skill: Incremental Mode + Auto-detect + Revise Nudge

## Overview

Three changes driven by a retro finding: an agent skipped `/reply` during a tight revise loop because the skill only supported batch-at-the-end mode. The agent did the right action (posted commit hashes) but bypassed the skill, so replies were standalone comments instead of threaded replies to reviewer feedback.

**Changes:**
1. Rewrite `/reply` to support both incremental (per-revision) and batch (all-pending) modes
2. Add PR auto-detection so `/reply` works without an explicit `#N`
3. Fix the GitHub API endpoint — the documented `/replies` endpoint 404s; the working pattern is `POST pulls/{N}/comments` with `in_reply_to`
4. Add a closing nudge to `/revise` that points agents toward `/reply` after each commit

## Notes

- **Not in scope:** orchestrator skill (`/feedback-loop`), `/retro` skill — flagged for future work
- **No README change needed** — both skills already exist in the README and the brief card descriptions remain accurate
- Structural cleanup of `/reply` happens as part of Phase 1 (reorder sections to match spec, remove redundancy, add Your Role)

## Progress

- [x] Phase 1: Rewrite `/reply` SKILL.md
- [x] Phase 2: Add closing nudge to `/revise` SKILL.md

---

## Phase 1: Rewrite `/reply` SKILL.md

Rewrite the skill file with three functional changes and structural cleanup.

### Step 1.1: Structural cleanup

Reorder sections to match `SKILL.spec.md` canonical order:

```
Goal → Your Role → Agent's Role → Invocation → Edge Cases → Closure Criteria → Notes
```

Remove:
- `## How It Works` — trailer format explanation folded into Agent's Role Step 2
- `## Prerequisites` — folded into a `## Precondition` section or mentioned inline in Agent's Role

Add:
- `## Your Role` — document the confirmation gate (user reviews mapping before replies are posted)

### Step 1.2: Two invocation modes

Update `## Invocation` to support:

| Pattern | Mode | Behavior |
|---|---|---|
| `/reply` | Batch | Auto-detect PR, scan all commits, post all pending replies |
| `/reply #N` | Batch | Explicit PR, scan all commits, post all pending replies |
| `/reply C1` | Incremental | Auto-detect PR, find commit for revision C1, post only those replies |
| `/reply #N C1` | Incremental | Explicit PR, find commit for revision C1, post only those replies |
| `/reply #N owner/repo` | Batch (cross-repo) | Explicit PR in another repo, batch all |

Disambiguation is clean: revision IDs (`C1`, `M1`, `m1`) start with a letter; PR numbers start with `#`.

### Step 1.3: Auto-detect PR from branch

Add to Agent's Role Step 1: before fetching PR context, if no `#N` was provided, detect the PR from the current branch:

```
gh pr view --json number,title,headRefName,baseRefName
```

If no PR is found and no `#N` was given, stop with a clear error. If `#N` is given, use it directly.

### Step 1.4: Incremental mode in Agent's Role

When a revision ID is specified (incremental mode):
- In Step 2 (Find Revise Commits), only look for the commit with a matching `Revision:` trailer instead of scanning all commits
- In Step 3 (Confirm), present only the mapping for that revision
- In Step 4 (Post Replies), post only those replies
- In Step 5 (Report), report only that revision's replies

When no revision ID is specified (batch mode):
- Existing behavior: scan all commits, build full mapping, confirm, post all

### Step 1.5: Fix GitHub API endpoint and pre-fetch comment metadata

The current skill documents `pulls/comments/{comment_id}/replies` which returns 404. The working endpoint is:

```
POST repos/{owner}/{repo}/pulls/{N}/comments
```

With fields: `body`, `in_reply_to` (the comment ID), plus required metadata from the original comment: `commit_id`, `path`, `line`, `side`.

This means the agent needs the original comment's metadata to post a reply. Two changes:

1. **Step 1 (Fetch PR Context)** — pre-fetch all PR review comments with their metadata:
   ```
   gh api repos/{owner}/{repo}/pulls/{N}/comments
   ```
   Build a lookup: `comment_id → {commit_id, path, line, side}` so Step 4 can iterate without additional API calls.

2. **Step 4 (Post Replies)** — use the correct endpoint with `in_reply_to` and the pre-fetched metadata. Write the payload to a temp file and post with `gh api --input`.

### Step 1.6: Fix bash examples

Remove backslash line continuation from all examples. Each command should be a single line per the CLAUDE.md convention.

### Step 1.7: Update triggers in frontmatter

Expand the TRIGGER clause to cover the incremental use case — e.g., "just committed a revision and wants to post the reply" alongside the existing batch triggers.

**Critical file:** `reply/SKILL.md`

---

## Phase 2: Add closing nudge to `/revise` SKILL.md

### Step 2.1: Add `## Closing the Phase` section

Insert a `## Closing the Phase` section after `## Completion` (before `## Notes`). The nudge is conditional:

**If the revision addressed PR comments** (has `Addresses:` trailer):
> "Revision committed. Run `/reply` to post the reply on the PR, or `/revise` to continue to the next revision."

**If the revision did not come from PR comments** (no `Addresses:` trailer):
> "Revision committed. Continue with `/revise` for the next revision."

This follows the conditional nudge pattern used by `/solutioning` and `/reasoning`.

### Step 2.2: Restructure completion into closure criteria

The current `## Completion` section functions as closure criteria but isn't named that way. Rename to `## Closure Criteria` to match the spec. Move the closing nudge to a new `## Closing the Phase` section that sits between Agent's Role content and Closure Criteria.

**Critical file:** `revise/SKILL.md`
