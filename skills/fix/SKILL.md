---
name: fix
description: End-to-end bug fix workflow—reproduce via regression tests (TDD) or evals when agent-shaped, implement the fix, verify with a VERIFIED/NOT VERIFIED verdict, then commit. Supports `/fix … with /raptor` to prefer deleting accidental complexity (ask on deep cuts). With a tracked bug id, read and archive the spec; without an id, fix in place. Use when the user invokes /fix or asks to fix a bug.
---

# Fix (bug workflow)

Prefer **TDD**: failing automated check first when practical. Discover backlog paths via `/backlog` (reads `docs/README.md` first) and project `AGENTS.md` / contributing docs.

## Which path?

| User input | Backlog | After fix |
|------------|---------|-----------|
| Tracked bug / backlog id / path / matching active row | Read that spec; cite the id in commits | Archive per `/backlog` |
| Ad-hoc description only | Do **not** file a new backlog entry unless asked | Skip archive; commit only |

When unsure, search the backlog before choosing.

## Workflow

1. **Understand** — Spec or user description. Skim architecture docs for the area. Classify symptom vs deeper design gap; ask when both “fix this bug” and “holistic fix” are plausible.

   For **agent/reasoning** failures: prefer improving tools, prompts, and context over heuristics (project agent-design docs if present).

2. **Reproduce (TDD)** — Smallest automated repro:
   - Agent-shaped → eval task / harness if the repo has one
   - Otherwise → failing unit/integration/UI test
   - If you cannot get a red repro → **stop and ask** for concrete details

3. **Fix** — Minimal change that satisfies the repro. Run scoped type/lint before re-testing (`/tests`). Optional `/deslop` if noisy.

4. **Verify** — `/verify-this`: falsifiable claim + baseline vs treatment → `VERIFIED` / `NOT VERIFIED` / `INCONCLUSIVE`. Do not land on `NOT VERIFIED`.

5. **Commit** — `/commit` (include bug id when tracked).

6. **Archive** (tracked only) — `/backlog` close-and-archive.

## Related

- `/interview` — scope lock when the bug is underspecified
- `/raptor` — when invoked as **`/fix … with /raptor`** (or “Raptor-style”), apply the deletion lens during the fix (see below)
- `/verify-this` · `/tests` · `/deslop` · `/backlog` · `/commit`

## `/fix … with /raptor`

Ideal invocation: fix the bug **and** prefer deleting accidental complexity over patching around it.

Follow `/fix` (TDD → fix → verify → commit). Thread `/raptor` into steps 1 and 3:

1. **Understand** — State the bug goal in one sentence. Ask: what exists only because of a past decision? Prefer a delete that removes the failure mode over a shim that hides it.
2. **Reproduce** — Unchanged (failing test/eval first).
3. **Fix** — Choose the simplest design that goes green. Delete parts/paths when the cut is **clear, reversible, and covered by the repro** (lesson kept as a simpler constraint). Stay inside `/raptor` hard stops (auth, integrity, trust, load-bearing tests).
4. **Verify** — Repro green **and** Raptor success checks (goal intact, complexity down, no new abstraction theater). Prefer `/verify-this`.
5–6. Commit / archive as usual.

### When to stop and ask (you)

Pause before cutting if **any** of these are true — one short tradeoff question, then wait:

| Pause when | Ask about |
|------------|-----------|
| Deep cut / hard tradeoff | Capability, compat, or product promise that might be lost |
| Lesson unclear | Why the old part existed; keep constraint vs delete artifact |
| Blast radius beyond the bug | Extra modules, public API, data shape, multi-tenant behavior |
| Rollback weak | No easy revert / flag / restore for this delete |
| Repro doesn’t cover the risk | What else must stay green that the failing test won’t catch |

Do **not** pause for routine, well-covered deletes that clearly remove the bug’s cause (proceed, prove with tests, note what died in the commit/summary).

Do **not** run a full standalone Raptor proposal essay unless the user asked for proposal-only or you hit a pause gate. Under `/fix … with /raptor`, momentum is: **simplify and fix when safe; ask when the deep cut’s implications need a human.**
