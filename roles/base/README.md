# base role

Installs core system packages and sets up the `less` alias to use `bat` for syntax highlighting.

## What it does

- Updates the apt cache (max 1 hour staleness)
- Installs system tools: `git`, `curl`, `wget`, `vim`, `gedit`, `gnome-tweaks`, `htop`, `unzip`, `ca-certificates`, `gnupg`, `lsb-release`, `build-essential`, `zram-config`, `util-linux-extra`
- Installs CLI tools: `tree`, `jq`, `ripgrep`, `fd-find`, `bat`, `fzf`, `ncdu`, `tealdeer`
- Installs the ChatGPT desktop snap
- Aliases `less` to `batcat` in `.bashrc`

## Variables

| Variable | Description |
|---|---|
| `dev_user` | User whose `.bashrc` receives the `less` alias |
| `dev_home` | Home directory path |

## Idempotency

All packages use `state: present`. Safe to re-run — no destructive operations.
