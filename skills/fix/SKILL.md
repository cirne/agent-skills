---
name: fix
description: End-to-end bug fix workflow—reproduce via regression tests (TDD) or evals when agent-shaped, implement the fix, verify with a VERIFIED/NOT VERIFIED verdict, then commit. With a tracked bug id, read and archive the spec; without an id, fix in place. Use when the user invokes /fix or asks to fix a bug.
---

# Fix (bug workflow)

Prefer **TDD**: failing automated check first when practical. Discover project conventions from AGENTS.md / contributing docs.

## Which path?

| User input | Backlog | After fix |
|------------|---------|-----------|
| Tracked bug id / path / matching active backlog row | Read that spec; cite the id in commits | Archive per `/backlog` |
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
- `/verify-this` · `/tests` · `/deslop` · `/backlog` · `/commit`
