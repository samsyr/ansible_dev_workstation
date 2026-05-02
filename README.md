# Workstation Setup

Modular Ansible setup for provisioning an Ubuntu workstation for software development, AI/ML work, containers, web development, JVM development, and general daily engineering use.

This repository is intentionally role-based. Each role owns one clear responsibility and has its own documentation under `roles/<role>/README.md`.

## Target environment

Primary target:

- Ubuntu 26.04
- Local workstation installation
- Developer machine / AI workstation
- Optional NVIDIA GPU support

The setup is designed to be repeatable and safe to re-run.

## Design principles

- Keep roles small and explicit
- Avoid hidden cross-role side effects
- Keep host-specific GPU setup isolated
- Prefer validation over destructive repair
- Make the workstation reproducible without making the hardware stack fragile

## Architecture

```text
[ Ubuntu OS ]
      ↓
[ base + security + user ]
      ↓
[ devtools + docker ]
      ↓
[ language runtimes: python-ai + node-web + jvm ]
      ↓
[ optional host-specific GPU layer: nvidia_cuda ]
```

## Role overview

| Role | Purpose |
|---|---|
| `base` | Core Ubuntu system setup |
| `security` | Basic workstation hardening |
| `user` | User environment, directories and shell defaults |
| `devtools` | General development tooling |
| `docker` | Docker/container runtime |
| `python-ai` | Python AI/ML development environment |
| `node-web` | Node.js and web development tooling |
| `jvm` | Java/JVM development stack |
| `nvidia_cuda` | Optional NVIDIA driver / CUDA validation and installation |

For detailed variables, idempotency notes and role-specific behavior, see:

```text
roles/<role>/README.md
```

## NVIDIA / CUDA boundary

NVIDIA and CUDA are intentionally isolated in the `nvidia_cuda` role.

The rest of the workstation setup must not silently install or modify GPU drivers.

Reason:

- NVIDIA drivers are kernel- and hardware-specific
- CUDA Toolkit is optional for most Python/PyTorch workflows
- GPU stacks can break during kernel or driver changes
- Python AI tooling should work with CPU fallback when GPU is unavailable

Default policy:

- Validate GPU availability when useful
- Do not force-install NVIDIA drivers by default
- Do not install CUDA Toolkit unless explicitly requested
- Let `python-ai` use GPU if available, otherwise CPU

## Inventory

Local workstation inventory example:

```yaml
all:
  children:
    workstation:
      hosts:
        localhost:
          ansible_connection: local
          ansible_python_interpreter: /usr/bin/python3
```

Recommended location:

```text
inventories/hosts.yml
```

## Main playbook

Recommended entry point:

```text
playbooks/workstation.yml
```

Example:

```yaml
---
- name: Configure Ubuntu workstation
  hosts: workstation
  become: false

  roles:
    - role: base
      tags: ["base"]

    - role: security
      tags: ["security"]

    - role: user
      tags: ["user"]

    - role: devtools
      tags: ["devtools"]

    - role: docker
      tags: ["docker"]

    - role: jvm
      tags: ["jvm"]

    - role: node-web
      tags: ["node", "web"]

    - role: nvidia_cuda
      tags: ["nvidia", "cuda", "gpu"]

    - role: python-ai
      tags: ["python", "ai", "ml", "pytorch"]
```

## Running the full workstation setup

For local provisioning, run with `sudo`:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml --limit workstation
```

## Running selected parts

Run only Python AI setup:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml \
  --limit workstation \
  --tags python,ai,ml
```

Run only Docker setup:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml \
  --limit workstation \
  --tags docker
```

Run only NVIDIA/CUDA validation:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml \
  --limit workstation \
  --tags nvidia,cuda,gpu
```

Explicitly install or repair NVIDIA driver:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml \
  --limit workstation \
  --tags nvidia \
  -e manage_nvidia_driver=true
```

Explicitly install CUDA Toolkit:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml \
  --limit workstation \
  --tags cuda \
  -e install_cuda_toolkit=true
```

## Validation

GPU visibility:

```bash
nvidia-smi
```

CUDA compiler, only if CUDA Toolkit is expected:

```bash
nvcc --version
```

PyTorch GPU visibility:

```bash
python - <<'PY'
import torch
print("torch:", torch.__version__)
print("cuda available:", torch.cuda.is_available())
print("cuda:", torch.version.cuda)
print("gpu:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else None)
PY
```

Docker:

```bash
docker version
docker run --rm hello-world
```

Node:

```bash
node --version
npm --version
```

Java:

```bash
java --version
```

## Variables

Common high-level variables are defined inside each role under:

```text
roles/<role>/defaults/main.yml
```

Role-specific documentation is available in:

```text
roles/<role>/README.md
```

Important GPU-related variables:

```yaml
manage_nvidia_driver: false
install_cuda_toolkit: false
validate_nvidia: true
nvidia_driver_package: "nvidia-driver-595-open"
```

Important Python AI variables:

```yaml
ai_project_dir: "~/dev/ai-sandbox"
install_pytorch: true
```

## Idempotency

The repository is intended to be safe to re-run.

Expected behavior:

- Packages are installed with `state: present`
- Directories are ensured, not recreated destructively
- Validation commands do not change system state
- GPU driver installation is conditional
- CUDA Toolkit installation is conditional
- User-facing configuration should only change when file content changes

Avoid adding tasks that:

- overwrite local user data
- uninstall drivers implicitly
- change GPU stack as a side effect of Python setup
- require manual interaction during normal runs

## Recommended project structure

```text
inventories/
  hosts.yml

playbooks/
  workstation.yml

roles/
  base/
    defaults/main.yml
    tasks/main.yml
    README.md

  security/
    defaults/main.yml
    tasks/main.yml
    README.md

  user/
    defaults/main.yml
    tasks/main.yml
    README.md

  devtools/
    defaults/main.yml
    tasks/main.yml
    README.md

  docker/
    defaults/main.yml
    tasks/main.yml
    README.md

  jvm/
    defaults/main.yml
    tasks/main.yml
    README.md

  node-web/
    defaults/main.yml
    tasks/main.yml
    README.md

  nvidia_cuda/
    defaults/main.yml
    tasks/main.yml
    README.md

  python-ai/
    defaults/main.yml
    tasks/main.yml
    README.md
```

## Troubleshooting

### Ansible cannot find the workstation host

Check inventory:

```bash
ansible-inventory -i inventories/hosts.yml --list
```

Test local connection:

```bash
ansible localhost -i inventories/hosts.yml -m ping
```

### Sudo / become problems on localhost

For local workstation bootstrap, the simplest approach is usually:

```bash
sudo ansible-playbook -i inventories/hosts.yml playbooks/workstation.yml --limit workstation
```

and keep the playbook itself with:

```yaml
become: false
```

### GPU is not visible

Check:

```bash
nvidia-smi
```

If this fails, fix the NVIDIA/CUDA layer first. The issue is outside `python-ai`.

### PyTorch does not see CUDA

Check whether PyTorch was installed with a CUDA-enabled wheel and whether `nvidia-smi` works.

```bash
python - <<'PY'
import torch
print(torch.cuda.is_available())
print(torch.version.cuda)
PY
```

## Development notes

Good next improvements:

- add `ansible-lint`
- add Molecule tests for selected roles
- add CI syntax check
- add `--check` mode compatibility where practical
- add per-host variable files under `host_vars/`
- add separate laptop/workstation/cloud inventories

## License

Personal / internal use by default. Adjust before publishing publicly.
