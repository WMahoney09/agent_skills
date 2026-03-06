---
name: leeroyyyyy
description: "⚠️ EXPERIMENTAL — Full send autonomous pipeline. Precondition: Research complete + problem-statement.md exists. Runs the entire delivery workflow without user input: solutioning → reasoning (+ recon) → [tire-kicking if ambiguous] → planning → pre-flight loop (min 2, max 4 cycles) → atomize → produce (subagent per phase) → review → triage → revise. Align-stage routing is nudge-driven — each skill emits a Next Step recommendation that determines the next dispatch. The agent makes every decision autonomously."
agent-invocation: user-invoked-only
agent-reference: forbidden
agent-note: "This skill can ONLY be invoked directly by the user (e.g., /leeroyyyyy). It must NEVER be invoked by reference from another skill or agent. Once invoked, the agent runs the full pipeline autonomously — do not pause for user input unless an ambiguity truly cannot be resolved without it."
---

# Leeroyyyyy: Autonomous Full-Pipeline Orchestrator

⚠️ **EXPERIMENTAL. This skill embodies the full send spirit — it will run the entire delivery workflow from solutioning through implementation and self-review without stopping to ask for input. Only invoke this when the problem is well-understood and you are comfortable handing the wheel over entirely.**

⚠️ **This skill can only be invoked directly by the user. It cannot be invoked by reference from another skill. Once invoked, the agent runs the entire pipeline autonomously without requesting user input.**

This skill picks up where Research left off. The problem is known. The agent now drives everything — solutioning, decision-making, planning, validation, execution, and post-implementation review — to completion.

## Precondition

Research must be complete and `problem-statement.md` must exist in `docs/workstreams/<slug>/` before invoking `/leeroyyyyy`. Research requires user dialogue and cannot be automated — it is the one stage leeroyyyyy does not own. If the problem is not yet well-defined, invoke `/understanding` first and return here when ready.

## Pipeline

The Align stage uses nudge-driven routing: each skill emits a `## Next Step` block in its artifact that tells leeroyyyyy what to dispatch next. The rest of the pipeline (Plan through Deliver) is fixed.

```
Solutioning  <- produce candidates, emit Next Step
    |
    v (read Next Step from solution-statement.md)
    |
    +--[Plan]-------> Planning  (short-circuit: prescriptive problem)
    |
    +--[reasoning]--> Reasoning + Recon  <- synthesize candidates, emit Next Step
                        |
                        v (read Next Step from truth-and-vector.md)
                        |
                        +--[Plan]------------> Planning  (clear conviction)
                        |
                        +--[tire-kicking]----> Tire-Kicking  <- stress-test, emit Next Step
                        |
                        +--[understanding]---> HALT  (problem shifted; needs user-driven Research)
                                                |
                                                v (always)
                                                Reasoning (2nd pass) -> Planning

Planning
    |
Pre-Flight -> Reasoning -> update plan  (min 2, max 4 cycles)
    |
Atomize  <- ensure all plan phases <= LOE 2
    |
Produce  <- dispatch each plan phase to a subagent
    |
Review  <- local technical review of the produced changes
    |
Triage  <- group and prioritize review findings into revisions
    |
Revise  <- address all Critical and Major revisions autonomously
```

---

## Context Management and Subagent Dispatch

Context is a finite resource — treat it as such.

Every phase handoff is a context boundary: pass artifact files, not conversation history. **Commits are the handoff mechanism** — every artifact is committed before the next stage begins; subagents read committed files, never conversation history.

The full run produces a readable git log. The Align-stage artifacts vary depending on routing — tire-kicking-report.md only appears if reasoning flagged ambiguity, and a second truth-and-vector.md commit appears after tire-kicking:
```
[docs]  solution-statement.md       <- solutioning
[docs]  truth-and-vector.md         <- reasoning (first pass)
[docs]  tire-kicking-report.md      <- tire-kicking (only if reasoning flagged ambiguity)
[docs]  truth-and-vector.md         <- reasoning (second pass, only after tire-kicking)
[plan]  *.plan.md                   <- planning (initial)
[plan]  *.plan.md                   <- pre-flight adjustments (one per cycle)
[plan]  *.plan.md                   <- atomize resizing
[code]  <implementation>            <- produce (phase N)
[plan]  *.plan.md                   <- phase N marked complete
[code]  <implementation>            <- produce (phase N+1)
[plan]  *.plan.md                   <- phase N+1 marked complete
...
```

Each commit corresponds to one pipeline stage's output. `problem-statement.md` is a precondition, not produced during the run.

**All plan phases are always dispatched to subagents — no exceptions.** The LOE ≤ 2 guarantee is established by `/atomize`, which runs after pre-flight; leeroyyyyy trusts this guarantee and never re-estimates at runtime.

Progress is reported in chat at each phase transition so the user can observe pipeline state without being blocked.

### Artifact Handoff Map

