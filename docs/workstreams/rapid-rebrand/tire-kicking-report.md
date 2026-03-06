# Tire-Kicking Report: RAPID Rebrand

## Candidates Under Test

- **A: In-Place Rename** — 5-column ASCII diagram, same structure, more columns
- **B: Two-Tier Layout** — Compact RAPID banner + grouped detail sections
- **C: RAPID Acronym Spine** — No diagram, RAPID letters as `##` headings with inline skill cards

---

## Scenario Results Matrix

| Scenario | A: In-Place Rename | B: Two-Tier Layout | C: RAPID Acronym Spine |
|---|---|---|---|
| 1. Newcomer onboarding | Bends | Holds | Holds |
| 2. Adding a new skill | Holds | Bends | Holds |
| 3. Deliver stage growth | Bends | Holds | Holds |
| 4. Narrow viewport rendering | Leaks | Bends | Holds |
| 5. Leeroyyyyy mapping | Holds | Holds | Holds |
| 6. Floating skill ambiguity | Bends | Holds | Holds |
| 7. Diff readability | Holds | Bends | Bends |

---

## Detailed Analysis

### Scenario 1: Newcomer Onboarding

> Someone opens the README for the first time. Can they immediately understand the RAPID workflow, find the right skill for their stage, and know what "floating" means?

**A: Bends.** The 5-column diagram communicates the RAPID flow visually, but the diagram is dense. Five columns of ASCII boxes with skill names crammed inside are harder to parse than the current three-column version. The "floating" concept remains a single line below the diagram — same as today. A newcomer can figure it out, but the first impression is a wall of ASCII art rather than a clear pipeline overview. The word "RAPID" may not even appear prominently unless added as a heading above the diagram.

**B: Holds.** The compact banner at the top is immediately scannable — five equal-width columns with short skill names, plus a labeled "Floating" line underneath. The two-tier structure gives a newcomer the overview first (banner), then the detail (sections). The floating concept is visually separated and explained. This is the most newcomer-friendly layout for the diagram-plus-detail pattern.

**C: Holds.** The document reads top-to-bottom as a narrative: R, A, P, I, D as `##` headings with goal statements and skill listings. A newcomer reads it like a story. The floating skills section at the end is its own heading with an explanation. The tradeoff is no at-a-glance visual overview, but for a first-time reader who will actually read the text, this is arguably the clearest. The RAPID acronym is the organizing spine itself, so the concept is impossible to miss.

### Scenario 2: Adding a New Skill

> A contributor creates a new skill and needs to place it in the right RAPID stage. Is it clear where it goes? Is the README update path obvious?

**A: Holds.** Same as today: add a box in the right column of the ASCII diagram, add an entry under the right `### Stage` section, add to Supporting Skills. The mechanics are identical to the current workflow, just with five columns instead of three. The CLAUDE.md checklist applies directly.

**B: Bends.** Two places need updating: the banner (add the skill name to the right column cell) AND the detail section (add the skill description). The banner's fixed-width column formatting means adding a skill to a column that's already full requires careful ASCII alignment. If the Implement column already has 6 skills, adding a 7th extends the banner height and may require re-aligning all columns. The dual-representation maintenance burden is real — the solution statement already flags this as a con.

**C: Holds.** Add a bold skill line under the right `##` heading. That's it — no diagram to adjust, no column alignment to worry about. The Supporting Skills section also needs updating (same as all candidates), but the RAPID-section update is a single line addition. This is the lowest-friction path for skill additions.

### Scenario 3: Deliver Stage Growth

> In 6 months, real skills get added to Deliver (e.g., /deploy, /demo). Does the structure accommodate this gracefully?

**A: Bends.** The Deliver column in the ASCII diagram starts empty (just listing manual activities). Adding `/deploy` and `/demo` means adding boxes to the rightmost column of a diagram that's already pushing width limits. Every skill added to Deliver makes the diagram wider or taller. The rightmost column is the worst place to grow because it's the one most likely to clip in narrow viewports. The structure works, but the diagram becomes progressively harder to maintain.

**B: Holds.** The banner accommodates new Deliver skills by adding names to the rightmost column cell. Since the banner uses simple text (not ASCII boxes), adding `deploy` and `demo` just extends the column vertically. The detail section below gets a new skill listing. The two-tier structure handles growth gracefully because neither tier has a hard width constraint on individual columns — they just grow downward.

**C: Holds.** The `## D — Deliver` section transitions from listing manual activities to listing skill cards. Adding `/deploy` means adding a bold skill line, identical to how skills appear in other sections. The structure is perfectly uniform across all stages regardless of how many skills each has. This handles growth most naturally.

