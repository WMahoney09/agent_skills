# ARTIFACT.spec.md — Canonical Artifact Definition Specification

This file is the authoritative specification for every per-skill `ARTIFACT.md` in this library. It is not itself an artifact definition — it defines the structure that all `skills/*/ARTIFACT.md` files must follow.

## Meta-Instruction Block

Every `ARTIFACT.md` must begin with this block:

```
## Meta

- **Storage:** `.claude/work/<work-item>/` at the nearest project root
- **Filename:** <defined per skill>
- **Trigger:** <when to generate this artifact>
```

The meta block provides at-a-glance orientation: where the file goes, what it's called, and when it's produced.

## Canonical Sections

| Section | Required | Description |
|---|---|---|
| **Meta** | Yes | Storage location, filename, and trigger condition. |
| **Template** | Yes | Full section structure of the artifact. This is the authoritative template — agents use it verbatim when producing the artifact. |
| **Side Effects** | No | Actions beyond writing the artifact file (e.g., directory creation). Include only when applicable. |
| **Notes** | No | Supplementary guidance, caveats, or design rationale. |

## Inline-Only Pattern

Some skills produce output that is presented in-context but not saved to a file (e.g., `estimate`). For these skills:

- `ARTIFACT.md` still exists and defines the canonical output format
- The **Meta** block uses `Filename: Inline — output is produced in-context, not saved to a file`
- The **Template** section defines the format agents must follow when presenting the output
- No file is written; the artifact is the formatted output itself

## In-Place Update Pattern

Some skills modify an existing file rather than creating a new one (e.g., `atomize` updates the plan file). For these skills:

- The **Meta** block names the target file (e.g., `*.plan.md`)
- The **Template** section documents what changes are made to the target file
- A separate inline output (e.g., a decomposition log) may also be defined

See `atomize/ARTIFACT.md` as the canonical example of this pattern.

## Storage Convention

All artifacts live in `.claude/work/<work-item>/` at the nearest project root. The `<work-item>` slug is established by the `understanding` skill when it creates the workstream directory.

Artifacts must be project-local — never saved to home directory conventions like `~/.claude/*`, `~/.cursor/*`, or similar paths.
