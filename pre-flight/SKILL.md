---
name: pre-flight
description: |
  Validate an implementation plan for gaps, contradictions, and opportunities before execution.
  TRIGGER when: a plan exists and the user asks to validate it before starting ("check the plan", "review the plan", "pre-flight this", "anything we're missing", "are we ready to start").
---

# Pre-Flight: Plan Validation and Optimization

Review an implementation plan to catch issues before they derail work during execution.

## Goal

Validate the plan by identifying and surfacing:
- **Gaps** - Missing pieces, incomplete steps, or unaddressed requirements
- **Contradictions** - Conflicting requirements, incompatible approaches, or circular dependencies
- **Open Questions** - Ambiguities that need clarification before proceeding
- **Opportunities** - Ways to simplify steps, reduce complexity, or clarify sequencing

## Review Dimensions

### 1. Completeness & Gaps

- Does every step have a clear outcome or deliverable?
- Are all dependencies listed, or are there implicit ones?
- Are there placeholders like "TBD" or "TK" that need resolution?
- Is the success criteria for each step actually verifiable?
- Are error cases or edge cases addressed?
- Are there steps that depend on external factors (API responses, team decisions, etc.) that aren't called out?

### 2. Contradictions & Conflicts

- Do any steps conflict with each other?
- Are there circular dependencies (A depends on B, B depends on A)?
- Do any steps contradict the stated constraints?
- Are there mutually exclusive decisions that both got included?
- Do the gotchas mentioned actually align with how the solution is proposed?

### 3. Internal Consistency

- Do the phases make logical sense in order?
- Are prerequisites clearly stated before dependent steps?
- Does the critical path make sense?
- Are assumptions consistent throughout (e.g., if Phase 1 assumes X, do later phases still assume X)?
- Do file modifications make sense given dependencies?

### 4. Clarity & Ambiguity

- Are any steps vague or open to interpretation?
- Could two different people read step X and implement it differently?
- Are the "gotchas" specific enough to be actionable?
- Is the scope clearly bounded (what's in vs. out)?

### 5. Opportunities for Optimization

- Can any steps be combined or eliminated?
- Are there repeated patterns that could be consolidated?
- Is there unnecessary work or over-engineering?
- Are there steps that could be simplified without losing clarity?
- Could the phases be reordered to reduce dependencies or unblock earlier work?

## Review Output

Present findings as:

**Issues Found:**
- List each issue with:
  - **What**: The specific problem
  - **Where**: Which phase/step it affects
  - **Impact**: Why it matters (blocks other work, ambiguous, risky, etc.)
  - **Suggestion**: Proposed fix or clarification needed

**Opportunities Identified:**
- List suggested improvements with reasoning

**Questions for the Person:**
- Any clarifications needed on how the person wants issues resolved

**Confidence Assessment:**
- "Plan is ready to implement" vs. "Issues should be resolved first" vs. "Critical issues found, recommend revising the plan"

## Severity Definitions

**Critical:**
- Circular dependencies
- Contradictions with stated constraints
- Missing prerequisites for key steps
- Undefined success criteria

**Major:**
- Ambiguous steps that could be interpreted multiple ways
- Gaps in logic or flow
- Implicit dependencies not called out
- Missing error handling

**Minor:**
- Possible simplifications or sequencing improvements
- Steps that could be clearer
- Non-blocking clarifications needed

## Handling Issues

- **Critical issues found:** Recommend revising the plan before proceeding. Implementing on a flawed plan compounds problems.
- **Minor issues found:** Flag them so the person can decide: proceed with the caveat in mind, or adjust the plan first.
- **No major issues found:** Confirm the plan is solid and ready for execution.

## Artifact

Produces inline findings (not saved to a file). See `ARTIFACT.md` for the canonical output format.

## Notes

- Pre-flight is a sanity check, not a redesign. If major rework is needed, that's a signal to go back and revise the plan.
- The goal is to catch preventable problems before they cause delays during execution.
- Small details can often be resolved during implementation; pre-flight focuses on structural issues.
- A simplified, well-sequenced plan is better than a correct-but-over-engineered one.
