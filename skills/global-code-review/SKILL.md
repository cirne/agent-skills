---
name: global-code-review
description: Runs a manageability and structural tech-debt review (thought exercise, not a rewrite plan), updates the canonical recommendations doc, and aligns priorities with the backlog. Use when the user invokes /global-code-review, asks for a global code review, structural debt audit, manageability review, or to refresh tech-debt priorities.
---

# Global code review (manageability / tech debt)

**Not a rewrite plan.** Use a “design from scratch” lens only to **rank** where names, placement, and boundaries hurt day-to-day work. Paydown is **incremental** via backlog items and surgical splits.

## Discover repo conventions

1. Canonical recommendations doc (e.g. `docs/architecture/global-code-review-recommendations.md`)
2. Companion risk reviews if any (security/ops) — do not duplicate
3. Backlog indexes (`/backlog`)
4. Optional focus/WIP file — read, do not edit unless asked

If no canonical doc exists, create one under the project’s architecture docs (or ask where it should live) before ranking.

## When to run

- Periodic hygiene (quarterly, after a large feature arc)
- User asks about biggest tech debt / manageability
- Before prioritizing a structural backlog item

**Do not run** for single-file review, security-only audit, or routine PR review (`/pr`).

## Workflow

```
- [ ] 1. Read canonical doc + backlog active slice
- [ ] 2. Evidence pass (hot paths, line counts, greps — not memory)
- [ ] 3. Reconcile shipped work
- [ ] 4. Update canonical doc (date, top 5, incremental recommendations)
- [ ] 5. Backlog alignment (link existing tickets; file new via /backlog if needed)
- [ ] 6. User summary (top 5 + what changed)
```

**Never** recommend a global rewrite, framework migration, or “stop shipping” refactor quarter.

## Report template

```text
Top 5 manageability issues:
1. …
What changed in the canonical doc:
- …
Suggested incremental next steps (ticket ids):
- …
```
