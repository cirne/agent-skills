---
name: grand-sync
description: >-
  Syncs every git repo under ~/dev plus the shared skills repo ~/.agents:
  skip quiet repos, fetch/pull, merge latest default branch into the current
  branch, triage local stale changes, then push. Use when the user invokes
  /grand-sync or asks to sync all repos under ~/dev.
---

# Grand sync (`~/dev` + shared skills)

Bring every **git repo** under `~/dev`, and the **shared skills repo** at `~/.agents`, up to date with origin — including the latest default branch on whatever branch is checked out — triage leftover local work, push, and report.

## Preflight (mandatory)

```sh
test -d "$HOME/dev"
```

If `~/dev` is **missing** (cloud VM, fresh sandbox, wrong machine): **stop immediately**. Tell the user grand-sync is local-only and requires `~/dev`. Do not invent another root, do not clone into a substitute path, do not continue.

Also skip non-directories and folders without `.git` (report as `not a git repo`).

## Repo set

1. Each `~/dev/*/` that is a git repo.
2. **`$HOME/.agents`** when it is a git repo (Cursor/Claude shared skills: `/grand-sync`, `/commit`, and the rest). It is **not** under `~/dev`. Always include it. If `~/.agents` is missing or not a git repo, note that and continue with `~/dev`.

Run the same per-repo loop on both. Do not treat `~/.agents` as optional just because the year-activity check would skip a quiet product repo.

## Per-repo loop

### 1. Skip if no activity this calendar year

After `git fetch --all --prune`:

```sh
git -C "$repo" log --all --since="$(date +%Y)-01-01" --until="$(( $(date +%Y) + 1 ))-01-01" -1 --format='%h'
```

Empty → **skip** (`no YYYY commits`). Use the machine’s current calendar year.

**Exception:** never year-skip `~/.agents`.

### 2. Triage local dirty state

Inspect `git status --porcelain`, staged vs unstaged, and (when useful) file mtimes / diffs vs `origin/<branch>`.

| Situation | Action |
|-----------|--------|
| Clean | Continue to sync |
| Local changes already present on origin (same paths/content landed upstream) | **Ditch** (`git reset --hard` / `git checkout --` / `git clean` as needed) |
| Cosmetic / formatting-only / clearly obsolete vs upstream | **Ditch** |
| Small, non-conflicting, still relevant (active WIP the user would want) | **Keep**: stash or commit only if needed to pull or merge; prefer stash → pull/merge → stash pop; merge/resolve only when pop conflicts and the work is still relevant |
| Old WIP that conflicts with many upstream commits and is no longer relevant | **Ditch** |
| Dirty **submodule** pointer with no intentional submodule work | Note in summary; do not recursively grand-sync unless asked |

Do **not** commit as part of grand-sync unless the user explicitly asked to preserve WIP via commit. A merge of the default branch (below) is allowed; that is not a WIP commit.

### 3. Sync current branch with its upstream

Stay on the **current** branch (including feature branches). Do not force-push. Do not switch every repo to `main`.

Prefer fast-forward only:

```sh
git -C "$repo" pull --ff-only
```

If no upstream is set, note `no upstream` and skip the upstream pull and the final push (still merge the default branch when it exists, and still include the repo in the summary).

If FF pull fails because of kept local work, resolve per the triage table (stash/pop or ask only when judgment is ambiguous and destructive).

### 4. Merge latest default branch into the current branch

Grand-sync means **current with GitHub**, not only with this branch’s upstream. A feature branch that only fast-forwards its own remote can still be far behind `main`. After the upstream pull, bring the latest default branch **onto** the checked-out branch so local work shows whether it conflicts.

Default branch: `origin/HEAD` when set, otherwise `origin/main`, otherwise `origin/master`.

```sh
# example: on a feature branch
git -C "$repo" merge --no-edit origin/main
```

- Already on the default branch → this step is the upstream fast-forward already done. Do not merge a branch into itself.
- `HEAD` already contains the default-branch tip (`git merge-base --is-ancestor`) → note `default already contained` and skip the merge.
- Dirty tree that you are keeping → stash, merge, stash pop.
- Merge conflicts → `git merge --abort`, leave the branch as it was after the upstream pull, and record **needs attention** (which files conflicted if cheap to list). Do not leave a conflicted tree. Do not force the merge.
- Merge succeeds → the new merge commit is local until the push below. Report `merged origin/<default>`.

### 5. Push

```sh
git -C "$repo" push
```

If push fails (hooks, auth, missing `npm` in PATH, etc.): record failure and continue to the next repo — do not halt the whole grand-sync.

### 6. Shell pitfalls

- In **zsh**, avoid assigning to `status` (read-only). Use names like `sb` / `repo_status`.
- Batch fetches; do not block the whole run on one slow remote forever — fail that repo and continue.

## Summary (required)

End with a compact table/list:

```text
## Grand sync — <YYYY-MM-DD>

Preflight: ~/dev OK

| Repo | Result | Notes |
|------|--------|-------|
| foo | pulled abc→def · merged origin/main · pushed | |
| bar | skipped | no 2026 commits |
| baz | ditched stale · pulled · push failed | pre-push hook: npm missing |
| qux | not a git repo | |
| ~/.agents | pulled · pushed | shared skills |

### Stale local decisions
- marshall: ditched staged docs already on origin
- …

### Needs attention
- … (or none)
```

Include: skipped, pulled, already current, default-branch merges (including conflicts aborted), ditched vs kept locals, push failures, non-git dirs, and `~/.agents`.
