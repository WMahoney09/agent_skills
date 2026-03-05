# Closing-Nudge Protocol: Conditional Workflow Phases

## Overview

Transform the RAPID pipeline from a fixed skill sequence to a nudge-driven flow where each skill emits a structured `## Next Step` closing block that recommends what should happen next. Leeroyyyyy reads these nudges and routes accordingly, remaining a thin dispatcher. The Align stage is reordered to solutioning -> reasoning -> tire-kicking (only if needed). Solutioning gains a short-circuit path for prescriptive problems.

**Numbering note:** Plan phases (1-6) refer to implementation steps in this plan. Leeroyyyyy phases (1-10) refer to pipeline stages in the orchestrator skill. Where disambiguation is needed, use "Plan Phase N" vs "Leeroyyyyy Phase N."

## Notes

- RAPID stages (R-A-P-I-D) remain mandatory and always produce their artifacts. Only skill sequence within a stage changes.
- The `## Next Step` block is a new convention that all artifact-producing Align-stage skills must adopt. Plan-stage and later skills are unaffected in this iteration.
- The reasoning skill's ARTIFACT.md currently says "this artifact is produced by the reasoning subagent after consuming the tire-kicking report" -- this note must be updated since reasoning now comes before tire-kicking.
- The understanding skill does NOT need a Next Step block -- it always hands off to the Align stage. Its nudge is implicit in the RAPID stage boundary.
- Pre-flight's "always at least one" rule is unchanged -- it is not affected by nudge routing.
- The `## Closing the Phase` section in SKILL.md is the human-facing closing prompt. The `## Next Step` block in the artifact is the machine-readable routing signal. Both must be updated for affected skills.
- Out of scope: changing Research, Plan, Implement, or Deliver stage skills. Only Align-stage skills and the orchestrator (leeroyyyyy) change.

## LOE Estimates

| Phase | LOE | Complexity | Impact | Notes |
|---|---|---|---|---|
| Phase 1 | 1 | Low | Low | 2 spec files, additive sections |
| Phase 2 | 2 | Medium | Low | 2 files, template restructure is prescriptive |
| Phase 3 | 2 | Medium | Low | 2 files, many sections but plan is very detailed |
| Phase 4 | 1 | Low | Low | 2 files, straightforward additions |
| Phase 5a | 2 | Low | Medium | 1 file, 5 structural/metadata tasks |
| Phase 5b | 2 | Medium | Low | 1 file, 4 substantive phase rewrites |
| Phase 5c | 1 | Low | Low | 1 file, minor artifact update |
| Phase 6 | 1 | Low | Low | 1 file, mechanical edits |

Phase 5 (original LOE 3) decomposed into 5a/5b/5c. All other phases were already at LOE 2 or below.

## Progress
- [x] Phase 1: Define the Next Step convention
- [x] Phase 2: Update solutioning skill and artifact
- [x] Phase 3: Update reasoning skill and artifact
- [x] Phase 4: Update tire-kicking skill and artifact
- [x] Phase 5a: Update leeroyyyyy orchestrator — pipeline structure and metadata
- [x] Phase 5b: Update leeroyyyyy orchestrator — phase descriptions and nudge mechanism
- [x] Phase 5c: Update leeroyyyyy ARTIFACT.md
- [x] Phase 6: Update README and documentation

---

## Phase 1: Define the Next Step convention

Establish the `## Next Step` block as a documented convention in the artifact spec, so all future artifact-producing skills can adopt it consistently.

### Step 1.1: Add Next Step convention to ARTIFACT.spec.md

#### Task 1.1.1: Read and update ARTIFACT.spec.md

Add a new section documenting the optional `## Next Step` block that artifact templates may include. The block has three fields:

```
## Next Step
Recommendation: <next-skill-slug or stage-name>
Confidence: high | medium | low
Rationale: <one sentence explaining why>
```

