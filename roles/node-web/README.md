# node-web role

Installs Node.js via nvm and pnpm as the global package manager.

## What it does

- Installs nvm v0.40.1 to `~/.nvm` (as `dev_user`)
- Writes `~/.bashrc.d/nvm.sh` to activate nvm and its bash completion in new shells
- Installs Node.js LTS via `nvm install --lts`
- Installs pnpm globally via npm

## Variables

| Variable | Description |
|---|---|
| `dev_user` | User to install nvm for |
| `dev_home` | Home directory path |

## Idempotency

nvm install uses `creates: ~/.nvm`. The Node/pnpm install task does not use a `creates:` guard — it runs on every play but nvm skips reinstallation if the LTS version is already present.
