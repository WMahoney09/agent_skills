# Plan: RAPID Rebrand

## Summary

Rebrand the skills library from the three-stage framing (Understanding → Planning → Implementation) to the five-stage RAPID workflow (Research → Align → Plan → Implement → Deliver). This is a documentation-only change: no new skills, no behavioral changes. The README gets a new structure (one-line flow, RAPID section headers, floating skills section, no more Supporting Skills section), skill frontmatter and prose get updated references, leeroyyyyy internal docs get RAPID terminology, and CLAUDE.md gets an updated checklist.

## Phases

### Phase 1a: README top section — replace diagram and intro
**Files:** `README.md`
**Changes:**
1. Replace the ASCII diagram (lines 5–27) with the one-line flow: `**RAPID flow:** Research → Align → Plan → Implement → Deliver` plus the floating skills callout block
2. Replace the intro paragraph (lines 1–3) to reference RAPID delivery workflow

**Dependencies:** none
**Success criteria:**
- README opens with the RAPID flow line instead of the old ASCII diagram
- Floating skills callout is present
- Intro paragraph references RAPID

---

### Phase 1b: README body — replace stage sections with RAPID sections
**Files:** `README.md`
**Changes:**
1. Replace `## Agentic Delivery Phases & Skills` and its three `### Stage N` subsections (lines 33–119) with five `## Letter — Name` sections:
   - `## R — Research` (goal line, `/understanding` card, `/recon` *(floating)* card)
   - `## A — Align` (goal line, `/solutioning` card, `/tire-kicking` card, `/reasoning` *(floating)* card)
   - `## P — Plan` (goal line, `/planning` card, `/pre-flight` card, `/atomize` card)
   - `## I — Implement` (goal line, `/produce` card, `/pair-on` card, `/review` card, `/triage` card, `/revise` card, `/reply` card)
   - `## D — Deliver` (goal line, manual activities list: PR, deploy, demo, feedback, acceptance)

**Dependencies:** Phase 1a
**Success criteria:**
- Five RAPID sections exist with correct skill cards
- Old `## Agentic Delivery Phases & Skills` and `### Stage N` subsections are gone

---

### Phase 1c: README cleanup — add Floating Skills, remove Supporting Skills, update Danger Zone
**Files:** `README.md`
**Changes:**
1. Add `## Floating Skills` section listing `/recon`, `/clarify`, `/reasoning`, `/estimate`, `/commit` with stage affinities where applicable
2. Remove the `## Supporting Skills` section entirely (absorbed into RAPID sections + Floating Skills)
3. Update `## Danger Zone` prose: replace "Understanding must be complete" → "Research must be complete" in the `/leeroyyyyy` description paragraph
4. Keep `## Conventions`, `## Orchestration Philosophy`, `## Meta`, `## How Skills Work`, `## Where Skills Live`, `## Portability`, `## Invocation`, `## File Structure`, `## Sources` unchanged

**Dependencies:** Phase 1b
**Success criteria:**
- Floating Skills section exists with all five floating skills
- Supporting Skills section is gone
- Danger Zone uses "Research" not "Understanding"
- Every skill in the library appears exactly once in a RAPID section (with floating annotation if applicable) OR in the Floating Skills section
- No references to old stage names ("Build A Shared Understanding", "Plan The Work", "Implement The Plan", "Stage 1/2/3") remain in README

---

### Phase 2: CLAUDE.md checklist update
**Files:** `CLAUDE.md`
**Changes:**
1. Update the README Sync Rule section:
   - Item 1: Change "Diagram (line starting with `Use anytime:`)" → "RAPID flow line and Floating Skills callout — add or remove the `/skill-name`"
   - Item 3: Change "Supporting Skills section — add an entry with the skill's description and typical usage pattern" → "RAPID stage section — add or update the skill card in the appropriate `## Letter — Name` section (or Floating Skills if the skill is stage-agnostic)"
   - Item 4: Update the duplication note about `/commit` and `/estimate` — they now appear in both Meta and Floating Skills
2. Update the checklist:
   - "README diagram updated" → "README RAPID section updated (skill card added/moved to correct stage)"
   - "README Supporting Skills section updated" → remove this item (absorbed into RAPID section update)
   - "README phase descriptions updated" → "README RAPID stage section updated (if the skill belongs to a specific stage)"

**Dependencies:** Phase 1c (README must be restructured first so CLAUDE.md references match reality)
**Success criteria:**
- CLAUDE.md checklist items reference the actual README structure (RAPID sections, floating skills, flow line)
- No references to "diagram", "Supporting Skills section" in the old sense remain

