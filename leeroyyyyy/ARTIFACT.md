## Meta

- **Storage:** `.claude/work/<work-item>/` at the nearest project root
- **Filename:** `summary-statement.md`
- **Trigger:** When the full pipeline completes (after all Critical/Major revisions are addressed, or after aborting with unresolvable issues)

## Template

```markdown
# Summary Statement

## Summary
<!-- 1–8 sentences: what was built, what changed, overall outcome -->

## Phases Executed
<!-- Bulleted list, one line each -->

## Out-of-Scope Items
<!-- As noted in the plan file -->

## Items Requiring User Attention
<!-- Unresolved revisions, escalations, or abort reason. Empty if clean completion. -->
```

## Notes

- If the pipeline aborted (e.g., pre-flight loop exhausted with unresolved Critical issues), document the abort reason in the Summary section and list unresolved issues under Items Requiring User Attention
- This is the final artifact of a leeroyyyyy run — it closes the pipeline
