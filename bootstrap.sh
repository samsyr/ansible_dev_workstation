#!/bin/bash
ansible-galaxy collection install -r requirements.yml --force
sudo ansible-playbook playbooks/site.yml --force

echo "Your SSH public key (copy to GitHub/GitLab/etc.):"
cat ~/.ssh/id_rsa.pub
