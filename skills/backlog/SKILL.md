---
name: backlog
description: >-
  Maintains engineering backlog hygiene—reconciles tracking docs with code,
  archives completed work, files new items, and updates indexes. Use when the
  user invokes /backlog, asks to triage or review the backlog, archive fixed
  issues, file a ticket, or align tracking docs with reality.
---

# Backlog

Repo-agnostic hygiene for in-repo (or linked) engineering work tracking. **Do not assume** Brain-style `BUG-`/`OPP-` layouts or any other project’s paths.

## 1. Discover conventions (mandatory first step)

### Primary source — docs org README

1. Read **`docs/README.md`** if it exists. Treat it as the **organization source of truth** for where work lives, how ids are allocated, how items are filed/closed/archived, and how cross-links work.
2. Skim **`AGENTS.md`** / **`CLAUDE.md`** (repo root) for pointers into that README or backlog paths.
3. **Follow those directions.** Do not invent a parallel layout when the README already specifies one.

The docs README should answer at least:

| Question | Examples of what you might find |
| -------- | -------------------------------- |
| Index / catalog | `docs/BACKLOG.md`, `docs/BUGS.md` + `docs/OPPORTUNITIES.md`, … |
| Spec directories | `docs/backlog/`, `docs/bugs/` + `docs/opportunities/`, … |
| Id scheme | `M-NNNN`, `BUG-NNN` / `OPP-NNN`, … |
| Next-id anchor | `NEXT_ID`, `NEXT_BUG_ID`, … (never infer from the filesystem) |
| Close / archive | `git mv` to `archive/`, status-only, … |
| Cross-references | id-as-link-text + path href; grep/fix hrefs on archive |
| Working set (optional) | `focus.md` — update when closing items listed there |

### If `docs/README.md` is missing or silent on backlog

**Do not silently invent a system.** In order:

1. **Probe** for an existing tracker (indexes, spec dirs, Linear/GitHub Issues, `TODO.md`) without creating files yet.
2. If a clear existing scheme is found, use it — and **offer to add or extend `docs/README.md`** so the next `/backlog` run has an explicit SoT (backlog section: index path, spec dirs, id/next-id rules, archive, cross-links).
3. If nothing exists, **ask** whether to bootstrap in-repo markdown tracking. Only with user agreement, create/update `docs/README.md` with backlog rules **and** the minimal index/dirs that README describes. Prefer the repo’s stated preferences; if the user has none, propose a simple single-queue layout and get a yes before writing.

### Anti-patterns

- Creating `docs/BUGS.md` / `docs/OPPORTUNITIES.md` (or Marshall `M-` layout) because another repo uses them
- Allocating ids by “max filename + 1”
- Filing work without updating the index the README names
- Skipping `docs/README.md` when it exists

## 2. When to run

- Hygiene: active lists match shipped code
- Close/archive done or superseded work
- File a new item with index + next-id updated
- Split a large item into shipped vs remaining
- Bootstrap or repair docs README backlog guidance (with user agreement when creating a new system)

## 3. Hygiene: doc vs code

1. Read the index(es) the docs README names; scan non-archive specs for contradictory **Status**
2. For suspected done: confirm in the codebase before archiving
3. Archive per repo rules (`git mv` when archive folders exist); grep the **id** and fix **stale hrefs** (keep id in link text)
4. Partial fixes: keep open with shipped vs remaining clearly stated
5. If `focus.md` (or equivalent) lists the item, update it on close

## 4. New item

1. Allocate the next id **only** from the canonical next-id anchor (monotonic — do not fill gaps)
2. Create the spec file where the docs README says (status, problem/goal, direction)
3. Add an index row and bump the next-id anchor in the **same** change
4. Link as the docs README specifies (typically `[ID](path-to-spec)`)

## 5. Close and archive

1. Set final **Status** in the body (+ date / one-line outcome when the repo expects it)
2. Move to archive if the repo uses archive folders (same filename unless README says otherwise)
3. Update the index (active → recently-closed / archived per README)
4. Grep the id; fix cross-reference **hrefs**; update `focus.md` if listed

## 6. Checklist

```
- [ ] Read docs/README.md (or AGENTS pointer); conventions clear
- [ ] Index matches disk
- [ ] Next-id anchor bumped only when filing
- [ ] Grep id; fix stale hrefs / focus entries
```

## Related

Sibling skills (`/interview`, `/fix`, `/implement`, `/commit`) should use this same discovery order — **docs README first** — when they need backlog paths or ids.