---

### Phase 3: Skill frontmatter and subtitle updates
**Files:**
- `understanding/SKILL.md` — subtitle "Discovery Phase Skill" → "Research Phase Skill"
- `solutioning/SKILL.md` — subtitle "Exploration Phase Skill" → "Align Phase Skill"
- `planning/SKILL.md` — subtitle "Architecture-to-Implementation Phase Skill" → "Plan Phase Skill"
- `produce/SKILL.md` — subtitle "Autonomous Implementation with Intelligent Commits" (no change needed — "Implementation" here is behavioral, not a stage name)
- `pair-on/SKILL.md` — subtitle "Pair Programming Implementation with User-Controlled Boundaries" (no change — behavioral)
- `pre-flight/SKILL.md` — description frontmatter: "Final check before Implementation phase begins" → "Final check before the Implement stage begins"

**Changes:**
1. `understanding/SKILL.md`:
   - Line 6: `# Understanding: Discovery Phase Skill` → `# Understanding: Research Phase Skill`
2. `solutioning/SKILL.md`:
   - Line 6: `# Solutioning: Exploration Phase Skill` → `# Solutioning: Align Phase Skill`
3. `planning/SKILL.md`:
   - Line 6: `# Planning: Architecture-to-Implementation Phase Skill` → `# Planning: Plan Phase Skill`
4. `pre-flight/SKILL.md`:
   - Frontmatter description: "Final check before Implementation phase begins" → "Final check before the Implement stage begins"

**Dependencies:** none (can run in parallel with Phase 1, but sequenced for clean commits)
**Success criteria:**
- Each updated skill's H1 title and/or frontmatter description uses RAPID stage names
- No skill subtitle references old stage framing ("Discovery Phase", "Exploration Phase", "Architecture-to-Implementation Phase")

---

### Phase 4a: Skill body prose updates — solutioning, planning, understanding
**Files:**
- `solutioning/SKILL.md`
- `planning/SKILL.md`
- `understanding/SKILL.md`

**Changes:** Replace old stage-name references in prose with RAPID equivalents. **Note:** Line numbers are orientation aids from the current file state; the executor should match by string content, not line number.

1. **`solutioning/SKILL.md`**:
   - Line 32: "Those belong in the Planning and Implementation phases" → "Those belong in the Plan and Implement stages"
   - Line 64: "constraints from the Understanding phase" → "constraints from the Research stage"
   - Line 89: "You're ready to move to Planning when:" → "You're ready to move to the Plan stage when:"
   - Line 101: "Ready to move to planning?" → "Ready to move to the Plan stage?"
   - Line 111: "move to Planning phase" → "move to the Plan stage"

2. **`planning/SKILL.md`**:
   - Line 8: "solution direction chosen during Solutioning" → "solution direction chosen during the Align stage"
   - Line 135: "In the leeroyyyyy context, Stage 1 (interactive Q&A) is automated" → keep "Stage 1" here — it refers to planning's own internal stage numbering, not the pipeline stage. No change.
   - Line 139: "You're ready to move to Implementation when" → "You're ready to move to the Implement stage when"
   - Line 153: "before we move to implementation" → "before we move to the Implement stage"
   - Line 155: "you're ready for Implementation" → "you're ready for the Implement stage"
   - Line 159: "prevents rework during implementation" → **intentional keep** — "implementation" here is behavioral language (the activity of implementing), not a pipeline stage name. No change.
   - Line 161: "go back to Solutioning" → "go back to Align (solutioning)"

3. **`understanding/SKILL.md`**:
   - Line 30: "work of the Solutioning phase" → "work of the Align stage (solutioning)"
   - Line 82: "hand off to the Exploration phase" → "hand off to the Align stage"

**Dependencies:** Phase 3 (subtitles should be updated before body prose, for clean diffs)
**Success criteria:**
- No old pipeline stage names remain in solutioning, planning, or understanding body prose
- Internal stage numbering in planning (Stage 1/2/3) is unchanged

---

### Phase 4b: Skill body prose updates — pre-flight
**Files:**
- `pre-flight/SKILL.md`

**Changes:**

