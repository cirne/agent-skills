---
name: soak
description: >-
  Validates open bugs/backlog items waiting on production soak—find candidates
  that need prod validation, inspect New Relic telemetry anchored to deployment
  time, and assess progress vs stated goals/completion criteria. Use when the
  user invokes /soak, asks to check NR/prod soak gates, or a morning/maintainer
  routine needs a soak pass.
---

# Soak

Check whether shipped work that is **waiting on production soak** is progressing toward its stated goals / completion criteria. This is not a full `/verify-this` proof and not a `/backlog` archive pass — it is a **telemetry-backed progress check**.

## When to use

- User invokes `/soak`
- Maintainer routines (e.g. `/good-morning`) that include a soak step
- “How is the NR soak looking?”, “can we clear soak on X?”, prod validation after deploy

## 1. Discover candidates (mandatory)

**Do not assume** a working-set file like `focus.md`. Find soak items from the open backlog:

1. Discover tracker layout via `/backlog` conventions: read **`docs/README.md`** (then `AGENTS.md` / `CLAUDE.md`) for indexes and spec dirs.
2. Search **open** (non-archived) bugs / opportunities / backlog items for production-validation language, e.g. **soak**, **NR soak**, **production validation**, “keep … until …”, “close after …”, “hide X when gates pass”, post-deploy validation sections.
3. Prefer items whose Status implies shipped-but-not-closed (partial, slice N open, soak open, waiting on prod). Skip pure design / unshipped work unless the spec explicitly says a soak gate is active.
4. For each candidate, extract **stated goals / completion criteria** from the spec (acceptance, close gates, telemetry targets, success metrics).

**No soak candidates** → report “none” and stop.

## 2. Anchor to deployment

Before judging metrics, establish **when the relevant change landed in the environment under test** (usually production):

1. Prefer **New Relic deployment markers** for the target app/entity (project NR docs for entity GUIDs / helper commands).
2. Fall back to deploy tags, release notes, merge time of the shipping PR, or timestamps called out in the spec.
3. Note soak age: time since that deploy (or since the fix under test). If the change is **too fresh** for the gate’s window (e.g. gate wants ≥24h and deploy was 2h ago), say so — do not treat short windows as decisive.

Use deploy time to choose comparison windows (post-deploy vs pre-deploy, or successive post-deploy days), not a blind calendar day-over-day when a recent ship dominates the signal.

## 3. Inspect New Relic

For each candidate:

1. Prefer **recipes in the spec** and the project’s New Relic skill/docs over inventing NRQL.
2. Query the metrics named by the completion criteria (error rates, custom events, latency, cost, coverage gaps, etc.).
3. Compare **post-deploy** (or last full gate window) against **pre-deploy baseline** and/or the **prior equivalent window**, as the gate implies.
4. When the spec names dogfood tenants / cohorts, check those **and** fleet aggregates — call out splits.
5. Watch for confounds: deploys mid-window, traffic shifts, incomplete markers, missing events after a schema change.

## 4. Assess vs stated criteria

Score each item against **the spec’s own gates**, not a generic “looks healthier”:

| Verdict | Meaning |
|---------|---------|
| **on track** | Moving toward the stated threshold; soak age adequate or improving as expected |
| **met** | Criteria clearly satisfied for the required soak window — ask before close/archive |
| **flat** | No meaningful movement vs baseline / prior window |
| **regressed** | Worse vs baseline or missing the gate direction |
| **too early** | Deploy/soak age insufficient for a decisive read |
| **blocked** | Cannot measure (missing telemetry, wrong env, recipe broken) |

**Do not close or archive** unless criteria are **met** and the user agrees — hand off to `/backlog` for archive. Optional: append a short dated soak note to the spec when the delta is worth keeping.

## Output shape

```text
## Soak — <YYYY-MM-DD>

Deploy anchor: <marker/version/time or unknown> · Env: <prod|staging|…>

- <ID>: <criteria one-liner> → <on track|met|flat|regressed|too early|blocked>
  metrics: <key numbers post vs pre / prior>; soak age <duration>; <note>
- (or none)

### Next
- <clear soak / keep watching / escalate / fix telemetry — or none>
```

When invoked from another skill (e.g. `/good-morning`), return the same bullets for that skill’s report section; do not duplicate a full morning report.

## Flags

| Flag | Effect |
|------|--------|
| `--dry-run` | Read-only: query + report; no spec edits |
| `<ID>` | Limit to one backlog id when the repo uses ids |
| `--env <name>` | Override default environment (project NR docs define names) |

## Related

- `/verify-this` — falsifiable VERIFIED / NOT VERIFIED proof (stricter than soak progress)
- `/backlog` — discover tracker layout; archive after soak criteria are met and the user agrees
- Project New Relic skill/docs (when present) — commands, entity names, NRQL recipes
