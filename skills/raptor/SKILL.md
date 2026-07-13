---
name: raptor
description: >-
  Simplify designs the Raptor way—first principles, aggressive deletion, and
  learning from past decisions instead of protecting them. Question whether
  requirements and features should exist at all given the product as it is
  NOW (not past ambitions): dig history/backlog for why code landed, then
  delete the requirement when the end-user job no longer needs it. Resist
  under-deletion (LLMs and engineers both half-cut). After implement, prove
  with tests and evals—not essays. Use when the user invokes /raptor (alone
  or with /fix, /implement, reviews, etc.), asks to simplify like Raptor 3,
  strip accidental complexity, challenge inherited requirements, or apply
  delete-before-optimize thinking.
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
| Half-Raptor / timid cut | New “owner” path bolted on; old scaffolding kept “just in case”; app LOC ↑ while claiming a win | Finish the delete cluster; net app LOC must fall |
| Sacred-requirement theater | Treat every BUG/OPP/eval expectation as load-bearing forever | Archaeology: why it landed; judge against product **now** |
| Skip validation | Ship deletes because the essay sounded brave | Run falsifiable proofs (tests **and** evals when the domain has them) before done |
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

## Question the requirement itself (step 0 — before any cut)

The Algorithm’s first step is not “delete code.” It is **make the requirements
less dumb.** Most Raptor failures start earlier: the agent accepts yesterday’s
BUG, OPP, eval case, or “we always wanted X” as physics, then cleverly deletes
scaffolding around a feature the product **no longer needs**.

**Judge against the product as it is NOW** — real users, current JTBD, current
surface — **not** where the team wanted to be six months ago. Past ambition is
not a requirement. An archived OPP is not a vow. An eval that locks old theater
is often debt, not product truth.

### Archaeology (do this before proposing deletes)

For every non-trivial part/process/flag under review, spend a few minutes
finding **why it was introduced**:

| Look in | What you’re hunting |
|---------|---------------------|
| Backlog / BUG / OPP / focus notes | Original failure mode, user report, “must” that may have expired |
| Git history / PR / commit messages | Intent at landing; whether the surrounding product changed since |
| Related evals / tests | Whether they lock a real user outcome or a superseded design |
| Agent transcripts / prod notes (if handy) | Whether anyone still hits the path |

Name the **lesson** in one line (“agent dropped inform → FYI gap”, “Needs
stuck after owner declined”). Then classify the requirement:

| Class | Meaning | Default move |
|-------|---------|--------------|
| **Still load-bearing now** | End user still needs this outcome on today’s surface | Keep the *constraint*; delete scaffolding around it |
| **Lesson kept, artifact optional** | Failure was real; today’s simpler path already covers it | Delete the part; keep a cheap invariant/test if useful |
| **Past ambition / zombie feature** | Built for a product shape we no longer ship or prioritize | Challenge deleting the **requirement** (feature/API/eval), not just the code |
| **Unknown** | Can’t find why it exists | Ask once — or treat as delete-with-rollback if blast radius is local |

**Half-Raptor on requirements:** simplifying implementation of a feature that
should not exist. That is optimizing the thing that should not exist.

**Ask “are you sure?”** when deleting a *user-visible* capability or a
hard-won invariant whose lesson is unclear. **Do not** ask merely because an
old doc still lists the feature.

### Questions that attack the requirement (not the code)

- Would we invent this if we shipped greenfield **for today’s product**?
- What end-user job fails if this entire feature/path disappears?
- Was this built for a roadmap we abandoned, a persona we don’t serve, or a
  density/UX target the surface no longer has?
- Does the backlog item still describe a failure users hit **now**, or only a
  past incident we already fixed another way?
- Are we keeping an eval/test because it encodes product truth — or because it
  encodes last quarter’s architecture?
- If the requirement vanished, would anyone notice outside eng/evals?

## Resist hesitation — cut deep

**Most engineers under-delete. Most LLMs under-delete harder.** The default
instinct is to add a cleaner path, leave the old heat shroud “for safety,” trim
a prompt clause, and call it Raptor. That is **half-Raptor** — usually worse
than doing nothing (two owners, more LOC, same failure modes).

**Resist that instinct.** When the goal needs a deep cut:

- Prefer **removing** the failure mode over **shimming** around it.
- Prefer **one owner** over “new rule + keep the old rule as backup.”
- Prefer **deleting dead API surface** (`drops` ignored forever, dual flags,
  display-only dedupe hiding storage bugs) over documenting why it still exists.
