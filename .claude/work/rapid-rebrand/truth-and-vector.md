# Truth & Vector: RAPID Rebrand

## Decision: Candidate C (RAPID Acronym Spine) with a one-line flow header

### Evidence Summary

| Criterion | B: Two-Tier | C: RAPID Spine | C + flow line |
|---|---|---|---|
| Scenario holds | 5/7 | 6/7 | 6/7 |
| Scenario bends | 2/7 | 1/7 | 1/7 (same bend — diff readability) |
| Leaks | 0 | 0 | 0 |
| Maintenance burden | Higher (dual representation) | Lowest | Lowest + trivial one-liner |
| Skill addition friction | Moderate (banner alignment) | Minimal (add a line) | Minimal |
| Rendering safety | Good (fits 80 cols with margin) | Perfect | Perfect (flow line is ~55 chars) |

### Why C wins over B

1. **6/7 holds vs 5/7.** C's only bend is diff readability — a one-time cost paid during this rebrand. B bends on both diff readability AND skill addition — the latter is a recurring cost every time the skill library grows.

2. **No dual representation.** B requires keeping a banner AND detail sections in sync. The CLAUDE.md checklist already has four items for skill changes. Adding a fifth ("update the banner too") is friction that compounds. C has one representation per skill, one place to update.

3. **Aligns with existing codebase style.** The current README uses `###` headings for stages with prose and skill listings underneath. C replaces `### Stage N: Name` with `## R/A/P/I/D — Name` — same pattern, upgraded headings. B introduces a new structural element (the banner) that has no precedent in the codebase.

4. **The at-a-glance gap is closeable at low cost.** The tire-kicking report itself identifies the hybrid: a single flow line at the top. This costs one line of markdown, requires zero column alignment, and never breaks at any viewport width.

### Closing the one bend

**Diff readability (bend):** This is a one-time cost. The rebrand PR will be large regardless of approach — B's diff is also non-trivial due to prose redistribution. C's diff is larger but the end state is simpler, which means every future diff is more readable. Accepting one hard-to-review PR in exchange for permanently simpler maintenance is the correct trade.

Mitigation: structure the PR with clear commit boundaries (diagram removal, stage header rewrites, skill card additions, floating skills section, supporting skills dedup) so reviewers can follow the logic commit by commit.

---

## Chosen Approach: Detailed Structure

### Top of README

```markdown
# Agentic Delivery Skills

This directory contains portable, tool-agnostic skills implementing the
RAPID delivery workflow. These skills work with Claude Code, Cursor, and
any AI coding agent with basic file access.

**RAPID flow:** Research → Align → Plan → Implement → Deliver

> Floating skills — `/recon` `/clarify` `/reasoning` `/estimate` `/commit` —
> can be used at any stage.
```

The one-line flow replaces the ASCII diagram. It fits in any viewport, communicates the pipeline at a glance, and costs nothing to maintain. The floating skills note sits directly beneath it so the two concepts (pipeline + floating) are adjacent.

### RAPID Stage Sections

Each RAPID letter becomes a `##` heading. Structure per section:

```
## R — Research

> Goal: Understand the problem space before proposing solutions.

**`/understanding`** — Build shared understanding through discovery...
  - Clarify constraints, context, and success criteria
  - No solutions proposed in this phase

**`/recon`** *(floating)* — Read-only investigation of code and docs...
  - Explore existing systems, architecture, and patterns
  - Gather context through file exploration and documentation
```

Each skill gets a bold inline card with its slash command, a dash, a one-line description, and bullet points for key behaviors. Skills with floating status get an inline `*(floating)*` annotation.

### Stage-by-stage mapping

**## R — Research**
> Goal: Understand the problem space before proposing solutions.

Skills:
- **`/understanding`** — Build shared understanding through discovery
- **`/recon`** *(floating)* — Read-only investigation of code and docs

Prose: Carries forward the "no solutions proposed" principle from current Stage 1, Step 1.

**## A — Align**
> Goal: Converge on a solution direction with evidence.

Skills:
- **`/solutioning`** — Explore 2-3 approaches and reason through tradeoffs
- **`/tire-kicking`** — Stress-test candidates against concrete scenarios
- **`/reasoning`** *(floating)* — Reason through problems to extract truths and directional vectors

Prose: Carries forward the "align on direction" principle from current Stage 1, Step 2. The closure/alignment content from current "Build A Shared Understanding" lands here — this is where the team converges.

**## P — Plan**
> Goal: Produce a documented, right-sized list of discrete changes.

Skills:
- **`/planning`** — Interactive Q&A to design step-by-step implementation plan
- **`/pre-flight`** — Validate plan readiness, identify gaps, recommend simplification
- **`/atomize`** — Estimate every phase, decompose until all phases score LOE ≤ 2

