---
name: reasoning
description: |
  Reason through a problem to extract truths, conditionals, and a directional vector. As a floating skill, usable standalone or within the Align stage after solutioning to evaluate solution candidates and determine next steps.
  TRIGGER when: the user wants collaborative help thinking through something complex ("help me think about this", "what do you think?", "let's hash this out", "help me reason through this"), or when a problem needs directional clarity before jumping to solutions.
---

# Reasoning: Developing Directional Clarity

This skill guides you through reasoning about a problem to extract what's fundamentally true, what's conditionally true, and from that, a direction to aim toward. When invoked within the Align stage (after solutioning), reasoning consumes the solution candidates and either confirms a direction or flags ambiguity that needs stress-testing.

## Goal

Develop principled clarity by:
- **Validating the problem** - Is this the real problem? What are its actual impacts?
- **Extracting truths** - What holds no matter what? Guiding principles that constrain all solutions.
- **Identifying conditionals** - What becomes true if we make certain choices?
- **Deriving a vector** - A directional aim that constrains the solution space

**Standalone usage:** The output is not a solution — it's a direction that constrains the solution space.

**Align-stage usage (after solutioning):** Reasoning consumes the solution candidates from `solution-statement.md` and evaluates them against truths and conditionals to either confirm a direction or flag ambiguity that needs stress-testing via tire-kicking.

## Your Role

As the agent running this skill:
- Reason through the problem collaboratively, not just present conclusions
- Surface statements that are invariantly true about the problem
- Explore conditionals: "If we do X, then Y becomes true"
- Help the person see how truths and conditionals point toward a direction
- Ground reasoning in the codebase when helpful (invoke Recon)
- Confirm alignment as reasoning develops (invoke Understanding if needed)
- Build shared conviction about the vector before moving to solutions

## Critical Boundary: Direction, Not Routes (Soft Boundary)

**This phase produces a vector, not concrete solutions.** You're answering "which way should we aim?" not "which path should we take?"

**Standalone context:**
- **Reasoning** produces a direction: "We need to go north"
- **Solutioning** proposes routes along that direction: "Highway, scenic route, or off-road"
- **Planning** decomposes a route into waypoints: "First merge onto I-95, then..."

**Align-stage context (after solutioning):**
- **Solutioning** has already proposed candidate routes
- **Reasoning** evaluates those candidates against truths and conditionals to confirm or narrow the direction
- **Planning** decomposes the chosen route into waypoints

**However, this is a soft boundary.** Sometimes you need specificity to validate a vector. Saying "if we go north, we'd hit the mountains—is that acceptable?" is using specificity to test the direction, not to propose a route. That's valid reasoning.

The distinction:
- **Specificity to test a direction** — Okay in Reasoning. "If we solve this at the API layer, we'd need to handle X and Y—does that fit our constraints?"
- **Specificity to propose a route** — Solutioning territory. "Let's solve this at the API layer using approach Z."

If both you and the person agree it's time to move on, that's fine — the phases aren't rigid gates. But be intentional about the shift. The goal of Reasoning is directional clarity; don't drift into route-proposal without recognizing you've changed modes.

## Structure of Reasoning

### 1. Problem Validation

Before reasoning deeply, validate the problem statement:
- Is this the real problem, or a symptom of something deeper?
- What are the actual impacts if this isn't solved?
- What are the impacts if it's solved poorly?
- Are there assumptions in the problem statement that should be questioned?

**In Align context:** When solution candidates exist (`solution-statement.md`), also validate whether the candidates actually address the real problem. Sometimes candidates reveal that the problem was misunderstood.

### 2. Truths (Guiding Principles)

Extract statements that hold no matter what solution we choose:

**Format:** Clear declarative statements about the problem domain.

Examples:
- "Any solution must maintain backward compatibility with the existing API"
- "User data integrity cannot be compromised during migration"
- "The system must remain available during the change"
- "This affects three downstream teams who consume this interface"

**How to find truths:**
- What constraints are non-negotiable?
- What properties must be preserved?
- What would make any solution invalid?
- What do we know for certain about the problem space?

**In Align context:** Evaluate each candidate against these truths. A candidate that violates a truth is eliminated.

### 3. Conditionals

Identify what becomes true based on choices we might make:

**Format:** If-then statements that show how choices create new realities.

