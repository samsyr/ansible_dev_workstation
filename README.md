# Workstation Setup

Minimal, reproducible Ubuntu development environment using Ansible.

## Goals

* Deterministic setup (same result every time)
* Fast bootstrap on fresh machines
* Minimal dependencies, no overengineering
* Incremental, role-based structure

---

## What this currently sets up

### Base system

* Core CLI tools (`git`, `curl`, `ripgrep`, `jq`, etc.)
* Clean apt-based installation (no unnecessary recommends)

### User environment

* Dev directories (`~/dev`, `~/bin`, etc.)
* Git configuration
* Bash modular config (`~/.bashrc.d/`)
* Useful CLI aliases

### Shell UX

* Starship prompt
* Git-aware prompt
* Fast CLI tooling (`rg`, `fd`, `bat`, `fzf`)

### CLI utilities

* `tree`, `jq`, `ripgrep`, `fd`, `bat`, `fzf`, `ncdu`
* `tldr` (via tealdeer, auto-updating)

---

## Project structure

```
workstation-setup/
├── ansible.cfg
├── bootstrap.sh
├── requirements.yml
├── inventories/
│   └── local/
│       └── hosts.yml
├── playbooks/
│   └── site.yml
└── roles/
    ├── base/
    └── user/
```

---

## Setup

Run:

```bash
./bootstrap.sh
```

Or manually:

```bash
ansible-galaxy collection install -r requirements.yml
sudo ansible-playbook playbooks/site.yml
```

---

## Idempotency

This setup is idempotent.

You can safely run:

```bash
sudo ansible-playbook playbooks/site.yml
```

multiple times. No unnecessary changes should occur.

---

## Design principles

### 1. Infrastructure as code

Everything is defined in Ansible.
No manual setup should be required.

---

### 2. Minimalism first

Only essential tools are included.

Add tooling incrementally when needed.

---

### 3. Separation of concerns

* `base` → system + CLI tools
* `user` → user environment + shell + git

---

### 4. Reproducibility over convenience

Avoid:

* global pip installs
* random scripts
* machine-specific tweaks

Prefer:

* declarative configuration
* version-controlled setup

---

## Next steps (planned)

### Docker (next milestone)

* Docker Engine installation
* Non-root Docker usage (docker group)
* Docker Compose + Buildx
* Foundation for reproducible dev environments

---

### Future additions

* Dev containers / docker-compose stacks
* Python environment (pyenv / venv strategy)
* AI/ML tooling (CUDA, PyTorch)
* Optional desktop tooling (IDE setup)

---

## Notes

* Designed for Ubuntu (tested on recent LTS)
* Uses official package sources where possible
* Avoids unnecessary abstractions

---

## Philosophy

> Build the environment right once, then never think about setup again.
