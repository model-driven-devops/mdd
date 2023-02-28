#!/usr/bin/env bash

OPTIONS="--env ANSIBLE_PYTHON_INTERPRETER=/usr/local/bin/python"
OPTIONS="$OPTIONS --env COLLECTIONS_PATHS=/TEST"
if [[ ! -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]]; then
   OPTIONS="$OPTIONS --env ANSIBLE_VAULT_PASSWORD_FILE=/tmp/vault.pw -v $ANSIBLE_VAULT_PASSWORD_FILE:/tmp/vault.pw"
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
   "ANSIBLE_INVENTORY" \
   )

for OPTION in ${OPTION_LIST[*]}; do
   if [[ ! -z "${!OPTION}" ]]; then
      OPTIONS="$OPTIONS --env $OPTION=${!OPTION}"
   fi
done

podman run -it --rm -v $PWD:/ansible --env PWD="/ansible" --env COLLECTIONS_PATHS="/TEST" --env USER="$USER" $OPTIONS ghcr.io/model-driven-devops/mdd:latest ansible-playbook "$@"
