---
name: reply
description: |
  Close the feedback loop on a pull request by replying to each reviewer comment with the commit hash that addresses it. Reads Addresses: trailers from revise commits to build the mapping automatically.
  TRIGGER when: revise commits exist and the user asks to respond to the reviewer ("reply to the reviewer", "respond on the PR", "close the loop", "let the reviewer know", "post replies"), after completing all revisions when the user signals they're done ("that's all the fixes", "let's wrap up the PR"), or immediately after a revision commit when the agent wants to reply for that revision ("reply for C1", "post the reply for this one").
---

# Reply: Close the Feedback Loop on PR Comments

This skill closes the review loop by posting a threaded reply to each PR comment with the commit hash that addresses it. It reads `Addresses:` trailers from commits made by `/revise` to build the comment-to-commit mapping automatically.

Supports two modes:
- **Batch** — after all revisions, scan all commits and post all pending replies at once
- **Incremental** — after each revision commit, post only the replies for that revision

## Goal

After `/revise` has addressed feedback, reviewers should be able to see exactly which commit resolved each of their comments — as a threaded reply on the original comment, not a standalone comment. This skill automates that mapping so agents don't manually post comments that lose the thread context.

## Your Role

Review the comment-to-commit mapping before replies are posted. The agent presents the mapping (full in batch mode, single-revision in incremental mode) and waits for your confirmation. This gate catches mapping errors before comments appear on the PR.

## Agent's Role

### Step 1: Resolve PR

If a PR number was provided (`#N`), fetch its details:

```
gh pr view N --json number,title,headRefName,baseRefName
```

If no PR number was provided, auto-detect from the current branch:

```
gh pr view --json number,title,headRefName,baseRefName
```

If auto-detection fails (no open PR for the current branch), stop with:

```
No open PR found for this branch. Specify a PR number: /reply #N
```

Derive `{owner}/{repo}` from the git remote origin (`gh repo view --json nameWithOwner`), or from the `owner/repo` argument if provided.

### Step 2: Fetch Comment Metadata

Pre-fetch all review comments on the PR with their metadata:

```
gh api repos/{owner}/{repo}/pulls/{N}/comments
```

Build two lookups from the response:

1. **Metadata lookup:** `comment_id → {commit_id, path, line, side}` — these fields are required by the GitHub API to post threaded replies (see Step 5)
2. **Existing replies lookup:** for each comment, check whether a reply containing "Addressed in" already exists — used for duplicate detection in Step 5

### Step 3: Find Revise Commits

Scan the git log for commits with `Addresses:` trailers on the current branch since it diverged from the base branch:

```
git log origin/{base}..HEAD --format="%H %s%n%b"
```

For each commit, extract:
- The full commit hash
- The short hash (first 7 characters)
- The commit title (subject line)
- The `Revision:` trailer value (if present)
- All comment IDs from the `Addresses:` line — strip the `#` prefix to get the numeric ID used in API calls

**Batch mode** (no revision ID specified): process all commits with `Addresses:` trailers.

**Incremental mode** (revision ID specified, e.g., `C1`): filter to only the commit whose `Revision:` trailer matches. If no matching commit is found:

```
No commit found with Revision: C1 trailer. Check that /revise committed with the correct trailer.
```

Build a map: `comment_id → {commit_hash, short_hash, commit_title}`

If a comment ID appears in multiple commits (e.g., a revision was amended or re-done), use the most recent commit hash.

### Step 4: Confirm Before Posting

Present the mapping for review:

```
Ready to post replies on PR #N — [title]:

  Comment #123 → abc1234  "Fix null check in auth middleware"
  Comment #124 → abc1234  "Fix null check in auth middleware"
  Comment #87  → f3e9b12  "Update error handling pattern"

  3 replies to post. Proceed?
```

In incremental mode, the mapping shows only the comments for the specified revision.

Flag any comments that will be skipped due to existing replies:

```
  ⏭ Comment #123 — already has a reply (skipping)
```

Wait for confirmation before posting.

### Step 5: Post Replies

