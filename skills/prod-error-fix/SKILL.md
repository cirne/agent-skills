---
name: prod-error-fix
description: >-
  Triage New Relic errors in production or staging, pick the single highest-priority real failure,
  and fix it via /fix. Filters expected auth, not-found, validation, and abort errors.
  Use when the user asks to check prod/staging errors, fix a production error, triage NR APM,
  or invokes /prod-error-fix. Apply a repo prod-error-fix.local overlay when present.
---

# Prod error fix (single highest-priority)

Find real production or staging failures in New Relic, pick **one** that most needs repair, then hand off to **`/fix`**. Do **not** commit unless the user asks.

Follow this skill first. Then read project New Relic config in this order; later sources override earlier ones on the same field:

1. **Project `/newrelic`** — first file that exists:
   - `.cursor/skills/newrelic/SKILL.md` or `.claude/skills/newrelic/SKILL.md`
   - else `.cursor/commands/newrelic.md` or `.claude/commands/newrelic.md`
   - else `.cursor/rules/newrelic.mdc`
   This is the source for account id, app or entity names, the NRQL command, and where stacks live. A command or rule counts; do not require the folder to be named `skills/`.
2. **`prod-error-fix.local`** — `.cursor/skills/prod-error-fix.local/SKILL.md`. Extra skips, diagnosis, and backlog. It may also override New Relic fields when `/newrelic` is silent or wrong for error triage.
3. **Defaults** below, only for fields neither file sets.

Do not invent another repo’s app names. If none of those files exist, use defaults and say so.

**Default user intent** (use verbatim when no window is given):

> check New Relic for errors in prod or staging from the last 4 days. if you find any, pick the one that most needs repair and /fix it. ignore spurious or expected errors such as legitimate authentication errors.

Default time window: **`SINCE 4 days ago`**.

## Defaults (project `/newrelic` or the overlay may replace any row)

Take these from the project `/newrelic` instructions when they state them: account id, which apps are in scope for errors (production, then staging, including a browser app when one is named), the exact NRQL invocation, and the log or error attribute that holds a stack. Ignore unrelated telemetry (page-view counts, custom events, cost). Browser **errors** are in scope.

| Setting | Default |
|---------|---------|
| Account id | `NEW_RELIC_ACCOUNT_ID` from the environment or repo `.env`. If unset, omit `--accountId` and let the CLI profile choose. |
| Credentials | `NEW_RELIC_API_KEY` (`NRAK-…`) in repo `.env` or the environment. A license key is not a query key. Source `.env` once if the shell has not: `set -a && [ -f .env ] && . ./.env && set +a`. Ask for a key only after a query fails. |
| App names | Do not hardcode. After the first successful query, `SELECT uniques(appName) FROM Transaction SINCE 4 days ago LIMIT 30` and prefer names containing `Production` or `Prod`, then `Staging`. |
| NRQL command | First match: (1) overlay command, (2) `pnpm run newrelic:nrql -- "<NRQL>"` when `package.json` defines `newrelic:nrql`, (3) `newrelic nrql query --accountId "$NEW_RELIC_ACCOUNT_ID" "<NRQL>"` when the CLI exists (drop `--accountId` if the id is unset). |
| Stack traces | `Log.error.stack` (or `error.stack` on `Log`). `TransactionError.stackTrace` is null for the Node agent. |
| Fix | Shared **`/fix`**, then the repo’s **`/fix.local`** if it exists. |
| Verify | Shared **`/verify-this`**. |
| Backlog | Discover the repo’s tracker the way **`/backlog`** does (`docs/README.md`, `AGENTS.md`, GitHub issues, or whatever that repo already uses). Do not assume a markdown bug list. |

## Step 1 — Triage

Run these in parallel with the resolved NRQL command. Substitute the overlay’s `appName` list when it has one; otherwise drop the `appName IN (…)` clause on the first pass and add it after discovery.

