# Artifact Capture, Subagent Orchestration & Plan Progress Tracking

## Overview

Introduce a co-located `ARTIFACT.md` per skill that defines the output template, naming
convention, and save location for that skill's phase artifact. Retire the `artifactor` skill,
absorbing its path-convention guidance into each `ARTIFACT.md`. Update the `planning` skill to
produce a portable `*.plan.md` format. Update `produce` to write progress back to the plan file
at phase boundaries via `[plan]` commits. Rewrite `leeroyyyyy` as a thin orchestrator that
dispatches subagents with targeted artifact handoffs and mandates subagenting for any plan phase
with LOE > 2.

## Notes

- **Out of scope:** `/capture` skill, Issue #2 Roadmapping (`.claude/work/` bootstrapping),
  changes to `recon`, `clarify`, `revise`, `pair-on`, `reply`
- **Artifactor** is retired as part of this work — its guidance is absorbed into each `ARTIFACT.md`
- **Storage convention:** all artifacts live in `.claude/work/<work-item>/` at the nearest project
  root. `understanding` creates the subdirectory using a slugified problem statement name.
- **Plan file format** (`*.plan.md`): Phase → Step → Task breakdown, overview + notes at top,
  progress tracking section updated by `produce` at the phase level
- **Skills without artifacts:** `recon`, `clarify`, `revise`, `pair-on`, `produce`, `reply`
  (no `ARTIFACT.md` needed — absence is sufficient)
- **Parallel subagenting in produce:** concurrent phase subagents each update only their phase
  row in the progress section of the plan file, avoiding conflicts

## Progress

- [ ] Phase 1: Create all ARTIFACT.md files
- [ ] Phase 2: Update SKILL.md files
- [ ] Phase 3: Rewrite leeroyyyyy SKILL.md
- [ ] Phase 4: Retire artifactor + update README

---

## Phase 1: Create all ARTIFACT.md files

Each file is independent — all can be created in parallel.

Every `ARTIFACT.md` must include a meta-instruction block at the top covering:
- Storage convention: save to `.claude/work/<work-item>/` at nearest project root
- Naming convention: filename defined per-skill below
- When to generate: the trigger condition for this skill

### Step 1.1: understanding/ARTIFACT.md

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

### Step 1.2: solutioning/ARTIFACT.md

**Output file:** `solution-statement.md`

Template sections:
- Chosen approach (name + 1–2 sentence description)
- Why this approach was selected (key evidence from tire-kicking and reasoning)
- Tradeoffs accepted
- Approaches considered and rejected (brief — name + one-liner reason)
- LOE score

**Trigger:** When a solution is confirmed and the phase closes.

### Step 1.3: tire-kicking/ARTIFACT.md

**Output file:** `tire-kicking-report.md`

Extract the artifact definition already implicit in the tire-kicking skill into a formal template.

Template sections:
- Candidates evaluated
- Scenarios tested (per candidate: holds / bends / leaks classification)
- Summary of bends and leaks per approach
- Comparative verdict

**Trigger:** When all candidates have been stress-tested and the report is complete.

### Step 1.4: reasoning/ARTIFACT.md

**Output file:** `truth-and-vector.md`

Template sections:
- Truths established (numbered list of confirmed facts / non-negotiables)
- Conditionals (things that are true given a specific context or assumption)
- Directional vector (1–3 sentences: where this reasoning points and why)

**Trigger:** When the reasoning pass is complete and a direction has been established.

### Step 1.5: planning/ARTIFACT.md

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

### Step 1.6: pre-flight/ARTIFACT.md

**Output file:** `pre-flight-issues.md`

Template sections:
- Issues found (each with: What / Where / Impact / Suggestion)
  - Critical issues
  - Major issues
  - Minor issues
- Opportunities identified
- Confidence level: Ready / Issues to resolve / Return to Planning

**Trigger:** At the end of each pre-flight cycle. File is overwritten each cycle (latest state wins).

### Step 1.7: review/ARTIFACT.md

**Output file:** `review-issues.md`

Template sections:
- Issues found (same structure as pre-flight: Critical / Major / Minor)
- Each issue: What / Where / Severity / Suggestion
- Go / No-go recommendation

**Trigger:** When the review pass is complete.