### Scenario 4: Narrow Viewport / Terminal Rendering

> The README is read in GitHub, in a terminal with 80-col width, and in VS Code preview. Does the layout hold?

**A: Leaks.** The current 3-column ASCII diagram is already 80 characters wide (line 6 of the current README is 80 chars). Expanding to 5 columns pushes the diagram well past 100 characters. The solution statement acknowledges this: "5-column ASCII diagram will be very wide and may not render well in narrow terminals or GitHub mobile." At 80 columns, the diagram will wrap or require horizontal scrolling in every terminal. GitHub's code block rendering will add a horizontal scrollbar, which is functional but ugly. VS Code preview will wrap the lines, destroying the column alignment entirely. This is not a minor cosmetic issue — it fundamentally breaks the visual communication that the diagram exists to provide.

**B: Bends.** The banner uses ~60 characters of width for five 11-char columns. This fits within 80 columns. However, the double-line box-drawing characters (`╔`, `╬`, etc.) in the solution statement's mockup add overhead. The proposed banner in the solution statement measures approximately 65 characters wide — it fits at 80 columns, but with limited margin. If skill names are long or if columns need to grow, it could push past 80 chars. The banner needs to be tested with actual content. Additionally, box-drawing characters may render inconsistently across terminals and fonts, though this is a minor concern.

**C: Holds.** No ASCII art means no width constraints. Markdown headings, blockquotes, and bold text render correctly at any viewport width. The layout is inherently responsive. This is the only candidate with zero rendering risk.

### Scenario 5: Leeroyyyyy Pipeline Mapping

> Someone reading leeroyyyyy's SKILL.md wants to cross-reference the RAPID stages. Is the mapping clear and consistent?

**A: Holds.** Leeroyyyyy's pipeline (Solutioning → Tire-Kicking → Reasoning+Recon → Planning → Pre-Flight → Atomize → Produce → Review → Triage → Revise) maps to RAPID stages via the README's stage sections. The stage headers use RAPID names, and leeroyyyyy's own pipeline section headers would be updated to reference RAPID stages in their descriptions. The cross-reference is straightforward: find the skill in the diagram, see which column it's in.

**B: Holds.** Same mapping clarity as A, plus the compact banner gives a quick visual reference. A reader can glance at the banner to see which RAPID stage a skill belongs to, then read leeroyyyyy's pipeline to see the execution order. The banner serves as a lookup table.

**C: Holds.** The `## R/A/P/I/D` headings in the README serve as the definitive stage listing. A reader of leeroyyyyy can scan the README's headings to see where each pipeline step falls. Since the RAPID acronym is the README's organizing structure, the mapping is self-evident. No need to decode a diagram — the headings ARE the mapping.

### Scenario 6: Floating Skill Ambiguity

> A user isn't sure if /reasoning belongs to Research or Align. Can they quickly find the answer?

**A: Bends.** The diagram would show `/reasoning` in the Align column (its primary affinity) AND on the "Use anytime" floating line below. But this dual placement requires the reader to notice both locations and mentally synthesize them. The diagram doesn't explain WHY a skill appears in two places. A reader might see `/reasoning` in the Align column and assume it's stage-bound, missing the floating line entirely. This ambiguity exists in the current README too (with `/recon`), and expanding to 5 columns with more floating skills makes it worse because there's more visual noise to scan through.

**B: Holds.** The banner shows `/reasoning` in the Align column AND on the "Floating (any stage)" line below. The solution statement includes the note: "Floating skills have stage affinities shown above but can be invoked at any point." This explicit explanation resolves the ambiguity. The compact banner makes both placements visible in a single eye-sweep without scrolling.

**C: Holds.** Under `## A — Align`, the skill card for `/reasoning` would include the annotation `*(also floating)*` — directly inline with the skill's description. Then `/reasoning` also appears in the `## Floating Skills` section. The inline annotation is the key differentiator: it answers the question right where the reader encounters the skill. No need to cross-reference another part of the document.

### Scenario 7: Diff Readability

> The PR for this rebrand will have a large diff. Which approach produces the most reviewable, understandable diff?

**A: Holds.** The diff is mostly find-and-replace: stage names change, diagram expands, section headers update. The structure stays the same (diagram, then stage sections, then meta, then supporting skills). A reviewer can read the diff top-to-bottom and understand each change as a rename. The diagram change will be a large contiguous block, but it's a single coherent change. This is the most reviewable because the changes are mechanical and predictable.

