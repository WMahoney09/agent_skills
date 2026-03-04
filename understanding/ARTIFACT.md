## Meta

- **Storage:** `.claude/work/<work-item>/` at the nearest project root
- **Filename:** `problem-statement.md`
- **Trigger:** When the understanding phase closes and mutual alignment is confirmed

## Template

```markdown
# Problem Statement

## Problem
<!-- 1–3 sentences, plain language -->

## Why It Matters / Why Now
<!-- What happens if this isn't solved? Why is now the right time? -->

## Key Constraints
<!-- Non-negotiable boundaries: technical, organizational, time, scope -->

## Success Criteria
<!-- How will we know this is solved? Concrete, verifiable outcomes. -->

## Assumptions Surfaced
<!-- Assumptions discovered during understanding that should be validated -->

## Workstream Slug
<!-- Slugified from the problem statement — used as the `.claude/work/<slug>/` directory name -->
```

## Side Effects

- Create `.claude/work/<slug>/` directory at the nearest project root if it doesn't exist
- The slug is derived from the problem statement (lowercase, hyphenated, concise)

## Notes

- `problem-statement.md` is the precondition artifact for `/leeroyyyyy` — it must exist before the autonomous pipeline can be invoked
- The workstream slug establishes the directory name used by all subsequent artifacts in the delivery pipeline
