# Shared Agent Skills (`~/.agents`)

Canonical home for **personal / cross-tool** Agent Skills, following the [Agent Skills](https://agentskills.io/) open standard and the cross-client discovery path documented in the [client implementation guide](https://agentskills.io/client-implementation/adding-skills-support).

**Public repo:** [github.com/cirne/agent-skills](https://github.com/cirne/agent-skills) · MIT licensed.

## Quick start (new machine)

```bash
git clone https://github.com/cirne/agent-skills.git ~/.agents
~/.agents/setup.sh
```

If `~/.agents` already exists with skills, either move it aside or add this remote and pull.

## Layout

```text
~/.agents/
├── README.md              ← this file (agent + human reference)
├── setup.sh               ← create/repair per-skill symlinks; idempotent
├── hooks/post-merge       ← runs setup.sh after `git pull`
├── .gitignore
└── skills/                ← SOURCE OF TRUTH (real directories only)
    ├── interview/
    ├── pr/
    ├── commit/
    ├── deslop/
    ├── verify-this/
    ├── fix/
    ├── implement/
    ├── tests/
    ├── worktree/
    ├── backlog/
    ├── coverage/
    ├── global-code-review/
    └── copy/
```

Each skill is a folder named like its frontmatter `name`, containing at least `SKILL.md`.

**Do not** store real skill copies under `~/.cursor/skills/`, `~/.claude/skills/`, or `~/.codex/skills/`. Those directories should hold **per-skill symlinks** into `~/.agents/skills/<name>`.

## Keeping skills up to date (agents: read this)

This README is the **canonical ops doc** for personal shared skills. Product repos may link here from `AGENTS.md`; do **not** invent a project-local skill just to document this home.

| Task | Do |
|------|-----|
| **Edit a skill** | Change files only under `~/.agents/skills/<name>/` |
| **Propagate to Cursor/Claude/Codex** | `~/.agents/setup.sh` (idempotent; creates/repairs per-skill symlinks) |
| **Save history** | `cd ~/.agents && git add -A && git commit` |
| **Multi-machine** | `git push` / on other machine `git pull` (post-merge hook runs `setup.sh`) |
| **New machine** | `git clone <remote> ~/.agents && ~/.agents/setup.sh` |
| **Project-specific overlay** | Keep as `<repo>/.cursor/skills/<name>.local/` until the shared skill is confirmed; then delete `.local` |

**Overlay pattern (product repos):** shared `/skill` owns process; `<repo>/.cursor/skills/<skill>.local/` is a **thin** project overlay (commands, paths, defaults). Agents should **follow shared first, then apply the overlay**. Overlays should stay roughly one screen — if they grow into a second full playbook, push general prose back into this repo.

**Brain-app overlays** (thin; under `brain-app/.cursor/skills/*.local/`): `commit` · `tests` · `pr` · `backlog` · `worktree` · `fix` · `implement` · `interview` · `coverage`. Shared-only there: `deslop` · `verify-this` · `copy` · `global-code-review`.

Cursor does **not** cloud-sync `~/.agents` or `~/.cursor/skills` — git is the sync mechanism.

## Why this pattern

| Goal | Approach |
|------|----------|
| One place to edit | Real files only in `~/.agents/skills/` |
| Open-standard / cross-tool | `.agents/skills` is the interoperability convention |
| Cursor, Claude Code, Codex, … | Per-skill symlinks into each tool’s native `skills/` dir |
| Avoid tool breakage | Never symlink the whole `skills/` directory (Codex writes `.system/`; CLIs expect a real dir) |
| Multi-machine | This directory is a **git repo** — push/pull, then `setup.sh` (auto on pull via hook) |

Cursor also scans `~/.agents/skills/` directly. Symlinks under `~/.cursor/skills/` keep Customize / tools that only look at the Cursor path in sync without duplicating content.

## Agent instructions (how to maintain this)

When the user asks to add, move, or sync personal skills, follow this checklist.

### 1. Add a new skill

1. Create `~/.agents/skills/<skill-name>/SKILL.md` (folder name = `name` in frontmatter).
2. Optional: `scripts/`, `references/`, `assets/` beside `SKILL.md`.
3. Run `~/.agents/setup.sh` to create per-skill symlinks for installed agents.
4. Commit and push (see Git below).

```bash
mkdir -p ~/.agents/skills/my-skill
# write ~/.agents/skills/my-skill/SKILL.md
~/.agents/setup.sh
cd ~/.agents && git add -A && git status
# commit + push when the user asks
```

### 2. Manual per-skill symlink (if not using setup.sh)

From each agent skills directory, link **one skill folder** (not the whole tree):

```bash
# Cursor
mkdir -p ~/.cursor/skills
ln -sfn ../../.agents/skills/interview ~/.cursor/skills/interview

# Claude Code
mkdir -p ~/.claude/skills
ln -sfn ../../.agents/skills/interview ~/.claude/skills/interview

# Codex (keep ~/.codex/skills a real directory — .system/ lives here)
mkdir -p ~/.codex/skills
ln -sfn ../../.agents/skills/interview ~/.codex/skills/interview

# Gemini CLI (if installed)
mkdir -p ~/.gemini/skills
ln -sfn ../../.agents/skills/interview ~/.gemini/skills/interview
```

Relative targets assume the agent config lives under `$HOME/.<tool>/skills/`. For tools under `~/.config/<tool>/skills/`, use three levels up:

```bash
mkdir -p ~/.config/opencode/skills
ln -sfn ../../../.agents/skills/interview ~/.config/opencode/skills/interview
```

Verify:

```bash
ls -la ~/.cursor/skills/interview ~/.claude/skills/interview ~/.codex/skills/interview
# each should be a symlink → .../.agents/skills/interview
```

### 3. Migrate a skill out of a tool-specific dir

If Customize or a CLI wrote a **real** directory under `~/.cursor/skills/foo` (or Claude/Codex):

```bash
# Only if destination does not already exist
mv ~/.cursor/skills/foo ~/.agents/skills/foo
~/.agents/setup.sh
```

If both exist, keep `~/.agents/skills/foo`, delete the tool-local copy, then re-run `setup.sh`.

### 4. Remove a skill

```bash
rm -rf ~/.agents/skills/<skill-name>
~/.agents/setup.sh   # removes stale symlinks
cd ~/.agents && git add -A   # commit when asked
```

### 5. Re-sync after pull / new machine

```bash
cd ~/.agents
git pull                 # post-merge hook runs setup.sh
# or explicitly:
~/.agents/setup.sh
```

Fresh machine bootstrap:

```bash
git clone <remote-url> ~/.agents
~/.agents/setup.sh
```

### 6. What not to do

- Do **not** `ln -sfn ~/.agents/skills ~/.cursor/skills` (directory-level link).
- Do **not** leave duplicate real copies in both `~/.agents/skills` and `~/.cursor/skills` (Cursor discovers both → duplicate skills).
- Do **not** commit secrets into skill files.
- Do **not** put repo-specific Braintunnel workflows here; those stay in the project’s `.cursor/skills/` or `.agents/skills/`.

## Git workflow

`~/.agents` is its own git repository (separate from any product repo). **Remote:** `https://github.com/cirne/agent-skills.git` (public).

```bash
cd ~/.agents
git status
git add -A
git commit -m "Add my-skill"
git push origin main
```

On another machine: clone → `setup.sh` → pull later (hook re-links).

```bash
git clone https://github.com/cirne/agent-skills.git ~/.agents
~/.agents/setup.sh
# later:
cd ~/.agents && git pull
```

## Project vs personal skills

| Kind | Location | Shared how |
|------|----------|------------|
| Personal / cross-project | `~/.agents/skills/` | This git repo + symlinks |
| Project / team via git | `<repo>/.agents/skills/` or `<repo>/.cursor/skills/` | Commit in the product repo |
| Org-wide Cursor | Team Marketplace plugin | Dashboard → Plugins |

## References

- [Agent Skills overview](https://agentskills.io/home)
- [Specification](https://agentskills.io/specification)
- [Where clients should scan](https://agentskills.io/client-implementation/adding-skills-support)
- [Cursor skills docs](https://cursor.com/docs/skills.md)
- Compatible with [skills.sh](https://skills.sh) global + symlink installs into `~/.agents/skills/`
