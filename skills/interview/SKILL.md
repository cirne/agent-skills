---
name: interview
description: Runs interview mode on a tracked opportunity or bug—one open question at a time until scope is locked and the spec is an implementation handoff another agent can execute (including TDD). Use for /interview, closing open questions, locking scope, or a final handoff pass before implementation.
---

# Interview (scope alignment → implementation handoff)

## North star

The interview exists so **another agent can implement and validate the work without this chat**.

- **Clarity:** locked product/technical decisions, no ambiguous forks.
- **Executability:** enough concrete detail (call sites, files, invariants) — not a technology dump of obvious facts.
- **Verifiability:** falsifiable acceptance + **TDD plan** (what to write first, which tests to replace, mocks/fixtures).
- **Restraint:** interview prose and decision history get **compressed** into a handoff spec; drop redundant root-cause essays and stale options.

**Do not** implement during interview mode — only decisions and doc updates until the spec is handoff-ready.

## Discover repo conventions first

Before the first question, locate how this repo tracks work (do not invent a layout):

1. Spec file or ticket the user named (path, id, or title).
2. Index / backlog files if present (e.g. `docs/OPPORTUNITIES.md`, `docs/BUGS.md`, `TODO.md`, Linear/GitHub issue).
3. Agent conventions (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, ADRs / architecture docs).
4. Sibling skills for post-handoff work (`fix`, `implement`, `backlog`) if they exist in the project.

Prefer the repo’s existing id scheme and doc paths. If none exist, keep decisions in the single spec file the user pointed at.

## When to run

- **`/interview`** with a ticket id, path, or “this bug/opportunity”
- User asks to **close open questions**, **lock scope**, or **prepare for implementation**
- Spec has **Open questions**, **Open decisions**, **TBD**, unresolved forks, or contradictory proposed direction
- User asks for a **final pass** on an already-interviewed spec (restructure for handoff without new product questions)

## Before the first question

1. **Load the spec** — full opportunity/bug/ticket file; index row if the repo has one.
2. **Inventory open items** — open-question sections, TBD rows, unresolved forks.
3. **Skim context** — related tickets, architecture docs, and code the implementer will touch (so options are grounded).
4. **State the plan** — question count and order (dependencies first: platform → data model → UX). One question per turn unless the user asks to batch.

## Per open issue (one at a time)

1. **Present the question** — what is undecided and why it blocks implementation.
2. **Offer options** — 2–4 choices with **tradeoffs** (cost, risk, reversibility). Prefer **UX-first framing** when the user thinks in outcomes; map to technical options briefly.
3. **Recommend** — one option tied to repo conventions, ADRs, and shipped neighbors.
4. **Ask for preference** — wait; answer clarifiers without advancing until they choose.
5. **Record the decision** — update the spec immediately (see below).
6. **Next issue** — only after the current decision is written.

**Never** ask two scope questions in one message unless the user explicitly batches.

## After each decision — update docs

### Spec file (always)

- Remove resolved items from open-questions sections.
- Add a **Resolved** (or equivalent) numbered record of the decision.
- Update summary, status, and direction sections — no stale forks.
- Update the backlog/index one-liner when the blurb changes and the repo has an index.

### Architecture docs (when the decision is big)

Update or add architecture / ADR notes for system invariants, storage boundaries, or API contracts that outlive one ticket. Link both ways. Skip ADRs for small local choices.

## Final pass — handoff spec (required before “ready”)

When product questions are closed (or user requests **final pass only**), rewrite the spec for **implementer + TDD** consumption. Target shape:

| Section | Purpose |
| -------- | -------- |
| **Problem** | Symptom + minimal repro (external feedback id if any) |
| **Locked decisions** | Compact table (interview §1–N); not long narrative |
| **Implementation plan** | Ordered steps, **call-site table**, files to touch, explicit **out of scope** |
| **TDD plan** | Phases red→green: test files, cases to **add/replace/keep**, mock/fixture pointers |
| **Verification** | Scoped test command + short manual smoke |
| **Key files** | Table only — no directory tour |

Prune: duplicate root-cause code blocks, obsolete “fix direction” bullets superseded by locked decisions, interview closure waffle.

Status → **Ready for implementation** (or the repo’s equivalent). Point the user at the project’s fix/implement workflow if one exists.

## Done criteria

- [ ] No open questions / TBD forks that block implementation
- [ ] **Locked decisions** table + **implementation plan** + **TDD plan** present
- [ ] Status is ready for implementation; index row consistent (if applicable)
- [ ] Architecture note added when decisions are cross-cutting
- [ ] Spec readable by a cold agent without chat context

Tell the user the ticket is **ready for handoff** and list deferred engineering-only items (spikes, migrations) explicitly.

## Output shape (each interview turn)

```markdown
## Question N of M — [short title]

**Context:** …

| Option | Tradeoffs |
|--------|-----------|
| A — … | … |
| B — … | … |

**Recommendation:** …

What’s your preference?