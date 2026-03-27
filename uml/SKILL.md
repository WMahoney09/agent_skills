---
name: uml
description: |
  Produce ASCII UML diagrams — sequence diagrams and component diagrams — to map code topology inline in conversation. Provides a consistent, named way to visualize code flow, service relationships, and data paths without re-specifying format, depth, or scope each time.
  TRIGGER when: the user asks for a UML diagram ("give me a UML", "can I get a UML", "UML of this"), requests a visual map of code ("map this flow", "trace this flow", "diagram this", "show me the topology", "how does this flow work"), or when externalizing code topology would help the user build a mental model of the system during any phase.
---

# UML: ASCII Diagrams for Code Topology

This skill produces ASCII UML diagrams inline in conversation. It gives the user a readable map of code topology — how requests flow through layers, how services interact, how components relate — without requiring any external renderer.

## Goal

Produce ASCII UML diagrams that:
- Are readable inline in a terminal chat session and in markdown documents
- Follow a consistent format so the user knows what to expect
- Help the user build a mental model of the codebase to make informed decisions
- Can be produced at any phase when the agent has sufficient codebase context

## Format Constraint

**ASCII only. Never produce Mermaid, PlantUML, or any syntax that requires rendering.** The output must be readable as-is in a monospace environment (terminal, code block, markdown file). If the user can't read it without a renderer, it fails the purpose of this skill.

## Diagram Modes

### Sequence Diagrams

Use when tracing a **flow or interaction over time** — a request through layers, a multi-step process, coordination between services.

**Elements:**
- **Actors/participants** listed across the top
- **Lifelines** as vertical `|` pipes below each participant
- **Messages** as labeled horizontal arrows (`──▶`, `<──`) between lifelines
- **Return values** as labeled dashed or solid arrows back
- **Conditional blocks** as `[if ...]` / `[else]` annotations
- **Notes** as inline annotations where clarification is needed

**Example structure:**
```
  Client          Controller       Service          Database
    |                 |               |                 |
    | POST /login     |               |                 |
    |────────────────>|               |                 |
    |                 | validate()    |                 |
    |                 |──────────────>|                 |
    |                 |               | query(email)    |
    |                 |               |────────────────>|
    |                 |               |    customer     |
    |                 |               |<────────────────|
    |                 |               |                 |
    |                 |  { token }    |                 |
    |                 |<──────────────|                 |
    |                 |               |                 |
    |   202 Accepted  |               |                 |
    |<────────────────|               |                 |
    |                 |               |                 |
```

### Component Diagrams

Use when showing **relationships between modules, services, or classes** — what depends on what, how pieces connect, where boundaries are.

**Elements:**
- **Boxes** drawn with box-drawing characters (`┌ ┐ └ ┘ │ ─`) for components
- **Labeled arrows** (`──▶`, `◀──`, `──`) showing relationships (uses, depends on, extends, implements)
- **Grouping boxes** for boundaries (e.g., a service boundary containing multiple internal components)
- **Annotations** for relationship types or cardinality where helpful

**Example structure:**
```
┌─────────────────────────────────────────┐
│              API Gateway                │
│                                         │
│  ┌─────────────┐    ┌───────────────┐   │
│  │ AuthCtrl    │    │ OrderCtrl     │   │
│  └──────┬──────┘    └───────┬───────┘   │
└─────────┼───────────────────┼───────────┘
          │                   │
          ▼                   ▼
┌─────────────────┐  ┌───────────────────┐
│  AuthService    │  │  OrderService     │
│                 │  │                   │
│  - login()      │  │  - create()       │
│  - verify()     │  │  - cancel()       │
└────────┬────────┘  └────────┬──────────┘
         │                    │
         ▼                    ▼
┌─────────────────────────────────────────┐
│              PostgreSQL                 │
│  ┌──────────┐  ┌──────────┐            │
│  │ customers│  │ orders   │            │
│  └──────────┘  └──────────┘            │
└─────────────────────────────────────────┘
```

## Mode Inference

The agent infers which diagram mode fits from conversational context:

- **Sequence** when the user is asking about flows, requests, processes, or "what happens when..." — anything with a time dimension
- **Component** when the user is asking about structure, relationships, dependencies, or "how do these pieces connect" — anything about static architecture

When ambiguous, **default to sequence** — it's the more commonly needed mode. Note that the alternative is available.

## Depth

**Default: 3–4 layers deep.** This covers the typical useful range (e.g., route → controller → service → database/external call).

**Zoom-in:** When the user asks to go deeper on a specific node, produce a **new diagram in a new response** focused solely on that subtree at greater depth. This preserves the parent diagram in conversation history and avoids re-rendering risk.

## Before/After

When a proposed change is in context (e.g., during solution exploration or planning), the skill can show **current state and proposed state** as two separate diagrams, clearly labeled. This helps the user see exactly what changes and where the seams are.

## Input

The skill accepts a range of specificity:

- **Explicit:** "UML of the POST /login flow from route to database"
- **Scoped:** "diagram how the auth service connects to its dependencies"
- **Implicit:** No entry point given — the agent infers from the current conversation what topology would be most useful and confirms before drawing

When input is implicit, the agent should briefly state what it intends to diagram before producing output.

## Artifact

Produces inline ASCII UML output (not saved to a file by default). See `ARTIFACT.md` for the canonical output structure. The diagram is rendered directly in conversation.

## Notes

- ASCII diagrams are designed for monospace environments — they will not align correctly in proportional fonts
- The agent must have sufficient codebase context to produce accurate diagrams — if context is lacking, investigate the codebase first
- Diagrams should reflect the actual code, not idealized architecture — accuracy over aesthetics
- Keep diagrams focused; a diagram that tries to show everything shows nothing
- When the user says "zoom in on [node]", that's a continuation of the same skill invocation — produce a new focused diagram
