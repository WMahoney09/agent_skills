# Problem Statement: Remove Workflow Parallelism from Skills Library

## Problem

The skills library's orchestration guidance optimizes for parallelism at the workflow level —
planning identifies parallel phases, pre-flight recommends parallelization as an improvement,
produce executes phases concurrently, and leeroyyyyy dispatches subagents in parallel. This
philosophy creates coordination problems (git conflicts, staging area races) and conflates
raw speed with quality. Subagents should be used exclusively for context isolation, with
sequential execution as the unconditional standard.

## Why It Matters / Why Now

A companion workstream (`artifact-capture-and-subagent-orchestration`) is actively rewriting
leeroyyyyy to mandate subagenting for every pipeline phase. That plan currently contains
parallelism guidance throughout. If the companion workstream ships without this correction,
it will actively reintroduce parallel subagenting at the point of rewrite. This workstream
must amend that plan before Phases 4a–4c of the companion workstream execute.

## Key Constraints

- Concurrent tool calls within a single agent response are explicitly out of scope — these are fine
- Code-level references to "concurrent access" (review) and "concurrent requests" (recon) are out of scope — these describe systems under investigation, not agent behavior
- The existing artifact-capture plan must be amended as part of this workstream
- Removing references alone is insufficient — the positive philosophy (subagents for context isolation, sequential execution as the standard) must be stated explicitly where parallelism guidance currently lives

## Success Criteria

- No skill recommends or encourages parallel workflow execution at the orchestration level
- Subagent usage is consistently framed as a context isolation mechanism, not a speed optimization
- Pre-flight and planning replace parallelization guidance with sequencing and simplification guidance
- The artifact-capture plan contains no parallelism guidance
- README contains no parallelism references in the context of workflow orchestration

## Assumptions Surfaced

- Sequential execution is a deliberate trade: short-term speed is sacrificed for output quality and long-term velocity
- The artifact-capture workstream's leeroyyyyy rewrite (Phases 4a–4c) must incorporate the sequential subagent model — not treat it as a separate concern
- The companion workstream's existing plan notes (e.g., "these steps are independent and can be parallelized") are instructions for produce — removing them changes execution behavior, which is the intent

## Workstream Slug

`remove-parallelism-from-skills`
