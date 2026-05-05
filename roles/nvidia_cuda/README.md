# nvidia_cuda role

Manages the NVIDIA GPU driver and CUDA Toolkit. All installation is opt-in via variables.

## What it does

- Installs the NVIDIA driver package (when `manage_nvidia_driver: true`)
- Installs `nvidia-cuda-toolkit` via apt (when `install_cuda_toolkit: true`)
- Writes CUDA environment variables to `/etc/profile.d/cuda.sh` (when `install_cuda_toolkit: true`):
  - `PATH` — adds `/usr/local/cuda/bin`
  - `LD_LIBRARY_PATH` — adds `/usr/local/cuda/lib64`
- Runs `nvidia-smi` to validate the driver; fails the play if `validate_nvidia: true` and it returns non-zero
- Runs `nvcc --version` to validate the toolkit; fails if `install_cuda_toolkit: true` and it returns non-zero

## Variables

| Variable | Default | Description |
|---|---|---|
| `manage_nvidia_driver` | `false` | Install the NVIDIA driver package |
| `install_cuda_toolkit` | `false` | Install CUDA Toolkit and write env vars |
| `validate_nvidia` | `true` | Fail the play if `nvidia-smi` is not working |
| `nvidia_driver_package` | `nvidia-driver-595-open` | apt package name for the driver |

## Idempotency

Driver and toolkit installs use `state: present`. Validation tasks use `changed_when: false`. Safe to re-run on a machine where the driver is already installed.

## Notes

This role is host-specific. Run `playbooks/nvidia-rtx5070-ubuntu2604.yml` for a standalone driver-only install targeting an RTX 5070 on Ubuntu 26.04.
