---
name: commit
description: Guides pre-commit self-review, optional deslop, scoped lint/typecheck/tests, commit locally, then land on the default branch; push to origin only on explicit request. Use when the user invokes /commit, asks to commit, land on main, push, or finish a change with git.
---

# Commit workflow

**Default path:** pre-commit gates → **commit locally** → land on local default branch when using feature worktrees → **push only on explicit request**.

Prioritize **correctness, security, and regressions** over style-only nits unless the user asked for polish.

## Discover repo conventions

Before running gates, learn this repo’s rules (do not invent):

1. Default branch name (`main` / `master`)
2. Agent conventions (`AGENTS.md`, `CLAUDE.md`, contributing docs)
3. Lint / typecheck / test scripts (`package.json`, Makefile, etc.)
4. Whether the workflow is **solo land-on-main** vs **PR-required**
5. Optional focus/WIP file (e.g. `focus.md`) — only touch if the project uses it (`docs/README.md` / `AGENTS.md`)
6. Project overlay **`/commit.local`** (or `.cursor/skills/commit.local/`) — when present, **its gate matrix and defaults replace discovery** for this repo

## 1. Self-review

```sh
git fetch origin <default-branch>
git diff origin/<default-branch>...HEAD
git status
```

Tier findings:

- **Critical** — fix before commit: bugs, secrets, auth/isolation, wrong behavior
- **Warning** — fix or accept explicitly: missing regression test, risky migration, weak errors
- **Note** — nits; non-blocking unless polish was requested

Large diffs (**>15 files** or **>500 lines**): slice review by directory or parallel subagents.

## 2. Test expectations

- New/changed behavior → add or update tests
- Bug fixes → regression test (fail without fix)
- Docs/comment-only → skip tests unless documenting untested behavior

Optional: `/deslop` on agent-heavy branches before gates.

## 3. Pre-commit gate

Use the **smallest** commands that cover the diff (project scripts). Typical order:

1. Lint on changed paths
2. Typecheck appropriate to touched packages
3. Scoped tests via `/tests` (log full output; never pipe)

All must exit **0** before commit. Full suite is post-commit / land / push — not every iteration.

## 4. Commit (local only)

1. Conventional Commits (`feat:`, `fix:`, …) unless the repo uses another style
2. No secrets or generated junk
3. **Do not push** unless the user explicitly asks

## 5. Land (solo / worktree workflows)

If the project uses feature worktrees and lands locally (see `/worktree`):

- From the primary clone: merge feature branch into local default branch
- Remove the worktree with `git worktree remove` (not `rm -rf`)
- Still **no push** unless asked

If the project requires PRs, stop after push-ready branch and point the user at `/pr` (or their PR flow).

## 6. Push (explicit request only)

When the user says “push” / “sync to origin”:

1. Run full CI / full suite if the project expects it before push
2. `git pull --ff-only` if needed
3. `git push` — never force-push the default branch without explicit ask

## Output

```text
Findings: <critical/warning/note counts, or "none">
Pre-commit: <commands + exit codes + log paths>
Commit: <hash + message>
Land: <done / skipped / blocked>
Push: <not requested | done | skipped>
```
