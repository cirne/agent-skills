---
name: commit
description: >-
  Guides pre-commit self-review, optional deslop, scoped lint/typecheck/tests,
  commit, land, and sync with origin until the working tree is clean and the
  branch matches its remote. Use when the user invokes /commit, asks to commit,
  land on main, push, or finish a change with git.
---

# Commit workflow

**Done means:** working tree **clean** and the current branch **in sync with its remote** (not ahead, not behind). Do not stop after a local-only commit while `git status` still shows ahead/behind.

**Default path:** pre-commit gates → **commit** → land on local default branch when using feature worktrees → **push / sync to origin** → verify clean + synced.

Prioritize **correctness, security, and regressions** over style-only nits unless the user asked for polish.

## Discover repo conventions

Before running gates, learn this repo’s rules (do not invent):

1. Default branch name (`main` / `master`)
2. Agent conventions (`AGENTS.md`, `CLAUDE.md`, contributing docs)
3. Lint / typecheck / test scripts (`package.json`, Makefile, etc.)
4. Whether the workflow is **solo land-on-main** vs **PR-required**
5. Optional focus/WIP file (e.g. `focus.md`) — only touch if the project uses it (`docs/README.md` / `AGENTS.md`)
6. **Project overlay** — if either path exists, **read it and apply after this skill** (do not invent repo gates):
   - `.cursor/skills/commit.local/SKILL.md` (preferred)
   - `.agents/skills/commit.local/SKILL.md`
   Overlay owns repo-specific gate matrix, paths, and defaults. Shared `/commit` still owns the overall process (review → gates → commit → land → **sync**). Overlay wins on conflicts for gates/defaults only. Keep overlays thin (~one screen); push general prose back into this skill.

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

If a `commit.local` overlay defines extra judgment gates (docs freshness, i18n, etc.), run those here too.

All must exit **0** (or explicit accept for judgment warnings) before commit. Full suite is post-commit / land / push — not every iteration.

## 4. Commit

1. Conventional Commits (`feat:`, `fix:`, …) unless the repo uses another style
2. No secrets or generated junk
3. After commit, continue to land (if needed) and **§6 Sync** — local-only commit is not finished work

## 5. Land (solo / worktree workflows)

If the project uses feature worktrees and lands locally (see `/worktree`):

- From the primary clone: merge feature branch into local default branch
- Remove the worktree with `git worktree remove` (not `rm -rf`)
- Then **§6 Sync** the default branch (or the branch the overlay says to publish)

If the project requires PRs: push the feature branch (§6), open/update the PR if that is the repo’s handoff, and treat **done** as clean working tree + feature branch synced with its remote (PR merge is separate unless the user asked to merge).

## 6. Sync with remote (required to finish)

`/commit` is **not complete** until:

```sh
git status --porcelain   # empty
git status -sb           # no ahead/behind vs upstream
```

Typical sequence:

1. Run full CI / full suite **only if the project overlay expects it before push** — **skip** for docs-only / comment-only / skill-markdown changes (and whenever the overlay says skip)
2. `git fetch` + `git pull --ff-only` (or rebase if that is the repo norm) if remote moved
3. `git push -u` as needed so local and upstream match
4. Re-check status: clean and not ahead/behind

Never force-push the default branch without an explicit ask. Never force-push shared branches unless the user explicitly requests it.

If push is blocked (permissions, hooks, network), report the blocker and leave status honest — do not claim done.

## Output

```text
Findings: <critical/warning/note counts, or "none">
Pre-commit: <commands + exit codes + log paths>
Commit: <hash + message>
Land: <done / skipped / blocked>
Sync: <pushed / already synced / blocked — reason>
Status: <clean + in sync with origin/<branch> | not done — …>
```
