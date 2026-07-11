---
name: pr
description: Lists, reviews, and merges GitHub pull requests (maintainer workflow). Fast-track docs/test-only PRs skip heavy gates; code PRs run full local gates. Use when the user invokes /pr, /pr list, /pr review, or /pr approve.
---

# Pull request workflow

**Requires:** `gh` authenticated for the repo.

Discover repo conventions first: default branch, whether CI runs on PRs or only post-merge, merge permissions, and any semantic-collision checks (ticket ids, migrations).

## Subcommands

| Invoke | Action |
|--------|--------|
| `/pr list` | Open PRs targeting the default branch |
| `/pr review <n>` | Checkout, sync, run review gates, verdict — **do not merge** |
| `/pr review <n> --fast` | Require fast-track classification |
| `/pr review <n> --docs` | Require docs-only |
| `/pr review <n> --full` | Force full code gates |
| `/pr approve <n>` | Merge after a clean review (user must explicitly approve) |

## `/pr list`

```sh
gh pr list --base <default-branch> --state open
```

Summarize number, title, author, branch, updated. Optional: tag **fast** vs **code** from changed paths.

## `/pr review <n>`

### 0. Load

```sh
gh pr view <n> --json number,title,author,headRefName,baseRefName,url,mergeable,mergeStateStatus
gh pr checkout <n>
```

### 1. Sync with default branch

Prefer `gh pr update-branch <n> --rebase`; else rebase/merge `origin/<default-branch>` and push. Resolve conflicts when straightforward.

### 1b. Semantic collisions (if the repo uses them)

After sync, check for non-git collisions the project cares about (duplicate ticket ids, migration version overlaps). Fail review until resolved. Skip when the diff has no relevant paths. Prefer project-local `/pr.local` or backlog docs for exact commands.

### 2. Diff + classify

```sh
git diff origin/<default-branch>...HEAD --name-only
```

**Fast track** when every path is docs and/or tests only (discover allowlists from project `/pr.local` or contributing docs). Otherwise **code full**.

### 3. Self-review

- **Critical** → FAIL
- **Warning** → FAIL unless explicitly accepted
- **Note** → non-blocking

Fast track: light docs/test hygiene only — no full test suite unless the project requires it.

### 4–7. Code PRs only

Run project gates (scoped + full tests per `/tests`, lint/typecheck, UI/i18n/copy if UI touched, optional `/deslop`). Follow AGENTS.md / `/commit` for the smallest typed gate.

### 8. Verdict

```text
PR #<n>: <title>
Track: fast | code
Sync: <ok | updated | blocked>
Semantic collisions: <none | resolved | FAIL>
Verdict: PASS | FAIL | PASS WITH WARNINGS
```

## `/pr approve <n>`

Only when review **PASS** (or accepted warnings) and the user explicitly asks to approve/merge.

```sh
gh pr merge <n> --merge --delete-branch
# --admin only when branch policy blocks solely due to missing PR CI and local gates passed
```

Then update local default branch with ff-only pull. Never force-push the default branch.

## Related

- `/commit` · `/deslop` · `/tests` · `/backlog` · `/copy`
