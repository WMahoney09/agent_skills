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
- **Canonical structure:** `SKILL.spec.md` at the project root defines the canonical section
  order for all skill files. The invariant for this workstream: `## Artifact` always appears
  immediately before `## Closure Criteria`.

## Progress

- [ ] Phase 1: Create canonical template files
- [ ] Phase 2a: Create ARTIFACT.md files — understanding, solutioning, tire-kicking, reasoning
- [ ] Phase 2b: Create ARTIFACT.md files — planning, pre-flight, review, triage
- [ ] Phase 2c: Create ARTIFACT.md files — estimate, atomize, leeroyyyyy
- [ ] Phase 3a: Add `## Artifact` section to 9 SKILL.md files
- [ ] Phase 3b: Update planning + produce SKILL.md; scan for artifactor refs
- [ ] Phase 4a: leeroyyyyy — add Context Management section + artifact handoff map
- [ ] Phase 4b: leeroyyyyy — rewrite pipeline section + pre-flight loop + commit instructions
- [ ] Phase 4c: leeroyyyyy — autonomy principle + frontmatter + Completion section
- [ ] Phase 5: Retire artifactor directory

---

## Phase 1: Create canonical template files

Establishes the authoritative specifications that all subsequent phases conform to.
Steps are independent and can be executed in any order. Phases 2a/2b/2c and 3a/3b depend on this phase.

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
- **Canonical example of inline-only + in-place update pattern:** reference `atomize/ARTIFACT.md`
  as the template for skills whose output modifies an existing file in-place rather than creating a
  new one

### Step 1.3: Update README — single combined pass

**This step absorbs Step 5.2 entirely. Step 5.2 requires no separate execution.**

Do all README changes in one edit:

**Conventions section (new):**
- Add a **Conventions** section pointing to `SKILL.spec.md` at the project root as the canonical
  skill file specification
- Point to `ARTIFACT.spec.md` at the project root as the canonical artifact definition specification
- One-paragraph explanation: every skill directory contains a `SKILL.md` conforming to
  `SKILL.spec.md`; skills that produce phase artifacts also contain an `ARTIFACT.md` conforming
  to `ARTIFACT.spec.md`

**Artifactor retirement:**
- Remove `artifactor` from the diagram (Use anytime section)
- Remove `artifactor` from the Meta section
- Remove `artifactor` from the Supporting Skills section
- Update `planning` skill description to remove reference to artifactor

**Leeroyyyyy update:**
- Update `leeroyyyyy` description to reflect subagent orchestration, Atomize as a pipeline step,
  and Understanding as a Precondition (not a pipeline phase)

---

## Phase 2a: Create ARTIFACT.md files — understanding, solutioning, tire-kicking, reasoning

Depends on Phase 1 (`ARTIFACT.spec.md` defines the required structure).
All four files are independent and can be executed in any order.

Every `ARTIFACT.md` must include the meta-instruction block at the top (per `ARTIFACT.spec.md`).

### Step 2a.1: understanding/ARTIFACT.md

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

### Step 2a.2: solutioning/ARTIFACT.md

**Output file:** `solution-statement.md`

Template sections:
- Chosen approach (name + 1–2 sentence description)
- Why this approach was selected (key evidence from tire-kicking and reasoning)
- Tradeoffs accepted
- Approaches considered and rejected (brief — name + one-liner reason)
- LOE score

**Trigger:** When a solution is confirmed and the phase closes.

### Step 2a.3: tire-kicking/ARTIFACT.md

**Output file:** `tire-kicking-report.md`

Extract the artifact definition already implicit in the tire-kicking skill into a formal template.

Template sections:
- Candidates evaluated
- Scenarios tested (per candidate: holds / bends / leaks classification)
- Summary of bends and leaks per approach
- Comparative verdict

**Trigger:** When all candidates have been stress-tested and the report is complete.

**Note:** The legacy `tire-kicking/SKILL.md` references `tire-kicking-scenarios.md` and
`path-forward.md` as example artifacts — do not replicate these names in ARTIFACT.md. The
canonical output filename for this workstream is `tire-kicking-report.md`.

### Step 2a.4: reasoning/ARTIFACT.md

**Output file:** `truth-and-vector.md`

Template sections:
- Truths established (numbered list of confirmed facts / non-negotiables)
- Conditionals (things that are true given a specific context or assumption)
- Directional vector (1–3 sentences: where this reasoning points and why)

