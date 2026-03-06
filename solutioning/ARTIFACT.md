## Meta

- **Storage:** `docs/workstreams/<work-item>/` at the nearest project root
- **Filename:** `solution-statement.md`
- **Trigger:** When a solution is confirmed and the phase closes

## Template

```markdown
# Solution Statement

## Candidates

### Candidate 1: <name>
<!-- Description, tradeoffs, constraints. Include an LOE estimate (1–5) for this candidate. -->

### Candidate 2: <name>
<!-- Description, tradeoffs, constraints. Include an LOE estimate (1–5) for this candidate. -->

<!-- Additional candidates as needed. A single candidate is valid for prescriptive problems. -->

## Next Step
Recommendation: <reasoning | Plan>
Confidence: <high | medium | low>
Rationale: <one sentence>
```

## Notes

- The solution statement captures the candidates, not the decision — the reasoning skill's `truth-and-vector.md` handles the decision and its justification
- The `## Candidates` section may contain a single candidate when the short-circuit path is taken; this is intentional, not an error or incomplete artifact
- Referenced by the planning skill as input for building the implementation plan
