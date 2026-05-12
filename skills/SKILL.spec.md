# SKILL.spec.md — Canonical Skill File Specification

This file is the authoritative specification for every `SKILL.md` in this library. It is not itself a skill — it defines the structure that all `skills/*/SKILL.md` files must follow.

## Frontmatter

Every `SKILL.md` begins with YAML frontmatter between `---` delimiters.

**Required fields:**

| Field | Description |
|---|---|
| `name` | Skill name (lowercase, hyphenated). Determines the `/slash-command`. |
| `description` | One-line description of what the skill does and when to use it. |

**Optional fields:**

| Field | Description |
|---|---|
| `agent-invocation` | Invocation constraint: `user-invoked-only`, `auto-and-referenced`, etc. |
| `agent-reference` | Whether other skills may invoke this one by reference: `forbidden`, etc. |
| `agent-note` | Free-text instruction to the agent about invocation rules. |

## Canonical Section Order

```
---
name: skill-name
description: ...
---

# Skill Name

[Optional experimental/warning notice]

## Goal
## Your Role          ← include if the skill has a user-facing interactive role
## Agent's Role       ← include if the skill has autonomous/orchestration behavior
## [Skill-specific content sections]
## Artifact           ← always immediately before Closure Criteria
## Closure Criteria
## Notes
```

### Section descriptions

| Section | Purpose |
|---|---|
| **Goal** | What the skill accomplishes — the outcome, not the process. |
| **Your Role** | What the human does during this skill. Include when the skill is interactive. |
| **Agent's Role** | What the agent does. Include when the skill has autonomous or orchestration behavior. |
| **Skill-specific content** | Any sections unique to this skill: methodology, classification, pipeline, etc. |
| **Artifact** | Brief summary of what this skill produces. Points to `ARTIFACT.md` for the full template. |
| **Closure Criteria** | Checklist of conditions that must be met before the skill is considered complete. |
| **Notes** | Supplementary guidance, caveats, and design rationale. |

### Optional sections

These sections may appear within the skill-specific content area (between Agent's Role and Artifact):

- `## Closing the Phase` — guidance on how to wrap up and transition. Conditional closing prompts are a valid pattern: a skill's `## Closing the Phase` section may contain branching logic that emits different closing prompts based on the skill's output (e.g., different nudges depending on whether the result is clear or ambiguous). This is expected for skills participating in nudge-driven routing.
- `## Invocation` — how the skill is invoked (useful for skills with multiple invocation patterns)
- `## Precondition` — what must be true before the skill can run

These sections must **not** appear after `## Artifact`.

## The `## Artifact` Invariant

`## Artifact` always appears **immediately before** `## Closure Criteria`. No exceptions.

Its content is a brief summary — typically 2–4 lines:
1. What artifact this skill produces (filename or "inline")
2. A reference to `ARTIFACT.md` for the full template
3. The trigger condition (when to generate)

Skills that do not produce artifacts omit the `## Artifact` section entirely. Absence is the signal — no placeholder or "N/A" marker is needed.

## Relationship to ARTIFACT.md

Skills that produce phase artifacts have a co-located `ARTIFACT.md` in the same directory. The `## Artifact` section in `SKILL.md` is the pointer; `ARTIFACT.md` is the full specification. See `ARTIFACT.spec.md` for the canonical artifact definition structure.
