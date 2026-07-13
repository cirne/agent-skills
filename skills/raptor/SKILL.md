---
name: raptor
description: >-
  Simplify designs the Raptor way—first principles, aggressive deletion, and
  learning from past decisions instead of protecting them. Thoughtful about when
  to ask “are you sure?” on deep cuts vs proceed on clear, reversible deletes.
  Use when the user invokes /raptor (alone or with /fix, /implement, reviews,
  etc.), asks to simplify architecture like Raptor 3, strip accidental
  complexity, challenge inherited requirements, or apply delete-before-optimize
  thinking.
---

# Raptor

Most systems accrue complexity (v2 adds sensors, flags, adapters, “just in case”).
**Raptor inverted that:** Raptor 3 is more powerful and lighter than Raptor 1/2
because plumbing, sensors, and heat-shroud kit were deleted or internalized—not
bolted on. Apply the same discipline to software, APIs, processes, and product scope.

Use `/raptor` anywhere deletion/first-principles thinking helps—design review,
refactor, opportunity, bug fix, process cleanup. Pairing with `/fix` (or other
skills) is **one example**, not the only mode.

## Danger — this tool is destructive if misused

Raptor is a **deletion lens**, not a license to gut the system. Done wrong it
removes load-bearing constraints, breaks users, and “simplifies” by amnesia.

| Misuse | What it looks like | Do instead |
|--------|--------------------|------------|
| Delete without a goal | “Remove complexity” with no outcome | One-sentence first-principles goal first |
| Delete the lesson with the artifact | Drop the check that existed for a real failure | Keep the constraint; delete scaffolding |
| Optimize-by-deletion theater | Big rewrite that adds new indirection | Prefer surgical removals you can reverse |
| Skip validation | Ship deletes because the essay sounded brave | Falsifiable success checks before merge |
| Confuse Raptor with cleanup | Treat as `/deslop` or drive-by PR nit | Scope to a named design / change set |
| Automate the cut | Bulk-delete “unused” without owners | Named owner + add-back plan per delete |
| Never ask / always ask | Gut the system silently, or stall every trivial delete | Use **When to ask “are you sure?”** below |

**Hard stops — never delete under a Raptor pass:**

- Auth, authz, encryption, secrets handling, audit/compliance requirements
- Data integrity (transactions, invariants, backups, migration safety)
- User-trust surfaces (billing, destructive confirmations, privacy)
- Tests that encode real behavior (delete *redundant* tests, not coverage of the goal)
- Anything with no rollback path and no named approver

SpaceX’s “add ~10% back” is not optional theater: **overshoot is expected**;
silent permanent loss is failure. Plan restores before you cut.

## When to ask “are you sure?”

This is the core judgment call for **every** Raptor invocation—solo or composed.

**Proceed** (no pause) when **all** are true:

- Cut is clearly inside the stated goal
- Reversible (revert / flag / restore known)
- Validation covers the risk (test, eval, or explicit smoke of the goal)
- Lesson from the old design is clear (constraint kept or consciously dropped)
- Blast radius is local; hard stops untouched

**Stop and ask** — one short “are you sure?” on implications — when **any** are true:

| Pause when | Ask about |
|------------|-----------|
| Deep cut / hard tradeoff | What capability, compat, or promise might be lost |
| Lesson unclear | Why it existed; keep constraint vs delete artifact |
| Blast radius wide | Public API, data shape, cross-module / multi-tenant effects |
| Rollback weak | How we restore if wrong |
| Validation gap | What else must stay green that current checks won’t catch |
| User said proposal-only / analysis | Do not implement; confirm before any cut |

**Ask shape:** what you’d delete, what still works, what might break, lesson kept,
rollback. One tradeoff per message; wait. Don’t batch unrelated deep cuts.

**Do not** pause for every routine, well-covered delete—that trains noise and
defeats Raptor. **Do not** silently take irreversible deep cuts—that is misuse.

## Modes

