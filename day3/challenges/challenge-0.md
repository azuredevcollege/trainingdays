# Baseline Deployment

If you could not finish the challenges and/or breakout parts of *Day 2*, here is a script that will put you back on track and give you the opportunity to start right off with the content of *Day 3*.

## Pre-Requisites

To run the deployment script, you will have to setup a few environment variables:

### bash

```bash
export BASE_REGION_NAME=<YourAzureRegion>
export BASE_RG_COMMON_NAME=<NameOfTheResourceGroup>
export BASE_AI_NAME=<NameOfTheAppInsightsComponent>
## both storage account names must be 15 characters or less and all LOWERCASE
export BASE_STORAGEACCOUNT_FE_NAME=<NameOfTheStorageAccountForFrontend>
export BASE_STORAGEACCOUNT_RES_NAME=<NameOfTheStorageAccountForFunctionsAndImages>
export BASE_API_WEBAPP_NAME=<NameOfTheContactsApiWebApp>
export BASE_RES_WEBAPP_NAME=<NameOfTheResourcesApiWebApp>
export BASE_RES_FUNCAPP_NAME=<NameOfTheFunctionsApp>
```

### ...or PowerShell

```powershell
$env:BASE_REGION_NAME="<YourAzureRegion>"
$env:BASE_RG_COMMON_NAME="<NameOfTheResourceGroup>"
$env:BASE_AI_NAME="<NameOfTheAppInsightsComponent>"
## both storage account names must be 15 characters or less and all LOWERCASE
$env:BASE_STORAGEACCOUNT_FE_NAME="<NameOfTheStorageAccountForFrontend>"
$env:BASE_STORAGEACCOUNT_RES_NAME="<NameOfTheStorageAccountForFunctionsAndImages>"
$env:BASE_API_WEBAPP_NAME="<NameOfTheContactsApiWebApp>"
$env:BASE_RES_WEBAPP_NAME="<NameOfTheResourcesApiWebApp>"
$env:BASE_RES_FUNCAPP_NAME="<NameOfTheFunctionsApp>"
```

## Run The Script

The script uses your local Azure CLI. So make sure you are logged in and have selected the correct subscription. You can check the current subscription by running:

```shell
az account show
```

If it isn't the correct one, follow these steps:

```shell
az account list -o table
```

It prints the available subscriptions for your account. Copy the subscription id of the one you want to work with and run...

```shell
az account set -s <SUBSCRIPTION_ID>
```

If the desired subscription does not show up, re-login to Azure via ```az login```.

If you are all set, run the script...

### bash

```shell
cd day3/scripts/baseline
# Execute...
./deploy_baseline.sh
```

### ...or PowerShell

```powershell
cd day3/scripts/baseline
# Execute...
./deploy_baseline.ps1
```

## Results

To check, if everything works as expected, go to the Azure Portal an open the resource group you chose to deploy the resources to. Open the "Frontend Storage Account" and choose "Static website" from the settings pane. Copy the **primary endpoint URL** and open it in a browser. You should now see the SCM Contacts application as it should be running after *Day 2* of the Azure Developer College.
