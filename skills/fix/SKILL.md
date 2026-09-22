---
name: fix
description: End-to-end bug fix workflow—root-cause over symptom patches, reproduce via regression tests (TDD) or evals when agent-shaped, implement the fix, verify with a VERIFIED/NOT VERIFIED verdict, then commit. Can pair with /raptor for a deletion bias (ask on deep cuts per /raptor). With a tracked bug id, read and archive the spec; without an id, fix in place. Use when the user invokes /fix or asks to fix a bug.
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

1. **Understand** — Spec or user description. Skim architecture docs for the area. Classify symptom vs deeper design gap.

   **Root cause over whack-a-mole.** Before coding, ask: what generalized failure mode produced this bug? Prefer a fix that closes the class (invariant, API contract, shared helper, prompt/tool contract, missing guard at the right layer) over a one-off patch at the call site that will recur under the next input. Name the root cause in one sentence; if you can only name the symptom, dig further or ask.

   **Complex / architectural → plan first.** If the right fix is not a localized change—cross-cutting refactor, new abstraction, data-model or persistence change, multi-surface redesign, or “holistic” vs “patch this instance” is genuinely ambiguous—**stop**. Present to the user before implementing:

   - Root cause (one sentence)
   - Proposed solution (what changes, where, what is deliberately *not* in scope)
   - Validation plan (failing repro first; what proves the class is fixed, not just this instance)
   - Risks / tradeoffs (blast radius, migration, follow-ups)

   Wait for approval (or a narrower direction) before step 2 beyond a minimal failing repro that locks the bug, or before step 3. Do not silently choose a large redesign.

   For **agent/reasoning** failures: prefer improving tools, prompts, and context over heuristics (project agent-design docs if present).

2. **Reproduce (TDD)** — Smallest automated repro that actually fails for the bug class:

   | Bug class | Primary repro | Secondary (optional) |
   |-----------|---------------|----------------------|
   | **Agent accuracy** — prompts, tool descriptions/output, tool↔prompt integration, retrieval/routing, “model chose the wrong tool” | **Eval** (live agent + expect on tools/answer) when the project has an eval harness | Unit tests for pure helpers / deterministic tool envelopes only |
   | Everything else | Failing unit/integration/UI test | — |

   Prefer a repro that fails for the **class** of bug (adjacent inputs / shared path), not only the reported instance—so a narrow patch cannot go green while siblings stay broken.

   **Agent accuracy — do not treat as sufficient repro/verify:**
   - Asserting a string/fragment exists in a prompt, skill, or tool `description`
   - Snapshotting full system prompts without exercising the agent loop
   Those checks are cheap to pass and do not prove the model uses the right tools or retrieves the right corpus. Prefer an eval that fails when the agent takes the wrong path (e.g. `search_mail` instead of unified `search`).

   - If you cannot get a red repro → **stop and ask** for concrete details

3. **Fix** — Minimal change that satisfies the repro **and** addresses the named root cause (not a call-site special case unless that *is* the root cause). For agent accuracy: tools/context/prompts first (project agent-design hierarchy), not keyword heuristics. Run scoped type/lint before re-testing (`/tests`). Optional `/deslop` if noisy.

4. **Verify** — `/verify-this`: falsifiable claim + baseline vs treatment → `VERIFIED` / `NOT VERIFIED` / `INCONCLUSIVE`. Do not land on `NOT VERIFIED`. For agent-accuracy bugs, the treatment evidence should include a **passing eval** (or an explicit INCONCLUSIVE if the harness/fixture cannot run), not only green unit tests. Prefer evidence that the failure **class** is closed, not only the original instance.

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

1. **Understand** — Bug goal in one sentence. Prefer a delete that removes the failure mode over a shim. Same complex/architectural ask gate as above.
2. **Reproduce** — Unchanged (failing test/eval first; prefer class-level repro).
3. **Fix** — Simplest design that goes green. Apply `/raptor` **When to ask “are you sure?”**: proceed on clear covered deletes; pause on deep cuts.
4. **Verify** — Repro green **and** Raptor checks (goal intact, app LOC ↓ excluding tests/evals). Prefer `/verify-this`.
5–6. Commit / archive as usual.

Do not write a full Raptor proposal essay unless the user asked for analysis-only
or you hit an ask gate. Momentum: **simplify and fix when safe; ask when
implications need a human.**
