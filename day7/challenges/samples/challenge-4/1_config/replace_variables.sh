#!/bin/bash

rm -f local-secrets.yaml
cp ./secrets.yaml ./local-secrets.yaml

rm -f local-configmap.yaml
cp ./configmap.yaml ./local-configmap.yaml

while read p; do
    kv=$(echo ${p//[[:blank:]]/})
    echo $kv
    IFS=' = ' read -r key value <<< "$kv"
 
    # remove first and last quote (") from variable value
    value="${value%\"}"  &&  value="${value#\"}"
    token="#{$key}#"
    echo "Using token: $token value: $value "
    os=$(uname -s)
    [[ "$os" == "Darwin" ]] && sed -i "" "s/$token/$value/g" ./local-secrets.yaml || sed -i "s/$token/$value/g" ./local-secrets.yaml
    [[ "$os" == "Darwin" ]] && sed -i "" "s/$token/$value/g" ./local-configmap.yaml || sed -i "s/$token/$value/g" ./local-configmap.yaml
done <../0_tf/azure_output.txt
