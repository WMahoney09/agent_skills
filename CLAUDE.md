# Agentic Skills — Project Instructions

## Skills Library Setup

`~/.claude/skills/` is a **symlink** pointing to this project directory (`/Users/will/agentic/skills/`). This means:

- **Always work in this project directory** when creating, editing, deleting, or renaming skills
- Do NOT read from or write to `~/.claude/skills/` directly — use this directory instead
- Changes here are automatically reflected in Claude's skill loader via the symlink
- New skill directories created here are immediately available as `/skill-name` commands without any additional installation step

### Operations reference

| Task | What to do |
|---|---|
| Create a skill | `mkdir skill-name` → write `skill-name/SKILL.md` |
| Edit a skill | Edit `skill-name/SKILL.md` directly in this repo |
| Delete a skill | Remove the `skill-name/` directory from this repo |
| Rename a skill | Rename the directory; update `name:` in frontmatter; update README |

Always follow the README Sync Rule below when making any of these changes.

## Agent Definitions Setup

`~/.claude/agents/` is a **symlink** pointing to `agents/` in this project directory. This means:

- Agent definitions live alongside skills in this repo
- Changes are immediately available to Claude Code via the symlink
- Agent definitions are role-based templates that compose skills into areas of responsibility

### Operations reference

| Task | What to do |
|---|---|
| Create an agent | Write `agents/<name>.md` with YAML frontmatter |
| Edit an agent | Edit `agents/<name>.md` directly in this repo |
| Delete an agent | Remove `agents/<name>.md` from this repo |
| Rename an agent | Rename the file; update `name:` in frontmatter; update README |

Always follow the README Sync Rule below when making any of these changes.

## Docs Convention

The `docs/` directory at the project root is the home for all project documentation and artifacts:

- **`docs/workstreams/<slug>/`** — Artifacts (problem statements, plans, review reports, etc.). The `<slug>` is established by the `/understanding` skill or by `/planning` when it creates the workstream directory.
- **`docs/reference/`** — Project reference material (architecture decisions, ontology, topology, etc.).

Artifacts are project-local — saved to `docs/workstreams/<slug>/`, never to tool-specific directories like `.claude/*`, `.cursor/*`, or home directory conventions like `~/.claude/*`.

## README Sync Rule

When any skill or agent definition is added, updated, removed, or renamed in this repository, the `README.md` must be updated to reflect the change.

### Checklist for skill changes

- [ ] Skill directory with `SKILL.md` exists (or has been removed)
- [ ] README skill listing updated
- [ ] README Meta section updated (if applicable)

### Checklist for agent definition changes

- [ ] Agent file `agents/<name>.md` exists (or has been removed)
- [ ] README agent definitions section updated
