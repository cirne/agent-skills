---
name: tests
description: How agents run the project test suite — capture full output to log files; never pipe test runs through grep, tail, or head. Use when running tests, coverage, e2e, iterating on failures, or any skill that executes the test suite.
---

# Running tests

**Order:** On product code changes, run scoped **type/lint on touched files first** (see project AGENTS.md / contributing docs) — then scoped tests. Full suite is for commit/CI, not every fix iteration.

**Never pipe a test command through `grep`, `tail`, `head`, `tee`, or similar.** Pipes drop context and force a re-run to recover diagnostics.

**Always** redirect the full run to a unique log under a project attempt dir (create if needed). Default convention: **`.test-attempts/`** at repo root. On failure, **read the log file** — do not re-run just to capture output.

## Setup (each run)

```sh
# Use the repo’s Node/runtime pin if present (nvm use, mise, asdf, …)
mkdir -p .test-attempts
LOG=".test-attempts/$(date +%Y%m%d-%H%M%S)-<slug>.log"
```

## Discover commands

Read package scripts / docs — do not assume. Common patterns:

| Intent | Prefer |
|--------|--------|
| Scoped | Smallest path filter the harness supports |
| Full suite | Project `test` / `ci` script |
| Coverage | Project coverage script |
| E2E | Project e2e script |

Prefer **`CI=1`** (or equivalent) for stable, grep-friendly logs when the project supports it. Append `> "$LOG" 2>&1`; check exit code separately.

**Vitest projects caveat:** `pnpm run test -- <file>` may still run the full suite. Prefer `pnpm exec vitest run <paths>` when that is the project pattern.

## After the run

| Exit | Action |
|------|--------|
| **0** | Note log path briefly |
| **non-zero** | Read `$LOG` (or `rg` inside the file). Fix with targeted re-runs (**new log per attempt**) |

## Related

- `/commit` — when to run scoped vs full suite
- `/coverage` — coverage-focused runs
- `/fix` — TDD regression runs
