## Meta

- **Storage:** `agent-harness/retros/`
- **Filename:** `YYYY-MM-DD-<slug>.md` (slug describes the decision, not the date — e.g., `pr-review-state-flag.md`, `comment-mode-only.md`)
- **Trigger:** When a retro produces a cross-cutting harness decision that touches multiple files or makes a non-obvious tradeoff worth preserving. Most retros do NOT produce an ADR.

## When to write one

Write an ADR when at least one of these is true:

- The decision changed multiple files in coordination (e.g., a rule in `user/CLAUDE.md` AND a new hook AND a skill edit)
- The chosen approach has a non-obvious tradeoff that a future reader would otherwise have to re-derive
- The change is a response to a specific incident that's worth remembering (so we don't undo it accidentally later)
- A reasonable future reader, seeing only the resulting code, would ask "why is this here?"

If the change is a single-file tweak whose reasoning is obvious from a diff or commit message, skip the ADR — the commit history is enough.

## Template

```markdown
# Retro: <one-line description of the decision or incident>

**Date:** <YYYY-MM-DD>
**Trigger:** <what prompted the retro — incident, friction, planned reflection>
**Status:** <Resolved | Open | Partially addressed>

## What happened

<Chronological account of the incident or session. What was attempted, what
went wrong, what the agent and human did in response. Be specific — names,
commands, paths.>

## Root cause

<The underlying reason this happened. If there are multiple contributing
factors, layer them: harness gap, agent failure, missing rule, etc. Distinguish
"what we did wrong" from "what the system allowed."> 

## What we kept

<Things that worked correctly and shouldn't change. Listing the keeps prevents
over-correction — future readers can see what NOT to undo.>

## What we fixed

<Concrete changes made in response. Reference the files touched (e.g.,
"Added a `## GitHub Reviews: Comment-Mode Only (MANDATORY)` section to
user/CLAUDE.md"). Include test evidence where applicable (hook test cases,
verification commands).>

## Open / future improvements

<Things noticed during this retro that weren't addressed in this round —
either intentionally deferred or out of scope. Naming them here makes them
discoverable when the next related incident happens.>

## Skill observations

<Per-skill feedback that surfaced during this retro, if any. Use the same
format as the retro's Skill Observations category. Optional — only include
when there's something meaningful to say about how a specific skill behaved.>
```

## Notes

- The ADR is a decision record, not a status report. Future readers should be able to reconstruct *why* the harness looks the way it does from these entries.
- Don't sanitize. If the agent made a mistake, name it. If the harness had a gap, name it. The point of these records is to preserve hard-won lessons.
- Cross-link: when an ADR drives an edit elsewhere in the harness (a hook, a CLAUDE.md section), it's worth referencing the ADR slug in a comment near that code so future readers can find the reasoning.
