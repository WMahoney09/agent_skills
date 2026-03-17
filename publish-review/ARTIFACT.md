## Meta

- **Storage:** GitHub pull request review (not a local file)
- **Filename:** N/A — the artifact is the GitHub review object
- **Trigger:** When the user confirms the finding-to-comment mapping and the review is posted

## Template

### Top-level review body

```markdown
## Agentic Review

**PR:** #N — title
**Recommendation:** Go / No-Go / Go with conditions
**Rationale:** 1-2 sentence assessment.

### Summary

| Severity | Count |
|---|---|
| Critical | N |
| Major | N |
| Minor | N |

**Critical**
- Finding description — `file:line`
- Finding description — `file:line`

**Major**
- Finding description — `file:line`

**Minor**
- Finding description — `file:line`

(Omit severity tiers with zero findings from both the table and the grouped list.)

---

### Findings Not in Diff

(Body-only findings listed here, if any. Each follows the inline format below but without line anchoring.)

- **[Severity]** Finding description — `file:line`

---

*Generated with help from Claude*
```

### Inline comment format

```markdown
**[Severity]** Finding description

_Why it matters:_ Specific risk or consequence.

Suggestion or recommended fix.
```

- "Why it matters" is included for Critical and Major findings only
- Minor findings include severity, description, and suggestion

## Notes

- The review event is always `COMMENT` — never `REQUEST_CHANGES` or `APPROVE`
- All comments are posted as a single atomic review, not as individual comments
- The body template scales with the findings — omit "Findings Not in Diff" if all findings are inline or file-level
