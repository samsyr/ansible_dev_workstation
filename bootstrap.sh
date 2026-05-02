#!/bin/bash
ansible-galaxy collection install -r requirements.yml
sudo ansible-playbook playbooks/site.yml