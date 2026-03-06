# Triage Report

**Source:** Review output
**Items ingested:** 10 (2 Major, 3 Minor, 3 Gaps, 2 Opportunities)
**Revisions identified:** 5

---

## Critical Revisions

None.

## Major Revisions

**Revision M1:** Leeroyyyyy has no handling for the `understanding` nudge from reasoning

> **Addresses:**
> - Major #1: "Leeroyyyyy does not handle `Recommendation: understanding` from reasoning -- reasoning can nudge back to `understanding` when the problem space has shifted, but leeroyyyyy's Phase 2 routing only handles `Plan` and `tire-kicking`"
> - Gap #3: "Reasoning's `understanding` nudge traverses a RAPID stage boundary -- `understanding` is a skill slug (lowercase) but routes backward to Research, crossing a stage boundary"
> - Opportunity #2: "Codify the abort-on-understanding pattern as a convention in ARTIFACT.spec.md"

**What needs to change:** Add explicit handling for `Recommendation: understanding` in leeroyyyyy's Phase 2 nudge routing. Since leeroyyyyy cannot run Research, this should trigger a halt-and-alert-user pattern: stop the pipeline, alert the user that reasoning determined the problem needs revisiting, and write `summary-statement.md` noting the abort reason. Additionally, consider whether `understanding` should be documented as a capitalized stage name (`Research`) per the ARTIFACT.spec.md convention, or whether the spec should be updated to acknowledge backward-routing as an edge case. The abort-on-understanding pattern should be codified in ARTIFACT.spec.md alongside the existing Recommendation value conventions.

**Affected files:**
- `leeroyyyyy/SKILL.md` (Phase 2 nudge routing, lines 110-119, 159-161)
- `reasoning/SKILL.md` (line 191-192, defines `understanding` as valid Recommendation)
- `reasoning/ARTIFACT.md` (line 26, 33, defines `understanding` value)
- `ARTIFACT.spec.md` (convention gap for backward-routing nudges)

---

**Revision M2:** Tire-kicking ARTIFACT.md places `## Next Step` outside the template code fence

> **Addresses:**
> - Major #2: "Tire-kicking ARTIFACT.md: `## Next Step` appears after `## Notes`, violating the 'always last' convention -- structurally inconsistent with solutioning and reasoning ARTIFACT.md files where `## Next Step` is inside the template code fence"

**What needs to change:** Move the tire-kicking `## Next Step` content into the template code fence, between `## Comparative Verdict` and the closing triple backticks. This matches the pattern used by solutioning and reasoning ARTIFACT.md files where `## Next Step` lives inside the template and `## Notes` follows the template as a section of the ARTIFACT.md definition file itself.

**Affected files:**
- `tire-kicking/ARTIFACT.md` (lines 39-53)

---

## Minor Revisions

**Revision m1:** Tire-kicking intro paragraph incorrectly says "sits after Align"

> **Addresses:**
> - Minor #1: "The intro says 'It sits after Align (we have a direction) and before or alongside Plan.' Tire-kicking now sits within Align, not after it."

**What needs to change:** Update `tire-kicking/SKILL.md` line 8 to say "It sits within the Align stage" or remove the positional framing entirely since the blockquote on line 10 already explains the conditional invocation context.

**Affected files:**
- `tire-kicking/SKILL.md` (line 8)

---

**Revision m2:** Solutioning artifact template lost the explicit LOE Score section

> **Addresses:**
> - Minor #2: "The old template had a `## LOE Score` section. The SKILL.md still instructs producing an LOE estimate per approach. The new template covers it implicitly in per-candidate comments but the explicit section is gone."

**What needs to change:** Confirm this is intentional (LOE is now per-candidate rather than a standalone section) and either restore the explicit section or add a brief note in the template comments clarifying that LOE is embedded per-candidate. No code change may be needed if the team accepts the implicit approach.

**Affected files:**
- `solutioning/ARTIFACT.md` (template, lines 9-26)

---

**Revision m3:** Editorial consistency in leeroyyyyy

> **Addresses:**
> - Minor #3: "Em-dash vs double-hyphen inconsistency -- leeroyyyyy uses `--` (double hyphen) in several places while the rest of the skill library uses em-dashes"
> - Gap #1: "Fallback sequence omits tire-kicking -- the fallback skips tire-kicking entirely, which is presumably intentional but underdocumented"

**What needs to change:** Normalize double-hyphens to em-dashes in `leeroyyyyy/SKILL.md` for consistency with the rest of the library. Optionally, add a brief note to the fallback sequence (line 119) explaining that the fallback intentionally skips tire-kicking to avoid processing loops.

**Affected files:**
- `leeroyyyyy/SKILL.md` (lines 66, 119, and other double-hyphen locations)

---

## Items Requiring Clarification

None. All items had clear intent and actionable suggestions.

---

## Informational Notes (no revision needed)

- **Gap #2** (second reasoning pass overwrites `truth-and-vector.md`): This is a known behavior, not a defect. The first-pass output is recoverable from git history. No action needed.
- **Opportunity #1** (extend nudge convention to Plan-stage skills): Out of scope for this change set. Worth tracking separately.

---

| Severity | Revisions |
|---|---|
| Critical | 0 |
| Major | 2 |
| Minor | 3 |
| Needs clarification | 0 |
| **Total** | **5** |

*Ready for `/revise`. Work Major revisions first.*
