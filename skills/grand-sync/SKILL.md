---
name: grand-sync
description: >-
  Syncs every git repo under ~/dev for the current calendar year: skip quiet
  repos, fetch/pull, triage local stale changes (merge if relevant, ditch if
  obsolete), then push. Use when the user invokes /grand-sync or asks to sync
  all repos under ~/dev.
---

# Grand sync (`~/dev`)

Bring every **git repo** under `~/dev` up to date with origin, triage leftover local work, push, and report.

## Preflight (mandatory)

```sh
test -d "$HOME/dev"
```

If `~/dev` is **missing** (cloud VM, fresh sandbox, wrong machine): **stop immediately**. Tell the user grand-sync is local-only and requires `~/dev`. Do not invent another root, do not clone into a substitute path, do not continue.

Also skip non-directories and folders without `.git` (report as `not a git repo`).

## Per-repo loop

For each `~/dev/*/` that is a git repo:

### 1. Skip if no activity this calendar year

After `git fetch --all --prune`:

```sh
git -C "$repo" log --all --since="$(date +%Y)-01-01" --until="$(( $(date +%Y) + 1 ))-01-01" -1 --format='%h'
```

Empty → **skip** (`no YYYY commits`). Use the machine’s current calendar year.

### 2. Triage local dirty state

Inspect `git status --porcelain`, staged vs unstaged, and (when useful) file mtimes / diffs vs `origin/<branch>`.

| Situation | Action |
|-----------|--------|
| Clean | Continue to sync |
| Local changes already present on origin (same paths/content landed upstream) | **Ditch** (`git reset --hard` / `git checkout --` / `git clean` as needed) |
| Cosmetic / formatting-only / clearly obsolete vs upstream | **Ditch** |
| Small, non-conflicting, still relevant (active WIP the user would want) | **Keep**: stash or commit only if needed to pull; prefer stash → pull → stash pop; merge/resolve only when pop conflicts and the work is still relevant |
| Old WIP that conflicts with many upstream commits and is no longer relevant | **Ditch** |
| Dirty **submodule** pointer with no intentional submodule work | Note in summary; do not recursively grand-sync unless asked |

Do **not** commit as part of grand-sync unless the user explicitly asked to preserve WIP via commit.

### 3. Sync current branch

Prefer fast-forward only:

```sh
git -C "$repo" pull --ff-only
```

If no upstream is set, note `no upstream` and skip pull/push for that repo (still include in summary).

If FF pull fails because of kept local work, resolve per the triage table (stash/pop or ask only when judgment is ambiguous and destructive).

### 4. Push

```sh
git -C "$repo" push
```

Stay on the **current** branch (including feature branches). Do not force-push. Do not switch every repo to `main`.

If push fails (hooks, auth, missing `npm` in PATH, etc.): record failure and continue to the next repo — do not halt the whole grand-sync.

### 5. Shell pitfalls

- In **zsh**, avoid assigning to `status` (read-only). Use names like `sb` / `repo_status`.
- Batch fetches; do not block the whole run on one slow remote forever — fail that repo and continue.

## Summary (required)

End with a compact table/list:

```text
## Grand sync — <YYYY-MM-DD>

Preflight: ~/dev OK

| Repo | Result | Notes |
|------|--------|-------|
| foo | pulled abc→def · pushed | |
| bar | skipped | no 2026 commits |
| baz | ditched stale · pulled · push failed | pre-push hook: npm missing |
| qux | not a git repo | |

### Stale local decisions
- marshall: ditched staged docs already on origin
- …

### Needs attention
- … (or none)
```

Include: skipped, pulled, already current, ditched vs kept locals, push failures, non-git dirs.