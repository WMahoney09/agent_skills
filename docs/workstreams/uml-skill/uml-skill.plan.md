# UML Skill Implementation Plan

## Overview

Create a floating `/uml` skill that produces ASCII UML diagrams — sequence diagrams and component diagrams — inline in conversation. The skill provides a consistent, named way to request visual maps of code topology without re-specifying format, depth, or scope each time.

## Notes

- **Out of scope:** File persistence of diagrams (may be added later), Mermaid output, tree/flow notation
- **Two diagram modes:** Sequence (actors, lifelines, messages) and Component (boxes, relationships, arrows) — agent infers which from context
- **No code changes:** This is purely skill authoring — SKILL.md, ARTIFACT.md, and README update

## Progress

- [x] Phase 1: Create UML skill directory and files
- [x] Phase 2: Update README

---

## Phase 1: Create UML skill directory and files

### Step 1.1: Create `uml/SKILL.md`

#### Task 1.1.1: Create the skill file with frontmatter

Frontmatter includes:
- `name: uml`
- Multi-line `description` with TRIGGER clause covering: "give me a UML", "can I get a UML", "map this flow", "show me the topology", "diagram this", "trace this flow", "UML" mentioned in any request for a visual map

#### Task 1.1.2: Write skill body

Sections to include:
- **Goal** — produce ASCII UML diagrams that are readable inline without rendering
- **Diagram Modes** — Sequence and Component, with guidance on when each applies and what elements each uses
- **ASCII Conventions** — define the character vocabulary: box-drawing (`│ ├─ └─ ┌ ┐ ┘ └ ─`), boxes (`┌──┐ │ └──┘`), arrows (`──▶`, `<──`), lifelines (`|`), conditional blocks (`[if ...]`)
- **Depth** — 3–4 layers default, zoom-in produces a new diagram in a new response
- **Before/After** — when a proposed change is in context, show current state and proposed state
- **Input** — from explicit entry point to implicit inference from conversation
- **Format constraint** — ASCII only, never Mermaid
- **Artifact** — reference to ARTIFACT.md

### Step 1.2: Create `uml/ARTIFACT.md`

#### Task 1.2.1: Write artifact definition

- **Meta:** inline output (no file persisted by default), triggered on `/uml` invocation or natural language trigger
- **Template:** define the structure of both sequence and component diagram output — title, participants/components listed, the diagram itself, and an optional legend/notes section
- **Notes:** inline-only, no workstream directory persistence

### Critical Files
- `uml/SKILL.md` — new file
- `uml/ARTIFACT.md` — new file

---

## Phase 2: Update README

### Step 2.1: Add `/uml` to Floating Skills

#### Task 2.1.1: Add to the floating skills callout line

Add `/uml` to the `> **Floating skills**` line alongside existing entries.

#### Task 2.1.2: Add skill card to the Floating Skills section

Add a card following the existing pattern:
- **`/uml`** — description of what it does, inline output, no artifact file

### Critical Files
- `README.md` — modified

---

## Gotchas & Risks

- **ASCII sequence diagrams are fragile in proportional fonts.** The skill should note that output is designed for monospace environments (terminal, code blocks). This is inherent to the format and not something the skill can fix — just document it.
- **Mode inference ambiguity.** When the user's request could be either sequence or component, the agent should default to sequence (the more common case from the examples) and note the alternative is available.

## Success Criteria

- `/uml` is listed as a floating skill and is invocable
- Invoking `/uml` or saying "give me a UML" produces an ASCII diagram without the user specifying format or depth
- Sequence and component modes are both supported and correctly inferred
- Output is readable inline in terminal without any external renderer
- README reflects the new skill in all required locations
