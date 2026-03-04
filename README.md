# Agentic Skills

A library of composable skills for structured software delivery, organized around the **RAPID** workflow.

**RAPID flow:** `Research → Align → Plan → Implement → Deliver`

> **Floating skills** (usable across stages): `/recon`, `/clarify`, `/reasoning`, `/estimate`, `/commit`

## Conventions

Every skill directory contains a `SKILL.md` conforming to [`SKILL.spec.md`](./SKILL.spec.md). Skills that produce phase artifacts also contain an `ARTIFACT.md` conforming to [`ARTIFACT.spec.md`](./ARTIFACT.spec.md). These two root-level spec files are the authoritative references for skill file structure and artifact definition structure, respectively.

## Agentic Delivery Phases & Skills

### Stage 1: Build A Shared Understanding

**Goal:** Arrive at a shared understanding of the problem *and* a high-level solution direction before any planning or implementation begins.

**Step 1 - Understanding:** `/understanding` → `understanding/SKILL.md`
- Build shared understanding of the problem
- Clarify constraints, context, and success criteria
- No solutions proposed in this phase

**Step 2 - Solutioning:** `/solutioning` → `solutioning/SKILL.md`
- Explore 2-3 distinct architectural approaches
- Reason through tradeoffs of each
- Align on the direction that best fits your constraints
- High-level architecture only, not implementation

### Stage 2: Plan The Work

**Goal:** Produce a documented list of discrete code changes needed to achieve the solution.

**Step 1 - Planning:** `/planning` → `planning/SKILL.md`
- Interactive Q&A to gather full context
- Design step-by-step implementation plan
- Identify phases, steps, tasks, dependencies, and risks
- Generate initial plan document

**Step 2 - Pre-Flight Validation:** `/pre-flight` → `pre-flight/SKILL.md`
- Interactive review and refinement of the plan
- Identify gaps, contradictions, and opportunities
- Validate plan readiness before implementation
- Recommend simplification
- Estimate LOE per phase as an observation (decomposition is out of scope)

**Step 3 - Atomize:** `/atomize` → `atomize/SKILL.md`
- Estimate every phase using `/estimate`
- Decompose any phase with LOE > 2 into subphases
- Iterate until all phases score ≤ 2
- Runs after pre-flight: first make it right, then make it atomic

### Stage 3: Implement The Plan

**Goal:** Execute the discrete changes documented in the plan, then verify the result.

**Step 1 - Implementation:**

Two distinct approaches depending on your workflow:

**Option A:** `/pair-on` → `pair-on/SKILL.md`
- Pair program with the agent through implementation
- Choose your review boundary: Phase, Step, or Task level
- Pause after each unit for your review and commit
- Agent executes, you manage git history and gate progress

**Option B:** `/produce` → `produce/SKILL.md`
- Autonomous execution with intelligent atomic commits
- Agent chooses work order and commit strategy
- Agent manages git history with semantically coherent commits
- Minimal intervention needed—commits are the deliverable

**Step 2 - Review & Revise:**

**`/review`** → `review/SKILL.md`
- Technical peer review of local changes or a pull request
- Covers security, architecture, correctness, tests, and accessibility
- Produces a severity-graded report (Critical / Major / Minor / Gaps / Opportunities)
- Delivers an explicit go/no-go merge recommendation
- Works locally (post-produce, pre-PR) or against any PR number

**`/triage`** → `triage/SKILL.md`
- Ingest feedback from a PR, review output, or a conversational list
- Group related items into unified revisions with explicit source linkage
- Prioritize by severity: Critical, Major, Minor
- Produce a structured report ready for action with `/revise`

**`/revise`** → `revise/SKILL.md`
- Address one revision at a time: align, implement, confirm, commit
- Lightweight alignment check before any code changes — agent states its understanding, you confirm
- Holistic implementation — if the issue is a pattern across files, all instances are fixed together
- User-gated commit — no change is committed until you explicitly confirm the issue is resolved
- Commit messages include revision ID and PR comment IDs for traceability with `/reply`

**`/reply`** → `reply/SKILL.md`
- Close the feedback loop by replying to each PR comment with the commit hash that addresses it
- Reads `Addresses:` trailers from `/revise` commits to build the mapping automatically
- Presents the full comment-to-commit mapping for confirmation before posting anything
- Flags any comments that have no associated commit so nothing slips through

