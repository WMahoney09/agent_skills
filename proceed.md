---
name: proceed
description: Execute the implementation plan phase-by-phase, step-by-step, or task-by-task with user-controlled review and commit boundaries.
disable-model-invocation: true
---

# Proceed: Implementation Execution with User-Controlled Boundaries

This skill executes the implementation plan from Phase 3, with you directing when to pause for review and committing between units.

## Goal

Execute the implementation plan at your chosen granularity (Phase, Step, or Task) while you:
- Review completed work
- Manage git history through commits
- Control when the agent proceeds to the next unit
- Request adjustments as needed

## Your Role

- Choose your review granularity at the start (Phase / Step / Task)
- Review completed work
- Make git commits as you see fit
- Request changes if needed, or approve and say "proceed"
- Say "proceed" to move the agent to the next unit
- Manage the git history and commit messages

## Agent's Role

The agent executing this skill should:

1. **Ask for granularity** at the start
2. **Execute one unit** at the chosen level
3. **Pause and wait** for your signal
4. **Accept feedback** and adjust if needed
5. **Only proceed** when explicitly told "proceed"

## Phase 1: Set Granularity

Before any implementation begins, the agent should ask:

**"How would you like me to proceed? Choose your review boundary:"**

- **Phase Level** - I'll complete an entire phase, then pause for review
- **Step Level** - I'll complete one step at a time, then pause for review
- **Task Level** - I'll complete one task at a time, then pause for review

The choice depends on how frequently you want to review:
- **Phase Level**: Fewer, larger review sessions (longer stretches of work)
- **Step Level**: Moderate review frequency (moderate stretch of work per unit)
- **Task Level**: Frequent review (smallest units, most control points)

## Phase 2: Execution Loop

For each unit of work at your chosen granularity:

### Execute

The agent should:
- Work through the complete unit (phase, step, or task)
- Write clean, focused code following the plan
- Make progress toward the defined success criteria
- Stop when the unit is complete

### Report

The agent should:
- Summarize what was completed
- Highlight key decisions or changes made
- Point out any issues encountered or workarounds applied
- Show the code/changes made (or indicate files changed if large)
- Confirm the unit's success criteria are met

### Pause and Wait

The agent should:
- Stop all work
- Wait for explicit feedback from you
- Not proceed until you explicitly say "proceed"
- Not make assumptions about what you want next

## Phase 3: User Review and Decision

At each pause point, you should:

1. **Review the work** - Read code, test functionality, verify it matches the plan
2. **Commit if satisfied** - Make a git commit with an appropriate message
3. **Make a decision:**

### Decision A: Approve and Proceed
- Say: **"proceed"**
- Agent moves to the next unit at your chosen granularity

### Decision B: Request Changes
- Specify what changes you want
- Agent re-does the current unit with your feedback
- Once adjusted, commit and say "proceed"

### Decision C: Skip or Defer
- Tell the agent to skip the current unit and move to the next one, or
- Tell the agent to pause entirely while you handle something else
- Resume with "proceed" when ready

## Key Behaviors

### The Agent Must:
- Complete only one unit per execution cycle
- Pause immediately after finishing a unit—do not continue to the next unit
- Wait for explicit "proceed" command before continuing
- Accept adjustment requests without question
- Re-execute the current unit if changes are requested
- Never assume or infer intent—ask if unclear

### The Agent Should Not:
- Continue to the next unit without an explicit "proceed" signal
- Combine units (e.g., do two tasks in one execution if set to Task level)
- Make commits—that's your job
- Push to remote—that's your decision
- Interpret silence as approval

## Example Workflow

**Setup:**
```
/proceed
→ Agent: "Choose your granularity: Phase / Step / Task?"
You: "Step level"
```

**First Unit:**
```
Agent: Executes Step 1
Agent: "Step 1 complete: [summary]. Ready for review."
You: Review, test, commit
You: "proceed"
```

**Second Unit:**
```
Agent: Executes Step 2
Agent: "Step 2 complete: [summary]. Ready for review."
You: "Actually, I need X changed in Step 2"
Agent: Adjusts Step 2
You: Review again, commit
You: "proceed"
```

**Continue:**
```
Agent: Executes Step 3
... and so on
```

## Success Criteria

Proceed is complete when:
- [ ] The entire plan has been executed
- [ ] You've reviewed and committed each unit
- [ ] All work is in git with clear commit history
- [ ] You're satisfied with the implementation

## Closure

When the final unit is complete and committed:

**Agent:** "Implementation complete. All phases/steps/tasks finished and committed. Ready to move to Review phase?"

At this point, the workflow moves to the Review phase where you'll do a holistic review before any finalization.

## Notes

- This workflow gives you full control over review cadence and commit boundaries
- You're the keeper of git history—each commit represents your approval of a unit
- If a unit needs major rework, you can request it; the agent will redo it
- Pause can happen at any time if you need to handle something outside this workflow
- The agent works at your pace, not on its own schedule
- Clear communication about what "proceed" means prevents confusion