**Precondition:** `problem-statement.md` must exist in `docs/workstreams/<slug>/` before leeroyyyyy is invoked. Research requires user dialogue and cannot be automated — it is the one stage leeroyyyyy does not own.

| Phase | Input artifacts | Output artifact | Subagent rule | Condition |
|---|---|---|---|---|
| Solutioning | problem-statement.md | solution-statement.md (with Next Step) | mandatory | always |
| Reasoning | solution-statement.md (+ problem-statement.md) | truth-and-vector.md (with Next Step) | mandatory | when solutioning nudges `reasoning` |
| Tire-kicking | problem-statement.md, solution-statement.md | tire-kicking-report.md (with Next Step) | mandatory | when reasoning nudges `tire-kicking` |
| Reasoning (2nd pass) | tire-kicking-report.md, solution-statement.md | truth-and-vector.md (with Next Step) | mandatory | always after tire-kicking |
| Planning | solution-statement.md, truth-and-vector.md | *.plan.md | mandatory | always |
| Pre-flight | *.plan.md, solution-statement.md | inline findings -> `[plan]` *.plan.md commit (via reasoning pass) | mandatory | always |
| Atomize | *.plan.md | *.plan.md (all phases <= LOE 2) | mandatory | always |
| Produce (per phase) | *.plan.md only | progress update in plan file | mandatory | always |
| Review | local diff | review-issues.md | mandatory | always |
| Triage | review-issues.md | triage-report.md | mandatory | always |
| Revise | triage-report.md, *.plan.md | commits | mandatory | always |

**Note on Reasoning:** The reasoning subagent executes its own recon pass — no committed recon artifact is produced or passed by leeroyyyyy. Recon findings are internal to the reasoning subagent's context. This is the one sanctioned exception to the commits-as-handoff principle, because recon is read-only investigation with no canonical output.

---

## Nudge-Reading Mechanism

After each Align-stage subagent commits its artifact, leeroyyyyy reads the artifact file to determine what to dispatch next:

1. Open the committed artifact (e.g., `solution-statement.md` or `truth-and-vector.md`)
2. Find the `## Next Step` section
3. Parse the `Recommendation:` line to extract the routing value
4. Dispatch based on the value: a **skill slug** (e.g., `reasoning`, `tire-kicking`) dispatches the named skill within the Align stage; a **stage name** (e.g., `Plan`) advances to the next RAPID stage

**Fallback:** If the `## Next Step` block is missing, malformed, or contains an unrecognized value, leeroyyyyy falls back to the default sequence: solutioning -> reasoning -> planning. The fallback intentionally skips tire-kicking to avoid processing loops — tire-kicking only runs when reasoning explicitly nudges toward it. This prevents a broken or incomplete artifact from halting the pipeline.

---

## Phase 1: Solutioning

**Dispatch:** subagent with `problem-statement.md`
**Invoke by reference:** `solutioning` skill

Explore candidate approaches to the problem. For each, surface tradeoffs, constraints, and an LOE estimate. The goal of this phase is to produce a set of candidates — do not pick a solution yet. For prescriptive problems where only one viable approach exists, a single candidate is valid.

**Commit:** `[docs]` commit of `solution-statement.md` before advancing.

**Nudge routing:** Read `## Next Step` from `solution-statement.md`:
- `Recommendation: Plan` -> skip to Phase 4 (Planning). This is the short-circuit path for prescriptive problems where a single candidate makes reasoning and tire-kicking unnecessary.
- `Recommendation: reasoning` -> proceed to Phase 2 (Reasoning). This is the standard path for multi-candidate solutions.

Report in chat: "Solutioning complete — N candidate(s) identified. Next Step: [routing decision]."

---

## Phase 2: Reasoning

**Dispatch:** subagent with `solution-statement.md`, `problem-statement.md`
**Invoke by reference:** `reasoning` skill, `recon` skill

Synthesize the solution candidates and the codebase's existing patterns to evaluate and choose a direction.

**Recon pass:** Before or alongside reasoning, use Recon to identify how similar problems are solved in the codebase — naming conventions, structural patterns, data flow patterns, and existing abstractions. Establishing this context is not optional: new patterns are acceptable when there is a clear reason for them, but consistency with existing solutions for similar problems is the default.

**Reasoning pass:** With solution candidates and codebase conventions in hand, reason through:
- Which candidates best fit the problem constraints?
- Which approach best aligns with existing codebase conventions?
- Is there clear conviction toward one candidate, or genuine ambiguity between them?
- If a new pattern is warranted, what is the clear justification?

**Output:** A directional choice with the evidence documented — candidate evaluation, convention alignment, and any justified departures from existing patterns. The agent proceeds without user confirmation unless the reasoning genuinely cannot resolve between approaches.

**Commit:** `[docs]` commit of `truth-and-vector.md` before advancing.

