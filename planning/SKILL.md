---
name: planning
description: Design and document the implementation approach. Use after aligning on a solution direction to create a detailed step-by-step plan before implementation begins.
---

# Planning: Plan Phase Skill

This skill guides you through creating a detailed implementation plan based on the solution direction chosen during the Align stage.

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

Save the plan file to `.claude/work/<work-item>/` at the nearest project root, using the naming convention `<work-item>.plan.md`.

The plan file uses a **Phase → Step → Task** breakdown:

```
# <Title>

## Overview
## Notes
## Progress
- [ ] Phase N: <name>

---

## Phase N: <name>
### Step N.N: <name>
#### Task N.N.N: <description>
```

The **Progress** section uses checkbox syntax (`- [ ]` / `- [x]`). Planning creates it with all phases unchecked — `produce` owns updating it at phase boundaries.

The plan document must include:

- **Overview**: High-level summary of what will be built
- **Notes**: Out of scope items, key decisions, design rationale
- **Progress**: Checkbox list of all phases
- **Phases**: Logical groupings of work with steps and tasks
- **Critical Files**: Which files will be created, modified, or removed
- **Gotchas & Risks**: Potential problems and how to mitigate them
- **Success Criteria**: How you'll know the plan is complete

## Key Principles

- **Information comes first** - Don't guess about your constraints or environment. Ask until you understand.
- **No implementation yet** - This is the blueprint, not the build. Describe *what* will happen and *why*, not yet *how in detail*.
- **Identify critical paths** - Make clear what must be done in sequence and what ordering dependencies exist.
- **Surface assumptions** - Call out any assumptions the agent is making so they can be validated.
- **Scope clarity** - Be explicit about what's included in this plan and what's not (e.g., "We'll update the API, but not the frontend" or "This assumes Redis is already set up").
- **Artifacts are project-local** - All generated artifacts (plans, notes, configurations) must be saved to `.claude/work/<work-item>/` at the nearest project root, never to home directory conventions like `~/.claude/*`, `~/.cursor/*`, or `~/.vscode/*`.

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

## Artifact

Produces `<work-item>.plan.md` in `.claude/work/<work-item>/`. See `ARTIFACT.md` for the full template. Generated when the plan document is finalized and ready for pre-flight.

After pre-flight validation, run `/atomize` to ensure all plan phases score ≤ LOE 2 before execution begins. In the leeroyyyyy context, Stage 1 (interactive Q&A) is automated — the agent uses recon rather than asking the user.

## Closure Criteria

You're ready to move to the Implement stage when:

- [ ] The plan is written and clear
- [ ] You understand each phase and why it's structured that way
- [ ] You know what files will be touched and why
- [ ] Dependencies are explicit
- [ ] You've identified gotchas and how to handle them
- [ ] You feel confident in the approach
- [ ] Any assumptions have been surfaced and validated

## Closing the Phase

When the plan is solid, confirm:

**"Here's the plan I've drafted based on what we discussed: [brief summary]. Does this match what you're thinking? Are there any changes or clarifications needed before we move to the Implement stage?"**

Iterate on feedback until the plan feels right. Once approved, you're ready for Implementation.

## Notes

- Quality planning prevents rework during implementation
- A thorough plan means fewer surprises mid-stream
- If during Q&A the agent realizes something important changes, go back to Align (solutioning)
- The plan should be detailed enough to execute but not so detailed that it becomes implementation
- Good plans call out what they don't cover, so expectations are clear