- Prefer **deleting a zombie feature/requirement** over endlessly hardening it.
- If app LOC did not fall on product paths, you almost certainly **did not cut
  deep enough** — name what is still on the tree and either delete it in this
  pass or explicitly defer it as residual (not a success claim).

Asking “are you sure?” is for **real** tradeoffs (capability loss, wide blast
radius, weak rollback)—**not** for soothing your urge to keep scaffolding.
Timidity is not prudence.

**Half-Raptor tells:**

- “We moved ownership” but old derive / merge / force / display paths remain
- Net **application** LOC rose or stayed flat via extract/rename theater
- Prompt got longer while apply grew guards
- Validation was “looks right” or unit-only when evals exist for the surface
- Clever redesign of a feature archaeology shows nobody needs anymore

If you catch yourself mid-pass doing any of the above: **stop polishing; finish
the delete cluster or report the pass incomplete.**

## When to ask “are you sure?”

This is the core judgment call for **every** Raptor invocation—solo or composed.

**Proceed** (no pause) when **all** are true:

- Cut is clearly inside the stated goal
- Reversible (revert / flag / restore known)
- Validation covers the risk (**will run** test, eval, or explicit smoke of the goal)
- Lesson from the old design is clear (constraint kept or consciously dropped)
- Blast radius is local; hard stops untouched

**Stop and ask** — one short “are you sure?” on implications — when **any** are true:

| Pause when | Ask about |
|------------|-----------|
| Deep cut / hard tradeoff | What capability, compat, or promise might be lost |
| Requirement itself may be zombie | Feature/eval/API deletion vs code-only delete; product-now judgment |
| Lesson unclear | Why it existed; keep constraint vs delete artifact |
| Blast radius wide | Public API, data shape, cross-module / multi-tenant effects |
| Rollback weak | How we restore if wrong |
| Validation gap | What else must stay green that current checks won’t catch |
| User said proposal-only / analysis | Do not implement; confirm before any cut |

**Ask shape:** what you’d delete, what still works, what might break, lesson kept,
rollback. One tradeoff per message; wait. Don’t batch unrelated deep cuts.

**Do not** pause for every routine, well-covered delete—that trains noise and
defeats Raptor. **Do not** silently take irreversible deep cuts—that is misuse.
**Do not** use “are you sure?” as cover for keeping parts you are merely afraid
to delete.

## Modes

| Mode | When | Behavior |
|------|------|----------|
| **Proposal** | `/raptor` alone, “review”, “propose”, or user has not asked to change code | Report only; include requirement archaeology; flag `gate: ask`; call out half-Raptor risks |
| **Implement** | User approved cuts, or paired with an action skill (`/fix`, `/implement`, …) and cuts are in scope | Cut deep when safe; **ask** on real deep tradeoffs (incl. killing a feature); **prove** with tests+evals; add back ~10% if needed |

Never treat “user invoked `/raptor`” alone as blanket permission to rewrite the tree.

## Core principles (always)

1. **Rethink the problem from first principles — and question the requirement.**
   Boil the goal down to what physics / users / data actually require **today**.
   Reason from fundamentals, not by analogy (“how X does it,” “industry best
   practice,” “we already have this pattern,” “the OPP said so”). A requirement
   without a named owner — or whose owner was a past roadmap — is especially
   suspect. Dig history/backlog before you defend or redesign it.

2. **Delete, delete, delete.**
   The best part is no part; the best process is no process. Remove before you
   polish. If you never have to put ~10% back, you did not delete hard enough.
   Do not optimize, accelerate, or automate something that should not exist.

3. **Don’t remain in love with past decisions; learn from them instead.**
   v1/v2 were experiments, not vows. Keep the *lesson* (why the heat shroud
   existed; what failed), not the *artifact*. Loyalty to yesterday’s design — or
   yesterday’s product ambition — is how Christmas-tree systems form. Prefer a
   clean break when the cost of compatibility exceeds the value of the old shape.

## The Algorithm (ordered — do not skip ahead)

Run these **in order**. The characteristic failure of a smart engineer is
optimizing or automating the thing that should have been deleted.

1. **Make the requirements less dumb** — attack the question before the solution;
   archaeology + product-now judgment (see **Question the requirement itself**).
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
- When backlog/evals defend a path that may be zombie relative to product now
- Paired with other skills when the user wants a deletion bias (examples below)

