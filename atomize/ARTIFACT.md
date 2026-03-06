## Meta

- **Storage:** `docs/workstreams/<work-item>/` at the nearest project root
- **Filename:** `<work-item>.plan.md` (updated in-place)
- **Trigger:** When all plan phases score ≤ 2 and the updated plan is confirmed

## Template

The plan file is modified directly: oversized plan phases are replaced by their decomposed subphases. The decomposition log is presented inline and not saved to a separate file.

### Inline decomposition log format

```
## Atomization Log

| Original phase | LOE | Split into | New LOE |
|---|---|---|---|
| Phase N: <name> | 3 | Phase Na: <name>, Phase Nb: <name> | 2, 1 |

All plan phases confirmed ≤ LOE 2.
```

## Notes

- Atomize modifies the plan file in-place — it does not create a separate artifact file
- The decomposition log is inline only (presented in chat, not saved)
- The updated plan file is committed as a `[plan]` commit after atomization is complete
