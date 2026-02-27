# Agentic Delivery Skills

This directory contains portable, tool-agnostic skills implementing a structured, multi-phase approach to software development. These skills work with Claude Code, Cursor, and any AI coding agent with basic file access.

```
╔════════════════════════════════════════════════════════════════════════════════╗
║                         AGENTIC DELIVERY WORKFLOW                              ║
╠═══════════════════════════╦══════════════════════╦═════════════════════════════╣
║   1. BUILD A SHARED       ║   2. PLAN THE WORK   ║   3. IMPLEMENT THE PLAN     ║
║      UNDERSTANDING        ║                      ║                             ║
╠═══════════════════════════╬══════════════════════╬═════════════════════════════╣
║                           ║                      ║                             ║
║  ┌─────────────────────┐  ║  ┌───────────────┐   ║  ┌───────────────────────┐  ║
║  │    Understanding    │  ║  │   Planning    │   ║  │    Implementation     │  ║
║  │   /understanding    │  ║  │   /planning   │   ║  │  /produce  /pair-on   │  ║
║  └──────────┬──────────┘  ║  └──────┬────────┘   ║  └───────────┬───────────┘  ║
║             │             ║         │            ║              │              ║
║  ┌──────────▼──────────┐  ║  ┌──────▼────────┐   ║  ┌╌╌╌╌╌╌╌╌╌╌╌▼╌╌╌╌╌╌╌╌╌╌╌┐  ║
║  │     Solutioning     │  ║  │  Pre-Flight   │   ║  ╎   Review & Revise     ╎  ║
║  │    /solutioning     │  ║  │  /pre-flight  │   ║  ╎      coming soon      ╎  ║
║  │    /tire-kicking    │  ║  └───────────────┘   ║  └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘  ║
║  └─────────────────────┘  ║                      ║                             ║
║                           ║                      ║                             ║
╚═══════════════════════════╩══════════════════════╩═════════════════════════════╝

  Use anytime:  /recon  /clarify  /reasoning  /estimate  /commit
```

## Agentic Delivery Phases & Skills

### Phase 1: Build A Shared Understanding

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

### Phase 2: Plan The Work

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
- Recommend parallelization or simplification

### Phase 3: Implement The Plan

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
- Agent chooses work order and parallelization strategy
- Agent manages git history with semantically coherent commits
- Minimal intervention needed—commits are the deliverable

**Step 2 - Review & Revise:** *(Coming soon)*

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

**Skill:** `/artifactor` → `artifactor/SKILL.md`
- Guidance for skill authors on artifact placement principles
- Ensures all agent-generated artifacts are project-local (not in home directories)
- Provides checklists and validation criteria for skills that generate artifacts
- **Note:** This is meta-guidance for skill development, not a workflow skill for users

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

**Skill:** `/tire-kicking` → `tire-kicking/SKILL.md`
- Stress-test proposed designs against concrete scenarios
- Identify where designs hold, bend, or leak before implementation
- Validate approaches against edge cases, lifecycle events, and data changes
- **Typical usage:** After Solutioning, before or alongside Planning to validate designs

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
