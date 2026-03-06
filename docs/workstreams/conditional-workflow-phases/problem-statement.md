# Problem Statement

## Problem

The RAPID pipeline — and `/leeroyyyyy` in particular — runs every skill within each stage unconditionally. Solutioning always proposes multiple approaches, tire-kicking always stress-tests them, reasoning always synthesizes. In practice, many tasks don't need the full ceremony, wasting context on phases that add no value. The individual skills also always nudge toward the same next step regardless of complexity, which means both manual and autonomous workflows lack intelligence about when to skip or short-circuit.

## Why It Matters / Why Now

Context consumption is the primary cost. Each dispatched subagent in leeroy burns tokens and time producing artifacts that may be unnecessary for simpler tasks. In the manual workflow the user compensates by skipping skills, but leeroy has no such intelligence — it follows the fixed pipeline blindly. As the skills library matures and leeroy sees more use, this overhead compounds.

## Key Constraints

- **RAPID stages are mandatory.** Every stage must produce its artifact: problem-statement (Research), solution-statement (Align), plan file (Plan), commits + summary-statement (Implement), PR (Deliver). The stage sequence is always followed.
- **Skills within a stage are conditional.** Which skills fire within a given stage can vary based on the nature of the task.
- **Planning always gets at least one pre-flight.** Non-negotiable.
- **The intelligence lives in the skills, not in the orchestrator.** Individual skills should make smarter nudges about what comes next. Leeroy follows those nudges, just like a user would.
- **The Align stage should be reordered.** Solutioning -> reasoning -> tire-kicking (only if needed), not solutioning -> tire-kicking -> reasoning. Reasoning is the lighter tool; tire-kicking is the heavy one you reach for when reasoning flags genuine ambiguity.
- **Dynamic assessment, not upfront classification.** Each gate assesses with the information available at that point, not a single upfront determination.

## Success Criteria

- Individual skills produce smarter closing nudges that assess the situation and recommend the appropriate next step — not always the same next step.
- Solutioning can short-circuit when the problem statement is prescriptive enough that proposing multiple approaches adds no value.
- Reasoning becomes the default step after solutioning; tire-kicking only fires if reasoning flags ambiguity between candidates.
- Leeroy follows skill nudges to route through each stage rather than hardcoding a fixed skill sequence.
- A simple, well-specified task consumes meaningfully less context than a complex, ambiguous one — both using the same pipeline.

## Assumptions Surfaced

- The estimate skill's current dimensions (complexity x impact) are insufficient for this; a notion of "uncertainty" or "ambiguity" may be needed, but where that assessment lives (estimate skill, the skills themselves, or elsewhere) is an open design question for solutioning.
- Skills already have closing prompts that nudge toward the next phase — the mechanism exists, it just needs to be made conditional.
- Leeroy's orchestration logic will need to change from a hardcoded phase list to something that delegates routing to the skills themselves.

## Workstream Slug

`conditional-workflow-phases`
