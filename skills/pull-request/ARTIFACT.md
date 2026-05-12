## Meta

- **Storage:** GitHub pull request (not a local file)
- **Filename:** N/A — the artifact is the pull request itself
- **Trigger:** When `/pull-request` is invoked and all changes are pushed

## Template

The PR description follows this structure:

```markdown
Closes #<issue-number>

[problem-statement.md](<relative link>) | [solution-statement.md](<relative link>)

## Summary

<1–8 sentence overview of what this change does and why.>

- <Problem:> <brief summary of the problem being solved>
- <Solution:> <brief summary of the approach taken>
- <change description>
- <change description>
- <additional changes as needed>

## Test Plan

- [ ] <verification step>
- [ ] <verification step>
- [ ] <additional steps as needed>
```

### Section guidance

**Issue links** — Appear first. Use GitHub-recognized resolution keywords (`Closes`, `Resolves`, `Fixes`) followed by the issue number. For external trackers (Linear, Jira), use a markdown link to the ticket instead.

**Artifact links** — Link to `problem-statement.md` and `solution-statement.md` if they exist in the workstream directory. Omit this line if no artifacts exist.

**Summary** — Start with a prose overview (1–8 sentences), then a bulleted list. The first two bullets should summarize the problem and the solution. Remaining bullets describe specific changes.

**Test plan** — A checkbox list of steps a reviewer can follow to verify the changes. Describe what to check, not how the code works.

## Notes

- The description scales with the change — a one-file fix doesn't need eight sentences and six bullets
- If no workstream artifacts exist (problem-statement, solution-statement), skip the artifact links line entirely rather than leaving a placeholder
- Issue links should only be included when there are actual issues to reference — don't fabricate them
