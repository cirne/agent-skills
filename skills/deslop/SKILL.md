---
name: deslop
description: Remove AI-generated code slop from the current branch diff without changing behavior. Use when the user invokes /deslop, asks to clean up agent-generated code, or before /commit on an agent-heavy branch.
---

# Deslop

Scan the branch diff against the default base branch (usually `origin/main`) and remove slop introduced on the branch. **Behavior must stay unchanged** unless fixing a clear bug found during review.

## When to run

- User asks to deslop, clean up, or de-AI the branch
- Before `/commit` on a mostly agent-authored branch
- Mid-session before a large review, when the diff feels noisy

**Skip** for docs-only edits, generated lockfiles, or when the user wants verbose comments preserved.

## Focus areas

Match repo conventions (AGENTS.md / CLAUDE.md / contributing docs if present):

- Comments that restate the obvious or clash with the file
- Defensive `try/catch` on trusted internal paths
- `as any` / casts used only to silence types — fix types when trivial
- Deep nesting better expressed with early returns
- One-off helpers that should stay inline
- Patterns inconsistent with the surrounding file (naming, imports, error handling)

## Workflow

1. `git fetch origin <default-branch>` (usually `main`)
2. Review `git diff origin/<default-branch>...HEAD` (+ unstaged if relevant)
3. Apply **minimal, focused** edits per file — no broad rewrites
4. Re-run the repo’s scoped checks for touched paths (see `/commit` or project docs)

## Guardrails

- Prioritize correctness over style — if unsure, leave it and note in the summary
- Do not bypass hooks or delete tests to “simplify”
- Final summary: **1–3 sentences** — what was removed and from which areas
