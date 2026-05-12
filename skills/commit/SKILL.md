---
name: commit
description: |
  Stage and commit changes with a consistent, typed commit convention.
  TRIGGER when: the user asks to commit changes ("commit this", "let's commit", "save our progress", "commit what we have"), or after completing implementation work and the user signals readiness to commit.
---

# Commit: Typed Commits with Clear Intent

This skill governs how changes are staged and committed.

## Commit Type Prefixes

Every commit message must begin with one of four type prefixes, determined by classifying the files changed:

| Prefix | When to use |
|--------|-------------|
| `[plan]` | Only plan files changed |
| `[plan/docs]` | Plan files and markdown files changed |
| `[docs]` | Only markdown files changed |
| `[code]` | Any non-plan, non-markdown file is changed |

**Classification rules:**
- A **plan file** is any file that is part of an implementation plan or task breakdown (e.g., files in a plans directory, files named `PLAN.md` or similar)
- A **markdown file** is any `.md` file that is not a plan file (e.g., READMEs, API docs, changelogs)
- If any file outside of these two categories is changed — source code, config, scripts, assets — the commit is `[code]`, regardless of what else is included

## Commit Message Format

```
[type] Brief title describing what changed

- Bullet describing a key change
- Bullet describing another key change
- Additional detail as needed
```

- **Title line**: `[type]` followed by a concise, plain-English description of the change
- **Body**: Bullet points that expand on what changed and why — include enough detail for a future reader to understand the commit without reading the diff

## Examples

```
[docs] Document order API endpoints and validation rules

- Add endpoint reference for POST /api/orders
- Describe request schema, validation constraints, and error responses

[code] Add login endpoint and JWT authentication middleware

- Implement POST /api/auth/login with credential validation
- Generate and sign JWT tokens on successful login
- Add middleware that validates tokens on protected routes
- Return 401 with structured error on invalid or expired tokens
```

## When Invoked Directly

When a user invokes `/commit`, the agent should:

1. **Inspect the working directory** — run `git status` and `git diff` to understand what has changed
2. **Determine the correct type** — assess whether changes are `[plan]`, `[docs]`, or `[code]`
3. **Group logically** — if unrelated concerns are mixed in the working directory, stage and commit them separately
4. **Write the commit** — follow the format above: typed prefix, brief title, detailed body
5. **Confirm completion** — report the commit(s) made with their messages

## Execution Rules

1. **One command per Bash call** — never chain with `&&`, `||`, `;`, or pipes.
2. **Use `git -C /path`** instead of `cd /path && git` when operating on a repo outside the working directory.
3. **For multi-line commit messages**, write the message to `/tmp/commit_msg.txt` using the Write tool, then commit with `git commit -F /tmp/commit_msg.txt`. Never use shell substitution like `git commit -m "$(cat <<'EOF'...)"`.
4. **Separate `git add` and `git commit`** into individual Bash calls.

## Key Rules

- Every commit starts with `[plan]`, `[plan/docs]`, `[docs]`, or `[code]` — no exceptions
- Classify by the files changed, not by intent — the type is determined mechanically
- `[code]` takes precedence over all others: any non-plan, non-markdown file in the commit makes it `[code]`
- Titles are brief and plain; detail belongs in the body
- Do not mix unrelated concerns in a single commit — split them if needed
