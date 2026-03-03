# Artifact Capture, Subagent Orchestration & Plan Progress Tracking

## Overview

Introduce a co-located `ARTIFACT.md` per skill that defines the output template, naming
convention, and save location for that skill's phase artifact. Retire the `artifactor` skill,
absorbing its path-convention guidance into each `ARTIFACT.md`. Update the `planning` skill to
produce a portable `*.plan.md` format. Update `produce` to write progress back to the plan file
at phase boundaries via `[plan]` commits. Rewrite `leeroyyyyy` as a thin orchestrator that
dispatches subagents with targeted artifact handoffs and mandates subagenting for every plan phase
(enforced via `/atomize` after the pre-flight loop completes).

## Notes

- **Out of scope:** `/capture` skill, Issue #2 Roadmapping (`.claude/work/` bootstrapping),
  changes to `recon`, `clarify`, `revise`, `pair-on`, `reply`
- **Artifactor** is retired as part of this work — its guidance is absorbed into each `ARTIFACT.md`
- **Storage convention:** all artifacts live in `.claude/work/<work-item>/` at the nearest project
  root. `understanding` creates the subdirectory using a slugified problem statement name.
- **Plan file format** (`*.plan.md`): Phase → Step → Task breakdown, overview + notes at top,
  progress tracking section updated by `produce` at the phase level
- **Skills without artifacts:** `recon`, `clarify`, `revise`, `pair-on`, `produce`, `reply`,
  `commit` (no `ARTIFACT.md` needed — absence is sufficient)
- **Estimate and phase decomposition:** `/atomize` owns plan-phase decomposition. It estimates
  every plan phase using `/estimate` and decomposes anything > LOE 2 into subphases, iterating
  until all plan phases score ≤ 2. In `leeroyyyyy`'s pipeline, atomize runs after pre-flight. At
  execution time every plan phase is dispatched to a subagent unconditionally — the ≤ 2 guarantee
  is established by atomize before produce begins.
- **Commits as handoff mechanism:** every artifact produced during a leeroyyyyy run is committed
  atomically before the next stage begins. Subagents receive file paths, not conversation context —
  the committed files are what make cross-agent handoffs possible without context bleed.
  Expected commit sequence for a full run (problem-statement.md is a precondition, not a commit):
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
  The orchestrator (leeroyyyyy) is responsible for ensuring each stage commits before the next begins.
- **Parallel subagenting in produce:** concurrent phase subagents each update only their phase
  row in the progress section of the plan file, avoiding conflicts
- **Canonical structure:** `SKILL.spec.md` at the project root defines the canonical section
  order for all skill files. The invariant for this workstream: `## Artifact` always appears
  immediately before `## Closure Criteria`.

## Progress

- [ ] Phase 1: Create canonical template files
- [ ] Phase 2: Create all per-skill ARTIFACT.md files
- [ ] Phase 3: Update SKILL.md files
- [ ] Phase 4: Rewrite leeroyyyyy SKILL.md
- [ ] Phase 5: Retire artifactor + update README

---

## Phase 1: Create canonical template files

Establishes the authoritative specifications that all subsequent phases conform to.
Steps are independent and can be parallelized. Phase 2 and Phase 3 depend on this phase.

### Step 1.1: Create SKILL.spec.md — canonical skill file specification

**Output file:** `/Users/will/agentic/skills/SKILL.spec.md`

This file is the authoritative specification for every `SKILL.md` in this library.
It is not itself a skill — it defines the structure that all `skills/*/SKILL.md` files must follow.

Content to include:
- **Frontmatter spec:** required fields (`name`, `description`), optional fields
  (`agent-invocation`, `agent-reference`, `agent-note`)
- **Canonical section order** with a brief description of what each section should contain:
  ```
  ---
  name: skill-name
  description: ...
  ---

  # Skill Name

  [Optional experimental/warning notice]

  ## Goal
  ## Your Role          ← include if the skill has a user-facing interactive role
  ## Agent's Role       ← include if the skill has autonomous/orchestration behavior
  ## [Skill-specific content sections]
  ## Artifact           ← always immediately before Closure Criteria
  ## Closure Criteria
  ## Notes
  ```
