# nvidia_cuda role

## Purpose
Manage NVIDIA GPU stack.

## Variables
- `manage_nvidia_driver`: bool
- `install_cuda_toolkit`: bool
- `nvidia_driver_package`: package name

## Idempotency
- Driver install conditional
- Does not overwrite working setup
- Validation is read-only

## Notes
Host-specific. Disabled by default.
