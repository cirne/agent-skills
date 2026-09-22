---
name: coverage
description: Measures, assesses, and improves test coverage with risk/feasibility triage — and flags coverage theater (shallow string/source mirrors). Use when the user invokes /coverage, asks which areas need tests, wants to add coverage for a specific area, or asks about coverage gaps, priorities, or weak/theater tests.
---

# Coverage

Goal: **improve real confidence and testability** within reason — know gaps, prioritize by **behaviors**, reject theater that only mirrors implementation, accept documented blind spots where automation is poor ROI. Line/branch % is evidence, not the objective; high % with shallow assertions is a false green.

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
| `/coverage` | Refresh metrics, summarize gaps, **scan for theater**, recommend next targets |
| `/coverage … need tests` | Rank by risk × gap (behaviors, not residual %; discount theater-inflated areas) |
| `/coverage theater` | Audit for shallow mirrors; do not chase line % |
| `/coverage add … for <area>` | Admission plan → **behavioral** tests → scoped coverage → update gap doc |

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

### Theater (do not ship)

**Coverage theater** = tests that mostly assert “the code we wrote is still the code we wrote” — no logic, branches, failure modes, or user-visible outcomes exercised. Brittle under copy/CSS refactors, and false confidence.

| Red flag | Why it’s weak |
|----------|----------------|
| `readFileSync` / source greps on `.svelte`, `.css`, implementation text | Never mounts or runs the unit; locks implementation text |
| Long prompt/copy `toContain` slogan lists | Mirrors wording; no branch or failure coverage |
| Exact Tailwind/CSS class strings or layout tokens | Style churn ≠ behavior |
| “Source contract” / “implements OPP-NNN” tests that only grep source | Documents intent in the wrong layer |
| Snapshot-of-prose with no inputs varied | Same as string laundry lists |
| Mock-only route-shape spam with no product-stakes failure mode | Asserts the mock, not the contract |
| Packing unrelated branches into one test to lift % | Optimizes the metric, not the risk |

| Usually *not* theater — keep | Why it’s real |
|------------------------------|----------------|
| Fixture values appear / wrong values do not | Data plumbing |
| Flag on → section present; flag off → absent | Conditional logic |
| Invariants: secrets omitted, dangerous tools absent, schema shape | Safety contracts |
| User action → callback / navigation / persistence / error state | Behavior |
| Parser/transform goldens with varied inputs and edge cases | Logic |
| Evals / judge harnesses for agent quality | Outcome-level (different layer) |

**Replacement heuristics** — prefer tests that stay meaningful if someone rewrote the copy, renamed a CSS class, or rephrased a prompt without changing behavior:

1. **Vary inputs** — empty, boundary, conflicting flags, bad data
2. **Assert outcomes** — return shape, side effects, DOM roles/state, HTTP status, DB rows
3. **Assert semantic contracts** — “must instruct X before Y,” “must not include secrets” — not the full slogan list
4. **One or two anchor phrases max** when copy *is* the contract (e.g. a user-facing error code) — never a laundry list
5. **Delete or rewrite** source-`readFileSync` tests; if line % was the only win, replace with a mount/behavior test or accept a documented blind spot

Refuse pure theater even when it would move the % needle. Project overlays may name concrete theater clusters; apply those filters too.

## Workflow

### 1. Measure

Run the project coverage command. Prefer **scoped** coverage on new test files after adding them; full suite only for audits / snapshot metrics.

### 2. Prioritize (risk × feasibility)

Score **High / Medium / Low** on each axis — for **behaviors**, not files alone.

- **Risk:** user/data harm if untested (auth, payments, sync, agent tools = high; chrome/dev-only = low)
- **Feasibility:** pure functions/routes = high; full OAuth / pixel-perfect / credential e2e = low

Tackle **high risk + high/medium feasibility** first. High risk + low feasibility → document accepted gap + lighter substitute.

Prefer (in order): (1) named missing behaviors in the gap tracker, (2) rewrite/delete theater, (3) residual % only when the case is a distinct regression class.

When an area already has tests, ask: **do they lock behavior, or just wording/markup?** Theater does not reduce residual risk.

### 3. Choose test type

Match project norms: unit, component, integration, eval, e2e.

### 4. Improve and record

Add meaningful tests that pass the quality gate. Update the gap tracker when closing a tracked gap **or** when demoting an area from “covered” to “theater / weak.” Re-measure scoped coverage for the target.

## Output

Top recommended targets (3–5) with risk, feasibility, **behavior under test**, suggested test shape, and **theater notes** (none / mild / heavy) — plus what changed in the gap doc if anything. Mark theater/weak so those gaps are not “closed.”

For `/coverage add`, include the admission criteria answers in the closing summary (and PR body when opening one).

## Automation

Overnight / cloud coverage agents: ship **≤3 high-value cases** or open **no PR**. If only theater-feasible work remains, update accepted blind spots / suggested next actions and exit without a test PR.
