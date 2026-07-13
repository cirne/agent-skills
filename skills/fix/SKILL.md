---
name: fix
description: End-to-end bug fix workflow—reproduce via regression tests (TDD) or evals when agent-shaped, implement the fix, verify with a VERIFIED/NOT VERIFIED verdict, then commit. Can pair with /raptor for a deletion bias (ask on deep cuts per /raptor). With a tracked bug id, read and archive the spec; without an id, fix in place. Use when the user invokes /fix or asks to fix a bug.
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
- `/raptor` — optional deletion/first-principles lens (e.g. `/fix … with /raptor`); follow `/raptor` for when to ask “are you sure?”
- `/verify-this` · `/tests` · `/deslop` · `/backlog` · `/commit`

## Example: `/fix … with /raptor`

One way to use `/raptor`—not the only way. Fix the bug **and** prefer deleting
accidental complexity over patching around it.

Follow `/fix` (TDD → fix → verify → commit). Thread `/raptor` into understand/fix:

1. **Understand** — Bug goal in one sentence. Prefer a delete that removes the failure mode over a shim.
2. **Reproduce** — Unchanged (failing test/eval first).
3. **Fix** — Simplest design that goes green. Apply `/raptor` **When to ask “are you sure?”**: proceed on clear covered deletes; pause on deep cuts.
4. **Verify** — Repro green **and** Raptor success checks. Prefer `/verify-this`.
5–6. Commit / archive as usual.

Do not write a full Raptor proposal essay unless the user asked for analysis-only
or you hit an ask gate. Momentum: **simplify and fix when safe; ask when
implications need a human.**
