# docker role

Installs Docker CE from the official Docker apt repository and adds the user to the `docker` group.

## What it does

- Adds the Docker GPG key to `/etc/apt/keyrings/docker.asc`
- Adds the Docker apt repository for the current Ubuntu release
- Installs: `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`
- Enables and starts the `docker` systemd service
- Adds `dev_user` to the `docker` group

## Variables

| Variable | Description |
|---|---|
| `dev_user` | User to add to the `docker` group |

## Notes

Group membership requires a logout/login to take effect for the current session.

## Idempotency

Package installs use `state: present`. Group membership uses `append: true` — does not remove existing groups.
