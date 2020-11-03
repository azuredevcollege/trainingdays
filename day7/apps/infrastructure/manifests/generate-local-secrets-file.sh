#!/bin/bash

# Usage: $ ./generate-local-secrets-file.sh -n <YOUR_KEY_VAULT_NAME>
#
# Script uses Azure CLI context to access Azure KeyVault
# and expects a file called secrets.yaml 
# with #{...}# tokens in the local directory.

while getopts ":n:" opt; do
  case $opt in
    n) KV_NAME="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2 && exit 1
    ;;
  esac
done

secrets=( `az keyvault secret list --vault-name $KV_NAME | jq ".[].name" -r` )
echo "Deleting local-secrets.yaml"
rm -f local-secrets.yaml
cp ./secrets.yaml ./local-secrets.yaml
for item in "${secrets[@]}"
do
    token="#{$item}#"
    echo "Using token: $token"
    secretvalue=( `az keyvault secret show --name $item --vault-name $KV_NAME | jq ".value" -r`)
    sed -i "s/$token/$secretvalue/g" ./local-secrets.yaml
done

echo "Finished replacing tokens. Enjoy!"
