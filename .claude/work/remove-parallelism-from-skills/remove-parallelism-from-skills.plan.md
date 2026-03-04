# Remove Workflow Parallelism from Skills Library

## Overview

Replace all orchestration-level parallelism guidance across the skills library with the
sequential subagent philosophy: subagents are a context isolation tool, not a throughput
optimization. Sequential execution is the unconditional standard. Concurrent tool calls
within a single agent response are out of scope and unaffected.

Seven files require changes. The README also gains a canonical Orchestration Philosophy
section as a durable library-level reference.

## Notes

- **Out of scope:** Concurrent tool calls within a single agent response; code-level
  references to "concurrent access" in `review` and "concurrent requests" in `recon`
- **Companion plan:** The artifact-capture plan must be amended to remove parallelism
  guidance introduced during its authoring — this is Phase 5
- **Replacement framing:** "Can be parallelized" → "can be executed in any order" where
  the independence information is useful to preserve; pure parallelism advocacy is removed
  without replacement

## Progress

- [x] Phase 1: README — Orchestration Philosophy + inline cleanup
- [x] Phase 2: produce/SKILL.md — remove parallel execution guidance
- [x] Phase 3: pre-flight/SKILL.md — replace parallelization rubric with simplification rubric
- [x] Phase 4: planning, atomize, leeroyyyyy — minor single-reference updates
- [x] Phase 5: Amend artifact-capture plan

---

## Phase 1: README — Orchestration Philosophy + inline cleanup

Single pass over `README.md`. All changes are independent within the file.

**Output file:** `README.md`

### Step 1.1: Add Orchestration Philosophy section

Add a new `## Orchestration Philosophy` section to the README. Placement: after the
pipeline stage descriptions, before any appendix or notes content.

Content to include:
- **Subagents are a context management tool, not a speed optimization.** Every subagent
  dispatch is a context boundary — the invoking agent hands off a committed artifact file,
  not conversation history.
- **Sequential execution is the standard.** Phases and subagents run one at a time.
  Concurrent subagent dispatch is not a goal and introduces coordination risk (git index
  conflicts, file write races, ambiguous commit ownership).
- **Commits are the handoff mechanism.** Each phase produces a committed artifact before
  the next phase begins. Subagents read committed files, never conversation context.
- **Independence ≠ concurrency.** Noting that two steps are independent means they can be
  executed in any order — not that they should run simultaneously.
- Concurrent tool calls within a single agent response (e.g., reading multiple files at
  once) are fine and unaffected by this principle.

### Step 1.2: Remove inline parallelism references

Two targeted edits:

- **Line ~60** (pre-flight description): `"Recommend parallelization or simplification"`
  → `"Recommend simplification"`
- **Line ~85** (produce/Option B description): `"Agent chooses work order and
  parallelization strategy"` → `"Agent chooses work order and commit strategy"`

---

## Phase 2: produce/SKILL.md — remove parallel execution guidance

**Output file:** `produce/SKILL.md`

### Step 2.1: Update work order description

- `"Choosing which units to execute and in what order (including parallelization where
  beneficial)"` → `"Choosing which units to execute and in what order"`

### Step 2.2: Update Plan Analysis phase

- `"Determine execution strategy based on dependencies and parallelization opportunities"`
  → `"Determine execution order based on dependencies"`
- `"Look for parallelizable work"` → remove this bullet

### Step 2.3: Remove Parallel Execution section

Remove the `#### Parallel Execution` section and its content entirely. Replace with a
brief note affirming sequential dispatch:

> **Sequential Execution is the Standard**
> Every phase runs to completion before the next begins. This is intentional — context
> isolation over throughput. Independence between phases means they can run in any order,
> not that they should run simultaneously.

### Step 2.4: Update Notes section

- `"Parallel execution of decoupled work is encouraged for efficiency"` → remove entirely

---

## Phase 3: pre-flight/SKILL.md — replace parallelization rubric with simplification rubric

Most complex change. Pre-flight actively rewards parallelization as a quality signal;
the entire framing of that category needs to shift.

**Output file:** `pre-flight/SKILL.md`

### Step 3.1: Update Goal / Opportunities category

- `"Ways to parallelize work, simplify steps, or reduce complexity"` →
  `"Ways to simplify steps, reduce complexity, or clarify sequencing"`

### Step 3.2: Update Opportunities for Optimization checklist

Remove parallelization questions; replace with simplification equivalents:

**Remove:**
- `"Are there steps that could be parallelized but are listed sequentially?"`
- `"Could the phases be reordered to unlock earlier parallelization?"`

**Replace with:**
- `"Are there steps that could be simplified or combined without losing clarity?"`
- `"Could the phases be reordered to reduce dependencies or unblock earlier work?"`

