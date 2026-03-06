## Meta

- **Storage:** `docs/workstreams/<work-item>/` at the nearest project root
- **Filename:** `truth-and-vector.md`
- **Trigger:** When the reasoning pass is complete and a direction has been established

## Template

```markdown
# Truth and Vector

## Truths Established
<!-- Numbered list of confirmed facts / non-negotiables that hold regardless of solution choice -->
1. ...
2. ...

## Conditionals
<!-- Things that are true given a specific context or assumption -->
- If <choice>, then <consequence>
- If <choice>, then <consequence>

## Directional Vector
<!-- 1–3 sentences: where this reasoning points and why -->

## Next Step
Recommendation: <Plan | tire-kicking | understanding>
Confidence: <high | medium | low>
Rationale: <one sentence explaining why>
<!--
Examples:
  Recommendation: Plan | Confidence: high | Rationale: Reasoning resolves cleanly; one candidate is clearly superior.
  Recommendation: tire-kicking | Confidence: medium | Rationale: Genuine ambiguity between candidates; stress-testing needed.
  Recommendation: understanding | Confidence: high | Rationale: Problem space has shifted; revisit Research.

Note: This block is only populated when reasoning runs in Align context (solution-statement.md exists).
When reasoning runs standalone, omit this section.
-->
```

## Notes

- The truth-and-vector artifact captures the output of reasoning — truths, conditionals, and a directional aim — as a referenceable file
- In the leeroyyyyy pipeline, this artifact is produced by the reasoning subagent after consuming the solution candidates from `solution-statement.md`. If tire-kicking ran before this pass, reasoning also consumes `tire-kicking-report.md` to incorporate stress-test evidence
