# user role

Configures the developer's user environment: shell, directories, git, prompt, and CLI tooling.

## What it does

- Creates personal directories: `~/dev`, `~/bin`, `~/tmp`, `~/.bashrc.d`, `~/.local/bin`, `~/.config`, `~/.config/tealdeer`
- Configures global git: `user.name`, `user.email`, `init.defaultBranch=main`, `pull.rebase=false`
- Creates `~/.bashrc.d/dev-aliases.sh` with aliases: `ll`, `gs`, `ga`, `gc`, `gp`, `cat=batcat`, `fd=fdfind`
- Ensures `.bashrc` sources all files in `~/.bashrc.d/`
- Installs Starship prompt to `~/.local/bin/starship`
- Writes a minimal `~/.config/starship.toml` (directory + git branch/status + character)
- Enables Starship in `~/.bashrc.d/starship.sh`
- Configures tealdeer for auto-update and populates the cache

## Variables

| Variable | Description |
|---|---|
| `dev_user` | Target user account |
| `dev_home` | Home directory path |
| `git_user_name` | Git `user.name` |
| `git_user_email` | Git `user.email` |

## Idempotency

Directories use `state: directory`. Config files are written with `copy` (only changes when content changes). Starship and tealdeer cache use `creates:` guards.
