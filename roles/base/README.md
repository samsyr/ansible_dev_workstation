# base role

## Purpose
Configure core Ubuntu system.

## Variables
- `base_packages`: list of packages to install
- `timezone`: system timezone
- `locale`: system locale

## Idempotency
- Uses apt with state=present
- Safe to run multiple times
- No destructive operations

## Notes
Foundation role, required on all hosts.