- **Optional sections:** `## Closing the Phase`, `## Invocation`, `## Precondition` — placed
  within the skill-specific content area, not after `## Artifact`
- **The `## Artifact` invariant:** always immediately precedes `## Closure Criteria`; its content
  is a brief summary pointing to `ARTIFACT.md` for the full template. Skills without artifacts
  omit this section entirely (absence is the signal).

### Step 1.2: Create ARTIFACT.spec.md — canonical artifact definition specification

**Output file:** `/Users/will/agentic/skills/ARTIFACT.spec.md`

This file is the authoritative specification for every per-skill `ARTIFACT.md` in this library.
It defines the structure that all `skills/*/ARTIFACT.md` files must follow.

Content to include:
- **Required meta-instruction block at the top** (must appear in every per-skill ARTIFACT.md):
  ```
  ## Meta
  - Storage: `.claude/work/<work-item>/` at the nearest project root
  - Filename: <defined per skill below>
  - Trigger: <when to generate this artifact>
  ```
- **Canonical sections:** Output file, Template (full section structure), Trigger, Notes
- **Inline-only exception:** for skills whose output is in-context only (e.g., `estimate`),
  document the convention: ARTIFACT.md still exists and defines the canonical output format,
  but no file is written
- **Side effects:** optional section for skills with side effects (e.g., directory creation)

### Step 1.3: Update README to reference canonical spec files

Add a **Conventions** section to README that:
- Points to `SKILL.spec.md` at the project root as the canonical skill file specification
- Points to `ARTIFACT.spec.md` at the project root as the canonical artifact definition specification
- One-paragraph explanation of the convention: every skill directory contains a `SKILL.md`
  conforming to `SKILL.spec.md`; skills that produce phase artifacts also contain an `ARTIFACT.md`
  conforming to `ARTIFACT.spec.md`

---

## Phase 2: Create all per-skill ARTIFACT.md files

Depends on Phase 1 (`ARTIFACT.spec.md` defines the required structure).
Each file is independent — all can be created in parallel.

Every `ARTIFACT.md` must include the meta-instruction block at the top (per `ARTIFACT.spec.md`).

### Step 2.1: understanding/ARTIFACT.md

**Output file:** `problem-statement.md`

Template sections:
- Problem statement (1–3 sentences, plain language)
- Why it matters / why now
- Key constraints
- Success criteria
- Assumptions surfaced
- Workstream slug (slugified from problem statement — used as the `.claude/work/<slug>/` directory name)

**Trigger:** When understanding phase closes and mutual alignment is confirmed.
**Side effect:** Create `.claude/work/<slug>/` directory if it doesn't exist.

### Step 2.2: solutioning/ARTIFACT.md

**Output file:** `solution-statement.md`

Template sections:
- Chosen approach (name + 1–2 sentence description)
- Why this approach was selected (key evidence from tire-kicking and reasoning)
- Tradeoffs accepted
- Approaches considered and rejected (brief — name + one-liner reason)
- LOE score

**Trigger:** When a solution is confirmed and the phase closes.

### Step 2.3: tire-kicking/ARTIFACT.md

**Output file:** `tire-kicking-report.md`

Extract the artifact definition already implicit in the tire-kicking skill into a formal template.

Template sections:
- Candidates evaluated
- Scenarios tested (per candidate: holds / bends / leaks classification)
- Summary of bends and leaks per approach
- Comparative verdict

**Trigger:** When all candidates have been stress-tested and the report is complete.

### Step 2.4: reasoning/ARTIFACT.md

**Output file:** `truth-and-vector.md`

Template sections:
- Truths established (numbered list of confirmed facts / non-negotiables)
- Conditionals (things that are true given a specific context or assumption)
- Directional vector (1–3 sentences: where this reasoning points and why)

**Trigger:** When the reasoning pass is complete and a direction has been established.

### Step 2.5: planning/ARTIFACT.md

**Output file:** `<work-item>.plan.md`

The plan file is itself the artifact. Template structure:

```
# <Title>

## Overview
## Notes
## Progress
- [ ] Phase N: <name>

---

## Phase N: <name>
### Step N.N: <name>
#### Task N.N.N: <description>
```

