# RAPID Evolution: Pipeline to Toolkit

## Status
Proposed — 2026-03-16

## Context

As models become more capable (Opus 4.6 + max effort, large context windows), rigid orchestration that was necessary with earlier models can limit productivity. The core insight: give the model tools and a goal, not a step-by-step workflow. RAPID was built as an externalization of an experienced engineering workflow, and the individual skills encode genuine expertise — but the prescribed stage sequence (R → A → P → I → D) may be unnecessary scaffolding for current-generation models.

Some skills also overlap with maturing native Claude Code features (planning ~ plan mode, recon ~ explore agent). As the platform evolves, home-rolled solutions that duplicate native features should yield to them.

## Decision

Evolve RAPID from a linear pipeline to a composable toolkit with logical constraints.

**Skills are tools, not stages.** The model decides which skills to use based on the task. The RAPID letters become categories for organizing the toolkit, not a mandatory sequence.

**Preserve logical constraints, not sequence:**
1. A plan file must exist before pre-flight can run (precondition)
2. Pre-flight must pass before implementation begins (quality gate)
3. Implementation must be reviewed by a separate/new agent (fresh-eyes quality gate)
4. Review findings must be addressed before delivery (quality gate)

These are constraints on the tools, not stages in a pipeline. The model decides *when* to plan, *whether* to tire-kick, *whether* to run full solutioning — but cannot skip review or pre-flight.

**Leeroy evolves** from a fixed pipeline to "problem statement in, PR out" with emergent skill selection, not prescribed dispatch order.

**Native features win where they're better.** Watch for convergence with Claude Code's built-in capabilities and let them supersede home-rolled skills.

## Consequences

- Skills remain valuable as encoded expertise — the quality of each "play" is what matters
- The artifact system (externalized documents as handoff mechanisms) and commit convention remain infrastructure
- Multi-agent patterns become the natural next step: teams debating solutions, parallel specialized reviewers, adversarial stress-testing
- README and skill descriptions will need updating to reflect toolkit framing over pipeline framing
- Leeroy will need a rewrite
