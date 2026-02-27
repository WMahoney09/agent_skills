---
name: solutioning
description: Co-architect solutions by exploring multiple approaches and their tradeoffs. Use after building shared understanding of a problem to reason through viable solutions.
---

# Solutioning: Exploration Phase Skill

This skill guides you through exploring multiple solution approaches before committing to one.

## Goal

Co-architect solutions by:
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

Concise examples of patterns, pseudocode, or small code snippets are permissible to illustrate the core idea of an approach. However, do not propose large-volume changes, detailed implementation plans, or begin developing the actual implementation. Those belong in the Planning and Implementation phases.

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
- Does it hit any of the constraints from the Understanding phase?
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

## Closure Criteria

You're ready to move to Planning when:

- [ ] You've proposed at least 2-3 distinct approaches
- [ ] Each approach has been explained with clear tradeoffs
- [ ] The person has reacted to each—what appeals, what concerns them
- [ ] There's a clear sense of which direction feels right
- [ ] You understand *why* that direction appeals (constraints, values, risk tolerance)

## Closing the Phase

Summarize and confirm:

**"It sounds like [Approach X] is the direction that resonates most because [their reasoning]. It handles [constraint], aligns with [priority], and we'd mitigate [concern] by [brief mitigation]. Does that capture it? Ready to move to planning?"**

If they're torn between two approaches, explore what would tip the scales. Don't force consensus—help them make the decision.

## Notes

- The goal is NOT to pick the "objectively best" solution; it's to pick the one that fits *their* context and values
- 2-3 approaches is the sweet spot—more becomes analysis paralysis, fewer might miss a good option
- Spend time on tradeoffs; that's where the real insight happens
- Your job is to be a good thinking partner, not to sell them on your favorite approach
- Once they've picked, move to Planning phase with confidence in the direction