## Orchestration Philosophy

Subagents are a **context management tool, not a speed optimization.** Every subagent dispatch is a context boundary — the invoking agent passes a committed artifact file, not conversation history.

**Sequential execution is the standard.** Phases and subagents run one at a time. Concurrent subagent dispatch introduces coordination risk (git index conflicts, file write races, ambiguous commit ownership) with no quality benefit.

**Commits are the handoff mechanism.** Each phase produces a committed artifact before the next phase begins. Subagents read committed files, never conversation context. This produces a readable git log that mirrors the pipeline: one commit per stage.

**Independence ≠ concurrency.** Noting that two steps are independent means they can be executed in any order — not that they should run simultaneously.

Concurrent tool calls within a single agent response (e.g., reading multiple files at once) are fine and unaffected by this principle.

---

## Meta

**Skill:** `/commit` → `commit/SKILL.md`
- Defines the typed commit convention used across all skills
- Type prefixes (`[plan]`, `[docs]`, `[code]`) are determined mechanically by the files changed
- Referenced by `produce` and other skills to ensure consistent git history
- **Note:** This is a shared convention skill — invokable directly but also referenced internally by other skills

**Skill:** `/estimate` → `estimate/SKILL.md`
- Defines the LOE scoring framework used to evaluate proposed changes
- Two-dimensional evaluation (Complexity × Impact) synthesized to a 1–5 score
- Referenced by `solutioning` and usable standalone to calibrate scope
- **Note:** This is a shared scoring skill — invokable directly but also referenced internally by other skills

## Supporting Skills

These skills can be used at any point in the workflow to deepen understanding, validate decisions, or gather context. The typical usage patterns below are recommendations, not strict requirements.

**Skill:** `/commit` → `commit/SKILL.md`
- Stage and commit current working changes using the typed commit convention
- Inspects `git status` and `git diff`, groups unrelated concerns into separate commits
- **Typical usage:** After completing any unit of work — phase, step, or ad-hoc change

**Skill:** `/recon` → `recon/SKILL.md`
- Read-only investigation of code and documentation
- Explore existing systems, architecture, and patterns
- Gather context through file exploration and documentation
- **Typical usage:** Before or during Understanding phase, or as standalone research

**Skill:** `/clarify` → `clarify/SKILL.md`
- Ask clarifying questions to sharpen and deepen shared understanding
- Surface hidden assumptions, contradictions, and constraints
- Test ideas and mental models through strategic questioning
- **Typical usage:** During Understanding or Reasoning phases to clarify ambiguities

**Skill:** `/reasoning` → `reasoning/SKILL.md`
- Reason through problems to extract truths, conditionals, and directional vectors
- Validate the problem and derive guiding principles
- Develop directional clarity before proposing solutions
- **Typical usage:** After Understanding, before Solutioning to establish direction

**Skill:** `/estimate` → `estimate/SKILL.md`
- Produce a Level of Effort (LOE) score for a proposed change
- Evaluate Complexity and Impact independently, then synthesize to a 1–5 score
- **Typical usage:** During Solutioning or Reasoning to calibrate scope and prioritize work

**Skill:** `/atomize` → `atomize/SKILL.md`
- Right-size a plan by estimating each phase and decomposing any phase with LOE > 2 into subphases
- Iterates estimate → decompose until every phase scores ≤ 2
- Produces a decomposition log and an updated plan ready for execution
- **Typical usage:** After `/pre-flight` — once the plan is coherent and correct, atomize ensures each phase is bounded before implementation begins

**Skill:** `/tire-kicking` → `tire-kicking/SKILL.md`
- Stress-test proposed designs against concrete scenarios
- Identify where designs hold, bend, or leak before implementation
- Validate approaches against edge cases, lifecycle events, and data changes
- **Typical usage:** After Solutioning, before or alongside Planning to validate designs

**Skill:** `/review` → `review/SKILL.md`
- Technical peer review of code changes — local diff or a specific pull request
- Covers security, architecture, correctness, tests, and accessibility (for UI-producing files)
- Produces a severity-graded report with an explicit go/no-go recommendation
- **Typical usage:** After `/produce` to verify local changes before opening a PR, or to review a collaborator's PR

