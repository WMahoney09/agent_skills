# Solution Statement

## Candidates

### Candidate 1: Floating `/uml` skill with ASCII sequence and component diagram modes

A single skill file (`uml/SKILL.md`) that instructs the agent to produce ASCII UML diagrams inline. The skill supports two modes inferred from conversational context:

1. **Sequence diagrams** — actors across the top with lifelines, labeled messages between participants, conditional blocks, and return values. Used when the user is tracing a flow or interaction over time (e.g., "map this request flow", "trace how login works").

2. **Component diagrams** — boxes with labeled relationships and arrows. Used when the user wants to see how modules, services, or classes relate to each other (e.g., "show me how these services connect", "what depends on what").

**Format:** ASCII only — box-drawing characters, pipes, dashes, arrows. No Mermaid. Readable inline in terminal chat and in markdown documents.

**Depth:** 3–4 layers by default. User can request a zoom-in on any node, which produces a new diagram in a new response focused on that subtree at greater depth.

**Before/after:** When a proposed change is in context, the skill can show current state alongside proposed state.

**Input:** Ranges from explicit ("UML of POST /login flow") to implicit (inferred from conversation context).

**Triggers:** "give me a UML", "can I get a UML", "map this flow", "show me the topology", "diagram this", "trace this flow", or any phrasing requesting a visual map of code structure or data flow.

**Persistence:** Inline output by default. An `ARTIFACT.md` defines output structure but no file is persisted unless explicitly requested.

**LOE:** 2 — single skill file with an artifact template. No code, no integrations. The complexity is in writing clear enough instructions that the agent produces consistent, readable output.

This is the only candidate. The problem statement prescribes the approach: the constraints (ASCII format, floating skill, named invocation, consistent conventions) eliminate alternatives. There is no meaningful second candidate — the decisions are about what goes in the skill file, not whether to build a skill.

## Next Step
Recommendation: Plan
Confidence: high
Rationale: Prescriptive problem with a single viable direction — no ambiguity to resolve through reasoning or tire-kicking.
