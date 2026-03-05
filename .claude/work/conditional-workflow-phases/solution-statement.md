# Solution Statement

## Chosen Approach
<!-- To be filled by reasoning — solutioning presents candidates only -->

## Why This Approach
<!-- To be filled by reasoning -->

## Tradeoffs Accepted
<!-- To be filled by reasoning -->

## Approaches Considered and Rejected
<!-- To be filled by reasoning -->

## LOE Score
<!-- To be filled by reasoning -->

---

## Candidates

### Approach A: Closing-Nudge Protocol — Skills Emit Structured Next-Step Recommendations

**Core idea:** Each skill's closing section gains a structured "nudge" block — a short assessment of what it found and a recommendation for the next step (or to skip the next step). Leeroy reads these nudges the same way a user would and routes accordingly. The intelligence about whether to skip tire-kicking or short-circuit solutioning lives entirely in the skill artifacts, not the orchestrator.

**How it works:**

1. Each skill's SKILL.md gains a "Closing Nudge" section with conditional logic. For example, solutioning's closing nudge assesses: "Is there meaningful ambiguity between candidates, or did one clearly dominate?" If one dominated, the nudge says "proceed directly to planning" (skipping tire-kicking and the reasoning-as-tiebreaker pass). If ambiguity exists, it says "proceed to reasoning for synthesis."

2. Each skill's artifact gains a machine-readable `## Next Step` section at the bottom. This is a simple structured block:
   ```
   ## Next Step
   Recommendation: proceed-to-reasoning | skip-to-planning | invoke-tire-kicking
   Confidence: high | medium | low
   Rationale: One sentence explaining why.
   ```

3. Leeroy's pipeline changes from a hardcoded phase list to a stage-based loop: for each RAPID stage, it reads the current artifact's Next Step recommendation and dispatches accordingly. The stage sequence (R-A-P-I-D) remains mandatory — Leeroy never skips a stage — but which skills fire within a stage is driven by the artifacts.

4. The Align stage reordering (solutioning -> reasoning -> tire-kicking) is encoded in the nudge logic: solutioning always nudges to reasoning; reasoning conditionally nudges to tire-kicking only when it flags genuine ambiguity between candidates.

5. Solutioning gains a short-circuit path: when the problem statement is prescriptive enough (single viable approach, clear constraints, low ambiguity), solutioning produces a single-candidate solution-statement.md with a nudge to skip directly to planning.

**Strengths:**
- Intelligence stays in the skills, exactly where the problem statement says it should. Leeroy remains a thin dispatcher.
- Each skill can evolve its nudge logic independently without changing the orchestrator.
- The nudge mechanism is human-readable — a user following the workflow manually would see the same recommendations.
- Dynamic assessment at each gate: each skill evaluates with the information it has at closing time, not an upfront classification.
- Minimal new abstraction — extends existing closing sections rather than introducing new concepts.

**Tradeoffs:**
- Every skill that participates in conditional routing needs its SKILL.md and artifact updated. The blast radius across skill files is moderate (solutioning, reasoning, tire-kicking, pre-flight at minimum).
- The "Next Step" block is a new convention that all artifact-producing skills must adopt. Risk of inconsistency if some skills emit it and others don't.
- Leeroy must parse artifact files for routing decisions, adding a dependency on artifact structure. If an artifact is malformed, routing breaks.
- The nudge logic in each skill is essentially duplicated decision-making — each skill decides "what should happen next" based on its own assessment, which means the routing intelligence is distributed and harder to reason about holistically.

**LOE:**
```
LOE: 3
Complexity: Medium | Impact: Medium
Touches 4-6 skill SKILL.md files and their ARTIFACT.md templates, plus leeroy's orchestration logic. Each change is individually simple (adding conditional closing sections), but the coordination across files and the need for consistent nudge format adds moderate complexity.
```

**Best for:** When the priority is keeping the orchestrator thin and the intelligence distributed. Best when the team values skills as self-contained units that know their own routing. This is the most aligned with the stated constraint that "intelligence lives in the skills, not the orchestrator."

---

### Approach B: Stage Router with Uncertainty Scoring — A Lightweight Gate Between Skills

**Core idea:** Introduce a small "stage router" concept — not a new skill, but a routing protocol embedded in Leeroy's stage transitions. At each stage boundary, Leeroy performs a lightweight assessment of the artifacts produced so far and decides which skills to invoke next. The assessment uses a simple uncertainty heuristic derived from the artifacts themselves (number of candidates, presence of leaks/bends, divergence between candidates).

**How it works:**

1. Leeroy's pipeline gains a routing function at each RAPID stage boundary. This function reads the most recent artifact and applies simple heuristics:
   - After solutioning: How many candidates? Did one clearly dominate (LOE gap > 1, no tradeoffs flagged)? If yes, skip to planning. If ambiguous, invoke reasoning.
   - After reasoning: Did reasoning flag genuine uncertainty or unresolvable tensions? If yes, invoke tire-kicking. If reasoning reached clear conviction, proceed to planning.
   - After planning: Always invoke at least one pre-flight (non-negotiable).

2. The heuristics are codified in Leeroy's SKILL.md as a routing table — a simple decision matrix at each stage boundary. Skills themselves don't change their closing sections; the routing intelligence lives in Leeroy.

3. The Align stage reordering is encoded directly in Leeroy's routing table: the sequence is solutioning -> (routing decision) -> reasoning -> (routing decision) -> tire-kicking.