Prose: Direct carryover from current Stage 2. No content redistribution needed.

**## I — Implement**
> Goal: Execute the discrete changes documented in the plan, then verify.

Skills:
- **`/produce`** — Autonomous execution with atomic commits
- **`/pair-on`** — Pair program with agent, you gate progress
- **`/review`** — Technical peer review of local changes or a PR
- **`/triage`** — Ingest feedback, group into prioritized revisions
- **`/revise`** — Address one revision at a time with user-gated commits
- **`/reply`** — Close the PR feedback loop with commit-to-comment mapping

Prose: Direct carryover from current Stage 3. The two implementation options (produce vs pair-on) and the review cycle stay as-is.

**## D — Deliver**
> Goal: Ship the work and close the loop.

No automation skills yet. Manual activities:
- Open a pull request
- Deploy to staging/production
- Demonstrate to stakeholders
- Gather feedback
- Confirm acceptance

Prose: New section. Kept deliberately thin. When `/deploy` or `/demo` skills are created in the future, they slot in as skill cards identical to other sections. The section heading exists now so the RAPID acronym is complete and the pipeline endpoint is explicit.

### Floating Skills

```
## Floating Skills

These skills have stage affinities (noted above) but can be invoked at
any point in the workflow.

- **`/recon`** — Read-only investigation *(affinity: Research)*
- **`/clarify`** — Clarifying questions to deepen understanding
- **`/reasoning`** — Extract truths and directional vectors *(affinity: Align)*
- **`/estimate`** — Produce a Level of Effort score
- **`/commit`** — Stage and commit using typed commit convention
```

Skills with stage affinities note them parenthetically. Skills without a stage affinity (clarify, estimate, commit) have no annotation — they are purely floating.

### Remaining sections

**Conventions** — unchanged. Still references SKILL.spec.md and ARTIFACT.spec.md.

**Orchestration Philosophy** — unchanged. No stage-name references in this section.

**Meta** — unchanged. `/commit` and `/estimate` entries stay. These define shared conventions referenced by other skills. No stage terminology used.

**Supporting Skills** — **restructured.** The current Supporting Skills section duplicates what will now live in the RAPID stage sections. Two options:

**Chosen option: Remove Supporting Skills entirely.** The RAPID stage sections + Floating Skills section now cover every skill with descriptions and typical usage. The Supporting Skills section was a flat list that existed because the ASCII diagram couldn't hold descriptions. With the RAPID spine, descriptions live inline. Keeping both creates duplication the CLAUDE.md checklist would need to maintain.

Justification: the CLAUDE.md checklist says "README Supporting Skills section updated" for any skill change. If skill descriptions live in the RAPID sections, that checklist item becomes "README RAPID section updated" — same work, one location instead of two.

**Danger Zone** — unchanged structure. `/leeroyyyyy` entry stays. Update prose references from old stage names to RAPID terminology.

**How Skills Work, Where Skills Live, Portability, Invocation, File Structure, Sources** — unchanged.

---

## Convention Alignment

| Convention | Status |
|---|---|
| CLAUDE.md checklist: skill directory with SKILL.md | No change needed |
| CLAUDE.md checklist: README diagram updated | Becomes: "README flow line updated" (only if adding a new stage, which is unlikely) |
| CLAUDE.md checklist: README Meta section updated | No change needed |
| CLAUDE.md checklist: README Supporting Skills section updated | Becomes: "README RAPID section updated" — same intent, points to new location |
| CLAUDE.md checklist: README phase descriptions updated | Becomes: "README RAPID section updated" — same intent |

**Departure:** CLAUDE.md references "diagram" and "Supporting Skills section" which will no longer exist in their current form. CLAUDE.md must be updated as part of this rebrand to reference the new structure. This is a justified departure — the checklist should describe the actual README structure.

---

## Summary

**What:** Candidate C (RAPID Acronym Spine) with a one-line `Research → Align → Plan → Implement → Deliver` flow header and a floating skills callout.

**Why:** Best hold rate (6/7), lowest maintenance burden, strongest alignment with existing section-heading style, only bend is a one-time diff cost.

**Key structural changes:**
1. ASCII diagram replaced by one-line flow + floating callout
2. Three `### Stage` sections become five `## Letter — Name` sections
3. Supporting Skills section removed (absorbed into RAPID sections + Floating Skills)
4. CLAUDE.md checklist updated to reference new structure
5. Deliver section added as explicit (thin) pipeline endpoint

**What stays the same:**
- Conventions section
- Orchestration Philosophy
- Meta section
- Danger Zone (leeroyyyyy)
- How Skills Work / Where Skills Live / Portability / Invocation / File Structure / Sources
- Skill files themselves (prose-only updates to ~6 files, separate from README work)
