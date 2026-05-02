# docker role

## Purpose
Install and configure Docker.

## Variables
- `docker_users`: users added to docker group

## Idempotency
- Docker installed only if missing
- Group membership managed declaratively

## Notes
Requires logout/login for group changes.
