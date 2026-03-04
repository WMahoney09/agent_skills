## Meta

- **Storage:** `.claude/work/<work-item>/` at the nearest project root
- **Filename:** `tire-kicking-report.md`
- **Trigger:** When all candidates have been stress-tested and the report is complete

## Template

```markdown
# Tire-Kicking Report

## Candidates Evaluated
<!-- List each candidate approach that was stress-tested -->

## Scenarios Tested

### <Candidate Name>

| Scenario | Result | Notes |
|---|---|---|
| <scenario> | Holds / Bends / Leaks | <why; what rule or change would close a bend or leak> |

### <Candidate Name>
<!-- Repeat per candidate -->

## Summary of Bends and Leaks

### <Candidate Name>
- **Bends:** <list>
- **Leaks:** <list>

### <Candidate Name>
<!-- Repeat per candidate -->

## Comparative Verdict
<!-- Which candidate held up best across scenarios? Key differentiators. -->
```

## Notes

- The canonical output filename is `tire-kicking-report.md` — do not use legacy names like `tire-kicking-scenarios.md` or `path-forward.md`
- The report is a comparative analysis across candidates, not a verdict on any single one — the reasoning skill consumes this to make the final solution choice
