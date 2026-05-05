#!/bin/bash
set -e
PLAYBOOK="${PLAYBOOK:-playbooks/site.yml}"
ansible-galaxy collection install -r requirements.yml
sudo ansible-playbook "$PLAYBOOK"

echo "Your SSH public key (copy to GitHub/GitLab/etc.):"
cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "(no SSH public key found)"