Progress section is updated by `produce` at phase boundaries (not by planning itself).

**Trigger:** When the plan document is finalized and ready for pre-flight.

### Step 2.6: pre-flight/ARTIFACT.md

**Output file:** `pre-flight-issues.md`

Template sections:
- Issues found (each with: What / Where / Impact / Suggestion)
  - Critical issues
  - Major issues
  - Minor issues
- Opportunities identified
- Confidence level: Ready / Issues to resolve / Return to Planning

**Trigger:** At the end of each pre-flight cycle. File is overwritten each cycle (latest state wins).

### Step 2.7: review/ARTIFACT.md

**Output file:** `review-issues.md`

Template sections:
- Issues found (same structure as pre-flight: Critical / Major / Minor)
- Each issue: What / Where / Severity / Suggestion
- Go / No-go recommendation

**Trigger:** When the review pass is complete.

### Step 2.8: triage/ARTIFACT.md

**Output file:** `triage-report.md`

Template sections:
- Critical revisions (grouped, with revision ID and description)
- Major revisions
- Minor revisions
- Deferred / out of scope items

**Trigger:** When triage groupings are finalized.

### Step 2.9: estimate/ARTIFACT.md

**Output file:** Inline — estimate output is produced in-context (not saved to a file).

The ARTIFACT.md defines the canonical output format:
```
LOE: <1–5>
Complexity: <Low|Medium|High> | Impact: <Low|Medium|High>
<1–5 sentence rationale explaining the synthesis, especially when dimensions diverge>
```

**Trigger:** Whenever an estimate is requested. Output is always inline.

**Note:** No file is written — estimate's artifact is its formatted output. Within the pipeline,
estimate is used by `/atomize` to enforce plan-phase decomposition: `/atomize` calls estimate per
plan phase and decomposes anything > LOE 2 until all plan phases are ≤ 2.

### Step 2.11: atomize/ARTIFACT.md

**Output file:** `<work-item>.plan.md` (updated in-place) — decomposition log is inline only.

The plan file is modified directly: oversized plan phases are replaced by their decomposed
subphases. The decomposition log is presented inline and not saved to a separate file.

Inline decomposition log format:
```
## Atomization Log

| Original phase | LOE | Split into | New LOE |
|---|---|---|---|
| Phase N: <name> | 3 | Phase Na: <name>, Phase Nb: <name> | 2, 1 |

All plan phases confirmed ≤ LOE 2.
```

**Trigger:** When all plan phases score ≤ 2 and the updated plan is confirmed by the user.

**Note:** atomize/SKILL.md already exists (created prior to this workstream). This step creates
only the co-located ARTIFACT.md.

### Step 2.10: leeroyyyyy/ARTIFACT.md

**Output file:** `summary-statement.md`

Template sections:
- Summary (1–8 sentences: what was built, what changed, overall outcome)
- Phases executed (bulleted list, one line each)
- Out-of-scope items (as noted in the plan file)
- Items requiring user attention (unresolved revisions, escalations, or abort reason)

**Trigger:** When the full pipeline completes (after all Critical/Major revisions are addressed,
or after aborting with unresolvable issues — document the abort reason in the summary).

---

## Phase 3: Update SKILL.md files

Depends on Phase 1 (`SKILL.spec.md` defines canonical structure and `## Artifact` placement).
Steps within this phase are independent and can be parallelized.
Step 5.2 (README update) can also run in parallel with this phase — no blocking dependency.

### Step 3.1: Add `## Artifact` section to each skill with an ARTIFACT.md

For each of the 11 skills (understanding, solutioning, tire-kicking, reasoning, planning,
pre-flight, review, triage, estimate, atomize, leeroyyyyy):

Add a brief `## Artifact` section **immediately before `## Closure Criteria`** in `SKILL.md`:
- One line stating what artifact this skill produces
- Reference to `ARTIFACT.md` for the full template
- The trigger condition (when to generate)

Keep it short — the detail lives in `ARTIFACT.md`. Follow `SKILL.spec.md` for canonical structure.

**Note on planning/SKILL.md:** The `## Artifact` addition and all other structural changes are
handled together in Step 3.2 as a single pass.

