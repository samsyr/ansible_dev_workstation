# devtools role

Installs development tools: terminal utilities, editors, and IDEs.

## What it does

- Installs via apt: `tmux`, `httpie`
- Installs `lazygit` (latest release from GitHub) to `/usr/local/bin`
- Installs VS Code via snap (classic confinement)
- Installs VS Code extensions: `GitHub.copilot`, `saoudrizwan.claude-dev`
- Installs Sublime Text from the official apt repository
- Downloads the Cursor IDE AppImage (latest, from the Cursor API), places it at `cursor_path`, symlinks it to `/usr/local/bin/cursor`, and creates a `.desktop` entry

## Variables

| Variable | Default | Description |
|---|---|---|
| `cursor_path` | `/opt/cursor.AppImage` | Where the Cursor AppImage is saved |

## Idempotency

- `lazygit` uses `creates: /usr/local/bin/lazygit`
- Cursor download uses `force: false` — skips if file already exists
- Package installs use `state: present`
