# Review Issues

**Change Set:** Conditional workflow phases -- nudge-driven Align stage
**Author:** leeroyyyyy autonomous pipeline
**Summary:** Transforms the RAPID Align stage from a fixed skill sequence (solutioning -> tire-kicking -> reasoning) to a nudge-driven flow (solutioning -> reasoning -> tire-kicking, conditional). Each Align-stage skill emits a structured `## Next Step` block in its artifact that leeroyyyyy reads to determine routing. Solutioning gains a short-circuit path for prescriptive problems. The convention is documented in ARTIFACT.spec.md and SKILL.spec.md.

---

**Critical Issues**
> Must be resolved before merge. These are blockers.

None found.

---

**Major Issues**
> Significant problems that should be resolved. May be blocking depending on risk tolerance.

1. **Leeroyyyyy does not handle `Recommendation: understanding` from reasoning**
   - **Where:** `leeroyyyyy/SKILL.md`, Phase 2 nudge routing (line 159-161) and Nudge-Reading Mechanism (line 110-119)
   - **Why it matters:** Reasoning's SKILL.md (line 191-192) and ARTIFACT.md (line 26, 33) both define `understanding` as a valid Recommendation value -- reasoning can nudge back to `understanding` when the problem space has shifted. However, leeroyyyyy's Phase 2 nudge routing only handles two values: `Plan` (advance to Planning) and `tire-kicking` (proceed to Phase 3). The fallback mechanism (line 119) handles missing/malformed values by defaulting to `solutioning -> reasoning -> planning`, but `understanding` is a recognized value, not a malformed one. Leeroyyyyy would either (a) fall through to the fallback and silently ignore the signal, or (b) attempt to dispatch a skill called `understanding` within the Align stage, which is wrong because `understanding` is a Research-stage skill requiring user dialogue. Either outcome is incorrect. Since leeroyyyyy explicitly cannot run Research (line 339: "Research is the one stage leeroyyyyy does not own"), this nudge should trigger a halt-and-alert-user pattern, similar to the unresolvable revision pattern in Phase 10.
   - **Suggestion:** Add explicit handling for `Recommendation: understanding` in leeroyyyyy's Phase 2 nudge routing: stop the pipeline, alert the user that reasoning determined the problem needs revisiting, and write `summary-statement.md` noting the abort reason. Alternatively, document in the Nudge-Reading Mechanism that `understanding` is treated as an abort signal.

2. **Tire-kicking ARTIFACT.md: `## Next Step` appears after `## Notes`, violating the "always last" convention**
   - **Where:** `tire-kicking/ARTIFACT.md` (lines 44-53)
   - **Why it matters:** ARTIFACT.spec.md states: "When present, `## Next Step` must be the final section in the artifact template, after all other content sections." In tire-kicking's ARTIFACT.md, `## Notes` (line 39) appears before `## Next Step` (line 44). However, `## Next Step` here is documenting what goes into the artifact _template_ (inside the generated report), while `## Notes` is a section of the ARTIFACT.md definition file itself. The ambiguity is whether "always last" applies to the ARTIFACT.md file's own sections or to the template content within the code fence. For solutioning, `## Next Step` is inside the template code fence and `## Notes` follows it in the ARTIFACT.md -- consistent. For reasoning, `## Next Step` is inside the template code fence and `## Notes` follows -- consistent. For tire-kicking, `## Next Step` is outside the template code fence as a separate ARTIFACT.md section, placed after `## Notes`. This is structurally inconsistent with the other two artifacts.
   - **Suggestion:** Move the tire-kicking `## Next Step` content into the template code fence (between `## Comparative Verdict` and the closing triple backticks), matching the pattern used by solutioning and reasoning. Then `## Notes` correctly follows the template, consistent with the other ARTIFACT.md files.

---

**Minor Issues**
> Non-blocking. Worth addressing but won't hold up a merge.

