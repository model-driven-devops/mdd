#!/usr/bin/env bash

OPTIONS=""
if [[ ! -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]]; then
   OPTIONS="--env ANSIBLE_VAULT_PASSWORD_FILE=/tmp/vault.pw -v $ANSIBLE_VAULT_PASSWORD_FILE:/tmp/vault.pw"
fi
if [[ ! -z "$VIRL_HOST" ]]; then
   OPTIONS="$OPTIONS --env VIRL_HOST=$VIRL_HOST"
fi
if [[ ! -z "$VIRL_USERNAME" ]]; then
   OPTIONS="$OPTIONS --env VIRL_USERNAME=$VIRL_USERNAME"
fi
if [[ ! -z "$VIRL_PASSWORD" ]]; then
   OPTIONS="$OPTIONS --env VIRL_PASSWORD=$VIRL_PASSWORD"
fi
if [[ ! -z "$VIRL_LAB" ]]; then
   OPTIONS="$OPTIONS --env VIRL_LAB=$VIRL_LAB"
fi


OPTIONS="$OPTIONS --env ANSIBLE_ROLES_PATH=/ansible/roles"

docker run -it --rm -v $PWD:/ansible --env PWD="/ansible" --env USER="$USER" $OPTIONS ciscops/ansible-devops ansible-playbook "$@"
