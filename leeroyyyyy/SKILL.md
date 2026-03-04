---
name: leeroyyyyy
description: "⚠️ EXPERIMENTAL — Full send autonomous pipeline. Invoked directly by the user after Understanding is complete. Runs the entire delivery workflow without user input: solutioning → tire-kicking → reasoning + recon → planning → pre-flight loop (min 2, max 4 cycles) → produce → review → triage → revise. The agent makes every decision autonomously."
agent-invocation: user-invoked-only
agent-reference: forbidden
agent-note: "This skill can ONLY be invoked directly by the user (e.g., /leeroyyyyy). It must NEVER be invoked by reference from another skill or agent. Once invoked, the agent runs the full pipeline autonomously — do not pause for user input unless an ambiguity truly cannot be resolved without it."
---

# Leeroyyyyy: Autonomous Full-Pipeline Orchestrator

⚠️ **EXPERIMENTAL. This skill embodies the full send spirit — it will run the entire delivery workflow from solutioning through implementation and self-review without stopping to ask for input. Only invoke this when the problem is well-understood and you are comfortable handing the wheel over entirely.**

⚠️ **This skill can only be invoked directly by the user. It cannot be invoked by reference from another skill. Once invoked, the agent runs the entire pipeline autonomously without requesting user input.**

This skill picks up where Understanding left off. The problem is known. The agent now drives everything — solutioning, decision-making, planning, validation, execution, and post-implementation review — to completion.

## Precondition

Understanding must be complete and `problem-statement.md` must exist in `.claude/work/<slug>/` before invoking `/leeroyyyyy`. Understanding requires user dialogue and cannot be automated — it is the one stage leeroyyyyy does not own. If the problem is not yet well-defined, invoke `/understanding` first and return here when ready.

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
Atomize  ← ensure all plan phases ≤ LOE 2
    ↓
Produce  ← dispatch each plan phase to a subagent
    ↓
Review  ← local technical review of the produced changes
    ↓
Triage  ← group and prioritize review findings into revisions
    ↓
