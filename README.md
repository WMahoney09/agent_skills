# RAPID Workflow

A library of composable skills for structured agentic software delivery.

_These are mostly modular and can be used outside of RAPID if needed._

| R | A | P | I | D |
|---|---|---|---|---|
| **Research** | **Align** | **Plan** | **Implement** | **Deliver** |
| `/understanding` | `/solutioning` | `/planning` | `/produce` | `/pull-request` |
| `/recon` | `/reasoning` | `/pre-flight` | `/pair-on` | `/triage` |
| | `/tire-kicking` | `/atomize` | | `/revise` |
| | | | | `/reply` |

> **Floating skills** (usable at any stage): `/recon` · `/clarify` · `/reasoning` · `/estimate` · `/commit` · `/review`

## Conventions

Every skill directory contains a `SKILL.md` conforming to [`SKILL.spec.md`](./SKILL.spec.md). Skills that produce phase artifacts also contain an `ARTIFACT.md` conforming to [`ARTIFACT.spec.md`](./ARTIFACT.spec.md). These two root-level spec files are the authoritative references for skill file structure and artifact definition structure, respectively.

## R — Research

> Build context, understand the problem, identify constraints.

- **`/understanding`** — Build shared understanding of a problem through discovery. Start here for new work.
- **`/recon`** *(floating)* — Read-only investigation of code and documentation. Usable at any stage.

**Artifacts produced:**

| Artifact | Skill | Frequency | Purpose |
|----------|-------|-----------|---------|
| `problem-statement.md` | `/understanding` | always | Problem definition: what's being solved, why it matters, constraints, success criteria, and assumptions. Creates the `docs/workstreams/<slug>/` directory. |

---

## A — Align

> Converge on a solution direction through exploration and stress-testing.

- **`/solutioning`** — Co-architect solutions by exploring multiple approaches and their tradeoffs. For prescriptive problems with only one viable direction, solutioning short-circuits to a single candidate and nudges directly to Plan.
- **`/reasoning`** *(floating)* — Reason through a problem to extract truths and directional clarity. Within the Align stage, reasoning is the default step after solutioning: it synthesizes solution candidates and determines whether tire-kicking is needed. Usable at any stage.
- **`/tire-kicking`** — Stress-test solution candidates against scenarios (edge cases, lifecycle, multi-actor, data change). Conditionally invoked when reasoning flags genuine ambiguity between candidates that cannot be resolved through reasoning alone.

**Artifacts produced:**

| Artifact | Skill | Frequency | Purpose |
|----------|-------|-----------|---------|
| `solution-statement.md` | `/solutioning` | always | Candidate solution approaches with descriptions, tradeoffs, constraints, and LOE estimates. Captures candidates without making the final decision. |
| `truth-and-vector.md` | `/reasoning` | always | Synthesized truths, conditionals, and a directional vector. Includes recommendation for next step (Plan, tire-kicking, or understanding). |
| `tire-kicking-report.md` | `/tire-kicking` | as needed | Comparative stress-test results across candidates — scenarios tested, holds/bends/leaks for each, and a comparative verdict. Feeds back into reasoning. |

---

## P — Plan

> Lock the implementation approach with a validated, right-sized plan.

- **`/planning`** — Design and document the implementation approach as a detailed step-by-step plan.
- **`/pre-flight`** — Review the plan for gaps, contradictions, and opportunities before execution.
- **`/atomize`** — Right-size a plan by decomposing any phase with LOE > 2 into subphases.

**Artifacts produced:**

| Artifact | Skill | Frequency | Purpose |
|----------|-------|-----------|---------|
| `<work-item>.plan.md` | `/planning` | always | Hierarchical implementation plan (Phase > Step > Task) with overview, notes, and progress checkboxes. |
| *(updated)* `<work-item>.plan.md` | `/atomize` | as needed | Decomposes oversized phases (LOE > 2) into subphases in-place. |
| *(inline)* pre-flight report | `/pre-flight` | always | Validation report covering critical/major/minor issues, opportunities, and confidence level. Produced in-context for consumption by reasoning — not saved to a file. |
| *(inline)* LOE estimate | `/estimate` | as needed | LOE score (1–5) with complexity/impact rationale. Produced on-demand in-context. Used by atomize to enforce decomposition limits. |

---

## I — Implement

> Build the work.

- **`/produce`** — Execute the implementation plan autonomously with intelligent atomic commits.
- **`/pair-on`** — Pair program through the plan with user-controlled review boundaries and commits.

**Artifacts produced:**

No file artifacts. Implement skills produce **code and commits** directly — the plan file's progress checkboxes are updated at phase boundaries by `/produce`.

---

## D — Deliver

> Ship the work, gather feedback, and revise until accepted.

- **`/pull-request`** — Open a pull request for local changes with a structured description, issue links, and artifact references.
- **`/triage`** — Ingest feedback, group related items into unified revisions, and prioritize by severity.
- **`/revise`** — Address a discrete revision with a lightweight alignment check and holistic implementation.
- **`/reply`** — Close the feedback loop on a PR by replying to each reviewer comment with the addressing commit.

