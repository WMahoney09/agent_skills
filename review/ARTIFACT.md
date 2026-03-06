## Meta

- **Storage:** `docs/workstreams/<work-item>/` at the nearest project root
- **Filename:** `review-issues.md`
- **Trigger:** When the review pass is complete

## Template

```markdown
# Review Issues

**Pull Request:** <title and number or "Local changes on [branch]">
**Author:** <name or "you">
**Summary:** <1–3 sentence description of what this change does>

---

## Critical Issues
> Must be resolved before merge.

- <issue description>
  - **Where:** <file:line or area>
  - **Why it matters:** <specific risk or consequence>
  - **Suggestion:** <recommended fix>

## Major Issues
> Significant problems that should be resolved.

- <issue description>
  - **Where:** <file:line or area>
  - **Why it matters:** <specific risk or consequence>
  - **Suggestion:** <recommended fix>

## Minor Issues
> Non-blocking. Worth addressing but won't hold up a merge.

- <issue description>
  - **Where:** <file:line or area>
  - **Suggestion:** <recommended improvement>

## Gaps & Inconsistencies

- <gap description>
  - **Where:** <location>
  - **Detail:** <what's missing or inconsistent>

## Opportunities

- <opportunity description>

---

**Recommendation:** Go / No-Go / Go with conditions

<1–3 sentence rationale>
```

## Notes

- The review report format mirrors the structure defined in `review/SKILL.md` — this ARTIFACT.md defines the file-based version for pipeline handoffs
- In the leeroyyyyy pipeline, `review-issues.md` is consumed by the triage subagent