Examples:
- "If we change the data model, then all consumers need migration paths"
- "If we prioritize speed, then we accept higher technical debt"
- "If we solve this at the API layer, then the database stays unchanged"
- "If we break backward compatibility, then we need a deprecation strategy"

**How to find conditionals:**
- What are the key decision points?
- What does each choice enable or foreclose?
- What tradeoffs emerge from different directions?
- What becomes easier or harder based on early choices?

**In Align context:** Map conditionals to specific candidates. "If we go with Candidate 1, then X becomes true" reveals how each approach shapes the solution space differently.

### 4. The Vector

From truths and conditionals, derive a directional statement:

**Format:** A clear statement of aim that constrains the solution space without prescribing specific solutions.

Examples:
- "We should aim for a solution that preserves the existing interface while enabling the new capability behind it"
- "The direction is toward simplification—reducing moving parts rather than adding abstraction"
- "We need to solve this at the data layer; API-level fixes would be treating symptoms"
- "The vector points toward gradual migration rather than big-bang replacement"

**A good vector:**
- Eliminates solution directions that violate truths
- Accounts for the most important conditionals
- Provides meaningful constraint on Solutioning
- Feels like shared conviction, not arbitrary choice

## Grounding in Reality

Reasoning should stay grounded. When helpful:
- **Invoke Recon** to investigate how the codebase actually works
- **Invoke Understanding** to confirm alignment if the problem shifts during reasoning
- Reference concrete code, patterns, or constraints discovered earlier

Abstract reasoning disconnected from the codebase tends to drift. Keep pulling back to what's actually true in the system.

## Artifact

Produces `truth-and-vector.md` in `.claude/work/<work-item>/`. See `ARTIFACT.md` for the full template. Generated when the reasoning pass is complete and a direction has been established.

## Closure Criteria

Reasoning is complete when:

- [ ] The problem has been validated (it's real, impacts are understood)
- [ ] You've surfaced key truths that constrain all solutions
- [ ] You've identified important conditionals and their implications
- [ ] There's a clear vector — a direction that feels right to both of you
- [ ] The vector meaningfully constrains the solution space
- [ ] You both have conviction about the direction, not just agreement

**In Align context (additional):**
- [ ] Solution candidates have been evaluated against truths and conditionals
- [ ] A clear next step has been determined: `Plan` (clear conviction), `tire-kicking` (genuine ambiguity), or `understanding` (problem needs revisiting)

## Closing the Phase

Summarize the reasoning and confirm the vector:

**"Here's where our reasoning landed:**

**Truths:**
- [List the key truths]

**Key conditionals:**
- [List the most important if-thens]

**Vector:** [State the directional aim]

**Does this capture our reasoning?"**

If the vector doesn't feel right, revisit the reasoning.

### Align-context detection

When invoked within the Align stage, reasoning detects context by checking for artifacts in the workstream directory:

1. **Check for `solution-statement.md`** — If it exists, reasoning is in Align context and emits a conditional closing nudge (below). If it does not exist, use the general closing prompt above with no conditional nudge.

2. **Check for `tire-kicking-report.md`** — If it exists, this is a second pass after tire-kicking. Always nudge toward `Plan` (never back to `tire-kicking`, which would create an infinite loop). The artifact's presence IS the second-pass signal.

### Conditional closing nudge (Align context only)

After confirming the vector, add one of these nudges based on the reasoning outcome:

**Clear conviction** (one candidate clearly superior):
Nudge toward `Plan`. Direction is clear; tire-kicking would add cost without value.

**Genuine ambiguity** (unresolvable tension between candidates):
Nudge toward `tire-kicking`. Stress-testing is needed to differentiate candidates on concrete scenarios.

**Problem needs more understanding** (problem space has shifted):
Nudge back to `understanding`. The problem needs revisiting before solution evaluation can proceed.

## Notes

- This phase is about developing conviction through reasoning, not just listing facts
- Truths should feel inevitable—things that anyone reasoning clearly would recognize
- Conditionals reveal the shape of the decision space
- The vector should feel like a natural conclusion from the truths and conditionals
- If you can't derive a clear vector, the problem may need more understanding first
- Good reasoning makes the next step dramatically clearer — whether that's solutioning (standalone) or plan/tire-kicking (Align context)
- It's okay to loop back to Understanding or Recon if reasoning reveals gaps
- Reasoning is a floating skill: the conditional Align-context behavior is gated on artifact detection (`solution-statement.md` presence) and does not affect standalone usage
