# Phased Development Workflow Skills

This directory contains portable, tool-agnostic skills implementing a structured, multi-phase approach to software development. These skills work with Claude Code, Cursor, and any AI coding agent with basic file access.

## Phased Development Phases & Skills

### Phase 1: Understanding (Discovery)
**Skill:** `/understanding` → `understanding.md`
- Build shared understanding of the problem
- Clarify constraints, context, and success criteria
- No solutions proposed in this phase

### Phase 2: Solutioning (Exploration)
**Skill:** `/solutioning` → `solutioning.md`
- Explore 2-3 distinct architectural approaches
- Reason through tradeoffs of each
- Align on the direction that best fits your constraints
- High-level architecture only, not implementation

### Phase 3: Planning (Architecture-to-Implementation)
**Skill:** `/planning` → `planning.md`
- Interactive Q&A to gather full context
- Design step-by-step implementation plan
- Identify phases, steps, tasks, dependencies, and risks
- Ready before implementation begins

### Phase 3.5: Pre-Flight (Plan Validation)
**Skill:** `/pre-flight` → `pre-flight.md`
- Final review of the implementation plan
- Identify gaps, contradictions, and opportunities
- Validate plan readiness before implementation
- Recommend parallelization or simplification

### Phase 4: Implementation (Execution)

Three distinct approaches depending on your workflow:

**Skill 1:** `/proceed` → `proceed.md`
- User-controlled execution with granular review points
- Choose your review boundary: Phase, Step, or Task level
- Pause after each unit for your review and commit
- Agent executes, you manage git history and gate progress

**Skill 2:** `/produce` → `produce.md`
- Autonomous execution with intelligent atomic commits
- Agent chooses work order and parallelization strategy
- Agent manages git history with semantically coherent commits
- Minimal intervention needed—commits are the deliverable

### Phase 5: Review (Evaluation)
**Status:** Planned for future implementation

### Phase 6: Commit/Finalization (Version Control)
**Status:** Planned for future implementation

## Supporting Skills

**Skill:** `/reconnaissance` → `reconnaissance.md`
- Read-only investigation of code and documentation
- Explore existing systems and patterns
- Gather context before Understanding or as standalone research
- Works before, during, or independently of the main workflow

**Skill:** `/phased-development` → `phased-development.md`
- Overview document describing all phases
- Reference material showing how phases connect
- Not typically invoked directly, but useful for context

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
- Some skills are marked `disable-model-invocation: true` for manual-only invocation

## File Structure

The skills in this directory are source files. To use them in Claude Code or Cursor, install them to:

```
~/.claude/skills/<skill-name>/SKILL.md
```

Each skill includes YAML frontmatter specifying `name` and `description`, which determines the `/slash-command` and invocation behavior.

## Sources

- [Extend Claude with skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Claude Code Skills Setup in Cursor](https://www.cursor-ide.com/blog/claude-code-skills)
- [Using Skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