**B: Bends.** The diff shows the old diagram being replaced with a new banner (structural change), plus the three stage sections being split into five (content reorganization). The prose redistribution — especially splitting "Build A Shared Understanding" content between Research and Align — creates non-trivial moved-text diffs that are hard to review. Git diff doesn't track moved paragraphs well. A reviewer needs to verify that no content was lost or duplicated during the split. The two-tier layout is a genuine structural change, not just a rename, which increases review burden.

**C: Bends.** The diff shows the old diagram being deleted entirely (a large red block), plus the three stage sections being replaced with five RAPID heading sections containing inline skill cards. The Supporting Skills section may also need restructuring to avoid duplication with the inline skill cards. This is the largest structural departure, producing the biggest diff. A reviewer needs to verify that all content from the old structure appears in the new structure, which requires comparing old and new side-by-side rather than reading a diff linearly. However, the resulting structure is simpler, so while the diff is harder to review, the end state is easier to understand.

---

## Summary by Candidate

### Candidate A: In-Place Rename

| Rating | Count | Scenarios |
|---|---|---|
| Holds | 3 | Adding a skill, Leeroyyyyy mapping, Diff readability |
| Bends | 3 | Newcomer onboarding, Deliver growth, Floating ambiguity |
| Leaks | 1 | Narrow viewport rendering |

**Critical finding:** The 5-column ASCII diagram leaks at 80-column width. This is not a cosmetic issue — it breaks the primary visual communication mechanism. The current 3-column diagram is already at the 80-character boundary. Five columns cannot fit without wrapping, horizontal scrolling, or significant abbreviation. Every other bend in Candidate A traces back to the diagram's density: newcomer onboarding is harder because the diagram is dense; Deliver growth is harder because the diagram is already at capacity; floating ambiguity is harder because there's more visual noise.

### Candidate B: Two-Tier Layout

| Rating | Count | Scenarios |
|---|---|---|
| Holds | 5 | Newcomer onboarding, Deliver growth, Leeroyyyyy mapping, Floating ambiguity, Narrow viewport |
| Bends | 2 | Adding a skill, Diff readability |

**Critical finding:** No leaks. The bends are real but manageable: the dual-representation maintenance burden (banner + detail sections) creates friction when adding skills, and the prose redistribution creates a harder-to-review diff. The banner itself is the strongest element — compact, scannable, and fits at 80 columns. The detail sections below are standard markdown and pose no issues. The main risk is the one-time cost of splitting "Build A Shared Understanding" prose between Research and Align sections.

### Candidate C: RAPID Acronym Spine

| Rating | Count | Scenarios |
|---|---|---|
| Holds | 6 | Newcomer onboarding, Adding a skill, Deliver growth, Narrow viewport, Leeroyyyyy mapping, Floating ambiguity |
| Bends | 1 | Diff readability |

**Critical finding:** No leaks. The only bend is diff readability — the structural departure from the current README produces the largest and least linear diff. However, this is a one-time cost. After the rebrand, Candidate C produces the most maintainable structure: adding skills requires a single line addition under a heading, no diagram alignment, no dual-representation sync. The loss of the ASCII diagram is the principal tradeoff — the document becomes a narrative rather than a visual reference. Whether this matters depends on whether the team values at-a-glance scanning (favors B) or top-to-bottom readability (favors C).

---

## Key Decision Axis

The tire-kicking eliminates **Candidate A** due to the viewport leak. The 5-column diagram cannot fit at 80 characters, and this is the exact environment where the README is most commonly read.

The remaining choice is between **B** and **C**, which trade off along a single axis:

| | B: Two-Tier Layout | C: RAPID Acronym Spine |
|---|---|---|
| At-a-glance overview | Strong (banner) | Weak (no diagram) |
| Top-to-bottom readability | Good (detail sections) | Best (narrative flow) |
| Maintenance burden | Higher (two representations) | Lower (one representation) |
| Skill addition friction | Moderate (banner alignment) | Minimal (add a line) |
| Diff reviewability | Moderate | Moderate |
| Rendering safety | Good (fits 80 cols with margin) | Perfect (no width constraints) |

Neither B nor C leaks. Both hold in the majority of scenarios. The choice comes down to whether the team values the visual overview (choose B) or long-term maintainability and simplicity (choose C).

A hybrid approach — C's structure with a minimal RAPID flow line (not a full banner, just `Research → Align → Plan → Implement → Deliver` as a one-line flow) — would capture the at-a-glance benefit without the maintenance burden of a full diagram. This was not proposed as a candidate but emerges naturally from the analysis.