Document that:
- This block is OPTIONAL -- only skills participating in conditional routing include it
- It always appears as the LAST section in the artifact template (after all other content)
- `Recommendation` values use this convention: **skill slugs** (lowercase, e.g., `reasoning`, `tire-kicking`) for within-stage routing, and **stage names** (capitalized, e.g., `Plan`) when the intent is to advance to the next RAPID stage. This distinction makes it unambiguous whether the recommendation is dispatching another skill within the current stage or signaling stage advancement.
- `Confidence` indicates how strongly the skill believes this is the right next step
- When confidence is `low`, the orchestrator (or user) should consider alternatives
- The block is both human-readable (for manual workflows) and machine-parseable (for leeroyyyyy)

**Critical file:** `/Users/will/agentic/skills/ARTIFACT.spec.md`

**Success criteria:** ARTIFACT.spec.md documents the Next Step convention clearly enough that a skill author could adopt it without additional context.

**Gotcha:** The spec must frame this as optional so that skills outside the Align stage (which don't need routing) aren't burdened with it.

#### Task 1.1.2: Add conditional closing pattern note to SKILL.spec.md

Add a brief note to the `## Closing the Phase` entry in the "Optional sections" table of SKILL.spec.md: conditional closing prompts are a valid pattern — a skill's `## Closing the Phase` section may contain branching logic that emits different closing prompts based on the skill's output (e.g., different nudges depending on whether the result is clear or ambiguous). This is not a violation of the spec; it is an expected pattern for skills participating in nudge-driven routing.

**Critical file:** `/Users/will/agentic/skills/SKILL.spec.md`

---

## Phase 2: Update solutioning skill and artifact

Solutioning gains two capabilities: (1) a short-circuit path for prescriptive problems, and (2) a conditional closing nudge with a `## Next Step` block.

### Step 2.1: Update solutioning SKILL.md

#### Task 2.1.1: Add short-circuit assessment to the Goal section

Add guidance that solutioning should first assess whether the problem statement is prescriptive enough that a single-candidate solution is appropriate. Indicators of a prescriptive problem:
- The problem statement specifies the approach or strongly constrains it
- There is only one viable technical direction given the constraints
- The constraints eliminate all but one class of solution

When the problem is prescriptive, solutioning produces a single-candidate solution statement and notes why alternatives were not explored.

#### Task 2.1.2: Update "Closure Criteria" to be conditional

The current closure criteria require "at least 2-3 distinct approaches." Make this conditional:
- Multi-candidate path: existing criteria unchanged (2-3 approaches, tradeoffs, etc.)
- Short-circuit path: single candidate with explicit rationale for why alternatives add no value

#### Task 2.1.3: Update "Closing the Phase" to emit conditional nudge

Replace the fixed closing prompt with conditional logic:

**If single candidate (short-circuit):**
Nudge toward `Plan` (stage advancement) directly, skipping reasoning and tire-kicking. The rationale: there is nothing to reason between or stress-test.

**If multiple candidates with one clear winner:**
Nudge toward `reasoning` to synthesize and confirm the choice. Rationale: reasoning is lightweight confirmation.

**If multiple candidates with genuine ambiguity:**
Nudge toward `reasoning` to develop directional clarity. Rationale: reasoning will determine whether tire-kicking is needed.

**Critical file:** `/Users/will/agentic/skills/solutioning/SKILL.md`

**Gotcha:** The "Critical Boundary" section (architectural phase, not implementation) must remain intact -- the short-circuit path is about reducing candidates, not about jumping to implementation details.

### Step 2.2: Update solutioning ARTIFACT.md

#### Task 2.2.1: Restructure the solution-statement template from decision record to candidates list

The current template is structured as a post-decision record with sections like "Chosen Approach," "Why This Approach," "Tradeoffs Accepted," and "Approaches Considered and Rejected." This structure is wrong for the new flow because solutioning now produces candidates, and reasoning picks the winner later.

Restructure the template as follows:

**Replace** the current template sections:
```
## Chosen Approach
## Why This Approach
## Tradeoffs Accepted
## Approaches Considered and Rejected
## LOE Score
```

**With** a candidates-oriented structure:
```
## Candidates

### Candidate 1: <name>
<!-- Description, tradeoffs, constraints, LOE estimate -->

### Candidate 2: <name>
<!-- Description, tradeoffs, constraints, LOE estimate -->

<!-- Additional candidates as needed. A single candidate is valid for prescriptive problems. -->

## Next Step
Recommendation: <reasoning | Plan>
Confidence: <high | medium | low>
Rationale: <one sentence>
```

The "Chosen Approach" / "Why This Approach" / "Tradeoffs Accepted" sections are removed entirely — the reasoning skill's `truth-and-vector.md` handles the decision and its justification. The "Approaches Considered and Rejected" section is unnecessary since all candidates carry forward for reasoning to evaluate.

#### Task 2.2.2: Update the Notes section

Update the existing note ("The solution statement captures the decision, not the exploration") to reflect the new purpose: the solution statement captures the candidates, not the decision. Add a note that the `## Candidates` section may contain a single candidate when the short-circuit path is taken, and that this is intentional (not an error or incomplete artifact).

**Critical file:** `/Users/will/agentic/skills/solutioning/ARTIFACT.md`

**Success criteria:** The solutioning artifact template is structured around candidates (not a pre-made decision), includes a Next Step block, and a subagent producing this artifact would know what values to emit based on the SKILL.md guidance.

---

## Phase 3: Update reasoning skill and artifact

Reasoning moves from "after tire-kicking" to "after solutioning" in the Align stage. It gains a conditional closing nudge that determines whether tire-kicking is needed.

### Step 3.1: Update reasoning SKILL.md

#### Task 3.1.1: Reframe the skill's position in the Align stage

The current framing positions reasoning as producing a vector before solutioning ("Solutioning will propose concrete routes along this vector"). This needs to be updated to reflect reasoning's new position: after solutioning, reasoning consumes the solution candidates and either confirms a direction or flags ambiguity.

Update these sections:
- The intro paragraph and Goal section to reflect that reasoning now consumes solution candidates
- The "Critical Boundary" section -- reasoning still produces a vector/direction, but now it does so by evaluating the candidates from solutioning rather than starting from scratch
- The "Structure of Reasoning" section -- Problem Validation is now informed by the solution candidates; Truths and Conditionals are evaluated in the context of the proposed approaches
- The "Closure Criteria" section -- "ready to move to Solutioning" becomes conditional: ready to move to `Plan` (if clear), or ready to invoke `tire-kicking` (if ambiguous)

**Align-context detection:** Reasoning is a floating skill. To determine whether it is operating within the Align stage, reasoning checks whether `solution-statement.md` exists in the workstream directory. If it does, reasoning is in Align context and emits conditional nudges (toward `Plan`, `tire-kicking`, or `understanding`). If `solution-statement.md` does not exist, reasoning uses its general closing prompt with no conditional nudge.

**Second-pass detection (tire-kicking loop):** When reasoning receives a `tire-kicking-report.md` as input (i.e., the tire-kicking report artifact exists in the workstream directory), this is the signal that reasoning is on its second pass after tire-kicking. In this case, reasoning always nudges toward `Plan` — it must not nudge back to `tire-kicking`, which would create an infinite loop. The presence of the tire-kicking artifact IS the second-pass signal; no other mechanism is needed.

#### Task 3.1.2: Add conditional closing nudge to "Closing the Phase"

Replace the fixed closing prompt ("Does this capture our reasoning? Is this the direction we want to aim toward in Solutioning?") with conditional logic:

**If reasoning reaches clear conviction (one candidate clearly superior):**
Nudge toward `Plan` (stage advancement). Rationale: direction is clear, tire-kicking would add cost without value.

**If reasoning identifies genuine ambiguity or unresolvable tension between candidates:**
Nudge toward `tire-kicking`. Rationale: stress-testing needed to differentiate candidates on concrete scenarios.

**If reasoning discovers the problem needs more understanding:**
Nudge back to `understanding`. Rationale: the problem space has shifted.

**Critical file:** `/Users/will/agentic/skills/reasoning/SKILL.md`

**Gotcha:** Reasoning is a floating skill (usable at any stage). The conditional closing nudge only applies when reasoning is invoked within the Align stage context. When invoked standalone or in other stages, the closing prompt should remain general. Add a note clarifying this: "When invoked within the Align stage (after solutioning), the closing nudge is conditional..."

### Step 3.2: Update reasoning ARTIFACT.md

#### Task 3.2.1: Add `## Next Step` block to the truth-and-vector template

Append the `## Next Step` block as the last section.

Example values:
- Clear conviction: `Recommendation: Plan | Confidence: high | Rationale: Reasoning resolves cleanly; one candidate is clearly superior.`
- Ambiguity: `Recommendation: tire-kicking | Confidence: medium | Rationale: Genuine ambiguity between candidates; stress-testing needed.`
- Needs more understanding: `Recommendation: understanding | Confidence: high | Rationale: Problem space has shifted; revisit Research.`

#### Task 3.2.2: Remove the outdated note about tire-kicking report consumption

The current Notes section says "this artifact is produced by the reasoning subagent after consuming the tire-kicking report." This is no longer the default flow. Update to reflect that reasoning consumes the solution-statement (candidates) as its primary input, and optionally consumes the tire-kicking report if tire-kicking ran before it.

**Critical file:** `/Users/will/agentic/skills/reasoning/ARTIFACT.md`

**Success criteria:** Reasoning's SKILL.md and ARTIFACT.md reflect its new position after solutioning, with conditional nudges toward `Plan` or `tire-kicking`.

---

## Phase 4: Update tire-kicking skill and artifact

Tire-kicking becomes conditional -- only invoked when reasoning flags genuine ambiguity. Its artifact gains a `## Next Step` block.

### Step 4.1: Update tire-kicking SKILL.md

#### Task 4.1.1: Add context about conditional invocation

Add a note near the top (after the intro paragraph) explaining that tire-kicking is invoked conditionally within the Align stage. It runs when reasoning flags genuine ambiguity between solution candidates that cannot be resolved through reasoning alone. When the pipeline reaches tire-kicking, it means the candidates are close enough that concrete scenario stress-testing is needed to differentiate them.

#### Task 4.1.2: Add closing nudge via "Closing the Phase" section

The current Closure section has no closing prompt -- just a checklist. Add a `## Closing the Phase` section BEFORE `## Artifact`, consistent with SKILL.spec.md ordering (the correct section order is: [skill-specific content] -> Closing the Phase -> Artifact -> Closure Criteria -> Notes). Include a conditional nudge:

**After tire-kicking completes:**
Always nudge toward `reasoning`. Rationale: reasoning consumes the tire-kicking report to make the final solution choice. This is the standard flow -- tire-kicking produces evidence, reasoning synthesizes it.

Note: This nudge is effectively fixed (always reasoning), but it is still expressed as a Next Step block for consistency with the convention. The conditionality is in whether tire-kicking runs at all, not in what it recommends after running.

#### Task 4.1.3: Reorder Closure section to follow SKILL.spec.md

Currently tire-kicking has `## Closure` instead of `## Closure Criteria`. Rename to `## Closure Criteria` for consistency with SKILL.spec.md. Ensure the section ordering is: `## Artifact` -> `## Closure Criteria` -> `## Notes`.

**Critical file:** `/Users/will/agentic/skills/tire-kicking/SKILL.md`

### Step 4.2: Update tire-kicking ARTIFACT.md

#### Task 4.2.1: Add `## Next Step` block to the tire-kicking-report template

Append the `## Next Step` block as the last section. Since tire-kicking always feeds back into reasoning, the recommendation is effectively fixed:

`Recommendation: reasoning | Confidence: high | Rationale: Tire-kicking evidence ready for reasoning synthesis and final solution choice.`

#### Task 4.2.2: Update the Notes section

The current note says "the reasoning skill consumes this to make the final solution choice" -- this is still correct but should be updated to reflect the new flow: reasoning invoked tire-kicking because of ambiguity, and now reasoning will consume the report to resolve that ambiguity.

**Critical file:** `/Users/will/agentic/skills/tire-kicking/ARTIFACT.md`

**Success criteria:** Tire-kicking is clearly documented as conditionally invoked, with a Next Step block that routes back to reasoning.

---

## Phase 5a: Update leeroyyyyy orchestrator — pipeline structure and metadata

Update the structural and metadata sections of leeroyyyyy's SKILL.md: pipeline diagram, artifact handoff map, frontmatter, sub-skill invocation note, and autonomy principle.

### Step 5a.1: Update the Pipeline section

#### Task 5a.1.1: Replace the fixed Align sequence with nudge-driven flow

The current pipeline shows:
```
Solutioning -> Tire-Kicking -> Reasoning
```

Replace with a nudge-driven Align stage:
```
Solutioning  <- produce candidates, emit Next Step
    |
    v (read Next Step from solution-statement.md)
    |
    +--[Plan]--> Planning (short-circuit: prescriptive problem)
    |
    +--[reasoning]--> Reasoning  <- synthesize candidates, emit Next Step
                        |
                        v (read Next Step from truth-and-vector.md)
                        |
                        +--[Plan]--> Planning (clear conviction)
                        |
                        +--[tire-kicking]--> Tire-Kicking <- stress-test, emit Next Step
                                                |
                                                v (always)
                                                Reasoning (second pass) -> Planning
```

Present this as a readable ASCII diagram or a clear description in the Pipeline section.

#### Task 5a.1.2: Update the Artifact Handoff Map

Update the table to reflect:
- Solutioning: input unchanged, output unchanged, but now emits Next Step
- Reasoning: input is now `solution-statement.md` (not `tire-kicking-report.md`), optionally also `tire-kicking-report.md` if tire-kicking ran
- Tire-kicking: now conditional -- only dispatched if reasoning's Next Step recommends it
- Add a "Condition" column or note explaining when each Align-stage phase runs

### Step 5a.2: Update metadata and framing sections

#### Task 5a.2.1: Update the description frontmatter

The current description mentions "solutioning -> tire-kicking -> reasoning". Update to reflect the new order and conditional flow.

#### Task 5a.2.2: Update the Sub-Skill Invocation Note

The current Sub-Skill Invocation Note lists skills in the old order (`solutioning`, `tire-kicking`, `reasoning`, ...). Update the list to reflect the new order: `solutioning`, `reasoning`, `tire-kicking`, `recon`, `planning`, `pre-flight`, `produce`, `review`, `triage`, `revise`. Note that `tire-kicking` is now conditionally invoked within the pipeline.

#### Task 5a.2.3: Update the Autonomy Principle section

The current Autonomy Principle section's bullet list says "Producing candidate solutions and tire-kicking all of them" and "Picking the best solution using evidence and codebase conventions." Update these bullets to reflect conditional tire-kicking and nudge-driven routing:
- "Producing candidate solutions and routing based on solution nudges" (replaces the tire-kicking-all-of-them language)
- "Conditionally stress-testing candidates when reasoning flags genuine ambiguity"
- "Picking the best solution using reasoning synthesis, evidence, and codebase conventions"

**Critical file:** `/Users/will/agentic/skills/leeroyyyyy/SKILL.md`

**Success criteria:** Pipeline diagram, artifact handoff map, frontmatter, sub-skill list, and autonomy principle all reflect the new nudge-driven Align stage structure.

---

## Phase 5b: Update leeroyyyyy orchestrator — phase descriptions and nudge mechanism

Rewrite the Align-stage phase descriptions (Phases 1-3 in leeroyyyyy) and add the nudge-reading mechanism.

### Step 5b.1: Rewrite Phase descriptions

#### Task 5b.1.1: Rewrite Phase 1 (Solutioning)

Add guidance that after the solutioning subagent commits `solution-statement.md`, leeroyyyyy reads the `## Next Step` block from the artifact and routes accordingly:
- If `Recommendation: Plan` -> skip to Phase 4 (Planning) — stage advancement
- If `Recommendation: reasoning` -> proceed to Phase 2 (Reasoning) — within-stage routing

#### Task 5b.1.2: Rewrite Phase 2 as Reasoning (was Tire-Kicking)

Phase 2 is now Reasoning, not Tire-Kicking. The reasoning subagent receives `solution-statement.md` (and `problem-statement.md` for full context). After reasoning commits `truth-and-vector.md`, leeroyyyyy reads the `## Next Step` block:
- If `Recommendation: Plan` -> skip to Phase 4 (Planning) — stage advancement
- If `Recommendation: tire-kicking` -> proceed to Phase 3 (Tire-Kicking) — within-stage routing

#### Task 5b.1.3: Rewrite Phase 3 as Tire-Kicking (was Reasoning)

Phase 3 is now Tire-Kicking, and it is conditional. It only runs if reasoning's Next Step recommends it. After tire-kicking commits its report, leeroyyyyy dispatches a second reasoning pass to consume the report and make the final solution choice. This second reasoning pass always nudges to `Plan` (stage advancement). The reasoning skill detects this is a second pass by the presence of `tire-kicking-report.md` in the workstream directory — see Task 3.1.1 for the detection mechanism.

Update the input artifacts: tire-kicking receives `problem-statement.md` and `solution-statement.md` (same as before). The second reasoning pass receives `tire-kicking-report.md` and `solution-statement.md`.

### Step 5b.2: Add the nudge-reading mechanism

#### Task 5b.2.1: Document the nudge-reading mechanism

Add a clear description of HOW leeroyyyyy reads the Next Step block. This is simple: after each Align-stage subagent commits its artifact, leeroyyyyy reads the artifact file, finds the `## Next Step` section, and parses the `Recommendation:` line. The value determines the next dispatch.

Include a fallback: if the Next Step block is missing or malformed, leeroyyyyy falls back to the default sequence (solutioning -> reasoning -> planning). This prevents a broken artifact from halting the pipeline.

**Critical file:** `/Users/will/agentic/skills/leeroyyyyy/SKILL.md`

**Success criteria:** Phase 1-3 descriptions accurately reflect the new Align stage flow with nudge-driven routing, and the nudge-reading mechanism is clearly documented with fallback behavior.

**Gotchas:**
- The Phase numbering in leeroyyyyy shifts: what was Phase 2 (Tire-Kicking) becomes Phase 2 (Reasoning), and Phase 3 (Reasoning) becomes Phase 3 (Tire-Kicking, conditional). All subsequent phase numbers stay the same since they reference "Phase 4: Planning" etc. -- but double-check cross-references.
- The git log example in "Context Management" shows `tire-kicking-report.md` before `truth-and-vector.md` -- update to reflect the new order (and note that tire-kicking-report may not appear if tire-kicking was skipped).

---

## Phase 5c: Update leeroyyyyy ARTIFACT.md

Update the summary-statement artifact template to reflect conditional Align-stage phases.

### Step 5c.1: Update the Phases Executed section guidance

#### Task 5c.1.1: Update the Phases Executed section guidance

The summary-statement template has a `## Phases Executed` section. Add a note that this should reflect which Align-stage phases actually ran (e.g., "Solutioning -> Reasoning -> Planning" if tire-kicking was skipped, or "Solutioning -> Reasoning -> Tire-Kicking -> Reasoning -> Planning" if the full sequence ran).

**Critical file:** `/Users/will/agentic/skills/leeroyyyyy/ARTIFACT.md`

**Success criteria:** The artifact template guidance accounts for variable Align-stage phase sequences.

---

## Phase 6: Update README and documentation

### Step 6.1: Update README.md

#### Task 6.1.1: Reorder Align stage skills in the RAPID table

The current table shows:
```
| `/solutioning` | `/tire-kicking` | `/reasoning` |
```

Change to:
```
| `/solutioning` | `/reasoning` | `/tire-kicking` |
```

This reflects the new order: solutioning -> reasoning -> tire-kicking (conditional).

#### Task 6.1.2: Update the A -- Align section

Update the skill descriptions to reflect the new flow:
- Solutioning: add note about short-circuit path
- Reasoning: note its new position as the default step after solutioning within the Align stage
- Tire-kicking: note that it is conditionally invoked when reasoning flags ambiguity

#### Task 6.1.3: Update the Danger Zone (leeroyyyyy description)

The current description says "Explores 2-3 candidate solutions and stress-tests all of them." Update to reflect that stress-testing is conditional and the pipeline adapts based on skill nudges.

#### Task 6.1.4: Update Floating Skills callout

The floating skills line lists `/reasoning`. Reasoning is still floating (usable at any stage), but its role within the Align stage has changed. No change needed to the floating skills line itself, but verify it is still accurate.

**Critical file:** `/Users/will/agentic/skills/README.md`

**Success criteria:** README accurately reflects the new Align stage order, solutioning's short-circuit path, tire-kicking's conditional nature, and leeroyyyyy's nudge-driven routing.
