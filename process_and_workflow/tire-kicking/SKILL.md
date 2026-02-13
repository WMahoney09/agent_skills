---
name: tire-kicking
description: Stress-test a proposed design or approach against scenarios (edge cases, lifecycle, multi-actor, data change). Use when you have a candidate solution and want to find where it holds, bends, or leaks before locking the plan or implementing.
---

# Tire-Kicking: Scenario Evaluation of a Proposed Design

This skill guides stress-testing a proposed design (or 2–3 options) against concrete scenarios to see where each **holds**, **bends**, or **leaks**. It sits after Solutioning (we have a direction) and before or alongside Planning (we lock the plan). The goal is to find gaps, over-constraints, or invalid assumptions before implementation.

## Goal

- **Surface where the design holds** — Handles the scenario without new design or operational patches.
- **Surface where it bends** — Can handle it but needs an explicit rule, convention, or one-off decision (document it or it will bite later).
- **Surface where it leaks** — Fails, undermines an invariant, or leaves a gap that can’t be closed without changing the approach.

Use the results to: fix the design (address leaks), document the rules (turn bends into explicit decisions), and record the path forward (why we chose this approach and how we closed the gaps).

## Your Role

- Provide the proposed design(s) or approach(es) to stress-test.
- Define or agree on scenarios (edge cases, lifecycle, actors, data changes).
- Review the agent’s classification (holds / bends / leaks) and notes.
- Decide how to close leaks (change design vs accept and document) and how to document bends.
- Optionally ask for a path-forward summary (decisions, rationale, and what’s left for the plan).

## Agent's Role

The agent running this skill should:

1. **Take the proposed design as given** — Don’t redesign; evaluate it.
2. **Work scenario by scenario** — For each scenario, state whether the design holds, bends, or leaks, and why (short notes).
3. **Be concrete** — Reference the actual model (tables, keys, flows) and the scenario setup so the classification is traceable.
4. **Call out assumptions** — If a scenario is underspecified, say what you assumed and how that affects the result.
5. **Summarize** — After all scenarios, summarize where the design leaks or bends most, and what would need to change or be documented.
6. **Optionally draft a path-forward** — If asked, record decisions, how leaks were closed, and what’s left for the plan (as in path-forward.md).

## Classification

| Result | Meaning |
|--------|--------|
| **Holds** | The approach handles the scenario without new design or operational patches. |
| **Bends** | The approach can handle it but needs an explicit rule, convention, or one-off decision; document it or it will bite later. |
| **Leaks** | The approach fails, undermines determinism (or another invariant), or leaves a gap that can’t be closed without changing the approach. |

## Typical Flow

### 1. Scope and scenarios

- **Input:** Proposed design (e.g. “pairwise attribute value incompatibilities table”) or 2–3 options.
- **Scenarios:** List scenarios to evaluate. Include:
  - **Edge cases** — Minimal/maximal config (e.g. no inactive attrs, only one value per attribute).
  - **Lifecycle** — Data or config changes (new value added, attribute flipped active/inactive, cascade delete).
  - **Multi-actor** — Customer vs tester vs admin vs integration; who does what and when.
  - **Data change** — Edit that makes two entities “match,” bulk update, import, feed run.
- **Output:** A scenario list (numbered or named) that both sides agree on.

### 2. Evaluate each scenario

For each scenario:

- **Setup:** One-line description of the situation.
- **Result:** Holds / Bends / Leaks.
- **Notes:** Why; what rule or change would close a bend or leak.

Present in a table (scenario | result | notes) or per-scenario blocks. Keep notes short and actionable.

### 3. Summarize and recommend

- **Leaks:** List scenarios where the design leaks. Recommend “change the design for this” or “accept and define a fallback (then it’s a bend).”
- **Bends:** List scenarios that bend; recommend turning each into an explicit decision or constraint in the plan.
- **Path-forward (optional):** Short document: how we got here (e.g. leak count, key scenario deep-dives), decisions (e.g. “we close the only leak by …”), and what’s left for the plan.

## What Tire-Kicking Is Not

- **Not Understanding** — We are not discovering the problem; we are testing a proposed solution.
- **Not Solutioning** — We are not generating new approaches; we are evaluating one (or a few) that are already on the table.
- **Not Implementation** — We are not writing code or migrations; we are finding where the design would break or need rules.

## Example Artifacts

For a full example of scenario evaluation and path-forward, see:

- **Scenario evaluation:** `.claude/work/some-feature/tire-kicking-scenarios.md` (or `.cursor/work/`, `.windsurf/work/`, etc.) — 14 scenarios, three approaches, holds/bends/leaks table and summary.
- **Path-forward:** `.claude/work/some-feature/path-forward.md` (or your tool's equivalent) — How the decision was made (leak count, deep-dives, bends), the chosen approach, and how the single leak was closed.

Use these as templates for structure and level of detail; adapt scenario list and depth to the design at hand.

## Closure

Tire-kicking is done when:

- [ ] All agreed scenarios have been evaluated (holds / bends / leaks).
- [ ] Leaks have been addressed (design change or explicit “we accept this and here’s the rule”).
- [ ] Bends have been listed for inclusion in the plan or design doc.
- [ ] Optionally: a path-forward or decision summary is written.

Then you can lock the plan or move to implementation with fewer surprises.
