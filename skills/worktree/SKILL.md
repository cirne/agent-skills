---
name: worktree
description: Create and run parallel git worktrees with shared mutable state via symlink when needed, and one editor window per checkout. Use when the user invokes /worktree, asks to add a worktree, or run parallel features.
---

# Worktree

Run **multiple branches in parallel** in separate directories.

## Discover repo conventions

1. Primary clone path and naming (`../<repo>-wt-<name>` is a common pattern)
2. Bootstrap script if present (e.g. `scripts/worktree-bootstrap.mjs`)
3. What should be **shared via symlink** vs copied (`.env`, local data dirs, large caches)
4. Dev server port strategy for parallel trees
5. How `/commit` lands work (local main vs PR)

## Quick: add a worktree

From the **primary** clone (adapt names/scripts to the repo):

```sh
git fetch origin
git worktree add ../<repo>-wt-NAME -b feat/NAME origin/<default-branch>
# run project bootstrap if it exists (symlinks shared state, install deps)
cd ../<repo>-wt-NAME
# start the project’s usual dev command
```

**Shared state:** prefer **symlinks** to the primary for `.env` and heavy local data — **never copy** unless the user asks for isolation.

**Isolated data:** only when the user wants destructive/schema experiments — skip the data symlink.

## Editor + agents

- **One window per worktree**
- **One agent thread per feature branch** until merge
- Run runtime/git commands from `git rev-parse --show-toplevel`

## Finish

1. `/commit` on the feature branch (project rules)
2. Land per project convention (local merge to default branch, or open a PR)
3. `git worktree remove <path>` then delete the local feature branch
4. Do **not** `rm -rf` without `git worktree remove`

## Housekeeping

```sh
git worktree list
```

Git refuses two worktrees on the **same branch** — use different branch names.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Port in use | Different port in env for the second checkout |
| Shared data wiped | Wipe only from the **primary** when data is symlinked |
| Same branch twice | Rename branch or remove the other worktree |
