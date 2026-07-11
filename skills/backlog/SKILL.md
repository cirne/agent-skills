---
name: backlog
description: Maintains bug and opportunity hygiene—reconciles tracking docs with code, archives completed work, files new items, and updates backlog indexes. Use when the user invokes /backlog, asks to triage bugs or opportunities, review the backlog, archive fixed issues, or align tracking docs with reality.
---

# Backlog (bugs & opportunities)

## Discover repo conventions

Locate how this repo tracks work (do not invent a layout):

| Need | Look for |
|------|----------|
| Bug index | `docs/BUGS.md`, `TODO.md`, Linear/GitHub issues |
| Opportunity/feature index | `docs/OPPORTUNITIES.md`, RFCs, roadmap |
| Spec files | `docs/bugs/`, `docs/opportunities/`, `docs/rfcs/` |
| Id allocation | `NEXT_BUG_ID` / `NEXT_OPP_ID` anchors or project equivalent |

Prefer the repo’s existing id scheme and paths. If none exist, ask before creating a new system.

## When to run

- Hygiene: active lists match shipped code
- Close/archive done or superseded work
- File a new bug or opportunity with index updated
- Split a large item into shipped vs remaining

## Hygiene: doc vs code

1. Read indexes and scan non-archive specs for contradictory **Status**
2. For suspected done: confirm in the codebase before archiving
3. Archive with `git mv` when the repo uses archive folders; grep the id and fix links
4. Partial fixes: keep open with shipped vs remaining clearly stated

## New item

1. Allocate the next id per repo convention (monotonic — do not fill gaps)
2. Create the spec file with symptom/problem, direction, status
3. Add an index row and bump the next-id anchor in the same change

## Close and archive

1. Set final **Status** in the body
2. Move to archive (if used)
3. Update the index (active → archived)
4. Grep the id and old paths; fix cross-references

## Checklist

```
- [ ] Canonical path for this repo’s backlog
- [ ] Index matches disk
- [ ] Grep id + old filenames; fix links
```
