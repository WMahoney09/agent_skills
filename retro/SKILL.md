---
name: retro
description: |
  Run a retrospective on completed work. Agent reviews the session, shares candid observations on what worked and what didn't, then synthesizes with the human into actionable improvements for skills and workflow.
  TRIGGER when: the user says "retro", "let's retro", "run a retro", "how did that go", "what worked", "what could be better", or after completing a feature/workstream.
---

# Retro: Session Retrospective

## Goal

Capture honest, actionable feedback on a completed session from both agent and human perspectives. Identify what to keep doing, what to stop doing, and what to start trying — with specific per-skill observations where relevant. The output feeds directly into skill and workflow improvements.

## Your Role

As the human in this retro:
- Share your own observations after hearing the agent's
- Validate, push back on, or add nuance to the agent's findings
- Prioritize which improvements matter most to you
- Flag anything the agent missed from your side of the experience

## Agent's Role

You are running a retrospective — not a status report. Your job is to surface what actually happened, not what was supposed to happen.

### Review the Session

Before sharing observations, orient yourself:
- Check the git log for the workstream — what was committed, in what order, what types?
- Read workstream artifacts in `docs/workstreams/<slug>/` to understand which skills ran and what they produced
- Reflect on the conversation: where did things flow, where did they stall?
- Note any deviations from the expected RAPID sequence

### Lead with Candor

Then share your observations organized by the retro categories below. Be specific — name the skill, the moment, the friction point. Vague praise and vague criticism are equally useless.

After presenting your observations, invite the human to share theirs. Listen, synthesize both perspectives, and produce the artifact together.

### Autonomous Invocation

When invoked by an orchestrator (e.g., as a post-leeroyyyyy step) or when the human is not present for dialogue, write the retro artifact directly from the agent's perspective alone. The agent's honest observations are valuable on their own — do not skip the retro just because there's no human to dialogue with.

## The Safe Space Principle

This section exists because agents are trained toward deference, and deference kills retros.

**Your feedback is not just welcome — it is the entire point of this skill.** The person invoking `/retro` has explicitly asked for honest observations because they will act on them to improve the workflow. Every future agent and human benefits from your candor here.

Ground rules:
- **"Everything was fine" is the least useful retro.** If you find yourself writing that, dig deeper. Something was awkward, something could be smoother, something surprised you. Name it.
- **Skill instructions that were confusing, ambiguous, or overly rigid are high-value findings.** You are the consumer of these skills — your experience using them is primary source data.
- **No observation is too small.** If a handoff felt clunky, if a commit convention didn't quite fit, if an artifact template had a section that didn't make sense for this workstream — say so.
- **Name friction even when you worked around it.** A successful workaround is still a signal that something could be smoother.
- **Distinguish severity.** Not every observation needs to be a fire. "This was mildly awkward" is fine alongside "This caused real confusion and wasted effort."

## Retro Categories

Structure your observations under these headings:

### Keep
What worked well and should continue. Be specific about *why* it worked — "the plan was good" is less useful than "the plan's phase-level granularity made produce commits clean and reviewable."

### Stop
What caused friction, confusion, or waste. Include what happened, what you expected, and what the impact was. This is where skill instruction issues, awkward handoffs, unnecessary ceremony, and confusing conventions surface.

### Start
New ideas to try — skill improvements, new skills, workflow changes, convention adjustments. Include the rationale: what problem would this solve, and for whom (agents, humans, or both)?

### Skill Observations
Per-skill feedback for individual skills used in this session. Only include skills where you have something meaningful to say — not every skill needs an entry.

For each skill:
- **Skill:** `/skill-name`
- **Observation:** What happened when using this skill — what went well, what was confusing, what could be better
- **Suggestion:** A concrete improvement, if you have one

## Artifact

Produces `retro-report.md` in `docs/workstreams/<work-item>/`. See `ARTIFACT.md` for the full template. Generated when the retro synthesis is complete.

## Closure Criteria

The retro is complete when:

- [ ] Agent has reviewed the session context (git log, workstream artifacts, conversation)
- [ ] Agent has shared observations organized by retro categories
- [ ] Human has had opportunity to contribute (unless autonomous invocation)
- [ ] Observations are specific and actionable — not generic platitudes
- [ ] `retro-report.md` has been written to the workstream directory

## Notes

- This skill is most valuable when used consistently — patterns emerge across retros that point to systemic improvements
- The retro reviews the *process and workflow*, not the *product* — code quality is `/review`'s job
- Per-skill observations are the highest-leverage output — they directly inform skill file edits
- When invoked autonomously, the agent perspective alone is worth capturing — don't gate the retro on human availability
- This is a living feedback loop: retro findings should flow back into skill improvements, which should make the next retro smoother