**Trigger:** When the reasoning pass is complete and a direction has been established.

---

## Phase 2b: Create ARTIFACT.md files — planning, pre-flight, review, triage

Depends on Phase 1. All four files are independent and can be executed in any order.
Pre-flight has a nuanced inline-only pattern — read the plan notes carefully before authoring.

### Step 2b.1: planning/ARTIFACT.md

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

### Step 2b.2: pre-flight/ARTIFACT.md

**Output file:** Inline — pre-flight findings are produced in-context (not saved to a file).

The ARTIFACT.md defines the canonical output format:
- Issues found (each with: What / Where / Impact / Suggestion)
  - Critical issues
  - Major issues
  - Minor issues
- Opportunities identified
- Confidence level: Ready / Issues to resolve / Return to Planning

**Trigger:** At the end of each pre-flight cycle. Output is always inline.

**Note:** Pre-flight's committed artifact is the updated plan file — produced by the reasoning
pass that follows and committed as `[plan]`. Pre-flight findings are consumed in-context by the
reasoning subagent; no file is written and the working index stays clean.

### Step 2b.3: review/ARTIFACT.md

**Output file:** `review-issues.md`

Template sections:
- Issues found (same structure as pre-flight: Critical / Major / Minor)
- Each issue: What / Where / Severity / Suggestion
- Go / No-go recommendation

**Trigger:** When the review pass is complete.

### Step 2b.4: triage/ARTIFACT.md

**Output file:** `triage-report.md`

Template sections:
- Critical revisions (grouped, with revision ID and description)
- Major revisions
- Minor revisions
- Deferred / out of scope items

**Trigger:** When triage groupings are finalized.

---

## Phase 2c: Create ARTIFACT.md files — estimate, atomize, leeroyyyyy

Depends on Phase 1. All three files have special patterns; read the plan notes for each carefully.
Files are independent and can be executed in any order.

### Step 2c.1: estimate/ARTIFACT.md

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

### Step 2c.2: atomize/ARTIFACT.md

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

### Step 2c.3: leeroyyyyy/ARTIFACT.md

**Output file:** `summary-statement.md`

Template sections:
- Summary (1–8 sentences: what was built, what changed, overall outcome)
- Phases executed (bulleted list, one line each)
- Out-of-scope items (as noted in the plan file)
- Items requiring user attention (unresolved revisions, escalations, or abort reason)

**Trigger:** When the full pipeline completes (after all Critical/Major revisions are addressed,
or after aborting with unresolvable issues — document the abort reason in the summary).

---

## Phase 3a: Add `## Artifact` section to 9 SKILL.md files

Depends on Phase 1 (`SKILL.spec.md` defines canonical structure and `## Artifact` placement).
All 9 files are independent — can be edited in any order.

### Step 3a.1: Add `## Artifact` section to each skill with an ARTIFACT.md

For each of the following 9 skills (understanding, solutioning, tire-kicking, reasoning,
pre-flight, review, triage, estimate, atomize):

Add a brief `## Artifact` section **immediately before `## Closure Criteria`** in `SKILL.md`:
- One line stating what artifact this skill produces
- Reference to `ARTIFACT.md` for the full template
- The trigger condition (when to generate)

Keep it short — the detail lives in `ARTIFACT.md`. Follow `SKILL.spec.md` for canonical structure.

**Note:** `leeroyyyyy` is excluded here — its `## Artifact` section is incorporated into the
full rewrite in Phases 4a–4c. Do not touch `leeroyyyyy/SKILL.md` in this phase.

**Note on planning/SKILL.md:** The `## Artifact` addition and all other structural changes are
handled together in Phase 3b as a single pass.

---

## Phase 3b: Update planning + produce SKILL.md; scan for artifactor refs

Depends on Phase 1. Steps within this phase are sequential where noted, otherwise independent.

### Step 3b.1: Update planning/SKILL.md — single combined pass

Combine all changes into one edit:

