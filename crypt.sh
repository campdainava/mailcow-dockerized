#!/bin/bash

# to generate a key, use:
#? age-keygen -o key.txt
# do not check this key in to the repo

if [ -z "$SOPS_AGE_KEY_FILE" ]; then
    echo 'Set env variable SOPS_AGE_KEY_FILE to path of generated age key'
    exit 1
fi

KEYS_REGEXP='^.*(SECRET|USER|PASS|NAME|PASSPHRASE|DB|URL|EMAIL|DOMAIN|KEY|CONTACT).*$'

if [[ $1 == encrypt ]]; then
    sops --encrypt --age $(awk '/public key:/ {print $NF}' $SOPS_AGE_KEY_FILE) --encrypted-regex "$KEYS_REGEXP" --input-type dotenv --output-type dotenv --in-place mailcow.conf
elif [[ $1 == decrypt ]]; then
    sops --decrypt  --age $(awk '/public key:/ {print $NF}' $SOPS_AGE_KEY_FILE) --encrypted-regex "$KEYS_REGEXP" --input-type dotenv --output-type dotenv --in-place mailcow.conf
else
    echo "Usage: crypt.sh [encrypt|decrypt]"
    exit 1
fi