**Artifacts produced:**

| Artifact | Skill | Frequency | Purpose |
|----------|-------|-----------|---------|
| `review-issues.md` | `/review` | always | Severity-graded code review report with critical/major/minor issues, gaps, and a go/no-go recommendation. |
| `triage-report.md` | `/triage` | as needed | Grouped and prioritized revisions with stable IDs (C1, M1, m1) for traceability. Deduplicates related review issues into unified revisions. |
| *(GitHub PR)* | `/pull-request` | always | The pull request itself — structured description with issue links, artifact references, summary, and test plan. |

## Floating Skills

These skills are valuable across multiple stages:

- **`/recon`** — Read-only investigation of code and documentation. Often used during Research, but useful at any stage.
- **`/clarify`** — Ask clarifying questions to sharpen understanding. Most common during Research and Align.
- **`/reasoning`** — Reason through complexity to extract truths and directional clarity. Core to Research and Align, useful everywhere.
- **`/estimate`** — Produce LOE scores (1–5). Used during Plan, but available anytime.
- **`/commit`** — Stage and commit with typed convention. Used throughout Implement, available anytime.
- **`/review`** — Technical peer review of code changes with severity-graded report and go/no-go recommendation. Core to Deliver, useful anytime.

## Orchestration Philosophy

Subagents are a **context management tool, not a speed optimization.** Every subagent dispatch is a context boundary — the invoking agent passes a committed artifact file, not conversation history.

**Sequential execution is the standard.** Phases and subagents run one at a time. Concurrent subagent dispatch introduces coordination risk (git index conflicts, file write races, ambiguous commit ownership) with no quality benefit.

**Commits are the handoff mechanism.** Each phase produces a committed artifact before the next phase begins. Subagents read committed files, never conversation context. This produces a readable git log that mirrors the pipeline: one commit per stage.

**Independence ≠ concurrency.** Noting that two steps are independent means they can be executed in any order — not that they should run simultaneously.

Concurrent tool calls within a single agent response (e.g., reading multiple files at once) are fine and unaffected by this principle.

---

## Meta

**Skill:** `/commit` → `commit/SKILL.md`
- Defines the typed commit convention used across all skills
- Type prefixes (`[plan]`, `[docs]`, `[code]`) are determined mechanically by the files changed
- Referenced by `produce` and other skills to ensure consistent git history
- **Note:** This is a shared convention skill — invokable directly but also referenced internally by other skills

**Skill:** `/estimate` → `estimate/SKILL.md`
- Defines the LOE scoring framework used to evaluate proposed changes
- Two-dimensional evaluation (Complexity × Impact) synthesized to a 1–5 score
- Referenced by `solutioning` and usable standalone to calibrate scope
- **Note:** This is a shared scoring skill — invokable directly but also referenced internally by other skills

## Danger Zone

> ⚠️ **Experimental skills live here. These push the boundaries of autonomous agent behavior. Use them when you're ready to hand the wheel over entirely and see what happens.**

**Skill:** `/leeroyyyyy` → `leeroyyyyy/SKILL.md`

The full send. **Precondition:** Research must be complete and `problem-statement.md` must exist in the workstream directory before invocation. Leeroyyyyy runs the entire delivery pipeline autonomously, dispatching every phase to a subagent with artifact file handoffs (not conversation context).

What Leeroyyyyy does autonomously:
- Explores candidate solutions and routes based on skill nudges — conditionally stress-testing when reasoning flags genuine ambiguity
- Picks the best solution using reasoning synthesis, evidence, and codebase conventions
- Builds a detailed implementation plan and validates it in a pre-flight + reasoning loop (min 2, max 4 cycles)
- Atomizes the plan so every phase scores ≤ LOE 2
- Executes the plan with semantically coherent atomic commits, dispatching each phase to a subagent
- Runs a local technical review of its own output
- Triages the review findings and addresses all Critical and Major revisions
- Produces a `summary-statement.md` at completion

The only time Leeroyyyyy stops is when it hits an ambiguity that Recon cannot resolve and that would lead to meaningfully different implementations — or when unresolvable Critical/Major issues remain after the review cycle. Everything else, it decides.

**Additional artifact:** `summary-statement.md` — Final pipeline completion report documenting what was built, phases executed, out-of-scope items, and any unresolved issues.

- **Cannot be invoked by reference** — direct user invocation only
- **Establishes the orchestrator permission pattern** — how user-invoked skills can grant sub-skills permission to run by reference

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
  - e.g. the `/produce` skill
- Some skills are marked `disable-model-invocation: true` for manual-only invocation

## File Structure

The skills in this directory are source files. To use them in Claude Code or Cursor, install them to:

```
~/.claude/skills/<skill-name>/SKILL.md
```

Each skill includes YAML frontmatter specifying `name` and `description`, which determines the `/slash-command` and invocation behavior.

## Sources

- [Agent Skills](https://agentskills.io/home)
- [Extend Claude with skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Claude Code Skills Setup in Cursor](https://www.cursor-ide.com/blog/claude-code-skills)
- [Using Skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
