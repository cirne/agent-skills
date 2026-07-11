---
name: verify-this
description: Verify a falsifiable claim with baseline vs treatment evidence and return VERIFIED, NOT VERIFIED, or INCONCLUSIVE. Use when the user asks to verify, prove, or show evidence; after a bug fix; for deploy/staging checks; or when tests pass but user-visible behavior is in doubt.
---

# Verify this

Verification is not a recap. It **proves or disproves** a specific claim with repeatable evidence.

Do **not** use for vague claims (“the code is cleaner”). Restate as a measurable claim first.

## When to use

- User says “verify this”, “prove it works”, “did this fix it”, “show me the evidence”
- After `/fix` or `/implement` when proving the ship bar
- Deploy/staging behavior after merge
- Performance, UI, API, or agent-behavior claims that need before/after proof

## Workflow

1. **Restate the claim** in falsifiable form: condition, metric, threshold
2. Pick the **smallest local surface** that can disprove it
3. Capture **baseline** (old/broken): merge base, parent commit, failing test/eval, or repro steps
4. Capture **treatment** (new/fixed) with the **same** command, data, warmup, and environment
5. Compare raw artifacts: test output, eval report, terminal transcript, HTTP response, metrics, screenshot
6. Return exactly one verdict: **`VERIFIED`**, **`NOT VERIFIED`**, or **`INCONCLUSIVE`**

## Discover repo surfaces

Find how this repo proves claims (do not invent):

| Claim type | Typical evidence |
|------------|------------------|
| Unit/integration | Failing then green test command from project docs |
| Type/lint | Same gate exit 0 |
| UI | Component test or documented manual repro |
| Agent behavior | Eval harness / fixture if present |
| Staging/prod | Observability queries the project already uses |

Follow `/tests` (or project test docs) for how to run and log commands.

## Artifact layout (optional)

When safe (no secrets / tenant PII):

```text
/tmp/verify-this/<claim-slug>/
├── claim.md
├── baseline/
├── treatment/
└── verdict.md
```

Prefer **inline evidence** in the reply when disk storage is risky.

## Verdict rules

- **`VERIFIED`**: baseline and treatment differ in the predicted direction, meeting the threshold, with no obvious confound
- **`NOT VERIFIED`**: unchanged, wrong direction, or misses threshold — **do not soften**
- **`INCONCLUSIVE`**: no valid baseline, noisy signal, failed measurement, or environment confound

## Output shape

```text
VERIFIED | NOT VERIFIED | INCONCLUSIVE
Claim: <falsifiable claim>

Evidence:
<metric/artifact>: baseline=<...>, treatment=<...>, delta=<...>, threshold=<...>

Reasoning:
<one paragraph naming evidence and any confounds>
```
