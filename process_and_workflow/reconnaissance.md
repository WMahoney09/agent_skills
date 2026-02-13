---
name: reconnaissance
description: Read-only investigation of code and documentation to understand existing systems, architecture, and patterns. Can be used before Understanding, as part of it, or standalone.
allowed-tools: Read, Glob, Grep, WebFetch
---

# Reconnaissance: Code and Documentation Investigation

This skill guides read-only exploration of a codebase and its documentation to build understanding of how systems currently work.

## Goal

Investigate and discover:
- **Code structure and patterns** - How the codebase is organized, key architectural patterns
- **Existing implementations** - How similar features or problems have been solved
- **Dependencies and integrations** - What systems connect and how
- **Documentation** - Both local documentation and relevant external docs
- **Key files and hotspots** - Where the important logic lives
- **Constraints and conventions** - How things are done in this codebase

## Your Role

- Ask the agent what to investigate, or let it start with an overview
- Guide deeper investigation based on findings
- Ask follow-up questions as patterns emerge
- Direct attention to specific areas of interest

## Agent's Role

The agent running this skill should:

1. **Start conversationally** - Ask if you want a quick overview or have specific things to investigate
2. **Explore and report findings** as they're discovered, not as a final document
3. **Respond to direction** - Pivot investigation based on your questions and interests
4. **Keep it read-only** - Investigate only, don't modify anything
5. **Mix local and external sources** - Check code, local docs, and relevant external documentation
6. **Make connections** - Help you understand how pieces relate

## Typical Investigation Flow

### Phase 1: Direction-Setting

**Agent asks:** "What would you like to investigate? I can:
- Do a quick overview of the codebase structure
- Dive into a specific feature or system (e.g., 'How does auth work?')
- Research a specific pattern or technology
- Look up external documentation about a framework or library
- Something else?"

### Phase 2: Initial Exploration

Based on your direction, the agent should:
- Find relevant files using Glob
- Read key files to understand structure
- Search for patterns using Grep
- Identify where similar work has been done
- Check documentation files (README, docs/, etc.)
- Look up relevant external documentation if needed

### Phase 3: Conversational Findings

The agent should present findings as discovered:
- "I found X files related to authentication"
- "The auth system uses pattern Y implemented in file Z"
- "Here's how similar work was done for [other feature]"
- "External documentation says..."
- "I notice this pattern used throughout: ..."

### Phase 4: Iterative Deepening

Based on findings and your questions:
- Dig deeper into specific areas
- Follow connections between systems
- Clarify how pieces work together
- Explore edge cases or alternative implementations
- Look into external resources for context

## What to Investigate

Good areas for reconnaissance:

**Architecture & Structure:**
- How is the codebase organized? (by feature, by layer, by concern?)
- What are the major components?
- What's the dependency graph?

**Specific Features:**
- How does authentication work?
- How are API requests handled?
- How does the database schema relate to the API?
- How are errors handled?

**Patterns & Conventions:**
- What patterns are used consistently?
- How do most developers structure a feature?
- What naming conventions are followed?
- How are tests organized?

**Integration Points:**
- What external services does this talk to?
- How are they integrated?
- What's the contract/interface?

**Documentation:**
- What local docs exist? (README, guides, architecture docs)
- What external docs are relevant? (framework docs, library docs, API docs)
- Are there examples or tutorials?

**Edge Cases:**
- How does the system handle error conditions?
- What about concurrent requests?
- How are migrations handled?

## Tools Available

The agent has read-only access to:
- **Glob** - Find files by pattern
- **Grep** - Search code for keywords, patterns
- **Read** - Read file contents
- **WebFetch** - Fetch and analyze external documentation

## Key Behaviors

### The Agent Should:
- Ask clarifying questions about what to investigate
- Present findings conversationally as they emerge
- Make connections between related pieces
- Suggest areas worth investigating
- Provide enough detail to understand, without overwhelming
- Ask follow-up questions based on your interest

### The Agent Should Not:
- Make assumptions—ask for clarification
- Write code or make changes
- Get lost in rabbit holes—stay focused on your direction
- Be overly verbose—be precise and clear
- Assume you know the codebase—explain what it finds

## Closure

Reconnaissance is complete when:
- You've gained the understanding you needed
- You're ready to move on to Understanding (for a new problem) or another phase
- Or you've decided to pivot to a different investigation

Say "**done**" when you're ready to end reconnaissance, or invoke another skill when ready to proceed.

## Use Cases

**Before Understanding a new problem:**
"I need to understand how the order system works before I can understand what needs to change"

**As part of Understanding:**
"Let me investigate how the current auth system works while we're clarifying the problem"

**Standalone exploration:**
"I just want to understand how this codebase is structured before I make my first change"

## Notes

- Reconnaissance is exploratory—don't force conclusions
- Good reconnaissance prevents "surprises" during Implementation
- Follow the codebase and documentation; they'll tell you what matters
- External docs (framework, library docs) provide important context
- If something seems odd or contradicts expectations, dig deeper