Revise  ← address all Critical and Major revisions autonomously
```

---

## Context Management and Subagent Dispatch

Context is a finite resource — treat it as such.

Every phase handoff is a context boundary: pass artifact files, not conversation history. **Commits are the handoff mechanism** — every artifact is committed before the next stage begins; subagents read committed files, never conversation history.

The full run produces a readable git log:
```
[docs]  solution-statement.md       ← solutioning
[docs]  tire-kicking-report.md      ← tire-kicking
[docs]  truth-and-vector.md         ← reasoning
[plan]  *.plan.md                   ← planning (initial)
[plan]  *.plan.md                   ← pre-flight adjustments (one per cycle)
[plan]  *.plan.md                   ← atomize resizing
[code]  <implementation>            ← produce (phase N)
[plan]  *.plan.md                   ← phase N marked complete
[code]  <implementation>            ← produce (phase N+1)
[plan]  *.plan.md                   ← phase N+1 marked complete
...
```

Each commit corresponds to one pipeline stage's output. `problem-statement.md` is a precondition, not produced during the run.

**All plan phases are always dispatched to subagents — no exceptions.** The LOE ≤ 2 guarantee is established by `/atomize`, which runs after pre-flight; leeroyyyyy trusts this guarantee and never re-estimates at runtime.

Progress is reported in chat at each phase transition so the user can observe pipeline state without being blocked.

### Artifact Handoff Map

**Precondition:** `problem-statement.md` must exist in `.claude/work/<slug>/` before leeroyyyyy is invoked. Understanding requires user dialogue and cannot be automated — it is the one stage leeroyyyyy does not own.

| Phase | Input artifacts | Output artifact | Subagent rule |
|---|---|---|---|
| Solutioning | problem-statement.md | solution-statement.md | mandatory |
| Tire-kicking | problem-statement.md, solution-statement.md (all candidates) | tire-kicking-report.md | mandatory |
| Reasoning | tire-kicking-report.md | truth-and-vector.md | mandatory |
| Planning | solution-statement.md, truth-and-vector.md | *.plan.md | mandatory |
| Pre-flight | *.plan.md, solution-statement.md | inline findings → `[plan]` *.plan.md commit (via reasoning pass) | mandatory |
| Atomize | *.plan.md | *.plan.md (all phases ≤ LOE 2) | mandatory |
| Produce (per phase) | *.plan.md only | progress update in plan file | mandatory |
| Review | local diff | review-issues.md | mandatory |
| Triage | review-issues.md | triage-report.md | mandatory |
| Revise | triage-report.md, *.plan.md | commits | mandatory |

**Note on Reasoning:** The reasoning subagent executes its own recon pass — no committed recon artifact is produced or passed by leeroyyyyy. Recon findings are internal to the reasoning subagent's context. This is the one sanctioned exception to the commits-as-handoff principle, because recon is read-only investigation with no canonical output.

---

## Phase 1: Solutioning

**Dispatch:** subagent with `problem-statement.md`
**Invoke by reference:** `solutioning` skill

Explore 2–3 meaningfully distinct approaches to the problem. For each, surface tradeoffs, constraints, and an LOE estimate. The goal of this phase is to produce a set of candidates — do not pick a solution yet. All viable candidates carry forward into tire-kicking.

**Commit:** `[docs]` commit of `solution-statement.md` before advancing.

Report in chat: "Solutioning complete — N candidates identified. Advancing to Tire-Kicking."

---

## Phase 2: Tire-Kicking

**Dispatch:** subagent with `problem-statement.md`, `solution-statement.md`
**Invoke by reference:** `tire-kicking` skill

Stress-test all candidates from Solutioning against concrete scenarios: edge cases, lifecycle events, multi-actor interactions, and data changes. Classify each scenario for each candidate as **holds**, **bends**, or **leaks**. The goal is a comparative picture across candidates, not a verdict on any single one.

Document all bends and leaks per approach. This record becomes the primary input to Phase 3.

**Commit:** `[docs]` commit of `tire-kicking-report.md` before advancing.

Report in chat: "Tire-Kicking complete. Advancing to Reasoning."

---

## Phase 3: Reasoning — Pick a Solution

**Dispatch:** subagent with `tire-kicking-report.md`
**Invoke by reference:** `reasoning` skill, `recon` skill

Synthesize the tire-kicking report and the codebase's existing patterns to make a decisive solution choice.

**Recon pass:** Before or alongside reasoning, use Recon to identify how similar problems are solved in the codebase — naming conventions, structural patterns, data flow patterns, and existing abstractions. Establishing this context is not optional: new patterns are acceptable when there is a clear reason for them, but consistency with existing solutions for similar problems is the default.

**Reasoning pass:** With tire-kicking results and codebase conventions in hand, reason through:
- Which candidates held up best across scenarios?
- Which leaks were closeable at low cost, and which indicate a structural weakness?
- Which approach best aligns with existing codebase conventions?
- If a new pattern is warranted, what is the clear justification?

**Output:** A chosen solution with the evidence documented — tire-kicking scores, convention alignment, and any justified departures from existing patterns. The agent proceeds without user confirmation unless the reasoning genuinely cannot resolve between approaches.

**Commit:** `[docs]` commit of `truth-and-vector.md` before advancing.

Report in chat: "Reasoning complete — solution chosen. Advancing to Planning."

---

## Phase 4: Planning

**Dispatch:** subagent with `solution-statement.md`, `truth-and-vector.md`
**Invoke by reference:** `planning` skill

Transform the chosen solution into a detailed, phase-by-step implementation plan. The agent uses Recon to gather context rather than asking the user. Save the plan file to `.claude/work/<work-item>/<work-item>.plan.md`.

Do not ask the user to review the plan before advancing — the pre-flight loop is the review mechanism.

The plan must include: phases, steps, dependencies, critical files, gotchas, success criteria, and any explicit notes on convention alignment or justified departures from existing patterns.

**Commit:** `[plan]` commit of `*.plan.md` before advancing.

Report in chat: "Plan drafted. Advancing to Pre-Flight validation."

---

## Phase 5: Pre-Flight + Reasoning Loop

**Minimum 2 pre-flights. Maximum 4 pre-flights.**

### Each cycle:

**Step A — Pre-Flight:** Dispatch subagent with `*.plan.md`, `solution-statement.md`

Invoke `pre-flight` skill by reference. Review the plan for gaps, contradictions, ambiguities, and optimization opportunities. Produce findings inline with severity levels (critical, major, minor) and a confidence assessment.

**Step B — Reasoning:** Dispatch subagent with pre-flight findings and `*.plan.md`

Invoke `reasoning` skill by reference. Take the pre-flight findings as input. Use reasoning both to **address the issues raised** and to **reduce remaining ambiguity** in the plan — these are equally important goals. Make autonomous decisions about each finding:
- Structural issues → revise the relevant plan sections
- Ambiguities → reason to a decision and document the resolution in the plan
- Clarifications → document them in-place in the plan
- Non-issues → note why and discard

**Commit:** `[plan]` commit of plan adjustments after each reasoning pass.

Report in chat at each step: "Running pre-flight cycle N/4...", "Pre-flight cycle N complete — running reasoning pass...", etc.

### Loop flow:

1. Run Pre-flight (cycle 1)
2. Run Reasoning (always, even if pre-flight is clean) → update plan → commit
3. Run Pre-flight (cycle 2)
4. If no Critical/Major issues: proceed to Atomize
5. If Critical/Major issues remain: run Reasoning → commit → Pre-flight (cycle 3)
6. Repeat until clean or cycle 4 reached
7. If the 4th pre-flight still has Critical/Major issues: **abort** — surface unresolved issues to the user, write `summary-statement.md` noting the abort reason, and stop

Report in chat: "Pre-flight clear — advancing to Atomize." or "Pre-flight cycle N has Critical issues — running reasoning pass..."

---

## Phase 6: Atomize

**Dispatch:** subagent with `*.plan.md`
**Invoke by reference:** `atomize` skill

Ensure all plan phases score ≤ LOE 2. Atomize runs once on the stable plan after the pre-flight loop completes.

**Commit:** `[plan]` commit of resized plan before advancing.

Report in chat: "Atomize complete — all plan phases ≤ LOE 2. Advancing to Produce."

---

## Phase 7: Produce

**Dispatch:** subagent per plan phase with `*.plan.md`
**Invoke by reference:** `produce` skill

Execute the plan autonomously, dispatching each plan phase to a subagent. Each subagent receives only the plan file path. The agent manages work order and git history. Semantically coherent atomic commits are the deliverable.

After each plan phase completes:
- `[code]` commit(s) for the implementation
- `[plan]` commit marking the phase complete in the plan file's Progress section

Report in chat at each phase boundary: "Phase N complete. Advancing to Phase N+1."

---

## Phase 8: Review

**Dispatch:** subagent with local diff
**Invoke by reference:** `review` skill

Run a local technical review of the changes produced in Phase 7. This is a review against the local branch diff — not against a PR. The agent conducts the full review across all in-scope dimensions: security, architecture, correctness, tests, and accessibility.

The review output feeds directly into Phase 9. The agent does not stop here or present the report to the user — it proceeds autonomously.

**Commit:** `[docs]` commit of `review-issues.md` before advancing.

---

## Phase 9: Triage

**Dispatch:** subagent with `review-issues.md`
**Invoke by reference:** `triage` skill

Ingest the review output from Phase 8. Group related findings into unified revisions and prioritize by severity (Critical, Major, Minor). The triage output is the revision list for Phase 10.

The agent proceeds autonomously — no user confirmation of the triage groupings is required.

**Commit:** `[docs]` commit of `triage-report.md` before advancing.

---

## Phase 10: Revise

**Dispatch:** subagent with `triage-report.md`, `*.plan.md`
**Invoke by reference:** `revise` skill (with autonomous commit authority)

Address all **Critical** and **Major** revisions from the triage output. For each revision:

1. The agent internally aligns on the issue (no user confirmation required)
2. Implements the fix holistically across all affected files
3. Assesses its own work against the revision description
4. Commits when satisfied — the user-gated commit step from the standard `/revise` skill is replaced by the agent's own assessment, since leroy has been granted full autonomy by the user

**Minor revisions:** The agent uses its judgment. Address minor revisions that are low-effort and clearly correct. Skip minor revisions where the fix would require a design decision that warrants user input — document those in the final summary instead.

Commit messages follow the standard revise format: type prefix, revision ID in the `Revision:` trailer.

### If a revision cannot be resolved autonomously:

If a Critical or Major revision requires a design decision that the agent genuinely cannot make without user input, stop, alert the user, and summarize the unresolved revision clearly. Do not paper over it with a partial fix.

---

## Completion

Leroy is complete when:

- [ ] All pipeline phases have run
- [ ] Produce has committed a clean, coherent implementation
- [ ] Review has been run locally against the produced changes
- [ ] Triage has grouped and prioritized review findings
- [ ] All Critical and Major revisions have been addressed and committed
- [ ] Any unresolvable revisions have been surfaced to the user

**Final summary:** Report what was built, what the review found, what was revised, and anything that needs user attention before opening a PR.

---

## Autonomy Principle

Once `/leeroyyyyy` is invoked, the agent owns all decisions. This means:
- Producing candidate solutions and tire-kicking all of them
- Picking the best solution using evidence and codebase conventions
- Making planning decisions based on Recon rather than asking for context
- Deciding which pre-flight issues to fix and how
- Reducing ambiguity through reasoning rather than asking the user
- Determining when the loop has run enough to advance

**The only exception:** If a genuine ambiguity exists that Recon cannot resolve and that would lead to meaningfully different implementations depending on the answer — stop, ask the single specific question, get the answer, then continue autonomously.

Do not use this exception as a crutch. Most ambiguities can be resolved by examining the codebase, applying the constraints from Understanding, or making a reasonable documented assumption.

## Sub-Skill Invocation Note

The skills invoked during this pipeline (`solutioning`, `tire-kicking`, `reasoning`, `recon`, `planning`, `pre-flight`, `produce`, `review`, `triage`, `revise`) are being invoked **by reference** under leroy's orchestration. This is a sanctioned exception to their `user-invoked-only` constraints — leroy, as a user-invoked orchestrator, grants them permission to run within this pipeline.

The `revise` skill's user-gated commit constraint is similarly superseded within leroy — the agent acts as the confirmation authority on behalf of the user who invoked leroy.
