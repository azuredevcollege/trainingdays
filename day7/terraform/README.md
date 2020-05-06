Add stroage account for terrastate

```shell
az group create --name tfstate-rg --location westeurope

az storage account create -n tfstateadcsa -g tfstate-rg --sku Standard_LRS

az storage container create -n tfstate --account-name tfstateadcsa --account-key `az storage account keys list -n tfstateadcsa -g tfstate-rg --query "[0].value" -otsv`
```