**Nudge routing:** Read `## Next Step` from `truth-and-vector.md`:
- `Recommendation: Plan` -> skip to Phase 4 (Planning). Reasoning reached clear conviction; tire-kicking would add cost without value.
- `Recommendation: tire-kicking` -> proceed to Phase 3 (Tire-Kicking). Genuine ambiguity between candidates requires stress-testing to differentiate.
- `Recommendation: understanding` -> **halt the pipeline**. Reasoning determined the problem space has shifted and needs revisiting. Since leeroyyyyy cannot run Research (it requires user dialogue), this is an abort condition. Write `summary-statement.md` noting the abort reason, alert the user that the problem needs revisiting via `/understanding`, and stop.

Report in chat: "Reasoning complete. Next Step: [routing decision]."

---

## Phase 3: Tire-Kicking (conditional)

**This phase only runs if reasoning's Next Step nudge recommends `tire-kicking`.** It does not run in every pipeline execution.

**Dispatch:** subagent with `problem-statement.md`, `solution-statement.md`
**Invoke by reference:** `tire-kicking` skill

Stress-test the ambiguous candidates against concrete scenarios: edge cases, lifecycle events, multi-actor interactions, and data changes. Classify each scenario for each candidate as **holds**, **bends**, or **leaks**. The goal is a comparative picture across candidates that reasoning could not resolve through analysis alone.

**Commit:** `[docs]` commit of `tire-kicking-report.md` before advancing.

**Second reasoning pass:** After tire-kicking commits, dispatch a second reasoning subagent with `tire-kicking-report.md` and `solution-statement.md`. This pass consumes the stress-test evidence and makes the final solution choice. The reasoning skill detects this is a second pass by the presence of `tire-kicking-report.md` in the workstream directory and always nudges toward `Plan` — it must not nudge back to `tire-kicking`, which would create an infinite loop.

**Commit:** `[docs]` commit of updated `truth-and-vector.md` before advancing to Phase 4.

Report in chat: "Tire-Kicking complete. Running second reasoning pass..." then "Reasoning complete — solution chosen. Advancing to Planning."

---

## Phase 4: Planning

**Dispatch:** subagent with `solution-statement.md`, `truth-and-vector.md`
**Invoke by reference:** `planning` skill

Transform the chosen solution into a detailed, phase-by-step implementation plan. The agent uses Recon to gather context rather than asking the user. Save the plan file to `docs/workstreams/<work-item>/<work-item>.plan.md`.

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

## Artifact

Produces `summary-statement.md` in `docs/workstreams/<work-item>/`. See `ARTIFACT.md` for the full template. Generated when the pipeline completes (clean or aborted).

## Completion

Leroy is complete when:

- [ ] All pipeline phases have run
- [ ] Produce has committed a clean, coherent implementation
- [ ] Review has been run locally against the produced changes
- [ ] Triage has grouped and prioritized review findings
- [ ] All Critical and Major revisions have been addressed and committed
- [ ] Any unresolvable revisions have been surfaced to the user
- [ ] `summary-statement.md` has been written per `leeroyyyyy/ARTIFACT.md`

Write `summary-statement.md` before reporting completion. Then report what was built, what the review found, what was revised, and anything that needs user attention before opening a PR.

---

## Autonomy Principle

Once `/leeroyyyyy` is invoked, the agent owns all decisions. The user↔agent back-and-forth that standalone skills expect is automated here — leeroyyyyy uses reasoning, recon, and subagents in place of user input.

**Research is the one stage leeroyyyyy does not own.** It requires user dialogue and must be completed before invocation. `problem-statement.md` is the handoff artifact. Everything from Align onward is fully autonomous.

What the agent decides without asking:
- Producing candidate solutions and routing based on solution nudges
- Conditionally stress-testing candidates when reasoning flags genuine ambiguity
- Picking the best solution using reasoning synthesis, evidence, and codebase conventions
- Making planning decisions based on Recon rather than asking for context
- Deciding which pre-flight issues to fix and how
- Reducing ambiguity through reasoning rather than asking the user
- Determining when the pre-flight loop has run enough to advance

**The only exception:** If a genuine ambiguity exists that Recon cannot resolve and that would lead to meaningfully different implementations depending on the answer — stop, ask the single specific question, get the answer, then continue autonomously.

Do not use this exception as a crutch. Most ambiguities can be resolved by examining the codebase, applying the constraints from Research, or making a reasonable documented assumption.

Progress is narrated in chat throughout the pipeline so the user is never in the dark about pipeline state, even though no input is requested.

## Sub-Skill Invocation Note

The skills invoked during this pipeline (`solutioning`, `reasoning`, `tire-kicking` (conditional), `recon`, `planning`, `pre-flight`, `produce`, `review`, `triage`, `revise`) are being invoked **by reference** under leroy's orchestration. This is a sanctioned exception to their `user-invoked-only` constraints — leroy, as a user-invoked orchestrator, grants them permission to run within this pipeline. Note: `tire-kicking` is only dispatched when reasoning's Next Step nudge recommends it — it does not run in every pipeline execution.

The `revise` skill's user-gated commit constraint is similarly superseded within leroy — the agent acts as the confirmation authority on behalf of the user who invoked leroy.
