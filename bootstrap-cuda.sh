#!/bin/bash
set -e
ansible-galaxy collection install -r requirements.yml --force
sudo ansible-playbook playbooks/site-cuda.yml --force