| Mode | When | Behavior |
|------|------|----------|
| **Proposal** | `/raptor` alone, “review”, “propose”, or user has not asked to change code | Report only; flag which deletes would need an “are you sure?” |
| **Implement** | User approved cuts, or paired with an action skill (`/fix`, `/implement`, …) and cuts are in scope | Proceed when safe; **ask** on deep cuts; validate; add back ~10% if needed |

Never treat “user invoked `/raptor`” alone as blanket permission to rewrite the tree.

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

- User invokes `/raptor` (any context)
- Design review where complexity grows faster than capability
- Before a big rewrite *or* feature add (challenge whether either is needed)
- After shipping v1/v2, deciding what the next generation should *drop*
- Paired with other skills when the user wants a deletion bias (examples below)

**Not a substitute for** `/deslop`, `/fix` alone, `/interview`, or
`/global-code-review`. Raptor is the *deletion / first-principles* lens.

### Example pairings (non-exhaustive)

| Pairing | What changes |
|---------|----------------|
| `/fix … with /raptor` | Prefer deleting the failure mode over shimming; TDD + verify; ask on deep cuts |
| `/implement … with /raptor` | Bias the build toward minimal parts; ask before dropping locked scope |
| `/raptor` on a design / OPP | Proposal (and optional `/interview` if product forks appear) |
| `/raptor` mid-refactor | Same ask/proceed gate; don’t expand into unrelated cleanup |

## Workflow

```
- [ ] 1. State the real goal in one sentence (user/outcome, not implementation)
- [ ] 2. List every requirement, dependency, and “must keep” — name an owner for each
- [ ] 3. Mark candidates to delete (parts, layers, flags, compat shims, processes)
- [ ] 4. For each delete: lesson kept, rollback, validate-by; tag proceed vs ask
- [ ] 5. Proposal mode → report and stop; Implement mode → ask on tagged deep cuts
- [ ] 6. Only then: cut in small reversible steps; validate; add back ~10% if needed
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
Mode: PROPOSAL | IMPLEMENT

Goal (first principles): …
Requirements challenged: …
Deletes (parts/processes/paths): …
  - item: …
    lesson kept: …
    rollback: …
    validate by: …
    gate: proceed | ask (why)
What we learn from the old design (keep the lesson, not the artifact): …
What remains (minimal): …
Risks / what we might add back (~10%): …
Success criteria (falsifiable): …
Not doing yet (optimize / speed / automate): …
Hard stops respected: auth/integrity/trust/tests/rollback …
```

Be concrete. Name files, APIs, tables, steps. Vague “simplify the architecture”
is failure. If Mode is PROPOSAL, end after the report (unless the user flips to
implement). Surface any `gate: ask` items before cutting them.

## Guardrails

- Be thoughtful about **when to ask “are you sure?”**—not never, not always.
- Proposal mode: no tree rewrites without explicit implement approval.
- Implement mode: proceed on clear covered deletes; ask on deep cuts; never skip
  hard stops or validation.
- Deletion must preserve the real goal—not delete the product.
- Prefer surgical removal over a glamorous rewrite unless the rewrite *is* the deletion.
- Do not bypass safety, auth, or tests to “simplify”; delete *needless* ceremony,
  not load-bearing checks.
- When past decisions encoded hard-won constraints, keep the constraint—delete
  the scaffolding around it.
- One delete cluster per pass when implementing; validate before the next cluster.
- Never mix “Raptor simplification” with unrelated refactors in the same change.
- If validation fails, **add back or revert**—do not layer fixes on a bad delete.
- Use `/interview` only when a pause opens real product-scope forks—not for every
  safe delete.

## Provenance (short)

Inspired by SpaceX Raptor 1→2→3 simplification and Musk’s five-step engineering
Algorithm (Everyday Astronaut Starbase tour 2021; restated Lex Fridman #438).
Canonical slogans: “question the requirements, delete the part,” “the best part
is no part,” “the most common error of a smart engineer is to optimize the thing
that should not exist.” Historical detail: [reference.md](reference.md).
