## Meta

- **Storage:** `.claude/work/<work-item>/` at the nearest project root
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
```

## Notes

- The truth-and-vector artifact captures the output of reasoning — truths, conditionals, and a directional aim — as a referenceable file
- In the leeroyyyyy pipeline, this artifact is produced by the reasoning subagent after consuming the tire-kicking report