1. **`pre-flight/SKILL.md`**:
   - Line 10: "catch issues before they derail work during Implementation" → "catch issues before they derail work during the Implement stage"
   - Line 22: "Provide the finalized plan from Phase 3" → "Provide the finalized plan from the Plan stage"
   - Line 24: "Decide on changes before moving to Implementation" → "Decide on changes before moving to Implement"
   - Line 36: "requirements from the Understanding phase" → "requirements from the Research stage"
   - Line 45: "constraints identified in Understanding" → "constraints identified during Research"
   - Line 90: `"Plan is ready to implement" vs. "Issues should be resolved before Implementation" vs. "Critical issues found, recommend returning to Planning"` → `"Plan is ready to implement" vs. "Issues should be resolved before the Implement stage" vs. "Critical issues found, recommend returning to the Plan stage"`
   - Line 95: "Recommend returning to the Planning phase" → "Recommend returning to the Plan stage"
   - Line 101: "ready for Implementation" → "ready for the Implement stage"
   - Line 140: "cause delays in Implementation" → "cause delays during Implement"
   - Line 141: "resolved during Implementation" → "resolved during the Implement stage"

**Dependencies:** Phase 4a
**Success criteria:**
- No old pipeline stage names remain in pre-flight body prose

---

### Phase 4c: Skill body prose updates — pair-on, produce, recon
**Files:**
- `pair-on/SKILL.md`
- `produce/SKILL.md`
- `recon/SKILL.md`

**Changes:**

1. **`pair-on/SKILL.md`**:
   - Line 10: "implementation plan from Phase 3" → "implementation plan from the Plan stage"
   - Line 167: "Ready to move to Review phase?" → "Ready to move to review?"
   - Line 169: "the workflow moves to the Review phase" → "the workflow moves to review"

2. **`produce/SKILL.md`**:
   - Line 44: "Review the plan from Phase 3" → "Review the plan from the Plan stage"

3. **`recon/SKILL.md`**:
   - Line 143: "move on to Understanding" → "move on to Research (understanding)"
   - Line 150: "Before Understanding a new problem" → "Before researching a new problem"
   - Line 153: "As part of Understanding" → "As part of Research"
   - Line 162: "surprises during Implementation" → "surprises during the Implement stage"

**Dependencies:** Phase 4b
**Success criteria:**
- No old pipeline stage names remain in pair-on, produce, or recon body prose
- Internal stage numbering within skills (e.g., planning's own "Stage 1/2/3" for its internal steps, revise's "Stage 1: Align / Stage 2: Implement") is left unchanged — those are skill-internal, not pipeline stages

---

### Phase 5: Floating skill prose updates
**Files:**
- `clarify/SKILL.md`
- `reasoning/SKILL.md`
- `tire-kicking/SKILL.md`

**Changes:**

1. **`clarify/SKILL.md`**:
   - Line 101: "for Recon and Understanding phases" → "for Research and Align stages"
   - Line 105: "for Solutioning and beyond" → "for Align (solutioning) and beyond"
   - Line 109: "discovery phases" → "research phases" (lowercase "discovery" referred to the old Discovery Phase stage name; "research" aligns with the RAPID Research stage)

2. **`reasoning/SKILL.md`**:
   - No changes to "Solutioning" references — reasoning explicitly names the `/solutioning` skill, not the old pipeline stage. "Solutioning" in reasoning's prose refers to the skill/activity, which is correct. Similarly "Understanding" refers to the `/understanding` skill. These are skill names, not stage names, and should stay.
   - Verify: all references are to skill names or activities, not pipeline stage names. No changes needed.

3. **`tire-kicking/SKILL.md`**:
   - Line 8: "It sits after Solutioning (we have a direction) and before or alongside Planning (we lock the plan)" → "It sits after Align (we have a direction) and before or alongside Plan (we lock the plan)"
   - Line 75: "Not Understanding" → "Not Research"
   - Line 76: "Not Solutioning" → "Not Align"
   - Line 77: "Not Implementation" → "Not Implement"
   - Line 101: "move to implementation" → "move to the Implement stage"

**Dependencies:** Phase 4c (keep all skill prose updates sequential for clean commits)
**Success criteria:**
- Floating skills use RAPID stage names when referring to pipeline stages
- Skill names (e.g., `/solutioning`, `/understanding`) remain unchanged — only pipeline stage references are updated

---

### Phase 6: leeroyyyyy internal documentation
**Files:** `leeroyyyyy/SKILL.md`

**Changes:** Update pipeline stage references to use RAPID terminology while preserving the numbered phase structure (Phase 1–10) which is leeroyyyyy-internal.

