# Problem Statement

## Problem
Pipeline artifacts currently live in `.claude/work/<slug>/`, which forces Claude to request permission to "edit its own settings" every time it writes an artifact. These are project documentation, not tool configuration — they belong outside `.claude/`.

## Why It Matters / Why Now
The permission prompt is unnecessary friction on every artifact write. The artifact convention is stable (12 skills produce them), making this the right time for a holistic migration. Moving artifacts to `docs/` also establishes a project-level documentation home for reference material (architecture, ontology, topology) that agents can consult.

## Key Constraints
- Must be a holistic change — every reference updated consistently across all skills
- Must work for any consuming project, not just this repo
- This repo is itself a consuming project (skills evolving skills) and needs its own migration
- Convention must be documented in `CLAUDE.md` so projects can adopt it
- Sequential, mechanical change — no competing approaches to evaluate

## Success Criteria
- Artifacts write to `docs/workstreams/<slug>/` instead of `.claude/work/<slug>/`
- `ARTIFACT.spec.md` updated with new canonical path
- All 12 per-skill `ARTIFACT.md` files updated
- Skill instructions (`SKILL.md` files) that reference the old path updated
- This repo's existing `.claude/work/` content migrated to `docs/workstreams/`
- `.gitignore` simplified — no more `.claude/work` allowlist
- `CLAUDE.md` documents the `docs/` convention (workstreams + reference)
- `MEMORY.md` updated
- `README.md` updated if applicable
- No permission prompts when writing artifacts
- Skills like `/recon` and `/understanding` aware of `docs/reference/` as a context source

## Assumptions Surfaced
- `docs/reference/` is established as a convention but not seeded with content in this change
- Consuming projects adopt this by updating their own `CLAUDE.md` — this repo leads by example
- The `workstreams/` name better describes what these directories contain than `work/`

## Workstream Slug
move-artifacts-to-docs
