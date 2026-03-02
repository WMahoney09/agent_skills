---
name: pre-flight
description: Review the implementation plan for gaps, contradictions, and opportunities before execution. Final check before Implementation phase begins.
agent-invocation: user-invoked-only
agent-note: "Agents may execute this skill ONLY when explicitly invoked by the user (e.g., /pre-flight). Agents must NEVER invoke this skill autonomously or on their own initiative."
---

# Pre-Flight: Plan Validation and Optimization

This skill performs a thorough review of the implementation plan to catch issues before they derail work during Implementation.

## Goal

Validate the plan by identifying and surfacing:
- **Gaps** - Missing pieces, incomplete steps, or unaddressed requirements
- **Contradictions** - Conflicting requirements, incompatible approaches, or circular dependencies
- **Open Questions** - Ambiguities that need clarification before proceeding
- **Opportunities** - Ways to parallelize work, simplify steps, or reduce complexity

## Your Role

- Provide the finalized plan from Phase 3
- Review the findings
- Decide on changes before moving to Implementation
- Flag any items you want adjusted before proceeding

## Agent's Role

The agent conducting the pre-flight review should work systematically through the plan, checking for:

### 1. Completeness & Gaps

- Does every step have a clear outcome or deliverable?
- Are all dependencies listed, or are there implicit ones?
- Are there placeholders like "TBD" or "TK" that need resolution?
- Does the plan address all requirements from the Understanding phase?
- Is the success criteria for each step actually verifiable?
- Are error cases or edge cases addressed?
- Are there steps that depend on external factors (API responses, team decisions, etc.) that aren't called out?

### 2. Contradictions & Conflicts

- Do any steps conflict with each other?
- Are there circular dependencies (A depends on B, B depends on A)?
- Do any steps contradict the constraints identified in Understanding?
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

- Are there steps that could be parallelized but are listed sequentially?
- Can any steps be combined or eliminated?
- Are there repeated patterns that could be consolidated?
- Is there unnecessary work or over-engineering?
- Could the phases be reordered to unlock earlier parallelization?

## Review Output

Present your findings as:

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

**Confidence Level:**
- Provide an assessment: "Plan is ready to implement" vs. "Issues should be resolved before Implementation" vs. "Critical issues found, recommend returning to Planning"

## Handling Issues

### If critical issues are found:
Recommend returning to the Planning phase to resolve them before proceeding. This prevents implementing based on a flawed plan.

### If minor issues are found:
Flag them so the person can decide: proceed with the caveat in mind, or adjust the plan first.

### If no major issues are found:
Confirm that the plan is solid and ready for Implementation.

## What Constitutes Different Severity Levels

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
- Possible optimizations or parallelization opportunities
- Steps that could be clearer
- Non-blocking clarifications needed

## Closure Criteria

Pre-flight is complete when:

- [ ] All issues (critical and major) have been identified and listed
- [ ] Opportunities for optimization have been noted
- [ ] Recommendations for fixes have been provided
- [ ] Questions for clarification are explicit
- [ ] A confidence level has been assigned
- [ ] The person has decided how to proceed

## Notes

- Pre-flight is a sanity check, not a redesign. If major rework is needed, that's a signal to go back to Planning.
- The goal is to catch preventable problems before they cause delays in Implementation.
- Small details can often be resolved during Implementation; pre-flight focuses on structural issues.
- An optimized plan (parallelized, simplified) is better than a correct-but-inefficient one.
