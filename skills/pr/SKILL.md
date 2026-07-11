---
name: pr
description: Lists, reviews, and merges GitHub pull requests (maintainer workflow). Fast-track docs/test-only PRs skip heavy gates; code PRs run full local gates. Use when the user invokes /pr, /pr list, /pr review, /pr approve, /pr sweep, or /pr fast-approve.
---

# Pull request workflow

**Requires:** `gh` authenticated for the repo.

Discover repo conventions first: default branch, whether CI runs on PRs or only post-merge, merge permissions, and any semantic-collision checks (ticket ids, migrations). Prefer project `/pr.local` or contributing docs for repo-specific fast-track allowlists and collision scripts.

## Subcommands

| Invoke | Action |
|--------|--------|
| `/pr list` | Open PRs targeting the default branch |
| `/pr review <n>` | Checkout, sync, run review gates, verdict — **do not merge** |
| `/pr review <n> --fast` | Require fast-track classification |
| `/pr review <n> --docs` | Require docs-only |
| `/pr review <n> --full` | Force full code gates |
| `/pr approve <n>` | Merge after a clean review (user must explicitly approve) |
| `/pr sweep` | Maintainer batch: serially fast-review + merge every docs/tests-only PR; skip code PRs — see [§ sweep](#pr-sweep) |
| `/pr fast-approve` | Alias for `/pr sweep` |

`<n>` may be `#52` or `52`. **`/pr review`** auto-selects **fast track** when every changed file matches the project allowlist; use **`--full`** to override.

**`/pr sweep`** (and **`/pr fast-approve`**) counts as explicit approval for every fast-track PR that passes review in the loop. Invoke it directly — do not merge code PRs in the same pass.

## `/pr list`

```sh
gh pr list --base <default-branch> --state open
```

Summarize number, title, author, branch, updated. Optional: tag **fast** (`docs` / `tests` / `docs+tests`) vs **code** from changed paths (`gh pr diff <n> --name-only`). When several PRs touch shared id namespaces or migrations, note **semantic-collision risk** — serial oldest-first + rebase mitigates most cases.

## `/pr review <n>`

### 0. Load

```sh
gh pr view <n> --json number,title,author,headRefName,baseRefName,url,mergeable,mergeStateStatus
gh pr checkout <n>
```

### 1. Sync with default branch

Prefer `gh pr update-branch <n> --rebase`; else rebase/merge `origin/<default-branch>` and push. Resolve conflicts when straightforward.

### 1b. Semantic collisions (if the repo uses them)

After sync, check for non-git collisions the project cares about (duplicate ticket ids, migration version overlaps). Fail review until resolved. Skip when the diff has no relevant paths. Prefer project `/pr.local` or backlog docs for exact commands.

### 2. Diff + classify

```sh
git diff origin/<default-branch>...HEAD --name-only
```

**Fast track** when every path is docs and/or tests only (discover allowlists from project `/pr.local` or contributing docs). Otherwise **code full**.

| Sub-tag | Condition |
|---------|-----------|
| `docs` | Every changed file is docs-only |
| `tests` | Every changed file is test-only |
| `docs+tests` | Mix of docs and test paths |

**`--fast`:** if not fast track → **FAIL** (list offending paths). **`--docs`:** if any non-doc path → **FAIL**.

### 3. Self-review

- **Critical** → FAIL
- **Warning** → FAIL unless explicitly accepted
- **Note** → non-blocking

Fast track: light docs/test hygiene only — no full test suite unless the project requires it.

### 4–7. Code PRs only

Run project gates (scoped + full tests per `/tests`, lint/typecheck, UI/i18n/copy if UI touched, optional `/deslop`). Follow AGENTS.md / `/commit` for the smallest typed gate.

Fast track: skip §4–§7 — record `Tests/Lint/UI/Deslop: skipped (fast track)`.

### 8. Verdict

```text
PR #<n>: <title>
Track: fast (docs | tests | docs+tests) | code
Sync: <ok | updated | blocked>
Semantic collisions: <none | resolved | FAIL>
Verdict: PASS | FAIL | PASS WITH WARNINGS
```

## `/pr approve <n>`

Only when review **PASS** (or accepted warnings) and the user explicitly asks to approve/merge — including via **`/pr sweep`** / **`/pr fast-approve`** for each PR in that batch.

```sh
gh pr view <n> --json mergeable,mergeStateStatus,headRefName
```

If not mergeable (conflicts) → **stop**. Mark draft PRs ready first (`gh pr ready <n>`).

```sh
gh pr merge <n> --merge --delete-branch
# --admin only when branch policy blocks solely due to missing PR CI and local gates passed
```

Then update local default branch:

```sh
git fetch origin
git checkout <default-branch>
git pull --ff-only origin <default-branch>
```

Never force-push the default branch.

## `/pr sweep`

**Aliases:** `/pr fast-approve`, `/pr fast approve`.

Maintainer routine: clear the fast-track queue in one pass. Lists all open PRs targeting `<default-branch>`, classifies each per §2, and for every **fast track** PR runs the accelerated path (§1 → §1b → §3 → §8) then [§ approve](#pr-approve-n) — **without** §4–§7.

**Code PRs** are **skipped** — listed in the closing summary for a later `/pr review <n> --full`.

### Flags

| Flag | Effect |
|------|--------|
| `--dry-run` | Classify and report what would merge; no checkout, no merge |
| `--oldest-first` | Default — ascending PR number (safer when several PRs share id namespaces) |
| `--newest-first` | Descending PR number |

### Serial only — never parallel

Each merge updates the default branch; the next PR must rebase on fresh `origin/<default-branch>` (especially for §1b semantic collisions). **Do not** check out or review multiple PRs in parallel.

Between **every** PR in the loop:

```sh
git fetch origin
git checkout <default-branch>
git pull --ff-only origin <default-branch>
```

### Workflow

#### 0. Start on default branch

```sh
git fetch origin
git checkout <default-branch>
git pull --ff-only origin <default-branch>
```

#### 1. List and classify (no checkout yet)

```sh
gh pr list --base <default-branch> --state open --json number,title,headRefName,author,createdAt,isDraft
```

Sort by PR number per flag (default **oldest-first**). For each PR, classify from the remote diff:

```sh
gh pr diff <n> --name-only
```

Tag each row **fast** (`docs` / `tests` / `docs+tests`) or **code**. Note semantic-collision risk when several fast-track PRs touch shared id or migration paths.

**`--dry-run`:** print the classified table and stop.

#### 2. Process fast-track PRs one at a time

For each PR classified **fast** (in sort order):

1. Run **`/pr review <n>`** on the fast track only — §0–§1b, §2 (confirm fast), §3, §8. Do **not** run §4–§7.
2. On **PASS** or **PASS WITH WARNINGS** (warnings documented): run [§ approve](#pr-approve-n) for that `<n>`.
3. Record: PR number, title, URL, `headRefName`, merge commit sha (if available), remote branch deleted (yes/no).
4. On **FAIL**: record failure reason; **continue** the loop.
5. **Always** end the iteration on fresh default branch before the next PR.

**Skip** PRs classified **code** without checkout.

#### 3. Closing summary (required)

After the loop, `git pull --ff-only origin <default-branch>` once more, then:

```sh
gh pr list --base <default-branch> --state open
```

Report in chat:

```text
## /pr sweep complete

### Merged (<count>)
| PR | Title | Branch | Merge commit | Branch deleted |
|----|-------|--------|--------------|----------------|
| #<n> | <title> | <headRefName> | <sha or n/a> | yes / no |

### Failed fast-track (<count>)
| PR | Title | Reason |
|----|-------|--------|
| #<n> | <title> | <§8 FAIL summary> |

(Omit sections when count is 0.)

### Skipped — code PRs (<count>)
| PR | Title | Branch | Track |
|----|-------|--------|-------|
| #<n> | <title> | <headRefName> | code (full review required) |

### Remaining open PRs (<count>)
| PR | Title | Author | Branch | Updated |
|----|-------|--------|--------|---------|
| … | … | … | … | … |

Local default branch: <ff-only ok | note>
```

If nothing was fast-track eligible: say so, still list **Remaining open PRs**.

### Typical invocations

```text
/pr sweep
/pr fast-approve
/pr sweep --dry-run
```

Pair with automation output (docs triage, coverage-gap agents) — run **`/pr sweep`** after those PRs land, not in parallel with other PR checkouts.

## Related

- `/commit` · `/deslop` · `/tests` · `/backlog` · `/copy` · project `/pr.local` when present
