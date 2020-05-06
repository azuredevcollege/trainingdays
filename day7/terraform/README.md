Add stroage account for terrastate

```shell
az group create --name adc-tfstate-rg --location westeurope

az storage account create -n tfstateadadc -g adc-tfstate-rg --sku Standard_LRS

az storage container create -n tfstate --account-name tfstateadadc --account-key `az storage account keys list -n tfstateadadc -g adc-tfstate-rg --query "[0].value" -otsv`
```

Kubernetes


k create ns dev

Ingress:

k create ns ingress

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install clstr-ingress stable/nginx-ingress --set rbac.create=true,controller.service.externalTrafficPolicy=Local --namespace ingress

Secret / Docker Reg

kubectl create secret docker-registry regcred --docker-server=azuredevcollege.azurecr.io --docker-username=azuredevcollege --docker-password=l0EJXNQ4IfU1XX/VkS62OMoerhBEukf6 --docker-email=christian.dennig@azuredevcollege.com -n dev