1. Frontmatter description: "Precondition: Understanding complete" → "Precondition: Research complete"
2. Line 15: "picks up where Understanding left off" → "picks up where Research left off"
3. Line 19 (Precondition): "Understanding must be complete" → "Research must be complete" / "Understanding requires user dialogue" → "Research requires user dialogue" / "invoke `/understanding` first" stays (skill name)
4. Line 76: Same pattern — "Understanding requires user dialogue" → "Research requires user dialogue"
5. Pipeline diagram (lines 24–43): Replace "Solutioning" label with "Align (Solutioning)" — actually, keep the pipeline diagram as-is since it names the skills/activities, not the RAPID stages. The diagram says "Solutioning ← produce 2-3 candidate solutions" which is the activity label. No change.
6. Artifact Handoff Map: "Solutioning" in the Phase column → keep as-is (these are activity names matching the skill invocations)
7. Line 95 heading "## Phase 1: Solutioning" → keep as-is (leeroyyyyy's internal phase naming)
8. Line 104 chat report: "Solutioning complete" → keep as-is (reporting on the activity)
9. Line 115: "This record becomes the primary input to Phase 3" → keep (leeroyyyyy-internal numbering)
10. Line 123: "## Phase 3: Reasoning — Pick a Solution" → keep (leeroyyyyy-internal)
11. Line 299: "Understanding is the one stage leeroyyyyy does not own" → "Research is the one stage leeroyyyyy does not own"
12. Line 299: "Everything from Solutioning onward" → "Everything from Align onward"
13. Line 311: "applying the constraints from Understanding" → "applying the constraints from Research"

**Rule:** References to the pipeline stage that precedes leeroyyyyy (the user-driven stage) change from "Understanding" to "Research". References to skill names (`/understanding`, `/solutioning`) and leeroyyyyy-internal phase labels (Phase 1: Solutioning, etc.) stay unchanged. The distinction: if it names what the user must have done before invoking leeroyyyyy, it is a RAPID stage reference and gets updated. If it names the activity the agent performs within the pipeline, it stays.

**Dependencies:** none (can run in parallel with Phases 3–5, but sequenced for commit clarity)
**Success criteria:**
- leeroyyyyy's precondition and autonomy sections use "Research" for the RAPID stage
- leeroyyyyy's internal pipeline phases, activity labels, skill names, and handoff map are unchanged
- The distinction between RAPID stage names and skill/activity names is preserved

---

### Phase 7: Final validation sweep
**Files:** all SKILL.md files, README.md, CLAUDE.md
**Changes:** No file edits expected. This is a grep-based validation pass.

1. Grep all `*.md` files for old stage names: "Build A Shared Understanding", "Plan The Work", "Implement The Plan", "Stage 1:" / "Stage 2:" / "Stage 3:" (in README context only), "Discovery Phase", "Exploration Phase"
2. Grep for "Understanding phase", "Solutioning phase", "Planning phase", "Implementation phase" — any hits that are pipeline-stage references (not skill-internal) are bugs
3. Verify README structure: one-line flow present, five RAPID sections present, Floating Skills section present, no Supporting Skills section
4. Verify CLAUDE.md checklist matches README structure

**Dependencies:** Phases 1a–6 all complete
**Success criteria:**
- Zero hits for old pipeline stage names in README
- Zero hits for old pipeline stage names in SKILL.md files (excluding skill-internal stage numbering in planning, revise, and produce). Expected false positives for "Stage 1/2/3" grep: `planning/SKILL.md` (internal Stage 1/2/3 steps), `revise/SKILL.md` ("Stage 1: Align / Stage 2: Implement" internal phases), `produce/SKILL.md` (internal phase references). These are skill-internal numbering and must be left unchanged.
- CLAUDE.md checklist accurately describes the README structure

## Progress
- [ ] Phase 1a: README top section — replace diagram and intro
- [ ] Phase 1b: README body — replace stage sections with RAPID sections
- [ ] Phase 1c: README cleanup — add Floating Skills, remove Supporting Skills, update Danger Zone
- [ ] Phase 2: CLAUDE.md checklist update
- [ ] Phase 3: Skill frontmatter and subtitle updates
- [ ] Phase 4a: Skill body prose updates — solutioning, planning, understanding
- [ ] Phase 4b: Skill body prose updates — pre-flight
- [ ] Phase 4c: Skill body prose updates — pair-on, produce, recon
- [ ] Phase 5: Floating skill prose updates
- [ ] Phase 6: leeroyyyyy internal documentation
- [ ] Phase 7: Final validation sweep
