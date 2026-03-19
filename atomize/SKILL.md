---
name: atomize
description: |
  Right-size a plan by estimating each phase with /estimate and decomposing any phase with LOE > 2 into subphases, repeating until every phase scores ≤ 2.
  TRIGGER when: the user wants to break down a plan into smaller pieces ("atomize this", "break this down", "decompose the plan", "these phases are too big", "right-size this", "make these smaller"), or when a plan exists and phases need to be sized for execution.
---

# Atomize: Phase Decomposition

Atomize ensures every phase in a plan is small enough to be executed as a focused, bounded unit of work. It uses `/estimate` to score each phase and iteratively decomposes oversized phases until none exceeds LOE 2.

## Goal

Produce a plan where every phase has LOE ≤ 2 — small enough for safe autonomous dispatch.

## Your Role

- Provide the plan to be atomized (file path or paste the content)
- Review the decomposition log and confirm the updated plan before accepting it
- Flag any decomposition that doesn't match your intent

## Agent's Role

Work through the plan iteratively:

### Step 1: Estimate all phases

Apply `/estimate` to each phase and record the score. Surface all scores before decomposing anything — a complete picture first, then targeted action.

### Step 2: Decompose phases with LOE > 2

For any phase scoring > 2:

- Split into 2 or more subphases that together accomplish the same goal as the original
- Each subphase inherits the parent's context and dependencies where relevant
- Name subphases clearly — descriptive names or suffixed variants (e.g., "Phase 2a", "Phase 2b")
- Re-estimate each new subphase immediately — do not defer

### Step 3: Iterate until all phases are ≤ 2

Repeat the estimate → decompose cycle until every phase scores ≤ 2. A single pass is rarely sufficient for complex plans.

## Decomposition Principles

- **Split at natural seams.** Find the boundary where the work meaningfully changes — different files, different systems, different concerns. That's where to cut.
- **Preserve the original goal.** Subphases together must accomplish exactly what the parent phase intended. Do not silently drop scope during decomposition.
- **Favor independent subphases.** If subphases are independent, note the ordering flexibility explicitly. If they are dependent, document the dependency.
- **Stop at 2.** LOE 1 and LOE 2 are both acceptable outcomes. There is no value in decomposing below 2.
- **Decomposition is not redesign.** If a phase needs to be restructured rather than split, surface it as a finding rather than making the change silently.

## Output

Present results in three parts:

1. **LOE summary table** — all phases with their final scores
2. **Decomposition log** — for each phase that was split: original → subphases + one-line rationale for the split
3. **Updated plan** — the full plan with decomposed phases in place, ready to replace the original

If any phase cannot reach ≤ 2 without restructuring the plan's goals, flag it explicitly rather than forcing an artificial split.

## Artifact

Updates `<work-item>.plan.md` in-place (oversized phases replaced by subphases). Decomposition log is inline only. See `ARTIFACT.md` for the full format. Generated when all plan phases score ≤ 2.

## Closure Criteria

- [ ] Every phase has been estimated
- [ ] Every phase with LOE > 2 has been decomposed
- [ ] All resulting phases score ≤ 2
- [ ] Decomposition log presented
- [ ] Updated plan produced and confirmed by the user

## Notes

- Atomize is about **right-sizing phases for execution** — validating plan correctness is `/pre-flight`'s job
- Pre-flight may note LOE observations, but decomposition is entirely atomize's responsibility
- Runs after `/pre-flight` — pre-flight ensures the plan is coherent and correct; atomize ensures the validated phases are right-sized for execution
- Can be run standalone or invoked by a coordinating skill (e.g., `/leeroyyyyy`) as part of the plan refinement loop
- The ≤ 2 threshold is the practical ceiling for autonomous execution: keeps context focused and failure blast radius small
