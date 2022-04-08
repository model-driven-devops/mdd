#!/usr/bin/env bash

ANSIBLE_PYTHON_INTERPRETER=/usr/local/bin/python

OPTIONS=""
if [[ ! -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]]; then
   OPTIONS="--env ANSIBLE_VAULT_PASSWORD_FILE=/tmp/vault.pw -v $ANSIBLE_VAULT_PASSWORD_FILE:/tmp/vault.pw"
fi
if [[ ! -z "$ANSIBLE_INVENTORY" ]]; then
   OPTIONS="$OPTIONS --env ANSIBLE_INVENTORY=$ANSIBLE_INVENTORY"
fi

OPTION_LIST=( \
   "CML_HOST" \
   "CML_USERNAME" \
   "CML_PASSWORD" \
   "CML_LAB" \
   "CML_VERIFY_CERT" \
   "CSR1000V_VERSION" \
   "UBUNTU_VERSION" \
   "IOSVL2_VERSION" \
   "ANSIBLE_PYTHON_INTERPRETER" \
   )

for OPTION in ${OPTION_LIST[*]}; do
   if [[ ! -z "${!OPTION}" ]]; then
      OPTIONS="$OPTIONS --env $OPTION=${!OPTION}"
   fi
done

OPTIONS="$OPTIONS --env ANSIBLE_ROLES_PATH=/ansible/roles"

docker run -it --rm -v $PWD:/ansible --env PWD="/ansible" --env USER="$USER" $OPTIONS ghcr.io/model-driven-devops/mdd:latest ansible-playbook "$@"
