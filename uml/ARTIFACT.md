## Meta

- **Storage:** Inline — output is produced in-context, not saved to a file
- **Filename:** N/A
- **Trigger:** When `/uml` is invoked or a natural language trigger requests a diagram

## Template

### Sequence Diagram

```
## <Title describing the flow>

  <Actor1>        <Actor2>        <Actor3>        <Actor4>
    |                |               |                |
    | <message>      |               |                |
    |───────────────>|               |                |
    |                | <message>     |                |
    |                |──────────────>|                |
    |                |               | <message>      |
    |                |               |───────────────>|
    |                |               |   <return>     |
    |                |               |<───────────────|
    |                |  <return>     |                |
    |                |<──────────────|                |
    |   <return>     |               |                |
    |<───────────────|               |                |
    |                |               |                |

<Optional: notes, legend, or clarifications>
```

### Component Diagram

```
## <Title describing the architecture>

┌─────────────────────────────────┐
│         <Boundary Name>        │
│                                 │
│  ┌─────────────┐  ┌──────────┐ │
│  │ <Component> │  │<Component>│ │
│  └──────┬──────┘  └─────┬────┘ │
└─────────┼───────────────┼──────┘
          │               │
          ▼               ▼
┌─────────────┐  ┌──────────────┐
│ <Component> │  │ <Component>  │
└─────────────┘  └──────────────┘

<Optional: notes, legend, or clarifications>
```

## Notes

- No file is written — UML's artifact is its formatted ASCII output rendered inline in conversation
- Both diagram types include a title line describing what is being diagrammed
- Optional notes/legend section follows the diagram when relationships or conventions need clarification
- When producing before/after diagrams, each is a separate instance of the template, clearly labeled "Current" and "Proposed"
