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
| Create a skill | `mkdir skills/skill-name` → write `skills/skill-name/SKILL.md` |
| Edit a skill | Edit `skills/skill-name/SKILL.md` directly in this repo |
| Delete a skill | Remove the `skills/skill-name/` directory from this repo |
| Rename a skill | Rename the directory; update `name:` in frontmatter; update README |

Always follow the README Sync Rule below when making any of these changes.

## Docs Convention

The `docs/` directory at the project root is the home for all project documentation and pipeline artifacts:

- **`docs/workstreams/<slug>/`** — Pipeline artifacts (problem statements, solution statements, plans, review reports, etc.). The `<slug>` is established by the `/understanding` skill when it creates the workstream directory.
- **`docs/reference/`** — Project reference material (architecture decisions, ontology, topology, etc.). Consulted by discovery skills like `/recon` and `/understanding` when it exists.

Artifacts are project-local — saved to `docs/workstreams/<slug>/`, never to tool-specific directories like `.claude/*`, `.cursor/*`, or home directory conventions like `~/.claude/*`.

## Bash Anti-Patterns (Permission System)

Claude Code's permission system matches Bash commands by **prefix**. Compound commands (`&&`, `||`, `;`, pipes) and shell substitution (`$(...)`) create command strings that don't match individual permission patterns and will **always trigger interactive prompts**, breaking autonomous flow.

**Never do these:**

| Anti-pattern | Why it breaks | Use instead |
|---|---|---|
| `cd /path && git status` | Compound `&&` — won't match `Bash(git status:*)` | `git -C /path status` |
| `git add file && git commit -m "msg"` | Compound `&&` — won't match either `Bash(git add:*)` or `Bash(git commit:*)` | Separate Bash calls: first `git add file`, then `git commit -m "msg"` |
| `git commit -m "$(cat <<'EOF'...)"` | Shell substitution `$(...)` — won't match `Bash(git commit:*)` | Write message to `/tmp/commit_msg.txt` with the Write tool, then `git commit -F /tmp/commit_msg.txt` |
| `gh pr create --body "$(cat /tmp/body.txt)"` | Shell substitution `$(...)` — won't match `Bash(gh:*)` | Use MCP `mcp__github__create_pull_request`, or `gh pr create --body-file /tmp/body.txt` |
| `command | tail -20` | Pipe — won't match `Bash(command:*)` | Run the command alone; truncate output by other means or accept full output |

**General rules:**
- One command per Bash call — no `&&`, `||`, `;`, or pipes
- Use `git -C /path` instead of `cd /path && git`
- Use file flags (`-F`, `--body-file`) instead of shell substitution (`$(cat ...)`)
- Use MCP tools (e.g., `mcp__github__create_pull_request`) instead of complex CLI invocations when available

## README Sync Rule

When any skill is added, updated, removed, or renamed in this repository, the `README.md` must be updated to reflect the change. Specifically:

1. **RAPID flow line and Floating Skills callout** — add or remove the `/skill-name` from the appropriate location
2. **Meta section** — if the skill defines a shared convention or meta-guidance, add an entry describing what it defines and how other skills reference it
3. **RAPID stage section** — add or update the skill card in the appropriate `## Letter — Name` section (or Floating Skills if the skill is stage-agnostic)
4. Skills that serve both as shared conventions *and* direct user tools (like `/commit` and `/estimate`) appear in **both** Meta and Floating Skills — this duplication is intentional

### Checklist for skill changes

- [ ] Skill directory with `SKILL.md` exists (or has been removed)
- [ ] README RAPID section updated (skill card added/moved to correct stage)
- [ ] README Meta section updated (if applicable)
- [ ] README RAPID stage section updated (if the skill belongs to a specific stage)
