# Agentic Skills — Project Instructions

## README Sync Rule

When any skill is added, updated, removed, or renamed in this repository, the `README.md` must be updated to reflect the change. Specifically:

1. **Diagram** (line starting with `Use anytime:`) — add or remove the `/skill-name` from the appropriate location
2. **Meta section** — if the skill defines a shared convention or meta-guidance, add an entry describing what it defines and how other skills reference it
3. **Supporting Skills section** — add an entry with the skill's description and typical usage pattern
4. Skills that serve both as shared conventions *and* direct user tools (like `/commit` and `/estimate`) appear in **both** Meta and Supporting Skills — this duplication is intentional

### Checklist for skill changes

- [ ] Skill directory with `SKILL.md` exists (or has been removed)
- [ ] README diagram updated if skill is a "use anytime" supporting skill
- [ ] README Meta section updated (if applicable)
- [ ] README Supporting Skills section updated
- [ ] README phase descriptions updated (if the skill belongs to a specific phase)
