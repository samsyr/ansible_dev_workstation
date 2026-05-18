# workstation-setup

Ansible playbooks for provisioning a personal Ubuntu workstation for software development, AI/ML work, and general engineering use.

Designed to be repeatable — safe to run multiple times on the same machine.

## Target environment

- Ubuntu 26.04
- Local workstation
- NVIDIA GPU (optional, RTX 5070 primary target)

## Quick start

Full setup with CUDA:

```bash
./bootstrap.sh
```

Setup without CUDA:

```bash
./bootstrap-without-cuda.sh
```

Both scripts install Ansible Galaxy requirements and run the appropriate playbook under `sudo`.

## Repository layout

```
bootstrap.sh               # Full CUDA setup entry point
bootstrap-without-cuda.sh  # Non-CUDA setup entry point

playbooks/
  site-cuda.yml            # Full workstation + NVIDIA/CUDA
  site.yml                 # Full workstation, no GPU assumption
  nvidia-rtx5070-ubuntu2604.yml  # Standalone GPU driver installer

roles/
  base/           # Core apt packages, ChatGPT desktop
  user/           # Dev dirs, git config, shell (Starship, aliases, tealdeer)
  docker/         # Docker CE, Compose, Buildx; adds user to docker group
  devtools/       # lazygit, VS Code, Sublime Text, Cursor IDE, tmux, httpie
  extras/         # Spotify
  jvm/            # SDKMAN, Java 21, Gradle, Groovy
  nvidia_cuda/    # NVIDIA driver, CUDA Toolkit, environment, validation
  python_ai/      # pyenv, uv, Python 3.11, AI venv (PyTorch, scikit-learn, etc.)
  security/       # Bitwarden desktop
  node_web/       # nvm, Node.js LTS, pnpm
```

## Key variables

Defined in `playbooks/site-cuda.yml` and `playbooks/site.yml`:

| Variable | Default | Description |
|---|---|---|
| `dev_user` | `sampo` | Target user account |
| `python_version` | `3.11.13` | pyenv-managed Python version |
| `java_version` | `21.0.11-tem` | SDKMAN Java version |
| `gradle_version` | `9.5.0` | SDKMAN Gradle version |
| `groovy_version` | `4.0.31` | SDKMAN Groovy version |
| `cursor_path` | `/opt/cursor.AppImage` | Cursor IDE install path |
| `nvidia_cuda_manage_driver` | `true` in cuda playbook | Install the NVIDIA driver |
| `nvidia_cuda_install_toolkit` | `true` in cuda playbook | Install CUDA Toolkit |
| `nvidia_cuda_validate` | `true` | Run `nvidia-smi` check |
| `nvidia_cuda_driver_package` | `nvidia-driver-595-open` | Driver package name |

## What each role does

**base** — installs core CLI tools (`ripgrep`, `fd`, `bat`, `fzf`, `jq`, `tree`, `ncdu`, `tealdeer`, `vim`, etc.), `zram-config`, `gedit`, `gnome-tweaks`, and the ChatGPT desktop snap.

**user** — creates `~/dev`, `~/bin`, `~/tmp`, `~/.bashrc.d`, configures global git settings, sets up Starship prompt, and installs tealdeer with auto-update.

**docker** — installs Docker CE from the official Docker repo, enables the service, and adds `dev_user` to the `docker` group. Requires logout/login to take effect.

**devtools** — installs `tmux`, `httpie`, `lazygit`, VS Code (snap, classic), VS Code extensions (GitHub Copilot, Claude Dev), Sublime Text, and Cursor IDE (AppImage downloaded from the Cursor API).

**extras** — installs Spotify via snap.

**jvm** — installs SDKMAN for the user and uses it to install Java, Gradle, and Groovy at the pinned versions.

**nvidia_cuda** — conditionally installs the NVIDIA driver and CUDA Toolkit, writes CUDA env vars to `/etc/profile.d/cuda.sh`, and validates the install with `nvidia-smi` and `nvcc`.

**python_ai** — installs pyenv and uv for the user, installs Python 3.11, creates an AI sandbox venv at `~/dev/ai-sandbox`, and installs PyTorch (CUDA 12.8 wheel), ultralytics, scikit-learn, opencv, numpy, pandas, matplotlib, and JupyterLab.

**security** — installs Bitwarden desktop via snap.

**node_web** — installs nvm for the user, installs Node.js LTS, and installs pnpm globally.

## Running individual parts

Override variables at the command line:

```bash
# Install only the GPU driver, skip everything else
sudo ansible-playbook playbooks/nvidia-rtx5070-ubuntu2604.yml

# Run full playbook but skip NVIDIA driver install
sudo ansible-playbook playbooks/site-cuda.yml -e nvidia_cuda_manage_driver=false

# Run full playbook but skip CUDA Toolkit
sudo ansible-playbook playbooks/site-cuda.yml -e nvidia_cuda_install_toolkit=false
```

## Validation

```bash
# GPU
nvidia-smi
nvcc --version

# Python + GPU
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda:", torch.cuda.is_available())
print("gpu:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else None)
PY

# Docker
docker run --rm hello-world

# Node
node --version && npm --version

# Java
java --version
```
