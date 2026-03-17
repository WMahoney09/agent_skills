---
name: publish-review
description: Publish review findings as a structured GitHub PR review with inline comments anchored to diff lines. Use after /review to deliver findings directly on the pull request.
agent-invocation: user-invoked-only
agent-note: "Agents may execute this skill ONLY when explicitly invoked by the user (e.g., /publish-review #N). Agents must NEVER invoke this skill autonomously or on their own initiative."
---

# Publish Review: Deliver Findings as Inline PR Comments

This skill takes `/review` findings from conversation context and posts them as a structured GitHub review with inline comments anchored to the actual diff lines. Reviewers see each finding in context without navigating away from the diff.

## Invocation

- **`/publish-review #N`** — Post findings to PR #N in the current repo
- **`/publish-review #N owner/repo`** — Post findings to PR #N in another repo

## Goal

Deliver `/review` findings directly onto a pull request as a single GitHub review with inline comments anchored to diff lines, so reviewers see each finding in the context where it matters.

## Agent's Role

### Step 1: Extract Findings from Conversation

Read back through the conversation to find the most recent `/review` output. For each finding, extract:

- **Severity** (Critical, Major, Minor)
- **Description** (the issue)
- **File and line** (`file:line` reference)
- **Why it matters** (Critical/Major only)
- **Suggestion** (recommended fix or direction)

If no `/review` output is found in the conversation, stop and report:

```
No review findings in this conversation. Run /review or /review #N first, then /publish-review #N to post the findings.
```

### Step 2: Fetch PR Diff and Map Findings

Fetch the PR diff and metadata. Derive `{owner}/{repo}` from the git remote origin (e.g., `gh repo view --json nameWithOwner`), or from the `owner/repo` argument if the user provided one.

```
gh pr diff #N
gh pr view #N --json number,title,author,url
```

**Reconciliation check:** If the `/review` output targeted a specific PR (e.g., "Pull Request: #5"), compare it against the target PR number. If they differ, surface a warning before proceeding:

```
⚠ Review findings are from PR #5, but you're publishing to PR #7. Proceed anyway?
```

This preserves flexibility for intentional cross-posting while preventing accidental mismatch.

Classify each finding into one of three buckets:

| Bucket | Condition | Result |
|---|---|---|
| **Inline** | File is in the diff AND line falls within a hunk | Comment anchored at that line |
| **File-level** | File is in the diff BUT line is outside any hunk | Comment with `subject_type: "file"` |
| **Body-only** | File not in the diff OR no `file:line` reference | Included in the top-level review body |

### Step 3: Check for Existing Feedback

Fetch existing review comments on the PR:

```
gh api repos/{owner}/{repo}/pulls/{N}/comments
```

Build a location index: `file:line → comment[]`. For each finding:

- If the finding's `file:line` matches an existing comment on the same file at the same source line (or within ±3 source lines) **and** the comment content overlaps in topic (similar keywords or issue description), flag it as "already covered". Proximity alone is not sufficient — both location and content must suggest the same issue.
- Record the existing comment's author and a snippet for the confirmation step

### Step 4: Format Comments

**Inline comment format:**

```
**[Severity]** Finding description

_Why it matters:_ Specific risk or consequence.

Suggestion or recommended fix.
```

- Include "Why it matters" for Critical and Major findings only
- Keep each comment self-contained — a reviewer should understand the issue without seeing the full report

**Top-level body format:**

Follow the template defined in `ARTIFACT.md`.

### Step 5: Present Mapping for Confirmation

Present the full plan before posting. Show:

- Each finding with its bucket assignment (inline / file-level / body-only)
- Any findings flagged as already covered, with existing comment details
- Counts by bucket

For findings flagged as already covered:

```
⚠ ALREADY COVERED:
  [Major] src/service.ts:42 — Missing null check
  Existing comment by @reviewer on line 42: "This needs a null check"
  → Skip (default) / Include anyway?
```

Default to skipping flagged findings, but the user can override.

Wait for user confirmation before posting.

### Step 6: Post Review via GitHub API

Build the review payload as a JSON object:

- `event`: `"COMMENT"` — never `REQUEST_CHANGES` or `APPROVE`
- `body`: the top-level review body (recommendation + rationale + body-only findings)
- `comments`: array of inline and file-level comment objects

Write the payload to `/tmp/pr_review_payload.json` using the Write tool, then post:

```
gh api repos/{owner}/{repo}/pulls/{N}/reviews --input /tmp/pr_review_payload.json
```

### Step 7: Report Completion

Report:
- Counts by bucket (inline / file-level / body-only / skipped)
- Review URL from the API response

## Edge Cases

**No review in conversation:**
Stop with guidance to run `/review` first. Do not attempt to generate findings.

**All findings outside diff:**
Post a body-only review. Warn in the confirmation step that no inline comments will be anchored to the diff.

**All findings already covered:**
Report "nothing new to post" and do not create an empty review.

**API 422 errors:**
If the API rejects a comment (e.g., invalid line position), retry with the offending comment moved from inline to file-level, or from file-level to body-only.

**PR has no diff:**
Report and stop — there is nothing to annotate.

## Artifact

The GitHub review object is the artifact. `ARTIFACT.md` documents the body template and inline comment format. Generated when the user confirms and the review is posted.

## Closure Criteria

The publish-review is complete when:

- [ ] Findings have been extracted from the most recent `/review` output
- [ ] The PR diff has been fetched and findings mapped to buckets
- [ ] Existing PR comments have been checked for overlap
- [ ] The full mapping has been presented and confirmed by the user
- [ ] The review has been posted as a single atomic GitHub review with event type `COMMENT`
- [ ] Completion has been reported with counts and review URL

## Notes

- This skill never approves or requests changes — those are human decisions. The review event is always `COMMENT`.
- All comments are posted as a single grouped review — one notification, dismissable as a unit.
- The confirmation gate is mandatory. Never post without user confirmation.
- This skill only publishes findings — it does not generate them. `/review` is the upstream skill.
