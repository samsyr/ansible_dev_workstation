# python_ai role

Sets up a Python AI/ML development environment using pyenv and uv, with a project venv pre-loaded with PyTorch and common ML libraries.

## What it does

- Installs system apt dependencies: `python3`, `python3-venv`, `python3-pip`, `python3-dev`, `ffmpeg`, `libgl1`, `libglib2.0-0`
- Installs pyenv build dependencies (ssl, zlib, readline, sqlite, llvm, etc.)
- Installs pyenv to `~/.pyenv` (as `dev_user`)
- Writes `~/.bashrc.d/pyenv.sh` to activate pyenv in new shells
- Installs `uv` to `~/.local/bin/uv` (as `dev_user`)
- Installs Python `python_version` via pyenv
- Creates `~/dev/ai-sandbox/` directory
- Writes `.python-version` file in the workspace
- Creates a uv virtualenv at `~/dev/ai-sandbox/.venv`
- Installs into the venv:
  - `torch`, `torchvision`, `torchaudio` (CUDA 12.8 wheel from PyTorch index)
  - `ultralytics`, `scikit-learn`, `opencv-python`, `numpy`, `pandas`, `matplotlib`, `jupyterlab`, `ipykernel`
- Runs `nvidia-smi` and warns (does not fail) if the GPU is not available

## Variables

| Variable | Example | Description |
|---|---|---|
| `dev_user` | `sampo` | User to install pyenv and uv for |
| `dev_home` | `/home/sampo` | Home directory path |
| `python_version` | `3.11.13` | Python version to install via pyenv |

## Idempotency

- pyenv install uses `creates: ~/.pyenv`
- uv install uses `creates: ~/.local/bin/uv`
- Python version install uses `creates:` pointing to the versioned pyenv directory
- Venv creation uses `creates: ~/dev/ai-sandbox/.venv`
- Package install uses a sentinel file `.venv/.ai-packages-installed` — runs only once

## Notes

PyTorch is installed with the CUDA 12.8 index URL. If you need a CPU-only wheel or a different CUDA version, edit the `uv pip install` command in `tasks/main.yml`.