### Step 1.8: triage/ARTIFACT.md

**Output file:** `triage-report.md`

Template sections:
- Critical revisions (grouped, with revision ID and description)
- Major revisions
- Minor revisions
- Deferred / out of scope items

**Trigger:** When triage groupings are finalized.

### Step 1.9: estimate/ARTIFACT.md

**Output file:** Inline — estimate output is produced in-context (not saved to a file).

The ARTIFACT.md defines the canonical output format:
```
LOE: <1–5>
Complexity: <Low|Medium|High> | Impact: <Low|Medium|High>
<1–5 sentence rationale explaining the synthesis, especially when dimensions diverge>
```

**Trigger:** Whenever an estimate is requested. Output is always inline.
**Note:** No file is written — estimate's artifact is its formatted output, used inline by the
requester (e.g., leeroyyyyy uses it to decide whether to subagent a phase).

### Step 1.10: leeroyyyyy/ARTIFACT.md

**Output file:** `summary-statement.md`

Template sections:
- Summary (1–8 sentences: what was built, what changed, overall outcome)
- Phases executed (bulleted list, one line each)
- Out-of-scope items (as noted in the plan file)
- Items requiring user attention (unresolved revisions, escalations)

**Trigger:** When the full pipeline completes (after all Critical/Major revisions are addressed).

---

## Phase 2: Update SKILL.md files

Depends on Phase 1. Steps within this phase are independent and can be parallelized.

### Step 2.1: Add `## Artifact` section to each skill with an ARTIFACT.md

For each of the 10 skills (understanding, solutioning, tire-kicking, reasoning, planning,
pre-flight, review, triage, estimate, leeroyyyyy):

Add a brief `## Artifact` section near the end of `SKILL.md`:
- One line stating what artifact this skill produces
- Reference to `ARTIFACT.md` for the full template
- The trigger condition (when to generate)

Keep it short — the detail lives in `ARTIFACT.md`.

### Step 2.2: Update planning/SKILL.md for portable plan format

