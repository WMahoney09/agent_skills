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

## Next Step
Recommendation: reasoning
Confidence: high
Rationale: Tire-kicking evidence ready for reasoning synthesis and final solution choice.
```

## Notes

- The canonical output filename is `tire-kicking-report.md` — do not use legacy names like `tire-kicking-scenarios.md` or `path-forward.md`
- The report is a comparative analysis across candidates, not a verdict on any single one — reasoning invoked tire-kicking because of ambiguity between candidates, and now reasoning will consume this report to resolve that ambiguity and make the final solution choice
- The `## Next Step` block is effectively fixed (always `reasoning`) because the conditionality is in whether tire-kicking runs at all, not in what it recommends after running