1. **Tire-kicking intro paragraph still says "It sits after Align"**
   - **Where:** `tire-kicking/SKILL.md` line 8
   - **Suggestion:** The intro says "It sits after Align (we have a direction) and before or alongside Plan." Tire-kicking now sits _within_ Align, not after it. Update to "It sits within the Align stage" or remove the positional framing since the blockquote on line 10 already explains the conditional invocation context.

2. **Solutioning artifact template lost the LOE Score section**
   - **Where:** `solutioning/ARTIFACT.md` template (lines 9-26)
   - **Suggestion:** The old template had a `## LOE Score` section. The SKILL.md still instructs producing an LOE estimate per approach (line 74: "Produce a Level of Effort score using the `estimate` skill"). The new template's per-candidate comment says "Description, tradeoffs, constraints, LOE estimate" which covers it implicitly, but the explicit section is gone. This is minor since the LOE is now per-candidate rather than per-solution, which is arguably better -- just note it is intentional.

3. **Em-dash vs double-hyphen inconsistency in leeroyyyyy**
   - **Where:** `leeroyyyyy/SKILL.md` -- uses `--` (double hyphen) in several places (e.g., line 66, 119) while the rest of the skill library uses em-dashes
   - **Suggestion:** Normalize to em-dashes for consistency with the rest of the library, or accept as a stylistic variation.

---

**Gaps & Inconsistencies**
> Missing tests, undocumented behavior, pattern divergence, or things that don't quite add up.

1. **Fallback sequence omits tire-kicking**
   - **Where:** `leeroyyyyy/SKILL.md` line 119: "leeroyyyyy falls back to the default sequence: solutioning -> reasoning -> planning"
   - **Detail:** The fallback skips tire-kicking entirely. This is presumably intentional (better to under-process than loop), but it means a malformed artifact from reasoning that _should_ have nudged to tire-kicking will silently skip it. The fallback is documented, so this is a known design choice -- just noting it.

2. **Second reasoning pass: what artifact does it overwrite?**
   - **Where:** `leeroyyyyy/SKILL.md` Phase 3 (line 178-180)
   - **Detail:** The second reasoning pass produces `truth-and-vector.md`, which overwrites the first pass's artifact. The git log example (line 71) shows two commits for `truth-and-vector.md`. This is fine for the pipeline, but if a post-hoc reviewer wants to see reasoning's first-pass output, they would need to check git history. Not a problem, just a noted behavior.

3. **Reasoning's `understanding` nudge traverses a RAPID stage boundary**
   - **Where:** `reasoning/SKILL.md` line 191-192, `reasoning/ARTIFACT.md` line 26
   - **Detail:** The ARTIFACT.spec.md convention says skill slugs are for within-stage routing and stage names (capitalized) are for stage advancement. `understanding` is a skill slug (lowercase), but it routes _backward_ to the Research stage, crossing a stage boundary. Per convention, this should arguably be `Research` (capitalized stage name) rather than `understanding` (skill slug). However, the intent is clearly to invoke the specific skill, not the abstract stage. This is an edge case in the convention that the spec does not fully address -- the convention assumes forward stage advancement, not backward routing.

---

**Opportunities**
> Improvements that go beyond the current change but are worth noting.

1. **Extend nudge convention to Plan-stage skills.** The pre-flight loop could benefit from the same pattern -- pre-flight could nudge "clean" vs "issues found" to make the loop logic more explicit and consistent with Align-stage routing.

2. **Codify the abort-on-understanding pattern.** If `understanding` nudges become a general "abort and return to user" signal for autonomous pipelines, document this as a convention in ARTIFACT.spec.md alongside the existing Recommendation value conventions.

---

**Recommendation**

**Go with conditions**

The changes are thorough, internally consistent, and faithfully implement the problem statement's requirements. The Align stage reordering is correct across all files, cross-references match, and the nudge convention is well-documented. The two major issues should be addressed before merge: (1) leeroyyyyy needs explicit handling for the `understanding` nudge to avoid silent misbehavior in an edge case the skills themselves define, and (2) the tire-kicking ARTIFACT.md structural inconsistency should be normalized to match the pattern used by solutioning and reasoning.