**Not a substitute for** `/deslop`, `/fix` alone, `/interview`, or
`/global-code-review`. Raptor is the *deletion / first-principles* lens.

### Example pairings (non-exhaustive)

| Pairing | What changes |
|---------|--------------|
| `/fix … with /raptor` | Prefer deleting the failure mode over shimming; TDD + verify; ask on deep cuts |
| `/implement … with /raptor` | Bias the build toward minimal parts; ask before dropping locked scope |
| `/raptor` on a design / OPP | Proposal (and optional `/interview` if product forks appear) |
| `/raptor` mid-refactor | Same ask/proceed gate; don’t expand into unrelated cleanup |
| `/backlog` + `/raptor` | Use backlog archaeology to challenge zombie requirements, not only to file more |

## Workflow

```
- [ ] 1. State the real goal in one sentence (user/outcome now, not implementation)
- [ ] 2. Archaeology: for each “must keep,” find why it landed (backlog/git/evals)
- [ ] 3. Classify requirements: load-bearing now | lesson-only | zombie | unknown
- [ ] 4. Mark candidates to delete (requirements/features AND parts/flags/shims)
- [ ] 5. For each delete: lesson kept, rollback, validate-by; tag proceed vs ask
- [ ] 6. Proposal mode → report and stop; Implement mode → ask on tagged deep cuts
- [ ] 7. Cut deep (finish the cluster — resist half-Raptor); overshoot on purpose
- [ ] 8. Prove the cut: run tests + evals (or project-equivalent); measure app LOC ↓
- [ ] 9. Add back ~10% only if proofs fail or a hard-won constraint was dropped by mistake
```

### Questions to force deletion

- If we shipped greenfield tomorrow **for today’s product**, would we invent this?
- What exists only because of a past decision or ambition we no longer need?
- Are we optimizing a path that should not exist?
- Can two components become one—or zero?
- What would we have to add back if we deleted this? (If nothing concrete → delete.)
- If this delete is wrong, how do we detect it within one test / one user journey?
- Am I keeping this only because deleting it feels scary? (If yes → cut or ask once, honestly.)
- Am I redesigning a feature archaeology shows is zombie relative to product now?

### Software translation (examples)

| Hardware instinct | Software analogue |
|-------------------|-------------------|
| External pipe / sensor | Optional flag, adapter, wrapper, telemetry “just in case” |
| Heat shroud protecting messy exterior | Compat layer, facade, dual-write, feature-flag forever |
| Bolted flange | Indirection between packages that could be one module |
| Part that weighs something and can fail | Code path that must be tested, documented, and reasoned about |
| Spec that no longer matches the vehicle | Zombie feature, stale OPP, eval locking superseded UX |

Prefer: fewer modules, fewer config knobs, fewer migration/compat branches,
one clear data path. Accept putting ~10% back after a delete overshoots.

## Validate — did Raptor work as intended?

A Raptor pass **succeeded** only if capability held (or improved) while
complexity fell—and the cut was *reversible until proven*.

**Do not claim success from reasoning alone.** After implement, **run** the
proofs that the goal still holds without the deleted parts.

### What to run (pick all that apply — skip only if the project truly has none)

| Surface under change | Required evidence |
|----------------------|-------------------|
| Ordinary code / API / UI | Scoped **tests** green for the touched paths; broaden if blast radius is wide |
| Agent / prompt / plan→apply / tool behavior | **Evals** (or the repo’s agent harness) that lock the goal — not only unit tests |
| Product invariant with telemetry | Relevant **metrics / NRQL / smoke** if that is how the goal is watched in prod |
| Docs/skills-only change | No product tests required; still state how a human would detect a bad edit |

Use the project’s `/tests`, eval commands, and `/verify-this` when available.
**Naming** a check in the report is not enough — **execute** it and record the
result (pass/fail, command or task ids).

**Succeeded when all of these are true** (after implement; proposal mode only
forecasts them):

1. **Goal intact** — proofs above are green (demo, eval, test, or user path).
   If you deleted a *requirement*, the goal is the product-now JTBD — not “old
   eval still green.” Update or drop zombie evals deliberately; don’t fail the
   pass by silently keeping theater.
2. **Complexity actually down** — fewer modules/paths/flags/steps; not a rewrite that
   relocated the same Christmas tree.
