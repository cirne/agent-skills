---
name: raptor
description: >-
  Simplify designs the Raptor way—first principles, aggressive deletion, and
  learning from past decisions instead of protecting them. Standalone default is
  proposal only; `/fix … with /raptor` proceeds on clear test-covered deletes and
  asks the user on deep cuts. Use when the user invokes /raptor, pairs /fix with
  /raptor, asks to simplify architecture or a design like Raptor 3, strip
  accidental complexity, challenge inherited requirements, or apply SpaceX-style
  delete-before-optimize thinking.
---

# Raptor

Most systems accrue complexity (v2 adds sensors, flags, adapters, “just in case”).
**Raptor inverted that:** Raptor 3 is more powerful and lighter than Raptor 1/2
because plumbing, sensors, and heat-shroud kit were deleted or internalized—not
bolted on. Apply the same discipline to software, APIs, processes, and product scope.

## Danger — this tool is destructive if misused

Raptor is a **deletion lens**, not a license to gut the system. Done wrong it
removes load-bearing constraints, breaks users, and “simplifies” by amnesia.

**Default mode depends on invocation:**

| Invocation | Default |
|------------|---------|
| `/raptor` alone (design review / simplification pass) | **Proposal only** — do not delete until the user approves implement |
| `/fix … with /raptor` | **Fix with deletion bias** — proceed on clear, test-covered cuts; **stop and ask** on deep cuts (see Composed with /fix) |

Never delete code, drop tables, remove APIs, or rewrite trees in proposal-only
mode. Under `/fix … with /raptor`, only cut what the bug goal justifies—and
pause when implications need a human.
| Misuse | What it looks like | Do instead |
|--------|--------------------|------------|
| Delete without a goal | “Remove complexity” with no outcome | One-sentence first-principles goal first |
| Delete the lesson with the artifact | Drop the check that existed for a real failure | Keep the constraint; delete scaffolding |
| Optimize-by-deletion theater | Big rewrite that adds new indirection | Prefer surgical removals you can reverse |
| Skip validation | Ship deletes because the essay sounded brave | Falsifiable success checks before merge |
| Confuse Raptor with cleanup | Treat as `/deslop` or drive-by PR nit | Scope to a named design / change set |
| Automate the cut | Bulk-delete “unused” without owners | Named owner + add-back plan per delete |

**Hard stops — never delete under a Raptor pass:**

- Auth, authz, encryption, secrets handling, audit/compliance requirements
- Data integrity (transactions, invariants, backups, migration safety)
- User-trust surfaces (billing, destructive confirmations, privacy)
- Tests that encode real behavior (delete *redundant* tests, not coverage of the goal)
- Anything with no rollback path and no named approver

SpaceX’s “add ~10% back” is not optional theater: **overshoot is expected**;
silent permanent loss is failure. Plan restores before you cut.

## Core principles (always)

1. **Rethink the problem from first principles.**
   Boil the goal down to what physics / users / data actually require. Reason from
   fundamentals, not by analogy (“how X does it,” “industry best practice,”
   “we already have this pattern”). Question every requirement—especially ones
   from smart people or sacred docs. A requirement without a named owner is
   especially suspect.

2. **Delete, delete, delete.**
   The best part is no part; the best process is no process. Remove before you
   polish. If you never have to put ~10% back, you did not delete hard enough.
   Do not optimize, accelerate, or automate something that should not exist.

3. **Don’t remain in love with past decisions; learn from them instead.**
   v1/v2 were experiments, not vows. Keep the *lesson* (why the heat shroud
   existed; what failed), not the *artifact*. Loyalty to yesterday’s design is
   how Christmas-tree systems form. Prefer a clean break when the cost of
   compatibility exceeds the value of the old shape.

## The Algorithm (ordered — do not skip ahead)

Run these **in order**. The characteristic failure of a smart engineer is
optimizing or automating the thing that should have been deleted.

1. **Make the requirements less dumb** — attack the question before the solution.
2. **Delete the part or process** — remove it; overshoot on purpose.
3. **Simplify / optimize** — only what survived steps 1–2.
4. **Accelerate cycle time** — go faster only on the lean path.
5. **Automate** — last; never encode a process you have not proven necessary.

**Never:** add abstraction “for later,” keep dual paths “just in case,” or
automate a workaround that should vanish.

## When to run

- User invokes `/raptor` or asks for Raptor-style simplification
- **`/fix … with /raptor`** (or “fix BUG-N with Raptor”) — deletion lens *inside* the bug fix; see **Composed with /fix** below
- Design review where complexity is growing faster than capability
- Before a big rewrite *or* a big feature add (challenge whether either is needed)
- After shipping v1/v2, when deciding what the next generation should *drop*

**Not a substitute for** `/deslop` (local AI-slop cleanup), `/fix` alone (bug fix without a deletion thesis),
or `/global-code-review` (manageability ranking). Raptor is the *deletion /
first-principles* lens on a concrete design or change set.

## Composed with `/fix` (preferred bug use case)

Ideal prompt: **`/fix BUG-232 with /raptor`**.

Here Raptor is not a separate proposal essay by default. It biases the fix toward
**delete the accidental complexity that caused the bug**, under `/fix`’s TDD and
verify loop.

| Situation | Behavior |
|-----------|----------|
| Cut is clear, reversible, covered by the failing repro (+ obvious neighbors) | **Proceed** — simplify and fix; prove no regressions; note what died |
| Deep cut / hard tradeoff / unclear lesson / blast radius beyond the bug | **Stop and ask** — short implications question; wait for the user |
| Standalone `/raptor` (no `/fix`) | Stay in **proposal only** until explicit implement approval |

