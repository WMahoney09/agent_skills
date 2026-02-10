---
name: artifactor
description: Guidance for agents on where and how to save generated artifacts (plans, documents, configurations) to ensure they are project-local and tracked in version control.
disable-model-invocation: true
---

# Artifactor: Project-Local Artifact Principles

This skill establishes and reinforces the principle that all agent-generated artifacts must be saved to the project directory, never to home directory conventions.

## Core Principle: Project-Local Only

**All agent-generated artifacts must be saved to the project directory, never to home directory conventions.**

### Why?

- **Version control:** Artifacts in the project can be tracked in git and reviewed alongside code
- **Team visibility:** Team members find artifacts in a consistent, discoverable location
- **No duplicates:** Prevents the same artifact from existing in multiple places with conflicting versions
- **Clean home directory:** Keeps `~/.cursor/*`, `~/.vscode/*`, and similar directories clean and free of project-specific files

### What This Means

❌ **DO NOT save artifacts to:**
- `~/.cursor/*`
- `~/.vscode/*`
- `$HOME/.*` (home directory dot directories)
- Any home directory path

✅ **DO save artifacts to:**
- `.cursor/` subdirectories in the project (e.g., `.cursor/plans/`, `.cursor/work/feature-name/`)
- `.vscode/` subdirectories in the project
- Other project-specific convention directories (e.g., `.github/`, `.config/`)

### Flexibility Within Projects

Agents have flexibility to follow project-specific conventions within the project directory. For example:
- `.cursor/plans/my-plan.md` (typical location)
- `.cursor/work/price-mgmt/plan.md` (following project structure)
- `.github/planning/proposal.md` (in a GitHub directory)

The key constraint is: **artifacts go in the project, never in home directory conventions.**

## Applying This Principle to Different Skills

Skills that generate artifacts should:

1. **State where artifacts go** - Clearly indicate that artifacts must be saved to the project, not home directory
2. **Suggest common locations** - Provide a typical location (e.g., `.cursor/plans/` for plans) but allow flexibility
3. **Forbid home directories** - Explicitly rule out paths like `~/.cursor/*`, `~/.vscode/*`, etc.
4. **Confirm with the user** - Ask users to approve the file path before writing
5. **Validate before delivery** - Include a checklist to verify the artifact is project-local before presenting it

## Examples from Existing Skills

### Planning Skill

The Planning skill follows this principle by:
- Saving plan files to `.cursor/plans/` (default) or project-specific `.cursor/` subdirectories
- Confirming the file path with the user before writing: *"I'll save this to `.cursor/plans/my-plan.md`. Does that look right?"*
- Including a pre-delivery validation checklist:
  - ✓ File is in `.cursor/` or project subdirectory
  - ✓ File path does NOT contain `~/.cursor/*`
  - ✓ File is ready to be tracked in git
  - ✓ User has confirmed the path

## Checklist for Skill Authors

When creating or updating a skill that generates artifacts, use this checklist:

- [ ] Skill clearly states artifacts must be project-local
- [ ] Skill forbids home directory locations (e.g., `~/.cursor/*`)
- [ ] Skill suggests a typical location (e.g., `.cursor/plans/`) but allows flexibility
- [ ] Skill asks the user to confirm the file path before writing
- [ ] Skill includes a validation checklist before delivering the artifact
- [ ] Validation checklist verifies:
  - [ ] File is in the project, not home directory
  - [ ] File path doesn't contain `~/`, `$HOME`, or absolute home paths
  - [ ] File is ready to be tracked in git
  - [ ] User has approved the location

## Notes

- This principle applies to all skills that generate artifacts, not just Planning
- Teams using these skills should expect all artifacts to live in the project
- If you find artifacts in home directories (like `~/.cursor/plans/`), move them to the project and delete the home directory copy
- When syncing skill files to `~/.claude/skills/`, remember that the principle of "project-local artifacts" still applies—it's a principle about where agents save their *outputs*, not where skills themselves live
