#!/usr/bin/env bash

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

ansible-playbook -i ./hosts.yaml ./playbook.yml # --ask-vault-password --become-password-file ./ansible_vault_password.txt