**Skill:** `/triage` → `triage/SKILL.md`
- Ingest feedback from a PR, `/review` output, or a conversational list
- Group related items into unified revisions with quoted source linkage
- Prioritize by severity: Critical, Major, Minor
- **Typical usage:** After `/review` or when addressing PR comments — produces a prioritized revision list ready for `/revise`

**Skill:** `/revise` → `revise/SKILL.md`
- Address one revision at a time with a user-gated commit
- Align on the issue before touching code, implement holistically, confirm before committing
- Commit messages include revision ID and PR comment IDs for traceability with `/reply`
- **Typical usage:** After `/triage` to work through revisions one by one, or standalone for a direct fix

**Skill:** `/reply` → `reply/SKILL.md`
- Close the PR feedback loop by replying to each reviewer comment with the commit hash that addresses it
- Reads `Addresses:` trailers from `/revise` commits to build the mapping automatically
- Confirms the full comment-to-commit mapping before posting anything
- **Typical usage:** After all `/revise` work is complete — the final step before requesting re-review

## Danger Zone

> ⚠️ **Experimental skills live here. These push the boundaries of autonomous agent behavior. Use them when you're ready to hand the wheel over entirely and see what happens.**

**Skill:** `/leeroyyyyy` → `leeroyyyyy/SKILL.md`

The full send. **Precondition:** Understanding must be complete and `problem-statement.md` must exist in the workstream directory before invocation. Leeroyyyyy runs the entire delivery pipeline autonomously, dispatching every phase to a subagent with artifact file handoffs (not conversation context).

What Leeroyyyyy does autonomously:
- Explores 2–3 candidate solutions and stress-tests all of them
- Picks the best solution using evidence and codebase conventions
- Builds a detailed implementation plan and validates it in a pre-flight + reasoning loop (min 2, max 4 cycles)
- Atomizes the plan so every phase scores ≤ LOE 2
- Executes the plan with semantically coherent atomic commits, dispatching each phase to a subagent
- Runs a local technical review of its own output
- Triages the review findings and addresses all Critical and Major revisions
- Produces a `summary-statement.md` at completion

The only time Leeroyyyyy stops is when it hits an ambiguity that Recon cannot resolve and that would lead to meaningfully different implementations — or when unresolvable Critical/Major issues remain after the review cycle. Everything else, it decides.

- **Cannot be invoked by reference** — direct user invocation only
- **Establishes the orchestrator permission pattern** — how user-invoked skills can grant sub-skills permission to run by reference

## How Skills Work

**Skills are stored in directories with a `SKILL.md` file inside**, not just as `.md` files. The structure matters for both Claude Code and Cursor.

## Where Skills Live

You have three locations depending on scope:

| Location  | Path | Applies to |
|-----------|------|-----------|
| Personal  | `~/.claude/skills/<skill-name>/SKILL.md` | All your projects |
| Project   | `.claude/skills/<skill-name>/SKILL.md` | This project only |
| Enterprise/Plugin | Managed elsewhere | Organization-wide |

## Portability

These skills are **tool-agnostic and portable**:
- ✅ Work with Claude Code (native skill support)
- ✅ Work with Cursor (agents can follow the workflow)
- ✅ Work with any AI coding agent (Windsurf, Aider, etc.)
- ✅ Can be enhanced for specific tools later (e.g., Claude Code versions using context forking)

## Invocation

Skills are invoked with `/skill-name`:
- Type `/understanding` to invoke the Understanding skill directly
- Some skills can be invoked by agents automatically when relevant
  - e.g. the `/produce` skill
- Some skills are marked `disable-model-invocation: true` for manual-only invocation

## File Structure

The skills in this directory are source files. To use them in Claude Code or Cursor, install them to:

```
~/.claude/skills/<skill-name>/SKILL.md
```

Each skill includes YAML frontmatter specifying `name` and `description`, which determines the `/slash-command` and invocation behavior.

## Sources

- [Agent Skills](https://agentskills.io/home)
- [Extend Claude with skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Claude Code Skills Setup in Cursor](https://www.cursor-ide.com/blog/claude-code-skills)
- [Using Skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
