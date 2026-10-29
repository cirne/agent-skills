---
name: pnpm-migrate
description: >-
  Migrates a Node project from npm to a pinned pnpm, including a React client
  subdirectory when it has its own package.json. Uses the project's .nvmrc for
  Node, pins a compatible pnpm, blocks npm install, and confirms tests and CI
  commands. Use when the user asks to switch to pnpm, standardize on pnpm, or
  invokes /pnpm-migrate.
---

# pnpm-migrate

Migrate install roots from npm to a pinned pnpm. Do not commit or push unless the user asks.

## Install roots

Treat each of these as its own install root when it has a `package.json`:

- The repo root.
- A client/app subdirectory (common names: `client`, `web`, `frontend`, `apps/web`, `apps/client`) that is a separate React (or other) app with its own lockfile.

If the root is already a workspace that installs the client, migrate once at the root. Do not give that client a second lockfile.

Skip archived specs and generated trees (`node_modules`, `dist`).

## Node, then pnpm

Node comes from the nearest `.nvmrc` (root, else the install root). Do not pick a Node that `.nvmrc` does not name.

```sh
# repo or install root that contains .nvmrc
nvm use
node -v
```

Use fnm/asdf/mise the same way when that is what the repo documents. Corepack on **that** Node supplies pnpm. Do not use a global pnpm that ignores the pin.

Pin the newest pnpm whose `engines.node` accepts this Node. Check the registry (`npm view pnpm engines`); if `latest` requires a newer Node, walk older majors until one fits. Pin that **exact** version. Corepack rejects ranges.

On every install root `package.json`:

```json
{
  "packageManager": "pnpm@X.Y.Z",
  "devEngines": {
    "packageManager": {
      "name": "pnpm",
      "version": "X.Y.Z",
      "onFail": "error"
    }
  }
}
```

`packageManager` is what Corepack and Yarn honor. `devEngines` with `onFail: "error"` is what makes `npm install` exit before it writes a lockfile. The version strings match. npm older than the `devEngines` field ignores it; say so if the pinned Node ships an older npm.

Activate it:

```sh
corepack enable
corepack prepare pnpm@X.Y.Z --activate
pnpm -v
```

## Install

Remove `package-lock.json` and `node_modules` for that root. Keep `yarn.lock` only until that root is migrated; then delete it too.

```sh
pnpm install
```

pnpm 12 does not read the `pnpm` key in `package.json`. Build-script policy goes in `pnpm-workspace.yaml` at that install root (settings only is fine when it is not a workspace):

```yaml
allowBuilds:
  esbuild: true
  protobufjs: false
```

`pnpm install` exits on ignored build scripts. Allow a script only when the package does not work without it (native or binary download, typically `esbuild`). Set `false` for scripts that merely print a warning. Re-run install until it exits 0, and confirm `pnpm -v` is the pinned version.

## Commands and docs

Update the files that tell a human or CI how to install. Leave historical tickets alone.

- GitHub Actions: `pnpm/action-setup@v4` (reads `packageManager`), then `actions/setup-node` with `node-version-file` pointing at `.nvmrc` and `cache: pnpm`, then `pnpm install --frozen-lockfile` and `pnpm test` / `pnpm lint` (the repo's real script names).
- Docker: `ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0`, `corepack enable`, copy `package.json` and `pnpm-lock.yaml` before install, `pnpm install --frozen-lockfile` (`--prod` for the production deps stage).
- README, `AGENTS.md`, and other active docs: `nvm use`, `corepack enable`, `pnpm install`. Replace `npm test` / `npm run lint` / `npm ci` with the pnpm equivalents.

## Confirm

Follow `/tests` for the suite (full log, no pipes). From each install root, with Node from `.nvmrc`:

1. `pnpm install` exits 0 and prints the pinned version.
2. The repo's test and lint (or `ci`) scripts exit 0.
3. `npm install` exits non-zero with `EBADDEVENGINES` and does not recreate `package-lock.json`.

Fix failures before calling the migration done. A client root gets the same three checks.
