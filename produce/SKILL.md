---
name: produce
description: Execute the implementation plan autonomously with intelligent atomic commits. Agent manages work order and git history.
agent-invocation: user-invoked-only
agent-note: "Agents may execute this skill ONLY when explicitly invoked by the user (e.g., /produce). Agents must NEVER invoke this skill autonomously or on their own initiative."
---

# Produce: Autonomous Implementation with Intelligent Commits

⚠️ **IMPORTANT: This skill is reserved for direct user invocation only. Agents may use this skill when explicitly invoked by the user (e.g., `/produce`), but must NEVER invoke this skill autonomously or on their own initiative.**

This skill executes the implementation plan autonomously, with the agent making strategic decisions about work order and creating semantically coherent atomic commits.

## Goal

Complete the implementation plan without pause, managing:
- **Work order** - Choosing which units to execute and in what order (including parallelization where beneficial)
- **Commit strategy** - Creating atomic, logically grouped commits based on semantic relationships
- **Git history** - Producing a clean, navigable commit history that tells the story of the implementation

## Your Role

- Review commits as they're pushed
- The git history speaks for itself; you don't need to manage it
- Intervene only if something goes wrong or diverges from the plan

## Agent's Role

**This skill is for direct user invocation only.** When a user explicitly invokes this skill (e.g., `/produce`), agents may execute it. However, agents must NEVER autonomously decide to invoke this skill on their own initiative.

The agent executing this skill (when invoked by the user) should:

1. **Review the plan** thoroughly
2. **Determine execution strategy** based on dependencies and parallelization opportunities
3. **Execute all units** in an optimal order
4. **Create atomic commits** with semantic coherence
5. **Manage git history** throughout execution
6. **Produce a clean, logical commit history** at completion

## Phase 1: Plan Analysis

Before beginning implementation, the agent should:

- Review the plan from Phase 3
- Identify dependencies and execution order
- Look for parallelizable work
- Understand the logical groupings and concerns
- Plan a work sequence that respects dependencies while optimizing flow

## Phase 2: Execution with Intelligent Commits

### Core Principle: Semantic Coherence

Each commit should represent a **logically coherent unit of work**. Files changed in a commit should be related by:
- **Feature/domain**: All parts of a User feature together, all parts of an Order feature separately
- **Concern/layer**: All API changes together, all UI changes together, all migrations together
- **Functional completeness**: Changes that must work together to provide a feature

### Commit Grouping Strategy

#### Good Groupings:
- User authentication screen + User login API route + User session migration = **1 commit** (cohesive feature)
- User profile UI + User profile API endpoint + User data model update = **1 commit** (cohesive feature)
- Order creation form + Order creation API handler + Order database schema = **1 commit** (cohesive feature)
- All database migrations for a release = **1 commit** (all infrastructure-related)
- All API route updates = **1 commit** (all backend layer)
- All UI component updates = **1 commit** (all frontend layer)

#### Bad Groupings:
- Order UI change + User API change = **Do not combine** (unrelated domains)
- Order API + User UI = **Do not combine** (unrelated domains)
- User authentication + database cleanup for unrelated tables = **Do not combine** (unrelated concern)

### Commit Atomicity Rules

- **One logical concern per commit**: Changes are all related by domain, layer, or feature
- **Commit when a unit is complete**: After finishing a task or step that forms a coherent unit
- **Don't batch unrelated changes**: Just because work exists in the working directory doesn't mean it belongs together
- **Preserve logical narrative**: Someone reading the commits should understand the progression of work

### Execution Patterns

#### Sequential Execution
If work is dependent, execute in order and commit after each logical unit completes.

#### Parallel Execution
If work is decoupled (e.g., User feature and Order feature are independent):
- Interleave execution to balance progress
- Keep changes grouped by domain when committing
- Don't mix Order changes with User changes in the same commit

#### Layered Execution
If implementing by layer (e.g., all migrations, then all APIs, then all UI):
- Complete all migrations and commit as one coherent unit
- Complete all API changes and commit as one coherent unit
- Complete all UI changes and commit as one coherent unit

## Phase 3: Commit Decisions

At each natural break point (task completion, step completion, or logical grouping), the agent should:

### Evaluate: Should I commit now?

**Commit if:**
- A task or step is complete and forms a coherent unit
- The files changed all relate to the same domain/feature/concern
- Committing now would help someone understand the progression
- The code is tested and working

**Don't commit if:**
- The unit is incomplete
- Changes belong to multiple unrelated concerns
- The work can be logically grouped with upcoming changes
- There are uncommitted dependencies needed for this to work

### Commit Message Format

All commits made during `produce` must follow the **commit** skill convention — type prefix, brief title, detailed body. Refer to the `commit` skill for the full format, type classification rules, and examples.

## Phase 4: Completion

When all phases, steps, and tasks are complete:

**Agent Summary:**
- List all commits made, grouped by concern/domain
- Confirm all plan items are complete
- Note any deviations from the plan (if any)
- Confirm git history is clean and coherent

## Success Criteria

Produce is complete when:

- [ ] All phases, steps, and tasks from the plan are executed
- [ ] All code is committed with atomic, semantically coherent commits
- [ ] Git history tells a clear story of the implementation
- [ ] Changes are logically grouped (same domain together, different domains separate)
- [ ] All commits have clear, descriptive messages
- [ ] Code is tested and working

## Key Behaviors

### The Agent Must:
- Execute the entire plan without stopping
- Create semantically coherent atomic commits
- Think about logical groupings before committing
- Avoid mixing unrelated domains in a single commit
- Write clear commit messages
- Manage the full git workflow

### The Agent Should Not:
- Commit after every single small change
- Mix unrelated concerns just because they're in the working directory
- Create cryptic or unclear commit messages
- Ask for permission to commit
- Pause and wait for user signal
- Leave unrelated changes uncommitted

## Deviation Handling

If the agent encounters:
- A blocker or issue it can't resolve → Note it and skip that unit, continuing with others
- A deviation from the plan → Document it and explain the reasoning in the final summary
- Ambiguity about grouping → Choose the most logical grouping and note the decision

## Notes

- This is autopilot mode: the agent has full autonomy over work order and commits
- The git history is the primary deliverable—it should be clean and navigable
- Semantic coherence matters more than batch size; a 5-file commit is fine if they're all related
- Parallel execution of decoupled work is encouraged for efficiency
- The agent should think like a human developer managing their own commits