3. **Application LOC down** — net lines of **application** code fell while addressing
   the issue. Measure with `git diff --stat` (or equivalent) on **product paths only**.
   **Exclude** test and eval code entirely—those may grow to lock simpler behavior.
   Exclude docs/skills unless they *are* the product under change. Move/rename
   theater that holds LOC flat does not count as a win.
4. **Lessons preserved** — every deleted artifact has an explicit “why it existed”
   note; hard-won constraints remain as simpler enforcement (test, type, invariant).
5. **Add-back budget used honestly** — something came back, or a written reason why
   zero add-backs is still aggressive enough *and* validated. Net app LOC should
   still be down after add-backs.
6. **Blast radius bounded** — scoped diff; rollback known (revert commit, flag, restore).

**Failed (stop / restore / keep cutting) when any of these appear:**

- Goal regressions (“simpler” but the job no longer works)
- Application LOC rose (or flat via move/rename theater) while claiming a Raptor win
- Half-Raptor: new path added, old scaffolding retained without a named residual defer
- Clever redesign of a zombie requirement without challenging whether it should exist
- Deleted safety, auth, or integrity with no replacement constraint
- New abstraction layer claimed as simplification
- Proofs not run, or only unit tests when evals exist for the changed agent surface
- No way to tell if the delete was wrong (no test, no eval, no metric, no owner watching)
- User expected a proposal and got a destructive rewrite

**Minimum evidence before calling it done:**

- Named success checks **executed** green (tests **and** evals when applicable;
  otherwise the strongest project-equivalent proof)
- Application LOC delta on product paths only (exclude `*.test.*`, `*.spec.*`,
  eval harness/tasks, test fixtures)
- Short “what died / why it existed / what we learned / what we added back” summary
- Explicit residual risks (what we might still need to restore) — residuals are
  **incomplete work**, not proof the pass succeeded

Prefer `/verify-this` when the claim is falsifiable (“X still works without Y”).

## Output format

```text
Mode: PROPOSAL | IMPLEMENT

Goal (first principles, product now): …
Requirement archaeology:
  - item: …
    why introduced (backlog/git/eval): …
    class: load-bearing now | lesson-only | zombie | unknown
    disposition: keep constraint | delete artifact | delete requirement | ask
Requirements challenged: …
Deletes (requirements/features AND parts/processes/paths): …
  - item: …
    lesson kept: …
    rollback: …
    validate by: …
    gate: proceed | ask (why)
What we learn from the old design (keep the lesson, not the artifact): …
What remains (minimal): …
Half-Raptor check: finished cluster? | still on the tree: …
Application LOC delta (exclude tests/evals; after implement): … → … (net …)
Proofs run (commands / eval task ids + pass|fail): …
Risks / what we might add back (~10%): …
Success criteria (falsifiable): …
Not doing yet (optimize / speed / automate): …
Hard stops respected: auth/integrity/trust/tests/rollback …
```

Be concrete. Name files, APIs, tables, steps. Vague “simplify the architecture”
is failure. If Mode is PROPOSAL, end after the report (unless the user flips to
implement). Surface any `gate: ask` items before cutting them.
After IMPLEMENT, refuse to call the pass done if app LOC did not fall **or**
required proofs were not run green.

## Guardrails

- Be thoughtful about **when to ask “are you sure?”**—not never, not always.
- **Question the requirement** before polishing its implementation; archaeology
  before loyalty to backlog.
- **Resist timid half-cuts**; finish the delete cluster or mark the pass incomplete.
- Proposal → report; Implement → cut only what’s in scope (ask on real deep tradeoffs).
- Preserve the real goal; keep hard-won constraints, delete scaffolding.
- Surgical removal over rewrite theater; no unrelated refactors in the same change.
- Never skip hard stops (auth/integrity/trust) or validation (tests + evals when
  applicable; app LOC ↓).
- One delete cluster per pass; if validation fails, **add back or revert**.
- `/interview` only when a pause opens real product-scope forks.

## Provenance (short)

Inspired by SpaceX Raptor 1→2→3 simplification and Musk’s five-step engineering
Algorithm (Everyday Astronaut Starbase tour 2021; restated Lex Fridman #438).
Canonical slogans: “question the requirements, delete the part,” “the best part
is no part,” “the most common error of a smart engineer is to optimize the thing
that should not exist.” Historical detail: [reference.md](reference.md).
