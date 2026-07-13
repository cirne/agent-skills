---
name: raptor
description: >-
  Simplify designs the Raptor way—first principles, aggressive deletion, and
  learning from past decisions instead of protecting them. Use when the user
  invokes /raptor, asks to simplify architecture or a design like Raptor 3,
  strip accidental complexity, challenge inherited requirements, or apply
  SpaceX-style delete-before-optimize thinking.
---

# Raptor

Most systems accrue complexity (v2 adds sensors, flags, adapters, “just in case”).
**Raptor inverted that:** Raptor 3 is more powerful and lighter than Raptor 1/2
because plumbing, sensors, and heat-shroud kit were deleted or internalized—not
bolted on. Apply the same discipline to software, APIs, processes, and product scope.

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
- Design review where complexity is growing faster than capability
- Before a big rewrite *or* a big feature add (challenge whether either is needed)
- After shipping v1/v2, when deciding what the next generation should *drop*

**Not a substitute for** `/deslop` (local AI-slop cleanup), `/fix` (bug fix),
or `/global-code-review` (manageability ranking). Raptor is the *deletion /
first-principles* lens on a concrete design or change set.

## Workflow

```
- [ ] 1. State the real goal in one sentence (user/outcome, not implementation)
- [ ] 2. List every requirement, dependency, and “must keep” — name an owner for each
- [ ] 3. Mark candidates to delete (parts, layers, flags, compat shims, processes)
- [ ] 4. Propose the minimal design that still hits the goal
- [ ] 5. Only then: simplify what remains; speed; automation
- [ ] 6. Summarize: what died, what was learned from the old design, what risk remains
```

### Questions to force deletion

- If we shipped greenfield tomorrow, would we invent this?
- What exists only because of a past decision we no longer need?
- Are we optimizing a path that should not exist?
- Can two components become one—or zero?
- What would we have to add back if we deleted this? (If nothing concrete → delete.)

### Software translation (examples)

| Hardware instinct | Software analogue |
|-------------------|-------------------|
| External pipe / sensor | Optional flag, adapter, wrapper, telemetry “just in case” |
| Heat shroud protecting messy exterior | Compat layer, facade, dual-write, feature-flag forever |
| Bolted flange | Indirection between packages that could be one module |
| Part that weighs something and can fail | Code path that must be tested, documented, and reasoned about |

Prefer: fewer modules, fewer config knobs, fewer migration/compat branches,
one clear data path. Accept putting ~10% back after a delete overshoots.

## Output format

```text
Goal (first principles): …
Requirements challenged: …
Deletes (parts/processes/paths): …
What we learn from the old design (keep the lesson, not the artifact): …
What remains (minimal): …
Risks / what we might add back (~10%): …
Not doing yet (optimize / speed / automate): …
```

Be concrete. Name files, APIs, tables, steps. Vague “simplify the architecture”
is failure.

## Guardrails

- Deletion must preserve the real goal—not delete the product.
- Prefer surgical removal over a glamorous rewrite unless the rewrite *is* the deletion.
- Do not bypass safety, auth, or tests to “simplify”; delete *needless* ceremony,
  not load-bearing checks.
- When past decisions encoded hard-won constraints (law of physics, user trust,
  data integrity), keep the constraint—delete the scaffolding around it.
- If the user asked only for analysis, stop at the report; do not rewrite the tree
  until they say to implement.

## Provenance (short)

Inspired by SpaceX Raptor 1→2→3 simplification and Musk’s five-step engineering
Algorithm (Everyday Astronaut Starbase tour 2021; restated Lex Fridman #438).
Canonical slogans: “question the requirements, delete the part,” “the best part
is no part,” “the most common error of a smart engineer is to optimize the thing
that should not exist.” Historical detail: [reference.md](reference.md).
