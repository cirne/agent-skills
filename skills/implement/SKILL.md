---
name: implement
description: End-to-end opportunity/feature implementation—read the tracked spec, run /interview when scope is open, build with DRY reuse, validate with tests, then archive. Use when the user invokes /implement or asks to implement an opportunity or new feature from the backlog.
---

# Implement (opportunity workflow)

Mirror of `/fix` for **new improvements and features** tracked in the project backlog (ids/paths per `docs/README.md` — discover via `/backlog`).

## Which path?

| User input | Backlog | After ship |
|------------|---------|------------|
| Tracked backlog id / path / matching active row | Read that spec; cite the id | Archive per `/backlog` |
| Ad-hoc feature only | **Stop** — ask whether to file a backlog item or do a small in-place change | Archive only if promoted first |

## Workflow

### 1. Understand

Load the spec + index row. Skim architecture docs for the area. **Reuse before inventing** — match local style, extend helpers, follow copy/i18n/design docs if present. Honor **Out of scope**.

### 2. Interview gate

**Do not implement** until handoff-ready. Run `/interview` when open questions, TBD, unlocked status, or missing implementation/TDD/verification sections remain.

### 3. Plan from the spec

Follow in order: locked decisions → implementation plan → TDD plan → verification commands.

### 4. Implement (TDD when specified)

Red → green → refactor within scope. Scoped type/lint before re-tests (`/tests`). Migrations/persisted shape: follow project migration docs. Optional `/deslop`.

### 5. Validate

`/verify-this` against the Verification section. Meaningful tests for the behavior that matters — not coverage theater. Use `/coverage` when closing tracked high-risk gaps.

### 6. Commit

`/commit` (include opportunity id when tracked).

### 7. Archive (tracked only)

`/backlog` close-and-archive when shipped (or Will not do / Superseded with user alignment). Partial ship → split remaining work cleanly.

## Related

- `/interview` · `/fix` · `/raptor` · `/copy` · `/tests` · `/coverage` · `/verify-this` · `/deslop` · `/backlog` · `/commit`

Optional: `/implement … with /raptor` for a deletion bias—follow `/raptor` ask/proceed and app-LOC validation.
