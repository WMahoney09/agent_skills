---
name: planning
description: Design and document the implementation approach. Use after aligning on a solution direction to create a detailed step-by-step plan before implementation begins.
---

# Planning: Architecture-to-Implementation Phase Skill

This skill guides you through creating a detailed implementation plan based on the solution direction chosen during Solutioning.

## Goal

Transform the architectural direction into a concrete, step-by-step implementation plan that:
- Breaks down the work into phases, steps, and tasks
- Identifies dependencies and critical files
- Calls out gotchas and risks
- Gives you and Claude shared confidence in how to execute

## Your Role

As the person reviewing this skill:
- Provide the context needed to build an accurate plan (what exists, what constraints apply)
- Answer clarifying questions honestly and completely
- Ask questions if you need clarification on the plan or proposed steps
- Review and iterate on the draft plan until you're confident

## Agent's Role

The agent running this skill should work through these three stages:

### Stage 1: Gather Information Through Interactive Q&A

Before writing any plan document, the agent should:

1. **Ask clarifying questions** to understand:
   - What files/systems will be touched and where they live
   - What dependencies exist (internal, external, organizational)
   - What are the actual constraints on timing, scope, or approach
   - What testing, documentation, or review processes are needed
   - Who needs to be involved or informed
   - What "done" looks like in concrete terms

2. **Review answers and continue dialogue** by:
   - Clarifying any unclear responses
   - Asking follow-up questions based on the answers given
   - Answering any questions the person asked in their response
   - Building a complete picture before planning begins

3. **Iterate until clarity** - Keep asking and refining until the agent has enough information to write a sound plan

### Stage 2: Synthesize and Plan

Once information gathering is complete, the agent should:

1. Review what was learned
2. Identify the logical phases of work
3. Break each phase into concrete steps
4. Identify blockers, risks, and dependencies
5. Estimate scope (in terms of files touched, complexity, not time)

### Stage 3: Present the Plan

**Before Writing the Plan Document:**

Follow the `artifactor` skill to determine where to save the plan file, confirm the path with the user, and validate the location before writing.

Generate a written plan document that includes:

- **Overview**: High-level summary of what will be built
- **Phases**: Logical groupings of work (e.g., Setup, Core Implementation, Testing, Integration)
- **Steps**: Within each phase, the concrete actions to take
- **Dependencies**: What must happen before other things can begin
- **Critical Files**: Which files will be created, modified, or removed
- **Gotchas & Risks**: Potential problems and how to mitigate them
- **Success Criteria**: How you'll know this phase/step is complete

## Key Principles

- **Information comes first** - Don't guess about your constraints or environment. Ask until you understand.
- **No implementation yet** - This is the blueprint, not the build. Describe *what* will happen and *why*, not yet *how in detail*.
- **Identify critical paths** - Make clear what must be done in sequence vs. what can be parallelized.
- **Surface assumptions** - Call out any assumptions the agent is making so they can be validated.
- **Scope clarity** - Be explicit about what's included in this plan and what's not (e.g., "We'll update the API, but not the frontend" or "This assumes Redis is already set up").
- **Artifacts are project-local** - All generated artifacts (plans, notes, configurations) must be saved to the project, never to home directory conventions like `~/.claude/*`, `~/.cursor/*`, or `~/.vscode/*`. See the [Artifactor skill](./artifactor.md) for full guidance on this principle.

## The Interactive Q&A: What to Ask

Example categories of questions an agent might explore:

**Project Structure & Files:**
- Where does this change live in the codebase?
- Are there existing patterns or utilities we should use?
- What other files depend on what we're changing?

**Integration Points:**
- Does this touch any external systems or APIs?
- Are there other teams or systems we need to coordinate with?
- What existing functionality might this affect?

**Constraints & Requirements:**
- Are there performance targets or constraints?
- Does this need to work in a specific way for backward compatibility?
- Are there organizational or process constraints?

**Testing & Validation:**
- What testing is required before this goes live?
- Are there specific test scenarios or edge cases we need to cover?
- Who reviews this before it's merged/deployed?

**Scope Boundaries:**
- What's explicitly *not* included in this work?
- Are there related problems we should defer?
- What should the person do if they discover X during implementation?

## Closure Criteria

You're ready to move to Implementation when:

- [ ] The plan is written and clear
- [ ] You understand each phase and why it's structured that way
- [ ] You know what files will be touched and why
- [ ] Dependencies are explicit
- [ ] You've identified gotchas and how to handle them
- [ ] You feel confident in the approach
- [ ] Any assumptions have been surfaced and validated

## Closing the Phase

When the plan is solid, confirm:

**"Here's the plan I've drafted based on what we discussed: [brief summary]. Does this match what you're thinking? Are there any changes or clarifications needed before we move to implementation?"**

Iterate on feedback until the plan feels right. Once approved, you're ready for Implementation.

## Notes

- Quality planning prevents rework during implementation
- A thorough plan means fewer surprises mid-stream
- If during Q&A the agent realizes something important changes, go back to Solutioning
- The plan should be detailed enough to execute but not so detailed that it becomes implementation
- Good plans call out what they don't cover, so expectations are clear