4. Solutioning short-circuit: Leeroy's routing function after solutioning checks whether the solution-statement has a single candidate with high confidence. If so, it routes directly to planning, bypassing both reasoning and tire-kicking.

5. No new artifact format or convention is needed. Leeroy reads existing artifact sections (candidate count, LOE scores, leak/bend counts) to make routing decisions.

**Strengths:**
- All routing logic is in one place (Leeroy's SKILL.md), making it easy to reason about the full flow and debug routing decisions.
- Skills don't need to change at all — their SKILL.md and ARTIFACT.md files remain untouched. Only Leeroy changes.
- No new conventions to enforce across the skill library. Lower coordination cost.
- The routing heuristics can be tuned in one file without touching the rest of the skill library.

**Tradeoffs:**
- Violates the stated constraint that "intelligence lives in the skills, not the orchestrator." Leeroy becomes a smarter dispatcher rather than a thin one.
- Leeroy must understand artifact internals (candidate counts, LOE scores, leak counts) to make routing decisions. This creates coupling between the orchestrator and artifact formats.
- A user following the manual workflow doesn't benefit from these routing heuristics — they only exist in Leeroy. The manual and autonomous workflows diverge.
- Harder to extend: adding a new skill to a stage requires updating Leeroy's routing table, not just writing the skill.
- Risk of Leeroy's routing logic growing complex over time as more stages and skills are added.

**LOE:**
```
LOE: 2
Complexity: Medium | Impact: Low
Changes are concentrated in a single file (leeroy's SKILL.md). The routing heuristics themselves are simple conditional logic. Impact is low because no other skills are modified.
```

**Best for:** When the priority is speed of implementation and minimal blast radius. Best when the team wants a quick win that reduces context consumption without touching the broader skill library. Also appropriate if Leeroy is the only consumer of routing intelligence (i.e., manual workflows will always rely on human judgment for routing).

---

### Approach C: Skill Contracts with Adaptive Depth — Skills Declare What They Need, Orchestrator Negotiates

**Core idea:** Each skill declares its input requirements and output guarantees as a "contract" in its SKILL.md frontmatter. The orchestrator (Leeroy) uses these contracts to determine whether a skill's preconditions are already satisfied by prior artifacts. If a skill's inputs are already resolved (e.g., reasoning's job is to pick between ambiguous candidates, but there's only one candidate), the skill is skipped because its contract is already fulfilled.

**How it works:**

1. Each skill's SKILL.md frontmatter gains a `contract` block:
   ```yaml
   contract:
     requires: ambiguity-between-candidates
     produces: chosen-direction
     skip-when: single-candidate-with-high-confidence
   ```

2. Artifacts gain lightweight semantic tags — not a new section, but tags embedded in existing sections. For example, solutioning's solution-statement.md would include a `candidates: 1` or `candidates: 3` field in its metadata, and a `confidence: high | medium | low` field.

3. Leeroy's stage loop becomes contract-driven: for each skill in the current stage, check whether its `skip-when` condition is met by the current artifact state. If met, skip. If not, dispatch.

4. The Align stage reordering is encoded by listing skills in the new order (solutioning, reasoning, tire-kicking) and letting the contract system determine which fire.

5. Adaptive depth: the contract system naturally handles the "simple task uses less context" goal. A prescriptive problem statement leads to a single-candidate solutioning output, which satisfies reasoning's skip-when condition, which satisfies tire-kicking's skip-when condition. The pipeline runs: solutioning (short-circuit) -> planning. A complex ambiguous problem runs the full sequence.

6. Pre-flight's "always at least one" rule is encoded as `skip-when: never` in its contract.

**Strengths:**
- Most principled and extensible design. New skills can be added with their own contracts without modifying the orchestrator.
- The contract system provides a clear, declarative language for routing that's easy to audit and test.
- Naturally handles the "dynamic assessment at each gate" requirement — each skill's skip-when is evaluated against the current artifact state.
- Separates the "what" (contract declarations) from the "how" (Leeroy's contract evaluation loop), keeping both simple.
- Could eventually support other orchestrators or manual workflows that read contracts.

**Tradeoffs:**
- Highest implementation cost. Requires changes to the SKILL.spec.md (new frontmatter fields), every participating skill's SKILL.md, artifact templates (semantic tags), and Leeroy's orchestration logic.
- Introduces a new abstraction (contracts) that the team must learn and maintain. Adds conceptual overhead to the skill authoring process.
- The `skip-when` conditions need careful design to avoid false positives (skipping when you shouldn't) or false negatives (running when you don't need to). Getting the heuristics right is the same challenge as Approach A/B, but wrapped in more formalism.
- Risk of over-engineering for the current scale of the skill library (roughly 15 skills). The contract system's extensibility benefits may not be needed yet.
- The semantic tags in artifacts add structure that must be consistently produced by every skill — similar coordination cost to Approach A but with additional formalism.

**LOE:**
```
LOE: 4
Complexity: High | Impact: Medium
Requires changes across the spec files, multiple skill SKILL.md files, artifact templates, and Leeroy. The contract evaluation logic in Leeroy is the most complex piece — it needs to parse frontmatter, read artifact metadata, and evaluate skip conditions. High complexity for the new abstraction; medium impact because the changes are spread but each is moderate.
```

**Best for:** When the skill library is expected to grow significantly and the routing logic needs to scale with it. Best when the team values declarative, auditable routing over ad-hoc conditional logic. This is the "build it right" approach — higher upfront cost for lower marginal cost of future changes.
