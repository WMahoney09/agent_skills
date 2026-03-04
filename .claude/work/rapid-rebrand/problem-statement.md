# Problem Statement

## Problem

The skills library's three-stage framing (Understanding → Planning → Implementation) is overloaded and doesn't reflect the actual delivery workflow. The bookend activities — research before solutioning and delivery after implementation — aren't represented at all. RAPID (Research → Align → Plan → Implement → Deliver) formalizes the five stages that actually exist into focused, separated concerns.

## Why It Matters / Why Now

- **Separation of concerns** — each stage currently does too much. Understanding and Solutioning are bundled; delivery isn't represented.
- **Room to grow** — each stage can be made more robust independently without overloading others.
- **Reflects reality** — research and delivery are real work that deserves representation in the framework.
- **Maps to product offering** — aligns with rapid prototyping workflows already offered by the team.

## Key Constraints

- **Documentation rebrand only** — no new skills, no behavioral changes to existing skills.
- **Scope:** README (diagram, stage descriptions, skill listings), skill frontmatter, and skill internal documentation.
- **`/leeroyyyyy` internal docs** should be updated to use RAPID stage names.
- **Deliver stage is thin** — enumerate manual activities (PR, deploy, demo, feedback, acceptance) but no `/deliver` skill yet.
- **Flag conflicts** between skill behavior and RAPID placement if discovered, but do not change skill behavior.

## Success Criteria

- README and all skill frontmatter consistently use RAPID terminology and five-stage framing.
- Pipeline diagram reflects five RAPID stages with correct skill mappings.
- Deliver stage documents real manual activities (PR creation, deployment, demonstration, feedback gathering, acceptance confirmation).
- Floating skills (`/clarify`, `/estimate`, `/recon`, `/reasoning`, `/commit`) are clearly distinguished from stage-bound skills.
- Someone new to the project can read the README and immediately understand the RAPID workflow end-to-end.

## Assumptions Surfaced

- `/understanding` is primarily Research but its closure work (confirming alignment on success criteria) naturally touches Align — this overlap is acceptable.
- `/reasoning` intentionally spans Research and Align as a floating skill.
- `/commit` is floating (used across stages by `/produce`, `/revise`, `/pair-on`).
- The RAPID acronym is the final naming — Research (not Recon), Align (not Understanding), Deliver (not Demonstrate).

## Workstream Slug

`rapid-rebrand`
