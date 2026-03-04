## Meta

- **Storage:** `.claude/work/<work-item>/` at the nearest project root
- **Filename:** `solution-statement.md`
- **Trigger:** When a solution is confirmed and the phase closes

## Template

```markdown
# Solution Statement

## Chosen Approach
<!-- Name + 1–2 sentence description of the selected solution -->

## Why This Approach
<!-- Key evidence from tire-kicking and reasoning that led to this choice -->

## Tradeoffs Accepted
<!-- What we're giving up or accepting with this approach -->

## Approaches Considered and Rejected
<!-- Brief — name + one-liner reason for rejection -->

## LOE Score
<!-- Level of Effort score from /estimate -->
```

## Notes

- The solution statement captures the decision, not the exploration — solutioning's dialogue produces the reasoning; this artifact records the outcome
- Referenced by the planning skill as input for building the implementation plan
