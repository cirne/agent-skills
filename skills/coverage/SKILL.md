---
name: coverage
description: Measures, assesses, and improves test coverage with risk/feasibility triage. Use when the user invokes /coverage, asks which areas need tests, wants to add coverage for a specific area, or asks about coverage gaps and priorities.
---

# Coverage

Goal: **improve coverage and testability** within reason — know gaps, prioritize by risk, accept documented blind spots where automation is poor ROI.

## Discover repo conventions

| Need | Look for |
|------|----------|
| Coverage command | `test:coverage`, `coverage`, vitest/jest/nyc config |
| Gap tracker | `docs/coverage.md` or equivalent |
| Test patterns | component-testing docs, fixtures, e2e vs unit |

Run via `/tests` logging rules (full logs, no pipe).

## Commands

| User says | Do |
|-----------|-----|
| `/coverage` | Refresh metrics, summarize gaps, recommend next targets |
| `/coverage … need tests` | Rank by risk × gap |
| `/coverage add … for <area>` | Assess → plan → add tests → scoped coverage → update gap doc |

## Workflow

### 1. Measure

Run the project coverage command. Prefer **scoped** coverage on new test files after adding them; full suite only for audits / snapshot metrics.

### 2. Prioritize (risk × feasibility)

Score **High / Medium / Low** on each axis.

- **Risk:** user/data harm if untested (auth, payments, sync, agent tools = high; chrome/dev-only = low)
- **Feasibility:** pure functions/routes = high; full OAuth / pixel-perfect / credential e2e = low

Tackle **high risk + high/medium feasibility** first. High risk + low feasibility → document accepted gap + lighter substitute.

### 3. Choose test type

Match project norms: unit, component, integration, eval, e2e.

### 4. Improve and record

Add meaningful tests (not theater). Update the gap tracker when closing a tracked gap. Re-measure scoped coverage for the target.

## Output

Top recommended targets (3–5) with risk, feasibility, and suggested test shape — plus what changed in the gap doc if anything.