For each comment ID in the confirmed mapping, post a threaded reply.

The GitHub API does not have a `/replies` sub-endpoint for PR review comments. Post to the pull request comments endpoint with `in_reply_to` and the original comment's metadata:

```
POST repos/{owner}/{repo}/pulls/{N}/comments
```

Write a JSON payload to `/tmp/reply_payload.json` for each comment:

```json
{
  "body": "Addressed in `abc1234` — Fix null check in auth middleware",
  "in_reply_to": 123,
  "commit_id": "abc1234def5678...",
  "path": "src/auth.ts",
  "line": 42,
  "side": "RIGHT"
}
```

Then post:

```
gh api repos/{owner}/{repo}/pulls/{N}/comments --input /tmp/reply_payload.json
```

- The `commit_id`, `path`, `line`, and `side` values come from the metadata lookup built in Step 2
- The `in_reply_to` value is the numeric comment ID (no `#` prefix)
- Skip any comment that already has an "Addressed in" reply (detected in Step 2)

The reply body format:

```
Addressed in `{short_hash}` — {commit_title}
```

This gives reviewers the hash to inspect and the commit title for immediate context. GitHub auto-links the hash to the commit diff.

### Step 6: Report Completion

Summarize what was posted:

```
Replied to 3 comments across 2 commits:

  abc1234 → #123, #124
  f3e9b12 → #87
```

In incremental mode, also suggest next steps:

```
Run /revise to continue to the next revision, or /reply to post remaining replies.
```

## Invocation

- **`/reply`** — Auto-detect PR, batch all pending replies
- **`/reply #N`** — Explicit PR, batch all pending replies
- **`/reply C1`** — Auto-detect PR, reply for a specific revision only
- **`/reply #N C1`** — Explicit PR, reply for a specific revision only
- **`/reply #N owner/repo`** — Batch all on a PR in another repo

Revision IDs (`C1`, `M1`, `m1`) start with a letter; PR numbers start with `#` — no ambiguity.

## Precondition

- At least one `/revise` commit must exist with `Addresses:` trailers referencing comment IDs
- You must have comment access to the PR

## Edge Cases

**No revise commits found:**
If no commits with `Addresses:` trailers are found on the branch:
```
No commits with Addresses: trailers found on this branch. Run /revise to address PR comments before using /reply.
```

**Comment not found in any commit:**
If a comment ID from the triage output has no matching `Addresses:` trailer, flag it:
```
⚠️  Comment #99 has no associated commit. It may not have been addressed by /revise, or the commit is missing the Addresses: trailer.
```
Do not silently skip it.

**Comment already has a reply:**
If a comment already has an "Addressed in" reply (detected in Step 2), skip it and note it in the summary. This prevents duplicates when running incremental mode followed by batch mode.

**Comment metadata not found:**
If a comment ID from the `Addresses:` trailer doesn't appear in the pre-fetched metadata (e.g., the comment was deleted or the ID is wrong):
```
⚠️  Comment #999 not found on PR #N. The comment may have been deleted or the ID in the Addresses: trailer may be incorrect.
```

## Closure Criteria

Reply is complete when:

- [ ] All commits with `Addresses:` trailers have been identified (or the specified revision's commit in incremental mode)
- [ ] The comment-to-commit mapping has been presented and confirmed
- [ ] All mapped comments have received a threaded reply (or been flagged as already replied / not found)
- [ ] Any unmapped comments have been flagged
- [ ] A completion summary has been reported

## Notes

- Reply closes the review workflow: `/review` → `/triage` → `/revise` → `/reply`
- Incremental mode fits naturally inside a revise loop — reply after each commit rather than waiting until the end
- The quality of the mapping depends on `/revise` commits having correct `Addresses:` trailers — if trailers are missing, flag it and ask the user to provide the mapping manually
- This skill only posts threaded replies; it does not resolve, dismiss, or close review threads
- The GitHub API requires the original comment's `commit_id`, `path`, `line`, and `side` to post a threaded reply via `in_reply_to` — this is why Step 2 pre-fetches all comment metadata upfront
