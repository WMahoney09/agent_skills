# Problem Statement

## Problem

During solutioning, planning, reasoning, and other phases where the agent has codebase context, the user often needs the agent to externalize its understanding of code topology as a readable map. Today this requires a paragraph-long freeform request each time, and agents default to Mermaid syntax which isn't readable inline in a terminal. There is no consistent, named way to request an ASCII diagram of code flow at a controlled depth.

## Why It Matters / Why Now

When the agent understands the codebase better than the user, alignment decisions suffer. The user can't evaluate proposed changes, trace data flow, or spot architectural concerns without a visual map. Every time they need one, they re-specify format, depth, and scope from scratch — or get Mermaid output they can't read without a renderer.

## Key Constraints

- Output must be ASCII UML — not Mermaid, not plain markdown lists
- Must be readable inline in a terminal chat session and in markdown documents
- Default depth of 3–4 layers, with the ability to zoom in on any node on request
- Floating skill — usable at any phase, not bound to a specific RAPID stage
- Must infer subject from conversation context when no explicit entry point is given

## Success Criteria

- Invoking `/uml` (or triggering via natural language) consistently produces an ASCII UML diagram without the user needing to specify format or depth
- The agent can show before/after diagrams when a proposed change is in context
- The user can request a deeper view of any node in the diagram and get a zoomed-in sub-diagram
- The output is readable without any external rendering tool

## Assumptions Surfaced

- ASCII box-drawing characters and tree notation are sufficient to represent UML-style diagrams (sequence, component, flow) without ambiguity
- 3–4 layers of depth covers the majority of use cases; deeper exploration is the exception
- The skill does not need to persist an artifact by default — inline output is the primary use case, though persistence may be added later

## Workstream Slug

`uml-skill`
