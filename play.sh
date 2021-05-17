#!/usr/bin/env bash

OPTIONS=""
if [[ ! -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]]; then
   OPTIONS="--env ANSIBLE_VAULT_PASSWORD_FILE=/tmp/vault.pw -v $ANSIBLE_VAULT_PASSWORD_FILE:/tmp/vault.pw"
fi
if [[ ! -z "$CML_HOST" ]]; then
   OPTIONS="$OPTIONS --env CML_HOST=$CML_HOST"
fi
if [[ ! -z "$CML_USERNAME" ]]; then
   OPTIONS="$OPTIONS --env CML_USERNAME=$CML_USERNAME"
fi
if [[ ! -z "$CML_PASSWORD" ]]; then
   OPTIONS="$OPTIONS --env CML_PASSWORD=$CML_PASSWORD"
fi
if [[ ! -z "$CML_LAB" ]]; then
   OPTIONS="$OPTIONS --env CML_LAB=$CML_LAB"
fi
if [[ ! -z "$ANSIBLE_INVENTORY" ]]; then
   OPTIONS="$OPTIONS --env ANSIBLE_INVENTORY=$ANSIBLE_INVENTORY"
fi

OPTION_LIST=( \
   "CML_HOST" \
   "CML_USERNAME" \
   "CML_PASSWORD" \
   "CML_LAB" \
   "CSR1000V_VERSION" \
   "UBUNTU_VERSION" \
   "IOSVL2_VERSION" \
   )

for OPTION in ${OPTION_LIST[*]}; do
   if [[ ! -z "${!OPTION}" ]]; then
      OPTIONS="$OPTIONS --env $OPTION=${!OPTION}"
   fi
done

OPTIONS="$OPTIONS --env ANSIBLE_ROLES_PATH=/ansible/roles"

docker run -it --rm -v $PWD:/ansible --env PWD="/ansible" --env USER="$USER" $OPTIONS ghcr.io/model-driven-devops/mdd-container:latest ansible-playbook "$@"
