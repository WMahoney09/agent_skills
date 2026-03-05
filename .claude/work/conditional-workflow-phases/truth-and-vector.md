# Truth and Vector

## Truths Established

1. **RAPID stages are mandatory; skills within stages are conditional.** The five-stage sequence (R-A-P-I-D) always runs and always produces its artifact. Which skills fire within a stage is the variable. This is a non-negotiable constraint from the problem statement.

2. **The intelligence lives in the skills, not the orchestrator.** Leeroy is a thin dispatcher. Individual skills assess their own situation at closing time and recommend the next step. Leeroy follows those recommendations the same way a user would. This is an explicit hard constraint and design philosophy.

3. **The mechanism already exists.** Skills already have "Closing the Phase" sections with closing prompts. The infrastructure is in place -- it just produces a fixed nudge every time instead of a conditional one. The change is behavioral (make closing nudges situationally aware), not structural (invent a new routing system).

4. **Dynamic assessment at each gate beats upfront classification.** Each skill evaluates with the information available when it closes, not a single determination made at pipeline start. This rules out any approach that tries to classify complexity once and route based on that classification.

5. **Context consumption is the primary cost.** Every unnecessary subagent dispatch burns tokens and time. The goal is not architectural elegance -- it is fewer wasted subagent invocations on tasks that do not need them.

6. **Planning always gets at least one pre-flight.** Non-negotiable. No routing logic can skip this.

7. **The Align stage reorder is decided: solutioning -> reasoning -> tire-kicking (only if needed).** Reasoning is the lighter default; tire-kicking is the heavy tool invoked only when reasoning flags genuine ambiguity.

## Conditionals

- If we choose **Approach A (Closing-Nudge Protocol)**, then:
  - Intelligence stays distributed in the skills, consistent with Truth #2
  - Each skill's SKILL.md and artifact template gains a structured "Next Step" section -- moderate blast radius across 4-6 files
  - Leeroy changes from a hardcoded phase list to reading artifact nudges -- a simple, well-bounded change to the orchestrator
  - Skills can evolve their nudge logic independently without coordinating with leeroy
  - Manual and autonomous workflows see the same recommendations (nudges are human-readable)
  - The convention of a "Next Step" block must be consistently adopted -- inconsistency breaks routing
  - LOE: 3 (Medium complexity, Medium impact)

- If we choose **Approach B (Stage Router)**, then:
  - Routing intelligence concentrates in leeroy, directly violating Truth #2 ("intelligence lives in the skills, not the orchestrator")
  - Skills remain untouched (lowest blast radius), but leeroy becomes a smarter, more coupled dispatcher
  - Manual workflows diverge from autonomous ones -- users do not benefit from routing heuristics
  - Leeroy must understand artifact internals (candidate counts, LOE scores, leak counts) creating tight coupling
  - Adding a new skill to a stage requires updating leeroy's routing table, not just writing the skill
  - LOE: 2 (Medium complexity, Low impact) -- cheapest to implement but architecturally misaligned

- If we choose **Approach C (Skill Contracts)**, then:
  - A new abstraction layer (contracts with `requires`, `produces`, `skip-when`) is introduced into the skill spec
  - Every participating skill's frontmatter, SKILL.md, and artifact template must change -- highest blast radius
  - The SKILL.spec.md itself changes to accommodate new frontmatter fields
  - The contract system is the most extensible but the current library (~15 skills) does not need that extensibility yet
  - The skip-when heuristics face the same design challenge as Approach A, wrapped in more formalism
  - LOE: 4 (High complexity, Medium impact) -- highest cost for marginal benefit over A

## Directional Vector

**Approach A (Closing-Nudge Protocol) is the clear direction.** It is the only candidate that satisfies the hard constraint that intelligence lives in the skills, not the orchestrator (eliminating B), while avoiding premature abstraction for a library of ~15 skills (eliminating C). The mechanism it extends -- closing prompts in SKILL.md -- already exists; the change is making those prompts conditional rather than fixed. Leeroy's change is minimal: read the artifact's Next Step block and follow it, exactly as a user would. This is the smallest intervention that solves the actual problem (wasted context on unnecessary phases) without violating the stated design philosophy.

Approach B is eliminated on principle: it moves intelligence into the orchestrator, contradicting a hard constraint. Its lower LOE does not compensate for architectural misalignment.

Approach C is eliminated on proportionality: it solves tomorrow's scaling problem at today's cost. The contract system's extensibility benefits are speculative; the nudge protocol can be upgraded to contracts later if the library grows to warrant it.

**No tire-kicking is needed.** The reasoning resolves cleanly -- one candidate violates a hard constraint, one is disproportionate to the problem, and one fits. There is no genuine ambiguity between approaches.
