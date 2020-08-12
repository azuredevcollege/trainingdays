#!/bin/sh
mkdir -p ~/.terraform.d/plugins && \
      curl -Ls https://api.github.com/repos/gavinbunney/terraform-provider-kubectl/releases/latest \
      | jq -r ".assets[] | select(.browser_download_url | contains(\"$(uname -s | tr A-Z a-z)\")) | select(.browser_download_url | contains(\"amd64\")) | .browser_download_url" \
      | xargs -n 1 curl -Lo ~/.terraform.d/plugins/terraform-provider-kubectl.zip && \
      pushd ~/.terraform.d/plugins/ && \
      unzip ~/.terraform.d/plugins/terraform-provider-kubectl.zip -d terraform-provider-kubectl-tmp && \
      mv terraform-provider-kubectl-tmp/terraform-provider-kubectl* . && \
      chmod +x terraform-provider-kubectl* && \
      rm -rf terraform-provider-kubectl-tmp && \
      rm -rf terraform-provider-kubectl.zip && \
      popd
      