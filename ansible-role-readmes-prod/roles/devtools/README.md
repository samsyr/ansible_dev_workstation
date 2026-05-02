# devtools role

## Purpose
Install general development tools.

## Variables
- `devtools_packages`: list of tools (git, cmake, etc.)

## Idempotency
- Package installs are idempotent
- Re-running does not reinstall unnecessarily

## Notes
Shared across all dev environments.
