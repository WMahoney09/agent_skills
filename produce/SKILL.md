---
name: produce
description: |
  Execute the implementation plan autonomously with intelligent atomic commits. Agent manages work order and git history.
  TRIGGER when: a plan exists and the user wants autonomous execution ("produce this", "build it", "execute the plan", "go ahead and implement", "run produce", "start building", "implement the plan"), or when the user signals they want the agent to take over implementation without step-by-step pairing.
---

# Produce: Autonomous Implementation with Intelligent Commits

Execute the implementation plan autonomously, with the agent making strategic decisions about work order and creating semantically coherent atomic commits.

## Goal

Complete the implementation plan without pause, managing:
- **Work order** - Choosing which units to execute and in what order
- **Commit strategy** - Creating atomic, logically grouped commits based on semantic relationships
- **Git history** - Producing a clean, navigable commit history that tells the story of the implementation

## Plan Analysis

Before beginning implementation:

- Review the full plan
- Identify dependencies and execution order
- Understand the logical groupings and concerns
- Plan a work sequence that respects dependencies

## Execution with Intelligent Commits

### Core Principle: Semantic Coherence

Each commit should represent a **logically coherent unit of work**. Files changed in a commit should be related by:
- **Feature/domain**: All parts of a User feature together, all parts of an Order feature separately
- **Concern/layer**: All API changes together, all UI changes together, all migrations together
- **Functional completeness**: Changes that must work together to provide a feature

### Commit Grouping Examples

**Good** — cohesive units:
- Login screen + login API route + session migration = **1 commit** (one feature end-to-end)
- All database migrations for a release = **1 commit** (single infrastructure concern)
- All UI component updates = **1 commit** (single layer)

**Bad** — unrelated domains mixed:
- Order UI change + User API change = **do not combine**
- User authentication + unrelated table cleanup = **do not combine**

### Commit Atomicity Rules

- **One logical concern per commit**: Changes are all related by domain, layer, or feature
- **Commit when a unit is complete**: After finishing a task or step that forms a coherent unit
- **Don't batch unrelated changes**: Just because work exists in the working directory doesn't mean it belongs together
- **Preserve logical narrative**: Someone reading the commits should understand the progression of work

### Execution Pattern

Every phase runs to completion before the next begins. Context isolation over throughput. When steps are independent, they can be executed in any order, but not simultaneously.

## Commit Decisions

At each natural break point, evaluate:

**Commit if:**
- A task or step is complete and forms a coherent unit
- The files changed all relate to the same domain/feature/concern
- The code is tested and working

**Don't commit if:**
- The unit is incomplete
- Changes belong to multiple unrelated concerns
- There are uncommitted dependencies needed for this to work

After staging files, **invoke the `/commit` skill** to create the commit. Do not run `git commit` directly. The agent decides **when** to commit and **what to stage**; `/commit` handles type classification, message formatting, and the actual commit.

## Phase-Boundary Progress Tracking

After completing each plan phase, update the plan file's Progress section:

1. Mark the phase row as complete: `- [x] Phase N: <name>`
2. If the phase deviated from the plan, add a brief inline deviation note
3. Invoke `/commit` for the plan file update before moving to the next phase

This produces a commit sequence of code commits for the implementation followed by a plan commit marking the phase complete, repeated for each plan phase.

## Deviation Handling

If the agent encounters:
- A blocker or issue it can't resolve — note it and skip that unit, continuing with others
- A deviation from the plan — document it and explain the reasoning in the final summary
- Ambiguity about grouping — choose the most logical grouping and note the decision

## Completion

When all phases, steps, and tasks are complete, provide a summary:
- List all commits made, grouped by concern/domain
- Confirm all plan items are complete
- Note any deviations from the plan
- Confirm git history is clean and coherent

## Notes

- This is autopilot mode: the agent has full autonomy over work order and commits
- The git history is the primary deliverable — it should be clean and navigable
- Semantic coherence matters more than batch size; a 5-file commit is fine if they're all related
- The agent should think like a human developer managing their own commits
