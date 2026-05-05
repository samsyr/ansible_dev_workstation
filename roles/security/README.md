# security role

Installs security-related desktop tooling.

## What it does

- Installs Bitwarden password manager via snap
- Warns (does not fail) if the snap install is unavailable

## Idempotency

Checks `snap list bitwarden` before attempting install. Safe to re-run.

## Notes

Currently focused on desktop tooling rather than system hardening. SSH config and firewall management are not yet implemented.