- Remove reference to `artifactor` skill (it's being retired)
- Add explicit guidance on the `*.plan.md` format: Phase → Step → Task breakdown
- Document the progress tracking section and note that `produce` owns updating it
- Clarify that plan file naming follows `<work-item>.plan.md`
- In leeroyyyyy context: Stage 1 (interactive Q&A) is automated — the agent uses recon
  rather than asking the user

### Step 2.3: Update produce/SKILL.md for phase-boundary progress tracking

- Add Phase-boundary checkpoint behavior:
  - After completing each plan phase, update the plan file's progress section
  - Mark the phase row as complete: `- [x] Phase N: <name>`
  - Add a deviation note inline if the phase deviated from plan
  - Commit the plan file update as a `[plan]` commit before moving to the next phase
- Add subagent context note: produce subagents receive only the plan file — not full
  conversation history
- Add parallel subagent note: concurrent phase subagents update only their own progress row

### Step 2.4: Remove artifactor references from all SKILL.md files

Scan all SKILL.md files for references to `artifactor` skill. Replace with inline convention:
"Save artifacts to `.claude/work/<work-item>/` at the nearest project root."

Primary file to update: `planning/SKILL.md` (already handled in Step 2.2).
Check all others for stray references.

---

## Phase 3: Rewrite leeroyyyyy/SKILL.md

Depends on Phase 1 (needs to know what artifacts each phase produces).
Can be written in parallel with Phase 2.

### Step 3.1: Establish the Context Management Principle

Add a prominent section (early in the file) establishing subagent dispatch as the
default strategy:

- Context is a finite resource — treat it as such
- Every phase handoff is a context boundary: pass artifact files, not conversation history
- Any plan phase with LOE > 2 **must** be subagented (non-negotiable)
- For pre-plan phases (solutioning, tire-kicking, reasoning, recon), use `estimate` to
  determine whether subagenting is warranted — err toward subagenting
- Concurrent phase work: multiple subagents may run in parallel; each receives only the
  artifacts it needs

### Step 3.2: Define the artifact handoff map per phase

For each pipeline phase, document explicitly:
- Input artifacts (what the subagent/agent receives)
- Output artifact (what it produces)
- Subagent rule (mandatory if LOE > 2 / estimate-gated / always inline)

| Phase | Input artifacts | Output artifact | Subagent rule |
|---|---|---|---|
| Solutioning | problem-statement.md | solution-statement.md | estimate-gated |
| Tire-kicking | problem-statement.md, solution-statement.md (all candidates) | tire-kicking-report.md | estimate-gated |
| Reasoning | tire-kicking-report.md, recon findings (inline) | truth-and-vector.md | estimate-gated |
| Planning | solution-statement.md, truth-and-vector.md | *.plan.md | estimate-gated |
| Pre-flight | *.plan.md, solution-statement.md | pre-flight-issues.md | estimate-gated |
| Produce (per phase) | *.plan.md only | progress update in plan file | LOE > 2 → mandatory |
| Review | local diff | review-issues.md | estimate-gated |
| Triage | review-issues.md | triage-report.md | estimate-gated |
| Revise | triage-report.md, *.plan.md | commits | estimate-gated |

### Step 3.3: Rewrite the pipeline section

Rewrite each phase's prose in leeroyyyyy to:
- Be explicit about what artifacts it passes to that phase
- Call out when to invoke estimate and how to act on the result
- Remove any language that implies holding full conversation context across phase boundaries
- Reinforce that leeroyyyyy is orchestration only — it does not implement artifact logic itself

### Step 3.4: Strengthen the autonomy principle

Rewrite the Autonomy Principle section to make clear:
- The user↔agent back-and-forth that standalone skills expect is automated here
- Leeroyyyyy uses reasoning, recon, and subagents in place of user input
- This is the one sanctioned exception to skills' behavioral consistency

---

## Phase 4: Retire artifactor + Update README

Steps are independent and can be parallelized.

### Step 4.1: Remove artifactor skill directory

Delete `/Users/will/agentic/skills/artifactor/` and its contents.

### Step 4.2: Update README

- Remove `artifactor` from the diagram (Use anytime section)
- Remove `artifactor` from the Meta section
- Remove `artifactor` from the Supporting Skills section
- Update `planning` skill description to remove reference to artifactor
- Add note in Contributing section (if present) that new skills requiring artifact output
  should include a co-located `ARTIFACT.md`
- Update `leeroyyyyy` description if needed to reflect subagent orchestration

---

## Critical Files

**Created:**
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
- `artifactor/ARTIFACT.md` (if exists)
- `artifactor/SKILL.md`
- `artifactor/` directory

---

## Gotchas & Risks

- **Tire-kicking already has implicit artifact behavior** — need to read it carefully before
  writing its ARTIFACT.md to avoid contradiction or duplication
- **Planning SKILL.md references artifactor** — must update Stage 3 guidance in tandem with
  retiring artifactor (Steps 2.2 and 4.1 must coordinate)
- **Estimate has no file output** — its ARTIFACT.md defines a canonical inline format, not a
  saved file. This is an exception to the general pattern; document it clearly in the ARTIFACT.md
  itself so it's not mistakenly treated as a file-producing skill
- **Leeroyyyyy rewrite scope** — Phase 3 is the most complex single phase. The artifact handoff
  map must accurately reflect what each downstream subagent actually needs; getting this wrong
  breaks the context isolation goal
- **Concurrent subagent plan file updates** — parallel produce subagents both write to the plan
  file. The constraint (each updates only its own progress row) must be explicit in both
  produce/SKILL.md and leeroyyyyy/SKILL.md

## Success Criteria

- [ ] Every skill with an artifact has a co-located `ARTIFACT.md` with template, naming, and trigger
- [ ] Every `ARTIFACT.md` includes the storage meta-instruction at the top
- [ ] `planning/SKILL.md` documents the `*.plan.md` format and progress tracking section
- [ ] `produce/SKILL.md` describes `[plan]` commits at phase boundaries
- [ ] `leeroyyyyy/SKILL.md` explicitly maps artifact handoffs for all 9 pipeline phases
- [ ] `leeroyyyyy/SKILL.md` mandates subagenting for LOE > 2 plan phases and estimate-gates all others
- [ ] `artifactor/` directory is deleted
- [ ] `README.md` contains no references to artifactor and accurately reflects all new skills
- [ ] All SKILL.md files contain no stale references to artifactor
