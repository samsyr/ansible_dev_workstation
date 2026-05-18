# extras role

Installs optional desktop applications and personalization.

## What it does

- Installs Spotify via snap
- Copies a wallpaper image to `wallpaper_dest` and sets it as the GNOME background (light + dark)

## Variables

| Variable | Description |
|---|---|
| `dev_user` | User whose GNOME background is configured |
| `wallpaper_dest` | Path where the wallpaper image is placed |

## Idempotency

- snap and apt installs use `state: present`
- `gsettings` is forced `changed_when: true` (re-applies on every run)
