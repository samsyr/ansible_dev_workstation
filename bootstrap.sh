#!/bin/bash
set -e
PLAYBOOK=playbooks/site-cuda.yml
source "$(dirname "$0")/bootstrap-without-cuda.sh"
