# Phased Development Workflow

This skill orchestrates a structured, multi-phase approach to building features and solving problems with Claude as a co-architect.

## Workflow Phases

The workflow consists of six sequential phases:

1. **Discovery** - Build shared understanding of the problem
2. **Exploration** - Discuss multiple solution approaches
3. **Planning** - Choose an approach and design implementation
4. **Implementation** - Execute the plan
5. **Review** - Evaluate the work and iterate if needed
6. **Commit** - Finalize changes in version control

## Phase 1: Discovery

**Goal:** Build a shared understanding of the problem, constraints, and context.

**Your role:**
- Explain the problem you're trying to solve
- Describe the context and constraints
- Share what you've already tried or considered

**Claude's role:**
- Ask clarifying questions to deepen understanding
- Identify hidden assumptions or constraints
- Reflect back what's understood so far

**Closure criteria:**
- You and Claude have aligned on what the problem actually is
- You've articulated key constraints and tradeoffs
- You understand what success looks like

**Transition question:** "Do we have a clear shared understanding of the problem and constraints?"

---

## Phase 2: Exploration

**Goal:** Discuss multiple viable approaches without committing to one.

**Your role:**
- Be open to different solutions
- Push back on approaches that don't fit your context
- Think out loud about tradeoffs

**Claude's role:**
- Propose 2-3 meaningfully different approaches
- For each, explain the tradeoffs (complexity, maintainability, flexibility, performance)
- Help you reason through which fits best
- Highlight pros and cons specific to your situation

**Closure criteria:**
- You've considered at least 2-3 distinct approaches
- You understand the tradeoffs of each
- You have a clear sense of which direction appeals most

**Transition question:** "Which approach feels right, and why?"

---

## Phase 3: Planning

**Goal:** Design the implementation approach before writing code.

**Your role:**
- Confirm which approach you're going with
- Ask questions about the plan
- Flag concerns about feasibility or complexity
- Decide on any implementation details that matter to you

**Claude's role:**
- Propose a step-by-step implementation plan
- Identify critical files and dependencies
- Call out potential pitfalls or gotchas
- Present architectural decisions clearly

**Closure criteria:**
- You have a clear, written plan
- You understand why each step is necessary
- You've approved the approach or discussed modifications
- You know what files will be touched and why

**Transition question:** "Does this plan look sound? Are you ready to implement?"

---

## Phase 4: Implementation

**Goal:** Execute the plan and build the feature/fix.

**Your role:**
- Let Claude work through the implementation
- Point out issues or course corrections as they emerge
- Approve or request changes to the approach mid-stream if needed

**Claude's role:**
- Follow the plan from Phase 3
- Make decisions consistent with the architecture discussed
- Ask for guidance only when the plan needs adjustment
- Write clean, focused code

**Closure criteria:**
- The implementation is complete
- Tests pass (if applicable)
- The code matches what was planned

**Transition question:** "Implementation looks complete. Ready to review?"

---

## Phase 5: Review

**Goal:** Evaluate the work, ensure it meets requirements, iterate if needed.

**Your role:**
- Read through the changes
- Test functionality if needed
- Identify any issues or gaps
- Request changes or iterations

**Claude's role:**
- Summarize what was built and how it works
- Explain design decisions made during implementation
- Be ready to iterate on feedback
- Highlight any assumptions or limitations

**Closure criteria:**
- You're satisfied with the implementation
- All issues are resolved
- You're ready to commit

**Transition question:** "Does this look good to commit?"

---

## Phase 6: Commit

**Goal:** Save the work to version control with clear commit messages.

**Your role:**
- Approve the commit message
- Verify git staging looks correct
- Push if appropriate for your workflow

**Claude's role:**
- Stage relevant changes
- Draft a clear commit message explaining the *why*
- Create the commit
- Verify the commit succeeded

**Closure criteria:**
- Changes are committed
- Commit message is clear and accurate
- You can move to the next task

---

## How to Use This Skill

When you're starting a new piece of work that fits this workflow, invoke it and provide your initial problem statement:

```
/phased-development

Here's what I'm trying to build...
```

The workflow will guide you through each phase. At each transition point, the skill will ask closure questions to ensure you're ready to move forward.

## Skipping or Shortening Phases

If a problem is very small (a one-line bug fix, obvious refactor), you can skip directly to implementation. But for anything substantial, moving through discovery and exploration prevents rework.

## Restarting a Phase

If you realize mid-way through implementation that the plan needs adjustment, you can restart the planning phase without losing context. Just say so.

## Notes

- This workflow emphasizes shared understanding and architectural clarity before implementation
- The goal is to prevent the common pattern of building, then discovering the approach was wrong
- Each phase builds on the previous one; they flow in sequence
- The skill preserves context across phases, so Claude carries forward what you've discussed
