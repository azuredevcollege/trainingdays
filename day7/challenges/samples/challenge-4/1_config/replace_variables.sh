#!/bin/bash

rm -f local-secrets.yaml
cp ./secrets.yaml ./local-secrets.yaml

rm -f local-configmap.yaml
cp ./configmap.yaml ./local-configmap.yaml

keys=( $( jq 'keys[]' -r ../0_tf/azure_output.json) )

for i in "${keys[@]}"
do
   param=".$i.value"
   value=$(jq $param ../0_tf/azure_output.json -r)
   token="#{$i}#"
   echo "Using param: $i value: $value "
   os=$(uname -s)
    [[ "$os" == "Darwin" ]] && sed -i "" "s/$token/$value/g" ./local-secrets.yaml || sed -i "s/$token/$value/g" ./local-secrets.yaml
    [[ "$os" == "Darwin" ]] && sed -i "" "s/$token/$value/g" ./local-configmap.yaml || sed -i "s/$token/$value/g" ./local-configmap.yaml
done
