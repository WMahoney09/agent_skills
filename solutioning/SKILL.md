---
name: solutioning
description: Co-architect solutions by exploring multiple approaches and their tradeoffs. Use after building shared understanding of a problem to reason through viable solutions.
---

# Solutioning: Align Phase Skill

This skill guides you through exploring multiple solution approaches before committing to one.

## Goal

First, assess whether the problem statement is prescriptive enough that a single-candidate solution is appropriate. Indicators of a prescriptive problem:
- The problem statement specifies the approach or strongly constrains it
- There is only one viable technical direction given the constraints
- The constraints eliminate all but one class of solution

When the problem is prescriptive, produce a single-candidate solution statement and note why alternatives were not explored.

Otherwise, co-architect solutions by:
- Proposing 2-3 meaningfully different approaches
- Explaining the tradeoffs of each
- Reasoning through which approach fits best
- Building shared conviction about the direction

## Your Role

As the agent running this skill:
- Come to the table with multiple distinct approaches (not minor variations)
- Explain each approach clearly and fairly
- Call out the tradeoffs and limitations of each
- Help the person reason through which fits their constraints and priorities
- Listen to their intuition and concerns
- Build a shared recommendation

## Critical Boundary: Architectural Phase, Not Implementation

**This is an architectural alignment phase, not an implementation phase.** The goal is to choose a direction, not build it.

Concise examples of patterns, pseudocode, or small code snippets are permissible to illustrate the core idea of an approach. However, do not propose large-volume changes, detailed implementation plans, or begin developing the actual implementation. Those belong in the Plan and Implement stages.

Keep the focus on:
- What's the high-level approach?
- What are the tradeoffs?
- Why would this work for the constraints we've identified?

Avoid:
- Detailed line-by-line implementation
- Comprehensive change proposals
- Building out the solution before alignment

## Structure for Each Approach

For each solution you propose, cover:

**The Approach:**
- What's the core idea?
- How would it work at a high level?
- What does implementation look like?

**Strengths:**
- What does this approach do well?
- When is it the clear winner?

**Tradeoffs:**
- What's the complexity cost?
- What's harder or more fragile?
- What might break or need revisiting later?
- Performance, maintainability, flexibility implications?

**Constraints:**
- Does it hit any of the constraints from the Research stage?
- Are there technical or organizational blockers?

**LOE:** Produce a Level of Effort score using the `estimate` skill. This gives a concrete, comparable cost signal alongside the qualitative tradeoffs.

**Best for:**
- When would you choose this approach?
- What values or priorities would make this the right choice?

## Evaluation Criteria

Help the person evaluate by asking:

- Which approach aligns best with your constraints?
- Which one feels maintainable to you and your team?
- Where do you see the biggest risks?
- If we picked the "wrong" one, what would tell us that?
- Which approach would you feel most confident shipping?

## Artifact

Produces `solution-statement.md` in `docs/workstreams/<work-item>/`. See `ARTIFACT.md` for the full template. Generated when a solution is confirmed and the phase closes.

## Closure Criteria

**Multi-candidate path** — you're ready to close when:

- [ ] You've proposed at least 2-3 distinct approaches
- [ ] Each approach has been explained with clear tradeoffs
- [ ] The person has reacted to each — what appeals, what concerns them
- [ ] There's a clear sense of which direction feels right
- [ ] You understand *why* that direction appeals (constraints, values, risk tolerance)

**Short-circuit path** — you're ready to close when:

- [ ] You've identified that the problem is prescriptive (see Goal section)
- [ ] A single candidate has been produced with clear rationale
- [ ] You've explained why alternatives were not explored (not an oversight — the constraints make them irrelevant)
- [ ] The solution statement artifact has been written (single-candidate format) — the short circuit skips multi-candidate evaluation, not the artifact

## Closing the Phase

The closing prompt is conditional based on the outcome:

**If single candidate (short-circuit):**
Write the solution statement first (single-candidate format), then close with:
"The problem is prescriptive enough that [Approach X] is the only viable direction — [rationale for why alternatives add no value]. Ready to move directly to the Plan stage?"

Nudge: advance to `Plan`. There is nothing to reason between or stress-test.

**If multiple candidates with one clear winner:**
"It sounds like [Approach X] is the direction that resonates most because [their reasoning]. It handles [constraint], aligns with [priority], and we'd mitigate [concern] by [brief mitigation]. Let's move to reasoning to confirm this choice."

Nudge: proceed to `reasoning` for lightweight confirmation.

**If multiple candidates with genuine ambiguity:**
"There's genuine tension between [Approach X] and [Approach Y] — [brief description of the tension]. Let's move to reasoning to develop directional clarity."

Nudge: proceed to `reasoning` to determine whether tire-kicking is needed.

If they're torn between two approaches, explore what would tip the scales. Don't force consensus — help them make the decision.

## Notes

- The goal is NOT to pick the "objectively best" solution; it's to pick the one that fits *their* context and values
- 2-3 approaches is the sweet spot—more becomes analysis paralysis, fewer might miss a good option
- Spend time on tradeoffs; that's where the real insight happens
- Your job is to be a good thinking partner, not to sell them on your favorite approach
- Once they've picked, move to the Plan stage with confidence in the direction