**Ask shape (when pausing):** what you’d delete, what still works, what might break,
what lesson you’d keep, rollback. One question; don’t batch unrelated tradeoffs.

**Proceed shape:** red repro → delete/simplify → green repro → `/verify-this` (and
Raptor success checks) → commit. If validation fails, add back or revert—don’t
stack patches on a bad delete.

Full interview is optional: use `/interview` only when the pause reveals open
product scope, not for every safe delete.

## Workflow

```
- [ ] 1. State the real goal in one sentence (user/outcome, not implementation)
- [ ] 2. List every requirement, dependency, and “must keep” — name an owner for each
- [ ] 3. Mark candidates to delete (parts, layers, flags, compat shims, processes)
- [ ] 4. For each delete: lesson kept, rollback, and how we will know it was safe
- [ ] 5. Propose the minimal design that still hits the goal (proposal only)
- [ ] 6. Define success criteria (see Validate below) — get user approval
- [ ] 7. Only if approved: implement deletes in small, reversible steps
- [ ] 8. Run validation; add back the ~10% that proved necessary; stop
```

### Questions to force deletion

- If we shipped greenfield tomorrow, would we invent this?
- What exists only because of a past decision we no longer need?
- Are we optimizing a path that should not exist?
- Can two components become one—or zero?
- What would we have to add back if we deleted this? (If nothing concrete → delete.)
- If this delete is wrong, how do we detect it within one test / one user journey?

### Software translation (examples)

| Hardware instinct | Software analogue |
|-------------------|-------------------|
| External pipe / sensor | Optional flag, adapter, wrapper, telemetry “just in case” |
| Heat shroud protecting messy exterior | Compat layer, facade, dual-write, feature-flag forever |
| Bolted flange | Indirection between packages that could be one module |
| Part that weighs something and can fail | Code path that must be tested, documented, and reasoned about |

Prefer: fewer modules, fewer config knobs, fewer migration/compat branches,
one clear data path. Accept putting ~10% back after a delete overshoots.

## Validate — did Raptor work as intended?

A Raptor pass **succeeded** only if capability held (or improved) while
complexity fell—and the cut was *reversible until proven*.

**Succeeded when all of these are true:**

1. **Goal intact** — the one-sentence outcome still works (demo, eval, or user path).
2. **Complexity actually down** — fewer modules/paths/flags/steps; not a rewrite that
   relocated the same Christmas tree.
3. **Lessons preserved** — every deleted artifact has an explicit “why it existed”
   note; hard-won constraints remain as simpler enforcement (test, type, invariant).
4. **Add-back budget used honestly** — something came back, or a written reason why
   zero add-backs is still aggressive enough *and* validated.
5. **Blast radius bounded** — scoped diff; rollback known (revert commit, flag, restore).

**Failed (stop / restore) when any of these appear:**

- Goal regressions (“simpler” but the job no longer works)
- Deleted safety, auth, or integrity with no replacement constraint
- New abstraction layer claimed as simplification
- No way to tell if the delete was wrong (no test, no metric, no owner watching)
- User expected a proposal and got a destructive rewrite

**Minimum evidence before calling it done:**

- Named success checks run green (project tests, eval, or manual script of the goal)
- Short “what died / what we learned / what we added back” summary
- Explicit residual risks (what we might still need to restore)

Prefer `/verify-this` when the claim is falsifiable (“X still works without Y”).

## Output format

```text
Mode: PROPOSAL ONLY | IMPLEMENT (user-approved)

Goal (first principles): …
Requirements challenged: …
Deletes (parts/processes/paths): …
  - item: …
    lesson kept: …
    rollback: …
    validate by: …
What we learn from the old design (keep the lesson, not the artifact): …
What remains (minimal): …
Risks / what we might add back (~10%): …
Success criteria (falsifiable): …
Not doing yet (optimize / speed / automate): …
Hard stops respected: auth/integrity/trust/tests/rollback …
```

Be concrete. Name files, APIs, tables, steps. Vague “simplify the architecture”
is failure. If Mode is PROPOSAL ONLY, end after the report.

## Guardrails

- **Standalone `/raptor`:** propose first; implement only on explicit approval.
- **`/fix … with /raptor`:** proceed on clear covered deletes; ask on deep cuts;
  never skip hard stops or verification.
- Deletion must preserve the real goal—not delete the product.
- Prefer surgical removal over a glamorous rewrite unless the rewrite *is* the deletion.
- Do not bypass safety, auth, or tests to “simplify”; delete *needless* ceremony,
  not load-bearing checks.
- When past decisions encoded hard-won constraints (law of physics, user trust,
  data integrity), keep the constraint—delete the scaffolding around it.
- One delete cluster per pass when implementing; validate before the next cluster.
- Never mix “Raptor simplification” with unrelated refactors in the same change.
- If validation fails, **add back or revert**—do not layer fixes on a bad delete.

## Provenance (short)

Inspired by SpaceX Raptor 1→2→3 simplification and Musk’s five-step engineering
Algorithm (Everyday Astronaut Starbase tour 2021; restated Lex Fridman #438).
Canonical slogans: “question the requirements, delete the part,” “the best part
is no part,” “the most common error of a smart engineer is to optimize the thing
that should not exist.” Historical detail: [reference.md](reference.md).
