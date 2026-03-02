---
name: leroy
description: Autonomous pipeline orchestrator. Invoked directly by the user after Understanding is complete. Runs solutioning → tire-kicking → reasoning + recon (pick solution) → planning → pre-flight + reasoning loop (minimum 2, maximum 4 cycles) → produce without user input. The agent makes all decisions autonomously.
agent-invocation: user-invoked-only
agent-reference: forbidden
agent-note: "This skill can ONLY be invoked directly by the user (e.g., /leroy). It must NEVER be invoked by reference from another skill or agent. Once invoked, the agent runs the full pipeline autonomously — do not pause for user input unless an ambiguity truly cannot be resolved without it."
---

# Yeet: Autonomous Full-Pipeline Orchestrator

⚠️ **This skill can only be invoked directly by the user. It cannot be invoked by reference from another skill. Once invoked, the agent runs the entire pipeline autonomously without requesting user input.**

This skill picks up where Understanding left off. The problem is known. The agent now drives everything — solutioning, decision-making, planning, validation, and execution — to completion.

## Precondition

The Understanding phase must be complete before invoking `/leroy`. If the problem is not yet well-defined, invoke `/understanding` first and return here when ready.

## Pipeline

```
Solutioning  ← produce 2–3 candidate solutions
    ↓
Tire-Kicking  ← stress-test all candidates
    ↓
Reasoning + Recon  ← synthesize findings, check conventions, pick a solution
    ↓
Planning
    ↓
Pre-Flight → Reasoning → update plan  (min 2, max 4 cycles)
    ↓
Produce
```

---

## Phase 1: Solutioning

**Invoke by reference:** `solutioning` skill

Explore 2–3 meaningfully distinct approaches to the problem. For each, surface tradeoffs, constraints, and an LOE estimate. The goal of this phase is to produce a set of candidates — do not pick a solution yet. All viable candidates carry forward into tire-kicking.

---

## Phase 2: Tire-Kicking

**Invoke by reference:** `tire-kicking` skill

Stress-test all candidates from Solutioning against concrete scenarios: edge cases, lifecycle events, multi-actor interactions, and data changes. Classify each scenario for each candidate as **holds**, **bends**, or **leaks**. The goal is a comparative picture across candidates, not a verdict on any single one.

Document all bends and leaks per approach. This record becomes the primary input to Phase 3.

---

## Phase 3: Reasoning — Pick a Solution

**Invoke by reference:** `reasoning` skill
**Invoke by reference:** `recon` skill

Synthesize the tire-kicking report and the codebase's existing patterns to make a decisive solution choice.

**Recon pass:** Before or alongside reasoning, use Recon to identify how similar problems are solved in the codebase — naming conventions, structural patterns, data flow patterns, and existing abstractions. Establishing this context is not optional: new patterns are acceptable when there is a clear reason for them, but consistency with existing solutions for similar problems is the default.

**Reasoning pass:** With tire-kicking results and codebase conventions in hand, reason through:
- Which candidates held up best across scenarios?
- Which leaks were closeable at low cost, and which indicate a structural weakness?
- Which approach best aligns with existing codebase conventions?
- If a new pattern is warranted, what is the clear justification?

**Output:** A chosen solution with the evidence documented — tire-kicking scores, convention alignment, and any justified departures from existing patterns. The agent proceeds without user confirmation unless the reasoning genuinely cannot resolve between approaches.

---

## Phase 4: Planning

**Invoke by reference:** `planning` skill

Transform the chosen solution into a detailed, phase-by-step implementation plan. The agent uses Recon to gather context rather than asking the user. Produce a written plan document saved to the project directory per the `artifactor` skill.

Do not ask the user to review the plan before advancing — the pre-flight loop is the review mechanism.

The plan must include: phases, steps, dependencies, critical files, gotchas, success criteria, and any explicit notes on convention alignment or justified departures from existing patterns.

---

## Phase 5: Pre-Flight + Reasoning Loop

**Minimum 2 cycles. Maximum 4 cycles.**

### Each cycle:

**Step A — Pre-Flight:** Invoke `pre-flight` skill by reference

Review the plan for gaps, contradictions, ambiguities, and optimization opportunities. Produce a findings report with severity levels (critical, major, minor) and a confidence assessment.

**Step B — Reasoning:** Invoke `reasoning` skill by reference

Take the pre-flight report as input. Use reasoning both to **address the issues raised** and to **reduce remaining ambiguity** in the plan — these are equally important goals. Make autonomous decisions about each finding:
- Structural issues → revise the relevant plan sections
- Ambiguities → reason to a decision and document the resolution in the plan
- Clarifications → document them in-place in the plan
- Non-issues → note why and discard

Update the plan file before the next cycle. Do not ask the user which issues to address or how to resolve ambiguities — reason to a conclusion and act.

### Loop exit criteria (agent decides):
- At least 2 full cycles have completed
- The most recent pre-flight returns no critical or major issues
- Reasoning confirms the plan is unambiguous and complete
- The agent is confident it can execute without mid-flight decisions

### If critical or major issues persist at 4 cycles:
**Stop. Alert the user.** Summarize the unresolved issues and explain why autonomous reasoning was insufficient to close them. The user must intervene before the pipeline can continue.

---

## Phase 6: Produce

**Invoke by reference:** `produce` skill

Execute the plan autonomously. The agent manages work order, parallelization strategy, and git history. Semantically coherent atomic commits are the deliverable.

---

## Autonomy Principle

Once `/leroy` is invoked, the agent owns all decisions. This means:
- Producing candidate solutions and tire-kicking all of them
- Picking the best solution using evidence and codebase conventions
- Making planning decisions based on Recon rather than asking for context
- Deciding which pre-flight issues to fix and how
- Reducing ambiguity through reasoning rather than asking the user
- Determining when the loop has run enough to advance

**The only exception:** If a genuine ambiguity exists that Recon cannot resolve and that would lead to meaningfully different implementations depending on the answer — stop, ask the single specific question, get the answer, then continue autonomously.

Do not use this exception as a crutch. Most ambiguities can be resolved by examining the codebase, applying the constraints from Understanding, or making a reasonable documented assumption.

## Sub-Skill Invocation Note

The skills invoked during this pipeline (`solutioning`, `tire-kicking`, `reasoning`, `recon`, `planning`, `pre-flight`, `produce`) are being invoked **by reference** under leroy's orchestration. This is a sanctioned exception to their `user-invoked-only` constraints — leroy, as a user-invoked orchestrator, grants them permission to run within this pipeline.