- Add `## Artifact` section immediately before `## Closure Criteria` (per Phase 3a)
- Remove reference to `artifactor` skill (it's being retired)
- Add explicit guidance on the `*.plan.md` format: Phase → Step → Task breakdown
- Document the progress tracking section and note that `produce` owns updating it
- Clarify that plan file naming follows `<work-item>.plan.md`
- Add reference to `/atomize` for plan-phase decomposition: after pre-flight, run `/atomize` to
  ensure all plan phases score ≤ LOE 2 before execution begins
- In leeroyyyyy context: Stage 1 (interactive Q&A) is automated — the agent uses recon
  rather than asking the user

### Step 3b.2: Update produce/SKILL.md for phase-boundary progress tracking

- Add Phase-boundary checkpoint behavior:
  - After completing each plan phase, update the plan file's progress section
  - Mark the phase row as complete: `- [x] Phase N: <name>`
  - Add a deviation note inline if the phase deviated from plan
  - Commit the plan file update as a `[plan]` commit before moving to the next phase
- Add subagent context note: produce subagents receive only the plan file — not full
  conversation history

### Step 3b.3: Remove artifactor references from all remaining SKILL.md files

Scan all SKILL.md files (excluding `leeroyyyyy/SKILL.md` and `planning/SKILL.md` — already handled)
for references to `artifactor` skill. Replace with inline convention:
"Save artifacts to `.claude/work/<work-item>/` at the nearest project root."

**Note:** This step may find nothing to change — that is the expected outcome. Run it as a
verification scan regardless.

---

## Phase 4a: leeroyyyyy — add Context Management section + artifact handoff map

Depends on Phases 2a, 2b, 2c (needs to know what artifacts each phase produces).
Read the current `leeroyyyyy/SKILL.md` before editing.

### Step 4a.1: Add Context Management and Subagent Dispatch Principle section

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
- Progress is reported in chat at each phase transition so the user can observe pipeline
  state without being blocked

### Step 4a.2: Add artifact handoff map table

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
| Reasoning | tire-kicking-report.md | truth-and-vector.md | mandatory |
| Planning | solution-statement.md, truth-and-vector.md | *.plan.md | mandatory |
| Pre-flight | *.plan.md, solution-statement.md | inline findings → `[plan]` *.plan.md commit (via reasoning pass) | mandatory |
| Atomize | *.plan.md | *.plan.md (all plan phases ≤ LOE 2) | mandatory |
| Produce (per phase) | *.plan.md only | progress update in plan file | mandatory |
| Review | local diff | review-issues.md | mandatory |
| Triage | review-issues.md | triage-report.md | mandatory |
| Revise | triage-report.md, *.plan.md | commits | mandatory |

**Note on Reasoning row:** The reasoning subagent executes its own recon pass — no committed
recon artifact is produced or passed by leeroyyyyy. "Recon findings" are internal to the
reasoning subagent's context, not a file handoff. This is the one sanctioned exception to the
commits-as-handoff principle, because recon is read-only investigation with no canonical output.

---

## Phase 4b: leeroyyyyy — rewrite pipeline section + pre-flight loop + commit instructions

Depends on Phase 4a (builds on the new sections added there).

### Step 4b.1: Rewrite the pipeline section

Rewrite each phase's prose in leeroyyyyy to:

- **Restore and update the `Precondition` section** — `problem-statement.md` must exist in the
  workstream directory before leeroyyyyy is invoked; Understanding is not part of the pipeline
- Pipeline starts at Solutioning (Phase 1); renumber phases accordingly
- Be explicit about what artifacts it passes to that phase
- Remove any language that implies holding full conversation context across phase boundaries
- Reinforce that leeroyyyyy is orchestration only — it does not implement artifact logic itself
- Update the frontmatter `description` field to include Atomize in the pipeline sequence and
  confirm the description matches the precondition framing for Understanding (not a pipeline phase)
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

### Step 4b.2: Rewrite the Pre-Flight + Reasoning Loop section

The loop runs with a minimum of 2 pre-flights and a maximum of 4. Note: this replaces the
existing skill's "2 cycle" framing — a "pre-flight" here means one pre-flight run; the minimum
of 2 pre-flights (with 1 reasoning pass between them) is intentional.

1. Run Pre-flight → save findings to `pre-flight-issues.md`
2. Run Reasoning (always, even if pre-flight is clean) → reason through findings and update plan
3. Run Pre-flight again
4. If no Critical/Major issues: proceed to Atomize
5. If Critical/Major issues remain: run Reasoning → Pre-flight (repeats)
6. Maximum 4 pre-flights total
7. If the 4th pre-flight still has Critical/Major issues: **abort** — surface unresolved issues
   to the user, write summary-statement.md noting the abort reason, and stop

Report progress in chat at each step: "Running pre-flight cycle N/4...", "Pre-flight clear —
advancing to Produce", "Pre-flight cycle N has Critical issues — running reasoning pass...", etc.

---

## Phase 4c: leeroyyyyy — autonomy principle + frontmatter + Completion section

Depends on Phase 4b. Final pass over the file.

### Step 4c.1: Strengthen the Autonomy Principle section

Rewrite the Autonomy Principle section to make clear:
- The user↔agent back-and-forth that standalone skills expect is automated here
- Leeroyyyyy uses reasoning, recon, and subagents in place of user input
- Understanding is the one stage leeroyyyyy does not own — it requires user dialogue and must
  be completed before invocation; `problem-statement.md` is the handoff artifact
- Everything from Solutioning onward is fully autonomous
- Progress is narrated in chat throughout the pipeline so the user is never in the dark about
  pipeline state, even though no input is requested

### Step 4c.2: Update Completion section + frontmatter

- Update the Completion section to reference `summary-statement.md` as the closure artifact —
  agent writes this file per `leeroyyyyy/ARTIFACT.md` before reporting completion
- Update frontmatter `description` field to include Atomize in the pipeline sequence and reflect
  precondition framing for Understanding

---

## Phase 5: Retire artifactor directory

Depends on Phase 3b (Step 3b.3 must complete — no SKILL.md files may still reference artifactor).

### Step 5.1: Remove artifactor skill directory

Delete `/Users/will/agentic/skills/artifactor/` and its contents.
**Prerequisite:** Phase 3b must be complete (no SKILL.md files may still reference artifactor).

### Step 5.2: Update README ✓ Complete

**Done as part of Step 1.3.** All README changes (Conventions section, artifactor retirement,
leeroyyyyy update) are executed as a single pass in Step 1.3. No separate execution needed.

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
- `atomize/ARTIFACT.md`
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
- **Planning SKILL.md references artifactor** — handled in Phase 3b as a single combined pass
  (not two separate edits to the same file)
- **Estimate has no file output** — its ARTIFACT.md defines a canonical inline format, not a
  saved file. This is an exception to the general pattern; document it clearly in the ARTIFACT.md
  itself so it's not mistakenly treated as a file-producing skill
- **Leeroyyyyy rewrite scope** — Phases 4a–4c are the most complex. The artifact handoff
  map must accurately reflect what each downstream subagent actually needs; getting this wrong
  breaks the context isolation goal
- **Phase 5 ordering** — Phase 5 (delete artifactor directory) must not run before Phase 3b
  is complete; verify leeroyyyyy/SKILL.md has no remaining artifactor references before deleting
- **Understanding as Precondition (not Phase 1)** — leeroyyyyy already has a Precondition
  section; Phases 4a–4c restore and update it. Ensure the frontmatter description and pipeline
  diagram both reflect the precondition framing, not a numbered phase

## Success Criteria

- [ ] `SKILL.spec.md` exists at project root with canonical section order and `## Artifact` invariant
- [ ] `ARTIFACT.spec.md` exists at project root with canonical meta-instruction block and template structure
- [ ] README has a Conventions section pointing to both root spec files
- [ ] Every skill with an artifact has a co-located `ARTIFACT.md` with template, naming, and trigger
- [ ] `leeroyyyyy/ARTIFACT.md` exists with `summary-statement.md` template
- [ ] Every per-skill `ARTIFACT.md` includes the meta-instruction block at the top
- [ ] `planning/SKILL.md` documents the `*.plan.md` format, progress tracking section, and
  reference to `/atomize` for plan-phase decomposition
- [ ] `produce/SKILL.md` describes `[plan]` commits at phase boundaries
- [ ] `leeroyyyyy/SKILL.md` has Understanding as a Precondition (not a pipeline phase), with Solutioning as Phase 1
- [ ] `leeroyyyyy/SKILL.md` explicitly maps artifact handoffs for all 10 pipeline phases
- [ ] `leeroyyyyy/SKILL.md` mandates subagenting for all phases unconditionally
- [ ] `leeroyyyyy/SKILL.md` pre-flight loop: min 2, max 4 cycles; abort on 4th failure; progress visible in chat
- [ ] `artifactor/` directory is deleted
- [ ] `README.md` contains no references to artifactor
- [ ] All SKILL.md files contain no stale references to artifactor