### Step 3.3: Update Minor severity description

- `"Possible optimizations or parallelization opportunities"` →
  `"Possible simplifications or sequencing improvements"`

### Step 3.4: Update closing Notes

- `"An optimized plan (parallelized, simplified) is better than a correct-but-inefficient
  one."` → `"A simplified, well-sequenced plan is better than a correct-but-over-engineered
  one."`

---

## Phase 4: planning, atomize, leeroyyyyy — minor single-reference updates

All three files have one parallelism reference each. Independent edits.

**Output files:** `planning/SKILL.md`, `atomize/SKILL.md`, `leeroyyyyy/SKILL.md`

### Step 4.1: planning/SKILL.md

- `"Make clear what must be done in sequence vs. what can be parallelized."` →
  `"Make clear what must be done in sequence and what ordering dependencies exist."`

### Step 4.2: atomize/SKILL.md

- `"If two subphases can run in parallel, say so explicitly. If they cannot, document the
  dependency."` → `"If subphases are independent, note the ordering flexibility explicitly.
  If they are dependent, document the dependency."`

### Step 4.3: leeroyyyyy/SKILL.md

- `"The agent manages work order, parallelization strategy, and git history."` →
  `"The agent manages work order and git history."`

---

## Phase 5: Amend artifact-capture plan

**Output file:**
`.claude/work/artifact-capture-and-subagent-orchestration/artifact-capture-and-subagent-orchestration.plan.md`

### Step 5.1: Remove parallel subagenting note from Notes section

Remove the bullet:
> `**Parallel subagenting in produce:** concurrent phase subagents each update only their
> phase row in the progress section of the plan file, avoiding conflicts`

### Step 5.2: Replace "can be parallelized" phase notes

Five occurrences where a phase notes its steps are independent and can be parallelized.
Replace each with: `"Steps are independent and can be executed in any order."`

Locations:
- Phase 1 header note (line 71)
- Phase 2a header note (line 161)
- Phase 2b header note (line 226)
- Phase 2c header note (line 300)
- Phase 3a header note (line 360)

### Step 5.3: Remove concurrent subagent guidance from Step 3b.2

In Step 3b.2 (Update produce/SKILL.md), remove:
> `"Add parallel subagent note: concurrent phase subagents update only their own progress row"`

### Step 5.4: Remove concurrent subagent guidance from Phase 4a

In Step 4a.1, remove the bullet:
> `"Concurrent phase work: multiple subagents may run in parallel; each receives only the
> artifacts it needs"`

In the artifact handoff map note for the Produce row, remove any reference to concurrent
or parallel subagents.

### Step 5.5: Remove concurrent subagent gotcha

In the Gotchas & Risks section, remove:
> `**Concurrent subagent plan file updates** — parallel produce subagents both write to
> the plan file. The constraint (each updates only its own progress row) must be explicit
> in both produce/SKILL.md and leeroyyyyy/SKILL.md`

---

## Critical Files

**Modified:**
- `README.md`
- `produce/SKILL.md`
- `pre-flight/SKILL.md`
- `planning/SKILL.md`
- `atomize/SKILL.md`
- `leeroyyyyy/SKILL.md`
- `.claude/work/artifact-capture-and-subagent-orchestration/artifact-capture-and-subagent-orchestration.plan.md`

**Created:** none
**Deleted:** none

---

## Gotchas & Risks

- **"Independent" ≠ "parallel"** — Preserve the independence information in the companion
  plan (it tells produce what order constraints exist) but strip the concurrency implication.
  The replacement phrase "can be executed in any order" carries the right meaning.
- **pre-flight is the highest-risk edit** — It doesn't just mention parallelization; it
  actively uses it as a positive quality signal. The replacement rubric must feel complete,
  not like something was deleted. Read the full section before editing.
- **leeroyyyyy/SKILL.md** — Only one reference in the file is targeted here. Phases 4a–4c
  of the companion workstream will rewrite this file more broadly. Don't over-edit it now.
- **Companion plan Step 3b.2** — This step instructs produce to add a parallel subagent
  note. Removing that instruction here means the companion workstream's implementation will
  not add it. Confirm the removal is clean and doesn't leave a dangling reference elsewhere
  in that plan.

## Success Criteria

- [ ] README has an Orchestration Philosophy section stating the sequential subagent principle
- [ ] No skill recommends or encourages parallel workflow execution at the orchestration level
- [ ] pre-flight's Opportunities category promotes simplification, not parallelization
- [ ] produce's Parallel Execution section is replaced with sequential execution note
- [ ] atomize notes ordering flexibility, not concurrency
- [ ] Artifact-capture plan contains no parallelism guidance
- [ ] All "can be parallelized" phrases in the companion plan read "can be executed in any order"