```bash
# Backend exceptions — exclude synthetic HTTP status rows
<nrql> "SELECT count(*) FROM TransactionError WHERE error.message NOT LIKE 'HttpError%' AND error.class NOT IN ('AbortError') SINCE 4 days ago FACET error.message, appName LIMIT 30"

# Browser exceptions (same window). Use the browser appName from /newrelic when it names one.
<nrql> "SELECT count(*) FROM JavaScriptError SINCE 4 days ago FACET errorMessage, appName LIMIT 30"

# Top URIs for the leading real error (swap the message filter after the first pass)
<nrql> "SELECT count(*) FROM TransactionError WHERE error.message LIKE '%YOUR_ERROR%' SINCE 4 days ago FACET request.uri, appName LIMIT 20"

# Stack traces
<nrql> "SELECT timestamp, message, error.message, error.stack FROM Log WHERE error.stack IS NOT NULL AND error.message NOT LIKE 'HttpError%' SINCE 4 days ago LIMIT 5"
```

Add `appName IN (…)` or `entity.name IN (…)` once names are known.

### Skip (expected / spurious)

| Pattern | Why skip |
|---------|----------|
| `HttpError 401`, `403` | Legit auth |
| `HttpError 404` | Missing resource, probes, or stale links |
| `HttpError 400` | Client validation |
| `AbortError`, `The operation was aborted` | Client disconnect / timeout |

The overlay may add more skips. Do **not** skip a class without evidence. If volume is high and a user route is affected, investigate.

## Step 2 — Pick one new error

**Skip anything already in the backlog.** Before ranking, discover how this repo tracks work (shared **`/backlog`**: `docs/README.md`, `AGENTS.md`, then an existing tracker such as GitHub issues). Search that tracker for each candidate’s error message, class, and URI. If an item already covers it — open or closed — drop that candidate. Do not re-pick the same failure every session. Only stay on an existing item when the user names that id.

Rank what remains by **user impact**:

1. **Users hit it** — a page, a browser error, or an API the UI calls — over background jobs
2. **Production** over staging when prod is in scope
3. **Higher count** in the window (same root cause)
4. **Uncaught / 500** over handled warnings
5. **Known systemic class** named in the overlay — one fix may help many call sites; note siblings, do not fix them in this session

Pick **exactly one** that is not already tracked. Mention runners-up briefly, including any skipped because they are already filed. If every real error is already in the backlog, say so and stop. Do not file a duplicate or start a second fix.

## Step 3 — Diagnose

Use the stack and URI. If the overlay has a diagnosis table, use it. Otherwise name the failing function and the input that produced the error, then hand off to **`/fix`**.

## Step 4 — Fix

Follow **`/fix`** (and **`/fix.local`** when present):

1. **TDD** — failing test (or eval if agent-shaped) that reproduces the failure mode
2. **Minimal fix** — match local patterns
3. **Verify** — **`/verify-this`** → `VERIFIED` / `NOT VERIFIED` / `INCONCLUSIVE` with evidence
4. **Commit** — only when the user asks, via **`/commit`**

## Step 5 — Report

```markdown
## NR triage (last N days)
| Error | Count | App | URI | Skip? |
...

## Chosen error
[message, why highest priority]

## Root cause
[1–2 sentences]

## Fix
[files / pattern]

## Verification
VERIFIED | NOT VERIFIED | INCONCLUSIVE — [evidence]

## Not fixed (same class)
[sibling call sites left alone]
```

## Step 6 — Backlog (after VERIFIED)

Record the fix in **this repo’s** tracker, using the same discovery as Step 2 (shared **`/backlog`**). That might be GitHub issues, an in-repo bug index, or something else. Do not invent a second system. Experimental, reverted, or **`INCONCLUSIVE`** fixes stay in the report only.

## Related

- Repo **`prod-error-fix.local`** when present
- Shared **`/fix`** · **`/verify-this`** · **`/backlog`** · **`/commit`**
