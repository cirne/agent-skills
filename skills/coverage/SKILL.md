---
name: coverage
description: Measures, assesses, and improves test coverage with risk/feasibility triage. Use when the user invokes /coverage, asks which areas need tests, wants to add coverage for a specific area, or asks about coverage gaps and priorities.
---

# Coverage

Goal: **improve coverage and testability** within reason — know gaps, prioritize by **behaviors**, accept documented blind spots where automation is poor ROI. Line/branch % is evidence, not the objective.

## Discover repo conventions

| Need | Look for |
|------|----------|
| Coverage command | `test:coverage`, `coverage`, vitest/jest/nyc config |
| Gap tracker | `docs/coverage.md` or equivalent |
| Test patterns | component-testing docs, fixtures, e2e vs unit |
| Project overlay | `<repo>/.cursor/skills/coverage.local/` when present |

Run via `/tests` logging rules (full logs, no pipe). When a project overlay exists, **follow this skill first, then the overlay**.

## Commands

| User says | Do |
|-----------|-----|
| `/coverage` | Refresh metrics, summarize gaps, recommend next targets |
| `/coverage … need tests` | Rank by risk × gap (behaviors, not residual %) |
| `/coverage add … for <area>` | Admission plan → tests → scoped coverage → update gap doc |

## Quality gate (before writing tests)

**Admission criteria** — for each proposed case, write (chat or PR body):

1. **Behavior** — one sentence, user-visible or data-integrity
2. **Failure mode** — if this regresses, user/system sees X
3. **Test shape** — mount+event, HTTP route contract, pure helper, or eval — not “hit uncovered lines”

**Refuse / skip** when the only win is covering another `if` in an already well-tested file with no distinct product stake. Prefer documenting an accepted blind spot or rewriting theater over packing residual branches.

**Definition of done**

- A deliberate break of the named behavior would fail the new test
- Prefer **≤3 distinct cases** per pass (one behavior per case; no mega-tests)
- Scoped coverage % may rise as secondary evidence — never the sole success metric
- Gap tracker updated with the **behavior** closed, not only a new line %

**Theater (do not ship)**

- `readFileSync` / source greps on `.svelte` / `.css` / implementation text
- Long prompt/copy `toContain` slogan lists
- Mock-only route-shape spam with no product-stakes failure mode
- Packing unrelated branches into one test to lift %

Project overlays may name concrete theater clusters; apply those filters too.

## Workflow

### 1. Measure

Run the project coverage command. Prefer **scoped** coverage on new test files after adding them; full suite only for audits / snapshot metrics.

### 2. Prioritize (risk × feasibility)

Score **High / Medium / Low** on each axis — for **behaviors**, not files alone.

- **Risk:** user/data harm if untested (auth, payments, sync, agent tools = high; chrome/dev-only = low)
- **Feasibility:** pure functions/routes = high; full OAuth / pixel-perfect / credential e2e = low

Tackle **high risk + high/medium feasibility** first. High risk + low feasibility → document accepted gap + lighter substitute.

Prefer (in order): (1) named missing behaviors in the gap tracker, (2) rewrite/delete theater, (3) residual % only when the case is a distinct regression class.

### 3. Choose test type

Match project norms: unit, component, integration, eval, e2e.

### 4. Improve and record

Add meaningful tests that pass the quality gate. Update the gap tracker when closing a tracked gap. Re-measure scoped coverage for the target.

## Output

Top recommended targets (3–5) with risk, feasibility, **behavior under test**, and suggested test shape — plus what changed in the gap doc if anything. Mark theater/weak so those gaps are not “closed.”

For `/coverage add`, include the admission criteria answers in the closing summary (and PR body when opening one).

## Automation

Overnight / cloud coverage agents: ship **≤3 high-value cases** or open **no PR**. If only theater-feasible work remains, update accepted blind spots / suggested next actions and exit without a test PR.
