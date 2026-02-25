---
name: estimate
description: Produce a Level of Effort (LOE) score for a proposed change by evaluating complexity and impact independently, then synthesizing to a 1–5 score.
---

# Estimate: Level of Effort Scoring

This skill produces a structured LOE score for a proposed change — a single number that helps decide whether to act now or defer, supported by the sub-scores that explain how we got there.

## Goal

Evaluate a proposed change across two dimensions and produce:
- A **LOE score** (1–5) as the primary deliverable
- **Sub-scores** for Complexity and Impact (each L / M / H)
- A **brief rationale** that explains the synthesis, especially when dimensions diverge

## Output Format

```
LOE: 3
Complexity: L | Impact: H
One-liner (or a few lines) explaining how the score was reached. Be especially clear when the two dimensions pull in different directions.
```

## Scoring Dimensions

### Complexity (L / M / H)
How hard is this to implement?

- **L** — Straightforward change. Clear scope, minimal logic, low coupling.
- **M** — Moderate effort. Some non-trivial logic, mild coupling, or moderate ambiguity.
- **H** — Involved change. Deep logic, high coupling, significant ambiguity, or requires coordination across systems.

Factors that raise complexity: technical difficulty, unclear requirements, tightly coupled systems, new patterns, concurrency concerns, data migrations.

### Impact (L / M / H)
How wide is the blast radius?

- **L** — Narrow scope. Few files, one system, minimal review surface.
- **M** — Moderate spread. Several files or one significant system, reasonable review burden.
- **H** — Wide spread. Many files, multiple systems or services, high regression risk, significant review burden.

Factors that raise impact: number of files touched, cross-service changes, shared interfaces, frequently-used code paths, downstream consumers.

## Synthesis: Complexity × Impact → LOE

| Complexity \ Impact | L | M | H |
|---|---|---|---|
| **L** | 1 | 2 | 3 |
| **M** | 2 | 3 | 4 |
| **H** | 3 | 4 | 5 |

Off-diagonal cases (L×H or H×L) both land at **3**. The rationale carries the nuance — make it clear which dimension is elevated and why.

## Behavior

**Default:** Reason from available context in the conversation.

**Permitted — use judgment:** If available context is insufficient for a reliable estimate, you may:
- Ask one or two targeted clarifying questions
- Read relevant files in the codebase

Don't over-investigate. The goal is a fast, useful signal — not a full audit. A well-reasoned estimate from context beats a precise one that takes ten minutes.

## Example Outputs

**Aligned dimensions (simple case):**
```
LOE: 1
Complexity: L | Impact: L
Single-file change to a utility function with no downstream consumers.
```

**Aligned dimensions (complex case):**
```
LOE: 5
Complexity: H | Impact: H
Replaces the core auth middleware — intricate logic, touches every authenticated route, and requires coordinating with the mobile team whose tokens will be affected.
```

**Off-diagonal (impact-dominant):**
```
LOE: 3
Complexity: L | Impact: H
The change itself is a one-liner in the base config, but it propagates to every service that inherits from it. Mechanically simple; the risk is in the spread.
```

**Off-diagonal (complexity-dominant):**
```
LOE: 3
Complexity: H | Impact: L
Isolated to a single algorithm in a rarely-touched module, but the logic is subtle and easy to break — requires careful reasoning through edge cases.
```

## Notes

- The LOE number is the answer to "should I do this now or later?" — optimize for that signal
- Sub-scores and rationale exist to explain the number, not to replace it
- When dimensions are at odds, the rationale is the most valuable part of the output — don't skip it
- A `3` can mean many different things; make the rationale earn its place
