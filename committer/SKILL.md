---
name: committer
description: Stage and commit changes with a consistent, typed commit convention. Can be invoked directly by the user or used by other skills (e.g., produce) to manage git history.
agent-invocation: user-invoked-and-referenced
---

# Committer: Typed Commits with Clear Intent

This skill governs how changes are staged and committed. It can be invoked directly to commit current working changes, or referenced by other skills (such as `produce`) to ensure a consistent commit convention throughout execution.

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
[plan] Add authentication implementation plan

- Covers login flow, session handling, and middleware strategy
- Identifies dependencies between auth and user profile tasks

[plan/docs] Add authentication plan and update architecture overview

- Add implementation plan covering login flow and middleware strategy
- Update architecture doc to reflect new auth layer

[docs] Document order API endpoints and validation rules

- Add endpoint reference for POST /api/orders
- Describe request schema, validation constraints, and error responses

[code] Add login endpoint and JWT authentication middleware

- Implement POST /api/auth/login with credential validation
- Generate and sign JWT tokens on successful login
- Add middleware that validates tokens on protected routes
- Return 401 with structured error on invalid or expired tokens

[code] Add order creation form and API handler

- Build OrderForm component with field validation
- Implement POST /api/orders with schema validation
- Wire form submission to API and handle error states
```

## When Invoked Directly

When a user invokes `/committer`, the agent should:

1. **Inspect the working directory** — run `git status` and `git diff` to understand what has changed
2. **Determine the correct type** — assess whether changes are `[plan]`, `[docs]`, or `[code]`
3. **Group logically** — if unrelated concerns are mixed in the working directory, stage and commit them separately
4. **Write the commit** — follow the format above: typed prefix, brief title, detailed body
5. **Confirm completion** — report the commit(s) made with their messages

## When Referenced by Other Skills

Skills like `produce` delegate all commit decisions to this convention. Any commit created during autonomous execution must follow the type prefix and message format defined here.

## Key Rules

- Every commit starts with `[plan]`, `[plan/docs]`, `[docs]`, or `[code]` — no exceptions
- Classify by the files changed, not by intent — the type is determined mechanically
- `[code]` takes precedence over all others: any non-plan, non-markdown file in the commit makes it `[code]`
- Titles are brief and plain; detail belongs in the body
- Do not mix unrelated concerns in a single commit — split them if needed
