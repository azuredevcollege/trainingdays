# Baseline Deployment

⏲️ *Est. time to complete: 15 min.* ⏲️

If you could not finish the challenges and/or breakout parts of *Day 2*, here is a script that will put you back on track and give you the opportunity to start right off with the content of *Day 3*.

## Table Of Contents

1. [Pre-Requisites](#pre-requisites)
2. [Run the script](#run-the-script)
3. [Results](#results)
4. [Optional](#optional)

## Pre-Requisites

The script itself is a `bash` script. If you want to use `bash` on your own/local machine, make sure you have the `zip` package installed:

```shell
sudo apt install zip
```

You can run the bash script either in the Azure Cloud Shell (<https://shell.azure.com> - _recommended_) or on your own machine. Either way, it will use your Azure CLI credentials. So make sure you are logged in and have selected the correct subscription. You can check the current subscription by running:

```shell
az account show
```

If it isn't the correct one, follow these steps:

```shell
az account list -o table
```

It prints the available subscriptions for your account. Copy the subscription id of the one you want to work with and run:

```shell
az account set -s <SUBSCRIPTION_ID>
```

If the desired subscription does not show up, re-login to Azure via `az login` and select the appropriate one.

If you are all set, you must run the script to deploy the baseline.

## Run the script

```shell
cd day3/scripts/baseline
# Execute...
./deploy_baseline.sh
```

## Results

To check, if everything works as expected after the script has finished, go to the Azure Portal and open the resource group (named `"azdcXXXX-rg"`). Check that all resources have been deployed.

Futhermore, the script outputs the URL for the website (like `"https://azdcXXXXfe.z6.web.core.windows.net/"`). Copy the URL and open it in a browser. You should now see the SCM Contacts application as it would be running after Day 2 of the Azure Developer College.

## Optional

You can overwrite each name of the resources created by using these environment variables. If you skip one of them, the script will use a generated name for you.

```shell
export BASE_REGION_NAME=<YourAzureRegion> #default: westeurope
export BASE_RG_COMMON_NAME=<NameOfTheResourceGroup>
export BASE_AI_NAME=<NameOfTheAppInsightsComponent>
## both storage account names must be 15 characters or less and all LOWERCASE
export BASE_STORAGEACCOUNT_FE_NAME=<NameOfTheStorageAccountForFrontend>
export BASE_STORAGEACCOUNT_RES_NAME=<NameOfTheStorageAccountForFunctionsAndImages>
export BASE_API_WEBAPP_NAME=<NameOfTheContactsApiWebApp>
export BASE_RES_WEBAPP_NAME=<NameOfTheResourcesApiWebApp>
export BASE_RES_FUNCAPP_NAME=<NameOfTheFunctionsApp>
```

[🔼 Day 3](../README.md) | [Next challenge ▶](./01-challenge-cosmosdb.md)
