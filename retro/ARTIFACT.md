## Meta

- **Storage:** `docs/workstreams/<work-item>/` at the nearest project root
- **Filename:** `retro-report.md`
- **Trigger:** When the retro synthesis is complete (both perspectives captured, or agent-only in autonomous mode)

## Template

```markdown
# Retro Report

**Work item:** <workstream slug>
**Date:** <YYYY-MM-DD>
**Skills invoked:** <comma-separated list of /skill-names used in this session>
**Mode:** <interactive | autonomous>

---

## Keep

- <observation — what worked well and why>

## Stop

- <observation — what caused friction, what was expected, what the impact was>

## Start

- <idea — what to try, what problem it solves, who benefits>

---

## Skill Observations

### `/skill-name`
- **Observation:** <what happened when using this skill>
- **Suggestion:** <concrete improvement>

*(Repeat for each skill with meaningful feedback. Omit skills with nothing notable to report.)*

---

## Action Items

> Prioritized improvements distilled from the observations above. Each item should be concrete enough to act on.

1. <highest-impact improvement — what to change and where>
2. <next improvement>
3. ...
```

## Notes

- The retro report is a process artifact, not a code artifact — it documents how the work went, not what was built
- Action items should reference specific skills or workflow steps where possible (e.g., "Update `/produce` SKILL.md to clarify X")
- When multiple retros exist in a workstream, comparing them reveals whether previous action items had effect
