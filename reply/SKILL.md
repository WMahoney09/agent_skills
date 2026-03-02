---
name: reply
description: Close the feedback loop on a pull request by replying to each reviewer comment with the commit hash that addresses it. Reads Addresses: trailers from revise commits to build the mapping automatically.
agent-invocation: user-invoked-only
agent-note: "Agents may execute this skill ONLY when explicitly invoked by the user (e.g., /reply #N). Agents must NEVER invoke this skill autonomously or on their own initiative."
---

# Reply: Close the Feedback Loop on PR Comments

This skill closes the review loop by posting a reply to each PR comment with the commit hash that addresses it. It reads `Addresses:` trailers from commits made by `/revise` to build the comment-to-commit mapping automatically.

## Invocation

- **`/reply #N`** — Post replies to unresolved comments on PR #N in the current repo
- **`/reply #N owner/repo`** — Post replies on a PR in another repo

## Goal

After `/revise` has addressed feedback, reviewers should be able to see exactly which commit resolved each of their comments. This skill automates that — no manual copy-pasting of commit hashes.

## Prerequisites

- `/revise` must have been run and commits must exist with `Addresses:` trailers referencing comment IDs
- You must have push/comment access to the PR

## How It Works

Commits made by `/revise` include trailers in this format:

```
Revision: C1
Addresses: #123, #124
```

This skill reads the git log, extracts those trailers, and for each comment ID posts a reply on the PR with the hash of the commit that addresses it.

## Agent's Role

### Step 1: Fetch PR Context

Get the PR details to confirm the repo and comment structure:

```
gh pr view #N --json number,title,headRefName,baseRefName
```

### Step 2: Find Revise Commits

Scan the git log for commits that contain `Addresses:` trailers. Look at commits on the current branch since it diverged from the base branch:

```
git log origin/<base>..HEAD --format="%H %s%n%b"
```

For each commit, extract:
- The full commit hash
- The short hash (first 7 characters)
- All comment IDs listed in the `Addresses:` line

Build a map: `comment ID → commit hash`

If a comment ID appears in multiple commits (e.g., a revision was amended or re-done), use the most recent commit hash.

### Step 3: Confirm Before Posting

Before posting any replies, present the full mapping to the user for review:

```
Ready to post the following replies:

  PR #N — [title]

  Comment #123 → abc1234  "Fix null check in auth middleware"
  Comment #124 → abc1234  "Fix null check in auth middleware"
  Comment #87  → f3e9b12  "Update error handling pattern across service layer"
  Comment #91  → f3e9b12  "Update error handling pattern across service layer"

  4 replies to post. Proceed?
```

Wait for confirmation before posting. This gives you the chance to catch any mapping errors before comments appear on the PR.

### Step 4: Post Replies

For each comment ID in the map, post a reply using:

```
gh api repos/{owner}/{repo}/pulls/comments/{comment_id}/replies \
  -f body="Addressed in {short_hash} — {commit_title}"
```

The reply body format:

```
Addressed in `{short_hash}` — {commit_title}
```

Example:
```
Addressed in `abc1234` — Fix null check in auth middleware
```

This gives reviewers the hash to inspect and the commit title for immediate context. GitHub will auto-link the hash to the commit diff.

### Step 5: Report Completion

After all replies are posted, summarize:

```
Replied to 4 comments across 2 commits:

  abc1234 → #123, #124
  f3e9b12 → #87, #91
```

## Edge Cases

**Comment not found in any commit:**
If a comment ID appears in the triage output but no commit has an `Addresses:` trailer for it, flag it:
```
⚠️  Comment #99 has no associated commit. It may not have been addressed by /revise, or the commit is missing the Addresses: trailer.
```
Do not silently skip it.

**Comment already has a reply:**
Check if the comment thread already has a reply from this workflow before posting. If it does, skip it and note it in the summary. Do not post duplicate replies.

**No revise commits found:**
If no commits with `Addresses:` trailers are found on the branch, report this clearly rather than proceeding:
```
No commits with Addresses: trailers found on this branch. Run /revise to address PR comments before using /reply.
```

## Closure Criteria

Reply is complete when:

- [ ] All commits with `Addresses:` trailers have been identified
- [ ] The full comment-to-commit mapping has been presented and confirmed
- [ ] All mapped comments have received a reply
- [ ] Any unmapped comments have been flagged
- [ ] A completion summary has been reported

## Notes

- Reply is the final step in the review workflow: `/review` → `/triage` → `/revise` → `/reply`
- The quality of the mapping depends entirely on `/revise` commits having correct `Addresses:` trailers — if trailers are missing, flag it and ask the user to provide the mapping manually
- This skill only posts replies; it does not resolve, dismiss, or close comments