### Step 3.2: Update planning/SKILL.md — single combined pass

Combine all changes into one edit:

- Add `## Artifact` section immediately before `## Closure Criteria` (per Step 3.1)
- Remove reference to `artifactor` skill (it's being retired)
- Add explicit guidance on the `*.plan.md` format: Phase → Step → Task breakdown
- Document the progress tracking section and note that `produce` owns updating it
- Clarify that plan file naming follows `<work-item>.plan.md`
- Add reference to `/atomize` for plan-phase decomposition: after pre-flight, run `/atomize` to
  ensure all plan phases score ≤ LOE 2 before execution begins
- In leeroyyyyy context: Stage 1 (interactive Q&A) is automated — the agent uses recon
  rather than asking the user

### Step 3.3: Update produce/SKILL.md for phase-boundary progress tracking

- Add Phase-boundary checkpoint behavior:
  - After completing each plan phase, update the plan file's progress section
  - Mark the phase row as complete: `- [x] Phase N: <name>`
  - Add a deviation note inline if the phase deviated from plan
  - Commit the plan file update as a `[plan]` commit before moving to the next phase
- Add subagent context note: produce subagents receive only the plan file — not full
  conversation history
- Add parallel subagent note: concurrent phase subagents update only their own progress row

### Step 3.4: Remove artifactor references from all SKILL.md files

Scan all SKILL.md files for references to `artifactor` skill. Replace with inline convention:
"Save artifacts to `.claude/work/<work-item>/` at the nearest project root."

Primary file to check: `leeroyyyyy/SKILL.md` (line 86 references artifactor).
`planning/SKILL.md` is already handled in Step 3.2 — skip it here.
Check all remaining SKILL.md files for stray references.

---

## Phase 4: Rewrite leeroyyyyy/SKILL.md

Depends on Phase 2 (needs to know what artifacts each phase produces).
Can be written in parallel with Phase 3.

### Step 4.1: Establish the Context Management and Subagent Dispatch Principle

Add a prominent section (early in the file) establishing subagent dispatch as the
unconditional execution strategy:

- Context is a finite resource — treat it as such
- Every phase handoff is a context boundary: pass artifact files, not conversation history
- **Commits are the handoff mechanism** — every artifact is committed before the next stage
  begins; subagents read committed files, never conversation history
- The full run produces a readable git log: docs → docs → docs → plan → plan → plan →
  code → plan → code → plan → ... — each commit corresponds to one pipeline stage's output
  (problem-statement.md is a precondition, not produced during the run)
- All plan phases are always dispatched to subagents — no exceptions
- The LOE ≤ 2 guarantee is established by `/atomize`, which runs after pre-flight; leeroyyyyy
  trusts this guarantee and never re-estimates at runtime
- Concurrent phase work: multiple subagents may run in parallel; each receives only the
  artifacts it needs
- Progress is reported in chat at each phase transition so the user can observe pipeline
  state without being blocked

### Step 4.2: Define the artifact handoff map per phase

For each pipeline phase, document explicitly:
- Input artifacts (what the subagent/agent receives)
- Output artifact (what it produces)
- Subagent rule

**Precondition:** `problem-statement.md` must exist in `.claude/work/<slug>/` before leeroyyyyy
is invoked. Understanding requires user dialogue and cannot be automated — it is the one stage
leeroyyyyy does not own. The roadmapping skill (future) will produce problem statements
automatically; until then the user runs `/understanding` manually before invoking leeroyyyyy.

| Phase | Input artifacts | Output artifact | Subagent rule |
|---|---|---|---|
| Solutioning | problem-statement.md | solution-statement.md | mandatory |
| Tire-kicking | problem-statement.md, solution-statement.md (all candidates) | tire-kicking-report.md | mandatory |
| Reasoning | tire-kicking-report.md, recon findings (inline) | truth-and-vector.md | mandatory |
| Planning | solution-statement.md, truth-and-vector.md | *.plan.md | mandatory |
| Pre-flight | *.plan.md, solution-statement.md | pre-flight-issues.md | mandatory |
| Atomize | *.plan.md, pre-flight-issues.md | *.plan.md (all plan phases ≤ LOE 2) | mandatory |
| Produce (per phase) | *.plan.md only | progress update in plan file | mandatory |
| Review | local diff | review-issues.md | mandatory |
| Triage | review-issues.md | triage-report.md | mandatory |
| Revise | triage-report.md, *.plan.md | commits | mandatory |

### Step 4.3: Rewrite the pipeline section

Rewrite each phase's prose in leeroyyyyy to:

- **Restore and update the `Precondition` section** — `problem-statement.md` must exist in the
  workstream directory before leeroyyyyy is invoked; Understanding is not part of the pipeline
- Pipeline starts at Solutioning (Phase 1); renumber phases accordingly
- Be explicit about what artifacts it passes to that phase
- Remove any language that implies holding full conversation context across phase boundaries
- Reinforce that leeroyyyyy is orchestration only — it does not implement artifact logic itself
- Update the frontmatter `description` field to reflect Solutioning as Phase 1
- **Add explicit commit instructions for every pipeline stage** — after each stage produces its
  artifact, leeroyyyyy commits before dispatching the next subagent:
  - Solutioning → `[docs]` commit of `solution-statement.md`
  - Tire-kicking → `[docs]` commit of `tire-kicking-report.md`
  - Reasoning → `[docs]` commit of `truth-and-vector.md`
  - Planning → `[plan]` commit of `*.plan.md`
  - Pre-flight (each cycle) → `[plan]` commit of plan adjustments
  - Atomize → `[plan]` commit of resized plan
  - Produce (each phase) → `[code]` commit(s) then `[plan]` commit marking phase complete
- Add Atomize as a pipeline step after the pre-flight loop completes, before produce begins —
  atomize runs once on the stable plan

**Pre-flight loop behavior** (update the Pre-Flight + Reasoning Loop section):

The loop runs with a minimum of 2 pre-flights and a maximum of 4:

1. Run Pre-flight → save findings to `pre-flight-issues.md`
2. Run Reasoning (always, even if pre-flight is clean) → reason through findings and update plan
3. Run Pre-flight again
4. If no Critical/Major issues: proceed to Produce
5. If Critical/Major issues remain: run Reasoning → Pre-flight (cycle repeats)
6. Maximum 4 pre-flight cycles total
7. If the 4th pre-flight still has Critical/Major issues: **abort** — surface unresolved issues
   to the user, write summary-statement.md noting the abort reason, and stop

Report progress in chat at each step: "Running pre-flight cycle N/4...", "Pre-flight clear —
advancing to Produce", "Pre-flight cycle N has Critical issues — running reasoning pass...", etc.

### Step 4.4: Strengthen the autonomy principle

Rewrite the Autonomy Principle section to make clear:
- The user↔agent back-and-forth that standalone skills expect is automated here
- Leeroyyyyy uses reasoning, recon, and subagents in place of user input
- Understanding is the one stage leeroyyyyy does not own — it requires user dialogue and must
  be completed before invocation; `problem-statement.md` is the handoff artifact
- Everything from Solutioning onward is fully autonomous
- Progress is narrated in chat throughout the pipeline so the user is never in the dark about
  pipeline state, even though no input is requested

---

## Phase 5: Retire artifactor + update README

Step 5.1 depends on Phase 3 (Step 3.4 must complete before artifactor directory is deleted).
Step 5.2 is independent and can run in parallel with Phase 3.

### Step 5.1: Remove artifactor skill directory

Delete `/Users/will/agentic/skills/artifactor/` and its contents.
**Prerequisite:** Step 3.4 must be complete (no SKILL.md files may still reference artifactor).

### Step 5.2: Update README for artifactor retirement and leeroyyyyy changes

Can run in parallel with Phase 3 (no dependency on SKILL.md changes):

- Remove `artifactor` from the diagram (Use anytime section)
- Remove `artifactor` from the Meta section
- Remove `artifactor` from the Supporting Skills section
- Update `planning` skill description to remove reference to artifactor
- Update `leeroyyyyy` description to reflect subagent orchestration and understanding as Phase 1

**Note:** The Conventions section pointing to `SKILL.spec.md` and `ARTIFACT.spec.md` is added
in Phase 1 Step 1.3 — do not duplicate it here.

---

## Critical Files

**Created:**
- `SKILL.spec.md` (project root — canonical skill file specification)
- `ARTIFACT.spec.md` (project root — canonical artifact definition specification)
- `understanding/ARTIFACT.md`
- `solutioning/ARTIFACT.md`
- `tire-kicking/ARTIFACT.md`
- `reasoning/ARTIFACT.md`
- `planning/ARTIFACT.md`
- `pre-flight/ARTIFACT.md`
- `review/ARTIFACT.md`
- `triage/ARTIFACT.md`
- `estimate/ARTIFACT.md`
- `leeroyyyyy/ARTIFACT.md`
- `.claude/work/artifact-capture-and-subagent-orchestration/` (this workstream directory)

**Modified:**
- `understanding/SKILL.md`
- `solutioning/SKILL.md`
- `tire-kicking/SKILL.md`
- `reasoning/SKILL.md`
- `planning/SKILL.md`
- `pre-flight/SKILL.md`
- `review/SKILL.md`
- `triage/SKILL.md`
- `estimate/SKILL.md`
- `leeroyyyyy/SKILL.md`
- `produce/SKILL.md`
- `README.md`

**Deleted:**
- `artifactor/SKILL.md`
- `artifactor/` directory

---

## Gotchas & Risks

- **`.spec.md` files are specs, not skills** — `SKILL.spec.md` and `ARTIFACT.spec.md` at the
  project root must have a clear header distinguishing them from skill/artifact instances. A
  skill loader globbing the directory should not pick them up as actionable files.
- **Tire-kicking already has implicit artifact behavior** — need to read it carefully before
  writing its ARTIFACT.md to avoid contradiction or duplication
- **Planning SKILL.md references artifactor** — handled in Step 3.2 as a single combined pass
  (not two separate edits to the same file)
- **Estimate has no file output** — its ARTIFACT.md defines a canonical inline format, not a
  saved file. This is an exception to the general pattern; document it clearly in the ARTIFACT.md
  itself so it's not mistakenly treated as a file-producing skill
- **Leeroyyyyy rewrite scope** — Phase 4 is the most complex single phase. The artifact handoff
  map must accurately reflect what each downstream subagent actually needs; getting this wrong
  breaks the context isolation goal
- **Concurrent subagent plan file updates** — parallel produce subagents both write to the plan
  file. The constraint (each updates only its own progress row) must be explicit in both
  produce/SKILL.md and leeroyyyyy/SKILL.md
- **Phase 5.1 ordering** — Step 5.1 (delete artifactor directory) must not run before Step 3.4
  is complete; verify leeroyyyyy/SKILL.md has no remaining artifactor references before deleting
- **Understanding as Phase 1** — removing the Precondition section from leeroyyyyy requires
  updating both the frontmatter description and the pipeline diagram in addition to the prose

## Success Criteria

- [ ] `SKILL.spec.md` exists at project root with canonical section order and `## Artifact` invariant
- [ ] `ARTIFACT.spec.md` exists at project root with canonical meta-instruction block and template structure
- [ ] README has a Conventions section pointing to both root spec files
- [ ] Every skill with an artifact has a co-located `ARTIFACT.md` with template, naming, and trigger
- [ ] Every per-skill `ARTIFACT.md` includes the meta-instruction block at the top
- [ ] `planning/SKILL.md` documents the `*.plan.md` format, progress tracking section, and
  reference to `/atomize` for plan-phase decomposition
- [ ] `produce/SKILL.md` describes `[plan]` commits at phase boundaries
- [ ] `leeroyyyyy/SKILL.md` has Understanding as Phase 1 (not a precondition)
- [ ] `leeroyyyyy/SKILL.md` explicitly maps artifact handoffs for all 10 pipeline phases
- [ ] `leeroyyyyy/SKILL.md` mandates subagenting for all phases unconditionally
- [ ] `leeroyyyyy/SKILL.md` pre-flight loop: min 2, max 4 cycles; abort on 4th failure; progress visible in chat
- [ ] `artifactor/` directory is deleted
- [ ] `README.md` contains no references to artifactor
- [ ] All SKILL.md files contain no stale references to artifactor
