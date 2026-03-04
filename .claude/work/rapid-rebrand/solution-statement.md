# Solution Statement: RAPID Rebrand

## Inventory of Changes

Before evaluating approaches, here is what actually needs to change:

**README.md:**
- ASCII diagram: 3-column → 5-column (or alternative layout)
- Stage headers: "Stage 1: Build A Shared Understanding" → "Research", "Stage 2: Plan The Work" → "Plan", "Stage 3: Implement The Plan" → "Implement", plus new "Align" and "Deliver"
- Skill listings under each stage
- Floating skills line ("Use anytime")
- Prose references to old stage names throughout

**Skill frontmatter (18 files):** No `stage:` key exists in any frontmatter today. References to stages are in prose (`description` field and body text), not structured metadata. This significantly reduces the mechanical work.

**Skill body text with stage references (files that mention old stage names in prose):**
- `solutioning/SKILL.md` — "Planning and Implementation phases", "Understanding phase"
- `pre-flight/SKILL.md` — "Implementation phase", "Understanding phase", "Planning phase"
- `planning/SKILL.md` — "Stage 1", "Stage 2", "Stage 3" (internal to planning's own workflow — these are NOT pipeline stages)
- `clarify/SKILL.md` — "Understanding phases"
- `pair-on/SKILL.md` — "Phase 3" (referring to old Stage 3)
- `produce/SKILL.md` — "Phase 3" (referring to old Stage 3)
- `recon/SKILL.md` — internal phases (not pipeline stages)
- `leeroyyyyy/SKILL.md` — extensive pipeline phase references (Phase 1-10)

**Key distinction:** Many skills use "Phase N" or "Stage N" internally for their own multi-step workflows (planning has Stage 1/2/3, recon has Phase 1/2/3, pair-on has Phase 1/2/3). These are internal to the skill and should NOT be renamed. Only references to the overall pipeline stages need updating.

---

## Candidate A: In-Place Rename with 5-Column Diagram

### Description

Direct, minimal rebrand. Replace all three-stage references with five-stage RAPID terminology throughout. The ASCII diagram expands from 3 columns to 5 columns. Each RAPID stage gets its own section header in the README with skill listings underneath.

**README structure:**
```
RAPID DELIVERY WORKFLOW
R: Research    A: Align    P: Plan    I: Implement    D: Deliver
```
- 5-column ASCII diagram mapping skills to stages
- Five `### Stage` sections replacing the current three
- Floating skills remain on a "Use anytime" line below the diagram
- Deliver section lists manual activities (PR, deploy, demo, feedback, acceptance) with no skill links
- Meta, Supporting Skills, Orchestration Philosophy, and lower sections stay as-is with prose updates

**Skill updates:**
- Update prose references in ~6 skill files where they mention pipeline stage names (solutioning, pre-flight, clarify, pair-on, produce, leeroyyyyy)
- Leave internal "Phase N" / "Stage N" references alone when they refer to a skill's own internal workflow
- leeroyyyyy gets the most extensive update: its pipeline section headers and description use old stage names

**RAPID mapping:**
| RAPID Stage | Skills |
|---|---|
| Research | /understanding, /recon (stage-bound usage) |
| Align | /solutioning, /tire-kicking, /reasoning (stage-bound usage) |
| Plan | /planning, /pre-flight, /atomize |
| Implement | /produce, /pair-on, /review, /triage, /revise, /reply |
| Deliver | (manual activities, no skills) |
| Floating | /recon, /clarify, /reasoning, /estimate, /commit |

### Tradeoffs

**Pros:**
- Simplest conceptual change — same structure, more columns
- Familiar layout for anyone who read the old README
- Minimal risk of breaking skill behavior since no behavioral changes

**Cons:**
- 5-column ASCII diagram will be very wide and may not render well in narrow terminals or GitHub mobile
- The diagram may feel cramped if skill names don't fit neatly
- Some skills appear in both a stage column and the floating line (recon, reasoning) — the diagram alone doesn't communicate this clearly
- Deliver column would be empty of skill boxes, creating visual asymmetry

**LOE: 2** — Mostly find-and-replace with some judgment calls on prose wording. The diagram is the hardest part.

**Risk: Low.** The main risk is the 5-column diagram rendering poorly. If it doesn't fit, it degrades the newcomer experience rather than improving it.

---

## Candidate B: Two-Tier Layout — RAPID Banner + Grouped Detail Sections

### Description

Replace the single ASCII diagram with a two-tier layout: a compact RAPID banner at the top showing the flow, followed by detailed sections below. This avoids the 5-column width problem entirely.

**README structure:**

Tier 1 — RAPID flow banner (compact, always fits):
```
╔═══════════╦═══════════╦═══════════╦═══════════╦═══════════╗
║  RESEARCH  ║   ALIGN   ║   PLAN    ║ IMPLEMENT ║  DELIVER  ║
╠═══════════╬═══════════╬═══════════╬═══════════╬═══════════╣
║ understand ║ solution  ║ planning  ║ produce   ║ (manual)  ║
║            ║ tire-kick ║ preflight ║ pair-on   ║           ║
║            ║           ║ atomize   ║ review    ║           ║
║            ║           ║           ║ triage    ║           ║
║            ║           ║           ║ revise    ║           ║
║            ║           ║           ║ reply     ║           ║
╚═══════════╩═══════════╩═══════════╩═══════════╩═══════════╝

  Floating (any stage):  /recon  /clarify  /reasoning  /estimate  /commit
```

Tier 2 — Detailed sections, one per RAPID stage:
```
### Research
### Align
### Plan
### Implement
### Deliver
```

Each section has its goal statement, step descriptions, and skill links (identical content to current Stage sections, just reorganized). The Deliver section describes manual activities.

**Floating vs stage-bound:** Handled via the "Floating" line under the banner. Skills like `/recon` and `/reasoning` that have a primary stage affinity but can be used anywhere appear in their primary stage column AND on the floating line. A brief note under the banner explains: "Floating skills have stage affinities shown above but can be invoked at any point."

**Skill updates:** Same scope as Candidate A — update prose references in ~6 skill files.

### Tradeoffs

**Pros:**
- The compact banner is immediately scannable — newcomers see the full RAPID flow at a glance
- No width problem: 5 equal columns of ~11 chars each fit easily
- Dual presence of floating skills is visually communicated
- Deliver stage has a column even if it's thin, maintaining the RAPID shape
- The banner + detail pattern scales if stages gain more skills later

**Cons:**
- More structural change to the README than Candidate A (reorganizing sections, not just renaming headers)
- The existing three-stage sections have carefully written prose that needs redistribution across five sections — some of this is non-trivial (e.g., the Understanding section's closure work maps to Align, not Research)
- Two representations of the same information (banner + detail sections) could drift if maintained carelessly

**LOE: 3** — The banner design is straightforward, but redistributing the existing stage prose across five sections requires judgment. Some content currently in "Build A Shared Understanding" needs to be split between Research and Align.

**Risk: Low-Medium.** The main risk is getting the prose redistribution wrong — putting content in the wrong RAPID stage. The problem statement flags that `/understanding` touches both Research and Align, which means the current single section needs careful splitting.

---

## Candidate C: RAPID Acronym as Organizing Spine with Inline Skill Cards

### Description

Restructure the README around the RAPID acronym itself as the primary organizing element. Instead of a diagram followed by separate sections, each letter of RAPID becomes a section header with an inline "skill card" format that combines the diagram information and the detail prose into one pass.

**README structure:**

A brief intro paragraph, then:

```
## R — Research

> Goal: Understand the problem space before proposing solutions.

**`/understanding`** — Build shared understanding through discovery...
**`/recon`** *(also floating)* — Read-only investigation of code and docs...

## A — Align

> Goal: Converge on a solution direction with evidence.

**`/solutioning`** — Explore 2-3 approaches and their tradeoffs...
**`/tire-kicking`** — Stress-test candidates against scenarios...

## P — Plan

> ...

## I — Implement

> ...

## D — Deliver

> Goal: Ship the work and close the loop.

No automation skills yet. Manual activities:
- Open a pull request
- Deploy to staging/production
- Demonstrate to stakeholders
- Gather feedback
- Confirm acceptance
```

Then a separate section:

```
## Floating Skills

These skills can be used at any stage...
/recon, /clarify, /reasoning, /estimate, /commit
```

No ASCII diagram at all — the structure IS the diagram. The RAPID acronym headings, rendered in sequence, communicate the flow.

**Skill updates:** Same scope as other candidates for skill file prose updates.

### Tradeoffs

**Pros:**
- Most readable for newcomers — the document reads top-to-bottom as a narrative
- No diagram rendering issues (no ASCII art to break)
- Each skill appears exactly once in its primary context, reducing confusion about where it "lives"
- Floating skills get their own section with clear explanation
- Deliver stage feels natural as a section rather than an empty diagram column
- Easiest to maintain going forward — adding a skill means adding a line to a section

**Cons:**
- Loses the at-a-glance visual overview that the ASCII diagram provides — the current README's diagram is arguably its most distinctive feature
- The "Supporting Skills" section at the bottom of the README has detailed descriptions for each skill; this approach moves some of that info up into the RAPID sections, creating potential duplication or requiring the Supporting Skills section to change role
- Biggest structural departure from current README — higher review burden
- Without any diagram, someone skimming the README might miss the RAPID flow entirely

**LOE: 3** — Similar to Candidate B in total work, but the nature of the work differs. Less diagram design, more prose reorganization. The Supporting Skills section needs rethinking to avoid duplication.

**Risk: Medium.** The biggest risk is that removing the ASCII diagram makes the document feel less distinctive and harder to scan. The current diagram is a strong visual anchor. A secondary risk is that merging skill descriptions into RAPID sections creates duplication with the Supporting Skills section, requiring a decision about whether to keep, consolidate, or restructure that section.

---

## Cross-Cutting Observations

### Deliver stage across all candidates
All three candidates treat Deliver the same way: enumerate manual activities, note that no `/deliver` skill exists yet, keep it thin. This is straightforward regardless of approach chosen.

### Floating skills across all candidates
The problem statement lists floating skills as: `/clarify`, `/estimate`, `/recon`, `/reasoning`, `/commit`. All candidates need to handle the dual nature of `/recon` (primary affinity to Research, but usable anywhere) and `/reasoning` (primary affinity to Align, but usable anywhere). The problem statement says this overlap is acceptable for `/understanding` touching both Research and Align.

### leeroyyyyy across all candidates
leeroyyyyy's internal pipeline (Phase 1-10) uses its own numbering that is independent of the RAPID stage names. The phases map roughly as: Phases 1-3 = Align, Phase 4-6 = Plan, Phase 7-10 = Implement. The description and precondition text needs RAPID terminology but the phase numbering can stay. All candidates have the same scope of work here.

### What does NOT need to change
- No frontmatter `stage:` key exists — no structural metadata changes needed
- Internal skill workflow stages (planning's Stage 1/2/3, recon's Phase 1/2/3, revise's Stage 1/2/3, pair-on's Phase 1/2/3) are internal to those skills and should not be renamed
- SKILL.spec.md and ARTIFACT.spec.md — no stage references
- `.claude/work/` plan files — historical artifacts, not living documentation
- Skill behavior — explicitly out of scope per problem statement

### Recommendation note
Per the problem statement, this solutioning phase should NOT pick a solution. All three candidates are viable. The key decision axis is: **visual density (diagram) vs. narrative readability (prose) vs. hybrid (banner + detail)**.
